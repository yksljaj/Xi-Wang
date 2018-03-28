//
//  LZPageViewController.m
//  LZSegmentPageController
//
//  Created by nacker on 16/3/25.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZPageViewController.h"

#import "LZPageMainCell.h"
#import "LanguageTool.h"

@interface LZPageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,LZPageContentViewDelegate>
@property (nonatomic, assign) CGFloat pageBarHeight;
@property (nonatomic, weak) UICollectionView *collectionMain;
@property (nonatomic, weak) UIView *line;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic,assign) int lastPositionX;
@property (nonatomic,assign) BOOL scrollToRight;

@property (nonatomic ,strong) NSArray *itemsArray;
@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic, strong) NSMutableArray *controllers;
@end

#define CollectionWidth (SCREEN_Width - 120)
#define SCREEN_Width ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_Height ([[UIScreen mainScreen] bounds].size.height)

static NSString *mainCell = @"mainCellmainCell";

@implementation LZPageViewController

- (NSMutableArray *)controllers{
    if (!_controllers) {
        NSMutableArray *controllers = [NSMutableArray array];
        for (int i = 0; i < _controllersClass.count; i ++) {
            Class className = _controllersClass[i];
            UIViewController *vc = [[className alloc] init];
            vc.title = _itemsArray[i];
            
            [self addChildViewController:vc];
            [controllers addObject:vc];
        }
        _controllers = controllers;
    }
    return _controllers;
}

- (instancetype)initWithTitles:(NSArray *)titlesArray controllersClass:(NSArray *)controllersClass
{
    if (self = [super init]) {
        
        self.itemsArray = titlesArray;
        self.controllersClass = controllersClass;
        self.pageBarHeight = 40;
        [self addCollectionPage];
        [self addCollectionMain];
    }
    return self;
}

-(void)setPageBarHeight:(CGFloat)pageBarHeight{
    _pageBarHeight = pageBarHeight;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    NSString *lan = [LanguageTool userLanguage];
    if([lan isEqualToString:@"zh-Hans"]){//判断当前的语言，进行改变
        [self addBackButtonWithTitle:@"回上页"];
    }else{
        [self addBackButtonWithTitle:@"回上頁"];
    }
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.videoInfoLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    self.videoInfoLabel.backgroundColor=[UIColor colorWithRed:0.04 green:0.14 blue:0.25 alpha:1.0];
    self.videoInfoLabel.textColor=[UIColor whiteColor];
    [self.videoInfoLabel setFont:[UIFont fontWithName:@"Arial" size:20]];
    self.videoInfoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.videoInfoLabel];
    
    
    _scrollToRight = YES;
    _lastPositionX = 0;
}

- (void)addCollectionPage{
    LZPageContentView *contentViews = [[LZPageContentView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.pageBarHeight) itemsArray:self.itemsArray];
    contentViews.delegate = self;
    [self.view addSubview:contentViews];
    self.contentViews = contentViews;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor orangeColor];
    self.lineWidth = self.view.frame.size.width / self.itemsArray.count;
    line.frame = CGRectMake(0, self.pageBarHeight - 3, self.lineWidth, 3);
    [self.contentViews addSubview:line];
    [self.contentViews bringSubviewToFront:line];
    self.line = line;
}

- (void)addCollectionMain{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.contentViews.frame), self.view.frame.size.width, self.view.frame.size.height - self.pageBarHeight - 64-self.videoInfoLabel.frame.size.height);
    
    UICollectionView *collectionMain = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionMain.dataSource = self;
    collectionMain.delegate = self;
    collectionMain.pagingEnabled = YES;
    collectionMain.scrollEnabled = YES;
    collectionMain.bounces = NO;
    collectionMain.showsHorizontalScrollIndicator = NO;
    [collectionMain registerClass:[LZPageMainCell class] forCellWithReuseIdentifier:mainCell];
    [self.view addSubview:collectionMain];
    [self.view bringSubviewToFront:collectionMain];
    self.collectionMain = collectionMain;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.frame.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LZPageMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mainCell forIndexPath:indexPath];
    [cell setIndexController:self.controllers[indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionMain scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.line.frame = CGRectMake((0 + indexPath.row) * self.lineWidth, self.pageBarHeight - 3, self.lineWidth, 3);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x ;
    int index = (x + SCREEN_Width * 0.5) / SCREEN_Width;
    [UIView animateWithDuration:0.25 animations:^{
        self.line.frame = CGRectMake(index *self.lineWidth, self.pageBarHeight - 3, self.lineWidth, 3);
    }];
    self.contentViews.index = index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentPostion = scrollView.contentOffset.x;
    if (currentPostion - _lastPositionX > 5) {
        _scrollToRight = YES;
    }else if(currentPostion - _lastPositionX < -5){
        _scrollToRight = NO;
    }
    _lastPositionX = currentPostion;
}

#pragma mark - LZPageContentViewDelegate
- (void)pageContentView:(LZPageContentView *)pageContentView didClickBtnIndex:(NSInteger)index
{
    [self.collectionMain scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self.collectionMain reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.line.frame = CGRectMake((0 + index) *self.lineWidth, self.pageBarHeight - 3, self.lineWidth, 3);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    NSString *lan = [LanguageTool userLanguage];
    if([lan isEqualToString:@"zh-Hans"]){//判断当前的语言，进行改变
         self.navigationItem.title=@"点播影片";
    }else{
         self.navigationItem.title=@"點播影片";
    }
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.videoInfoLabel.text=self.mediaTitle;
   
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// 默认方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)addBackButtonWithTitle:(NSString *)title {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

/**
 *  @brief set left bar button with custom image (or custom view)
 */
- (void)addBackButtonWithImageName:(NSString *)imageName {
    // init your custom button, or your custom view
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 22); // custom frame
    [backButton setTitle:@"back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // set left barButtonItem with custom view
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
