//
//  RequestVideosViewController.m
//  Xi Wang
//
//  Created by Jessie on 2018/3/13.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "RequestVideosViewController.h"
#import "ImageDownloader.h"
#import "media.h"
#import "TableViewCell.h"
#import "SegmentedViewController.h"
#import "LZPageViewController.h"
#import "VideoDetailViewController.h"
#import "LanguageTool.h"
#import "NavViewControllerPlus.h"
@interface RequestVideosViewController ()

@end

@implementation RequestVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButtonWithTitle:@"回主頁"];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSURL *url=[NSURL URLWithString:@"http://210.71.250.70/video_2017/api/index.php?cmd=cate&pvid=3767205bcd683e93a47f"];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error ==nil){
            NSError * error = nil;
           self.dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            self.dataArray =(NSMutableArray *)[media handleData:self.dataDic withType:kListTypeVideoMain];
            NSLog(@"下載:%@",self.dataArray);
        }else{
            NSLog(@"下載錯誤:%@",error);
        }
        
        //        UINavigationController *navcvc=self.navigationController.parentViewController.childViewControllers[1];
        //        CollectionViewController *cvc=navcvc.viewControllers[0];
        //        cvc.dataArray=self.dataArray;
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
        // });
        
    }];
    [dataTask resume];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    switch (_listType) {
        case kListTypeVideoMain:
            self.navigationItem.title=@"點播主類別";
            break;
        case kListTypeVideoMain_CN:
            self.navigationItem.title=@"点播主类别";
            break;
        default:
            break;
    }
    
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (_listType) {
        case kListTypeVideoMain:
        case kListTypeVideoMain_CN:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_listType) {
        case kListTypeVideoMain:
        case kListTypeVideoMain_CN:
            return [[self.dataArray valueForKey:@"mainclass"] count];
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"Cell";
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        UINib *nib=[UINib nibWithNibName:@"TableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    switch (_listType) {
        case kListTypeVideoMain:
        {
            media * item = [_dataArray valueForKey:@"mainclass"][indexPath.row];
            cell.textLabel.text = item.mediaTitle_tw;
            break;
        }
        
    case kListTypeVideoMain_CN:
        {
            media * item = [_dataArray valueForKey:@"mainclass"][indexPath.row];
            cell.textLabel.text = item.mediaTitle_cn;
            break;
        }
    
    }
    cell.backgroundColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor colorWithRed:0.09 green:0.42 blue:0.72 alpha:1.0] ForCell:cell];  //highlight colour
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Reset Colour.
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1] ForCell:cell]; //normal color
    
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    media * item = [_dataArray valueForKey:@"mainclass"][indexPath.row];
    NSString *lan = [LanguageTool userLanguage];
    if([lan isEqualToString:@"zh-Hans"]){//判断当前的语言，进行改变
        LZPageViewController *pageVc = [[LZPageViewController alloc] initWithTitles: @[@"影片分类",@"影片",] controllersClass:@[[SegmentedViewController class],[VideoDetailViewController class]]];
        pageVc.videoInfoLabel.text=item.mediaTitle_cn;
        pageVc.videoVrid=item.mediaVrid;
        [self.navigationController pushViewController:pageVc animated:YES];
    }else{
        LZPageViewController *pageVc = [[LZPageViewController alloc] initWithTitles: @[@"影片分類",@"影片",] controllersClass:@[[SegmentedViewController class],[VideoDetailViewController class]]];
        pageVc.videoInfoLabel.text=item.mediaTitle_tw;
        pageVc.videoVrid=item.mediaVrid;
        //[self.navigationController pushViewController:pageVc animated:YES];
        NavViewControllerPlus *nav = [[NavViewControllerPlus alloc] initWithRootViewController:pageVc];
        [self presentViewController:nav animated:YES completion:nil];
    }
   
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
