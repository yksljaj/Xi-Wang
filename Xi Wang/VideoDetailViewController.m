//
//  VideoDetailViewController.m
//  Xi Wang
//
//  Created by Jessie on 2018/3/19.
//  Copyright © 2018年 Jessie. All rights reserved.
//
#import "VideoDetailViewController.h"
#import "LZPageViewController.h"
#import "media.h"
#import "TableViewCell.h"
#import "ImageDownloader.h"
#import "BrightcoveViewController.h"
#import "LanguageTool.h"
#import "NavViewControllerPlus.h"
static NSString * const kViewControllerPlaybackServicePolicyKey = @"BCpkADawqM0ZCmvPPuzqqK-7VqqrkuZoieaedQKKcazyvX1u1t4e0ap6HQou5jY09S0gVLvB_XT7IuwzkCsJFt5e6z8rEsRb9NsQgeRu_0qZlpTJYvIJkGTbufUyQSrkffC0Yf0D35g-iDm5";
static NSString * const kViewControllerAccountID = @"4938530621001";

@interface VideoDetailViewController ()
@property (nonatomic, strong) BCOVPlaybackService *playbackService;
@property (nonatomic, strong) id<BCOVPlaybackController> playbackController;
@property (nonatomic) BCOVPUIPlayerView *playerView;
@property (nonatomic, weak) IBOutlet UIView *videoContainer;

@end

@implementation VideoDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
//    [UINavigationController attemptRotationToDeviceOrientation];
   // [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    NSLog(@"enter");
    
}

-(BOOL)shouldAutorotate{
    return NO;
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"Enter!");
    _indicatorView.hidden=NO;
    [_activityIndicator startAnimating];
    
    self.videoDetailTableView.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.videoDetailTableView.delegate = self;
    self.videoDetailTableView.dataSource = self;
    
    [self actIndicatorBegin];
    //[NSThread detachNewThreadSelector: @selector(actIndicatorBegin) toTarget:self withObject:nil];
    NSString *urlStr=[NSString stringWithFormat:@"http://210.71.250.70/video_2017/api/index.php?cmd=searchvideo_byparent&pvids=%@",_videoVrid];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error ==nil){
            NSError * error = nil;
            self.dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            self.dataArray =(NSMutableArray *)[media handleData:self.dataDic withType:kListTypeVideoListWithImg];
            
            NSLog(@"下載:%@",self.dataArray);
        }else{
            NSLog(@"下載錯誤:%@",error);
        }
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.videoDetailTableView reloadData];
            [self actIndicatorEnd];
        }];
        
    }];
    [dataTask resume];
    
    //[NSThread detachNewThreadSelector: @selector(actIndicatorEnd) toTarget:self withObject:nil];
    
    
}

- (void) actIndicatorBegin {
    [_activityIndicator startAnimating];
}

-(void) actIndicatorEnd {
    _indicatorView.hidden=YES;
    [_activityIndicator stopAnimating];
    NSUInteger count=[[_dataArray valueForKey:@"videodetail"] count];
    NSString *btnStr=[NSString stringWithFormat:@"影片(%lu)",(unsigned long)count];
    UIButton *btn=[[((LZPageViewController *)self.parentViewController) contentViews] viewWithTag:1];
    [btn setTitle:btnStr forState:UIControlStateNormal];
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"enter");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray valueForKey:@"videodetail"] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"videodetailcell"];
        if(cell==nil){
            cell=[[[NSBundle mainBundle] loadNibNamed:@"VideoImgTableViewCell" owner:nil options:nil]firstObject];
    }
    
    
    media * item = [_dataArray valueForKey:@"videodetail"][indexPath.row];
    NSString *lan = [LanguageTool userLanguage];
    
    if(item.mediaBrightcoveID)
    if([lan isEqualToString:@"zh-Hans"]){//判断当前的语言，进行改变
        cell.videoTitleLabel.text = item.mediaTitle_cn;
    }else{
        cell.videoTitleLabel.text = item.mediaTitle_tw;
    }
    
    if (item.mediaPic == nil) {
        if(item.mediaBrightcoveImgUrl!=[NSNull null]){
        //没有图像下载
        cell.videoImg.image = nil;
        
        //NSLog(@"dragging = %d,decelerating = %d",self.tableView.dragging,self.tableView.decelerating);
        // ??执行的时机与次数问题
        //if (self.videoDetailTableView.dragging == NO && self.videoDetailTableView.decelerating == YES) {
            [self startPicDownload:item forIndexPath:indexPath];
        //}
        }else{
            cell.videoImg.image=[UIImage imageNamed:@"youtube.png"] ;
            cell.videoImg.contentMode=UIViewContentModeScaleAspectFit;
        }
        
    }else{
        //有图像直接展示
        NSLog(@"1111");
        cell.videoImg.image = item.mediaPic;
        
    }
    cell.backgroundColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    cell.videoTitleLabel.textColor=[UIColor whiteColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TableViewCell *cell = (TableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    BrightcoveViewController *bvc=[BrightcoveViewController new];
    media * item = [_dataArray valueForKey:@"videodetail"][indexPath.row];
    bvc.mediaBrightcoveID=item.mediaBrightcoveID;
    bvc.mediaTitle=cell.videoTitleLabel.text;
    NavViewControllerPlus *nav = [[NavViewControllerPlus alloc] initWithRootViewController:bvc];
    [self presentViewController:nav animated:YES completion:nil];
    //[self.navigationController pushViewController:bvc animated:YES];
}

//- (NSString *)stripTags:(NSString *)str
//{
//    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
//    
//    NSScanner *scanner = [NSScanner scannerWithString:str];
//    scanner.charactersToBeSkipped = NULL;
//    NSString *tempText = nil;
//    
//    while (![scanner isAtEnd])
//    {
//        [scanner scanUpToString:@"<" intoString:&tempText];
//        
//        if (tempText != nil)
//            [html appendString:tempText];
//        
//        [scanner scanUpToString:@">" intoString:NULL];
//        
//        if (![scanner isAtEnd])
//            [scanner setScanLocation:[scanner scanLocation] + 1];
//        
//        tempText = nil;
//    }
//    
//    return html;
//}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)startPicDownload:(media *)item forIndexPath:(NSIndexPath *)indexPath
{
    //创建图像下载器
    ImageDownloader * downloader = [[ImageDownloader alloc] init];
    
    //下载器要下载哪个新闻的图像，下载完成后，新闻保存图像
    downloader.mediaItem = item;
    
    //传入下载完成后的回调函数
    [downloader setCompletionHandler:^{
        
        //下载完成后要执行的回调部分，block的实现
        //根据indexPath获取cell对象，并加载图像
#pragma mark cellForRowAtIndexPath-->没看到过
        TableViewCell * cell = (TableViewCell *)[self.videoDetailTableView cellForRowAtIndexPath:indexPath];
        cell.videoImg.image = downloader.mediaItem.mediaPic;
        
    }];
    
    //开始下载
    [downloader startDownloadImage:item.mediaBrightcoveImgUrl];
    
    // [downloader release];
}


- (void)loadImagesForOnscreenRows
{
#pragma mark indexPathsForVisibleRows-->没看到过
    //获取tableview正在window上显示的cell，加载这些cell上图像。通过indexPath可以获取该行上需要展示的cell对象
    NSArray * visibleCells = [self.videoDetailTableView indexPathsForVisibleRows];
    for (NSIndexPath * indexPath in visibleCells) {
        media * item = [_dataArray objectAtIndex:indexPath.row];
        if (item.mediaPic == nil) {
            //如果新闻还没有下载图像，开始下载
            [self startPicDownload:item forIndexPath:indexPath];
        }
    }
}

@end
