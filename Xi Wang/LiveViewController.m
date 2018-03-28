//
//  LiveViewController.m
//  Xi Wang
//
//  Created by Jessie on 2018/3/13.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "LiveViewController.h"
#import "LanguageTool.h"
#import "TableViewCell.h"
static NSString * const kVideoURLString = @"http://bcliveuniv-lh.akamaihd.net/i/Live_1@384161/master.m3u8";
@interface LiveViewController ()
@property (nonatomic, strong) id<BCOVPlaybackController> playbackController;
@property (nonatomic) BCOVPUIPlayerView *playerView;
@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.liveTbv.delegate=self;
    self.liveTbv.dataSource=self;
    self.view.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.navigationItem.title=@"直播";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSString *lan = [LanguageTool userLanguage];
    if([lan isEqualToString:@"zh-Hans"]){//判断当前的语言，进行改变
        [self addBackButtonWithTitle:@"回主页"];
    }else{
        [self addBackButtonWithTitle:@"回主頁"];
    }
    [self fetchData];
    
    self.liveTbv.rowHeight = UITableViewAutomaticDimension;
    self.liveTbv.estimatedRowHeight = UITableViewAutomaticDimension;
    
    
    
    BCOVPlayerSDKManager *manager = [BCOVPlayerSDKManager sharedManager];
    
    _playbackController = [manager createPlaybackControllerWithViewStrategy:nil];
    _playbackController.delegate = self;
    _playbackController.autoAdvance = YES;
    _playbackController.autoPlay = YES;
    BCOVPUIPlayerViewOptions *options = [[BCOVPUIPlayerViewOptions alloc] init];
    options.presentingViewController = self;
    
    BCOVPUIBasicControlView *controlsView = [BCOVPUIBasicControlView basicControlViewWithLiveDVRLayout];
    
    BCOVPUIPlayerView *playerView = [[BCOVPUIPlayerView alloc] initWithPlaybackController:self.playbackController options:options controlsView:controlsView ];
    playerView.delegate = self;
    
    playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width* 9.0 / 16.0);
    _videoContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(playerView.frame), CGRectGetHeight(playerView.frame))];
    //playerView.frame = _videoContainer.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_videoContainer addSubview:playerView];
    [self.view addSubview:_videoContainer];
//    playerView.frame = _videoContainer.bounds;
//    playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [_videoContainer addSubview:playerView];
    _playerView = playerView;
    _playerView.playbackController = _playbackController;
    
    NSURL *videoURL = [NSURL URLWithString:kVideoURLString];
    BCOVSource *source = [[BCOVSource alloc] initWithURL:videoURL deliveryMethod:kBCOVSourceDeliveryHLS properties:nil];
    BCOVVideo *video = [[BCOVVideo alloc] initWithSource:source cuePoints:nil properties:nil];
    [self.playbackController setVideos:@[video]];
    
    
}

-(void)fetchData{
    NSURL *url=[NSURL URLWithString:@"http://210.71.250.70/video_2017/api/index.php?cmd=liveplaylist"];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error ==nil){
            NSError * error = nil;
           self.dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//            for(int i=0;i<[rawArr count];i++){
//                self.dataDic=rawArr[i];
//            }
           // self.dataArray =(NSMutableArray *)[media handleData:self.dataDic withType:kListTypeVideoLive];
            NSLog(@"下載:%@",self.dataArray);
        }else{
            NSLog(@"下載錯誤:%@",error);
        }
        
        //        UINavigationController *navcvc=self.navigationController.parentViewController.childViewControllers[1];
        //        CollectionViewController *cvc=navcvc.viewControllers[0];
        //        cvc.dataArray=self.dataArray;
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.liveTbv reloadData];
        }];
        // });
        
    }];
    [dataTask resume];
}

- (void)playbackController:(id<BCOVPlaybackController>)controller playbackSession:(id<BCOVPlaybackSession>)session didReceiveLifecycleEvent:(BCOVPlaybackSessionLifecycleEvent *)lifecycleEvent
{
    if ([lifecycleEvent.eventType isEqualToString:kBCOVPlaybackSessionLifecycleEventPlay])
    {
        NSLog(@"ViewController Debug - Received lifecycle play event.");
    }
    else if([lifecycleEvent.eventType isEqualToString:kBCOVPlaybackSessionLifecycleEventPause])
    {
        NSLog(@"ViewController Debug - Received lifecycle pause event.");
    }
}


- (void)playbackController:(id<BCOVPlaybackController>)controller didAdvanceToPlaybackSession:(id<BCOVPlaybackSession>)session
{
    NSLog(@"ViewController Debug - Advanced to new session.");
}

#pragma mark UI Styling

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
   
    NSLog(@"%f",_playerView.frame.size.height);
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
     self.liveTbv.frame=CGRectMake(0, self.videoContainer.frame.size.height, CGRectGetWidth(_videoContainer.frame), [UIScreen mainScreen].bounds.size.height-self.videoContainer.frame.size.height);
    [super viewWillAppear:animated];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataArray valueForKey:@"live"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"Cell";
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        UINib *nib=[UINib nibWithNibName:@"LiveTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    media * item = [_dataArray valueForKey:@"live"][indexPath.row];
    switch (_listType) {
        case kListTypeVideoLive:
        {
            cell.titleLabel.text = [self.dataArray valueForKey:@"thetitle_tw"][indexPath.row];
            break;
        }
        case kListTypeVideoLive_CN:
        {
        
            cell.titleLabel.text = [self.dataArray valueForKey:@"thetitle_cn"][indexPath.row];
            break;
        }
        default:
            break;
            
    }
    NSMutableString *temp1=[self.dataArray valueForKey:@"xdate"][indexPath.row];
    NSMutableString *dateStr= [NSMutableString stringWithString:temp1];
    [dateStr deleteCharactersInRange:NSMakeRange(0, 5)];
    cell.xDateLabel.text=dateStr;
    NSMutableString *temp2=[self.dataArray valueForKey:@"xtime"][indexPath.row];
    NSMutableString *timeStr= [NSMutableString stringWithString:temp2];
    [timeStr deleteCharactersInRange:NSMakeRange(5, 3)];
    cell.xTimeLabel.text=timeStr;
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

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}


//- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
//{
//    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//    float statusBarHeight=[UIApplication sharedApplication].statusBarFrame.size.height;
//    float navBarHeight=self.navigationController.navigationBar.frame.size.height;
//    float scale=[UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width;
//    switch (deviceOrientation) {
//        case UIDeviceOrientationLandscapeLeft:
//            [self setNeedsStatusBarAppearanceUpdate];
//            
//            _playerView.frame = CGRectMake(0, 0, 180, 320);
//            _videoContainer.frame = CGRectMake(0, 0, CGRectGetWidth(_playerView.frame), CGRectGetHeight(_playerView.frame));
//            _playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//            [self.view layoutIfNeeded];
//            NSLog(@"螢幕向左橫置");
//        case UIDeviceOrientationLandscapeRight:
//            [self setNeedsStatusBarAppearanceUpdate];
//            _playerView.frame = CGRectMake(0, 0, 180, 320);
//            _videoContainer.frame = CGRectMake(0, 0, CGRectGetWidth(_playerView.frame), CGRectGetHeight(_playerView.frame));
//            _playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//            NSLog(@"螢幕向右橫置");
//        case UIDeviceOrientationPortrait:
//            _playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width* 9.0 / 16.0);
//            _videoContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_playerView.frame), CGRectGetHeight(_playerView.frame))];
//            //playerView.frame = _videoContainer.bounds;
//            _playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        default:
//            break;
//    }
//    }

-(void)viewWillLayoutSubviews{
    NSLog(@"emter");
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    float statusBarHeight=[UIApplication sharedApplication].statusBarFrame.size.height;
    float navBarHeight=self.navigationController.navigationBar.frame.size.height;
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self setNeedsStatusBarAppearanceUpdate];
            
            _playerView.frame = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.height)*16.0/9.0, [UIScreen mainScreen].bounds.size.height-statusBarHeight-navBarHeight);
            _videoContainer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(_playerView.frame));
            _playerView.center=_videoContainer.center;
            //_playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            //[self.view layoutIfNeeded];
            NSLog(@"螢幕向左橫置");
            break;
        case UIDeviceOrientationPortrait:
            _playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width* 9.0 / 16.0);
            _videoContainer.frame = CGRectMake(0, 0, CGRectGetWidth(_playerView.frame), CGRectGetHeight(_playerView.frame));
            //playerView.frame = _videoContainer.bounds;
            //_playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            break;
        default:
            break;
    }
    
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
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
