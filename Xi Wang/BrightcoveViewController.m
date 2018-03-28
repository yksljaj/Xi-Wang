//
//  BrightcoveViewController.m
//  Xi Wang
//
//  Created by Jessie on 2018/3/19.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "BrightcoveViewController.h"
#import "LanguageTool.h"

static NSString * const kViewControllerPlaybackServicePolicyKey = @"BCpkADawqM0ZCmvPPuzqqK-7VqqrkuZoieaedQKKcazyvX1u1t4e0ap6HQou5jY09S0gVLvB_XT7IuwzkCsJFt5e6z8rEsRb9NsQgeRu_0qZlpTJYvIJkGTbufUyQSrkffC0Yf0D35g-iDm5";
static NSString * const kViewControllerAccountID = @"4938530621001";
//static NSString * const kViewControllerVideoID = @"your video id";


@interface BrightcoveViewController ()<BCOVPlaybackControllerDelegate>
@property (nonatomic, strong) BCOVPlaybackService *playbackService;
@property (nonatomic, strong) id<BCOVPlaybackController> playbackController;
@property (nonatomic) BCOVPUIPlayerView *playerView;
@property UIView *videoContainer;

@end

@implementation BrightcoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    NSString *lan = [LanguageTool userLanguage];
    if([lan isEqualToString:@"zh-Hans"]){//判断当前的语言，进行改变
        [self addBackButtonWithTitle:@"回上页"];
    }else{
        [self addBackButtonWithTitle:@"回上頁"];
    }
    self.navigationItem.title=self.mediaTitle;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _playbackController = [BCOVPlayerSDKManager.sharedManager createSidecarSubtitlesPlaybackControllerWithViewStrategy:nil];
    
    _playbackController.analytics.account = kViewControllerAccountID; // optional
    
    _playbackController.delegate = self;
    _playbackController.autoAdvance = YES;
    _playbackController.autoPlay = YES;
    
    _playbackService = [[BCOVPlaybackService alloc] initWithAccountId:kViewControllerAccountID policyKey:kViewControllerPlaybackServicePolicyKey];
    // Set up our player view. Create with a standard VOD layout.
    BCOVPUIPlayerView *playerView = [[BCOVPUIPlayerView alloc] initWithPlaybackController:self.playbackController options:nil controlsView:[BCOVPUIBasicControlView basicControlViewWithVODLayout] ];
    
    // Install in the container view and match its size.
    playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width* 9.0 / 16.0);
    _videoContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(playerView.frame), CGRectGetHeight(playerView.frame))];
    //playerView.frame = _videoContainer.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_videoContainer addSubview:playerView];
    
//    UITextView *videoContentView=[[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(playerView.frame)+50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
//    videoContentView.text=_mediaContent_tw;
//    videoContentView.editable=NO;
//    [videoContentView setFont:[UIFont fontWithName:@"Arial" size:18]];
//    [self.view addSubview:videoContentView];
    [self.view addSubview:_videoContainer];
    _playerView = playerView;
    
    // Associate the playerView with the playback controller.
    _playerView.playbackController = _playbackController;
    
    [self requestContentFromPlaybackService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// 默认方向
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
//}

- (void)requestContentFromPlaybackService
{
    
    [self.playbackService findVideoWithVideoID:self.mediaBrightcoveID parameters:nil completion:^(BCOVVideo *video, NSDictionary *jsonResponse, NSError *error) {
        
        if (video)
        {
            // Add subtitle track to video object
            BCOVVideo *updatedVideo = [video update:^(id<BCOVMutableVideo> mutableVideo) {
                NSString *str=[[jsonResponse objectForKey:@"text_tracks"][0]objectForKey:@"src"];
                // Get the existing text tracks, if any
                NSArray *currentTextTracks = mutableVideo.properties[kBCOVSSVideoPropertiesKeyTextTracks];
                
                // Get the subtitles array
                NSArray *newTextTracks = [self setupSubtitles:str];
                
                // Combine the two arrays together.
                // We don't want to lose the original tracks that might already be in there.
                NSArray *combinedTextTracks = ((currentTextTracks != nil)
                                               ? [currentTextTracks arrayByAddingObjectsFromArray:newTextTracks]
                                               : newTextTracks);
                
                // Update the current dictionary (we don't want to lose the properties already in there)
                NSMutableDictionary *updatedDictionary = [mutableVideo.properties mutableCopy];
                
                // Store text tracks in the text tracks property
                updatedDictionary[kBCOVSSVideoPropertiesKeyTextTracks] = combinedTextTracks;
                mutableVideo.properties = updatedDictionary;
                
            }];
            
            [self.playbackController setVideos:@[ updatedVideo ]];
        }
        else
        {
            NSLog(@"Error retrieving video playlist: `%@`", error);
        }
        
    }];
}

- (NSArray *)setupSubtitles:(NSString *)caption
{
    // Create the array of subtitle dictionaries
    NSArray *textTracks =
    @[
      @{
          kBCOVSSTextTracksKeyKind: kBCOVSSTextTracksKindSubtitles,
          kBCOVSSTextTracksKeyLabel: @"English",
          kBCOVSSTextTracksKeyDefault: @YES,
          kBCOVSSTextTracksKeySourceLanguage: @"en",
          kBCOVSSTextTracksKeySource: caption,
          kBCOVSSTextTracksKeyMIMEType: @"text/vtt"
          }
      ];
    
    return textTracks;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
