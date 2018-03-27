//
//  AVPlayerViewController.m
//  Xi Wang
//
//  Created by Jessie on 2018/3/14.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "AVPlayerViewController.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface AVPlayerViewController ()

//   视屏播放器背景图
@property (strong, nonatomic) UIView *backView;
//   播放视频控件
@property (nonatomic,strong) AVPlayer *player;
//   提供视频信息   创建AVPlayer使用的
@property (nonatomic,strong) AVPlayerItem *playerItem;
//   给AVPlayer一个播放的layer层
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
//   工具栏 view  (放播放按钮等控件的view)
@property (nonatomic,strong) UIView *bottomView;
//   播放
@property (nonatomic,strong) UIButton *playButton;
//   全屏按钮
@property (nonatomic,strong) UIButton *fullScreenButton;
//   滑动条
@property (nonatomic,strong) UISlider *slider;


//   自动消失定时器
@property (nonatomic,strong) NSTimer *autoDismissTimer;

//@property (strong, nonatomic) AVPlayerModel *videoModel;
//
//@property (strong, nonatomic) NSArray *videoArr;

@end



@implementation AVPlayerViewController


// 必须要 移除观察者，
- (void)dealloc{
    // 移除本控制器所有的通知；
    [self.player pause];
    self.player=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 移除定时器
    [self.autoDismissTimer invalidate];
    self.autoDismissTimer = nil;
}

//- (instancetype)initWithVideoList:(NSArray<AVPlayerModel *> *)videoList {
//    NSAssert(videoList.count, @"The playlist can not be empty!");
//    self = [super init];
//    if (self) {
//        self.videoArr = [videoList mutableCopy];
//        self.videoModel = self.videoArr[0];
//    }
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"直播";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self setSubUI];
}


- (void)setSubUI{
    // 初始化背景
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight / 2.5)];
    self.backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backView];
    
    // 提供视频信息   创建AVPlayer使用的
    self.playerItem = [[AVPlayerItem alloc] initWithURL:self.url];
    //  通过AVPlayerItem创建AVPlayer
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    // 单纯使用AVPlayer类是无法显示视频的，要将视频层添加至AVPlayerLayer中，这样才能将视频显示出来  所以要给AVPlayer一个播放的layer层
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //  位置
    _playerLayer.frame = self.backView.bounds;
    //    插入指定位置             第二个参数，可以将一个图层插入到指定的下标位置
    [self.backView.layer insertSublayer:self.playerLayer atIndex:0];
    
    // 监听播放器状态变化   利用KVO 监听  只要属性一改变就会调用监听方法
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //添加手势动作,隐藏下面的进度条
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.backView addGestureRecognizer:tap];
    
    // 布局底部功能栏
    self.bottomView = [[UIView alloc] init];
    //  透明度
    self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.backView addSubview:self.bottomView];
    
    self.bottomView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).with.offset(0);
        make.right.equalTo(self.backView).with.offset(0);
        make.bottom.equalTo(self.backView).with.offset(0);
        make.height.mas_equalTo(30);
    }];
    
    // 播放或暂停按钮
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //  选中状态
    self.playButton.selected = YES;
    UIImage *playButtonImage = [UIImage imageNamed:@"pause.png"];
    [self.playButton setImage:playButtonImage forState:UIControlStateNormal];
    [self.bottomView addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(5);
        make.centerY.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    //  添加点击播放事件
    [self.playButton addTarget:self action:@selector(pauseOrPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //  底部全屏按钮
    self.fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fullScreenButton setImage:[UIImage imageNamed:@"fullscreen.png"] forState:UIControlStateNormal];
    self.fullScreenButton.selected = YES;
    [self.bottomView addSubview:self.fullScreenButton];
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(-5);
        make.centerY.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    //   添加点击全屏事件
    [self.fullScreenButton addTarget:self action:@selector(clickFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    // 底部进度条
    self.slider = [[UISlider alloc] init];
    //   已播放的部分颜色
    self.slider.minimumTrackTintColor = [UIColor whiteColor];
    //  未播放部分的进度条颜色
    self.slider.maximumTrackTintColor = [UIColor grayColor];
    // 初始位置  默认是0
    self.slider.value = 0.0;
    [self.slider setThumbImage:[UIImage imageNamed:@"dot.png"] forState:UIControlStateNormal];
    [self.bottomView addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(45);
        make.right.equalTo(self.bottomView).with.offset(-45);
        make.centerY.equalTo(self.bottomView);
    }];
    
    
    //  拖拽
    [self.slider addTarget:self action:@selector(sliderTapValueChange:) forControlEvents:UIControlEventTouchUpInside];
    //   点击
    UITapGestureRecognizer *tapSlider = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSlider:)];
    [self.slider addGestureRecognizer:tapSlider];
    
    [self.bottomView addSubview:self.slider];
    
    //  播放视频
    [self.player play];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.player pause];
}

#pragma mark ==== 暂停或者播放
- (void)pauseOrPlay:(UIButton *)sender{
    
    if (sender.selected == YES)
    {
        [sender setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        //  暂停
        [self.player pause];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [self.player play];
    }
    // 别忘记切换 状态
    sender.selected = !sender.selected;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark ==== 点击全屏按钮
- (void)clickFullScreen:(UIButton *)button{
    
    if (button.selected == YES)
    {   // 全屏
        
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        [self.fullScreenButton setImage:[UIImage imageNamed:@"nonfullscreen@3x.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        //  缩小
        [self toSmallScreen];
        [self.fullScreenButton setImage:[UIImage imageNamed:@"fullscreen@3x.png"] forState:UIControlStateNormal];
    }
    button.selected = !button.selected;
}


#pragma mark ====   全屏显示
- (void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        // 选择屏幕
        self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
//        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeLeft) forKey:@"orientation"];
//        [UINavigationController attemptRotationToDeviceOrientation];
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGFloat topPadding = window.safeAreaInsets.top;
        CGFloat bottomPadding = window.safeAreaInsets.bottom;
        // BackView 全屏
        self.backView.frame = CGRectMake(0, topPadding, kScreenWidth, kScreenHeight-topPadding-bottomPadding);
        // layer的方向宽和高对调
        self.playerLayer.frame = CGRectMake(0, 0, kScreenHeight-topPadding-bottomPadding, kScreenWidth);
        //UIApplication *application = [UIApplication sharedApplication];
        //[application setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(kScreenWidth-50);
            make.left.equalTo(self.backView).with.offset(0);
            make.width.mas_equalTo(kScreenHeight-topPadding-bottomPadding);
        }];
    }else{
        // BackView 全屏
        self.backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        // layer的方向宽和高对调
        self.playerLayer.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
        
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(kScreenWidth-50);
            make.left.equalTo(self.backView).with.offset(0);
            make.width.mas_equalTo(kScreenHeight);
        }];
    }
    
    // 加到window上面
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    
}


#pragma mark ==== 缩小
- (void)toSmallScreen{
    
    self.backView.transform = CGAffineTransformIdentity;
    self.backView.frame = CGRectMake(0, 100, kScreenWidth, kScreenHeight / 2.5);
    self.playerLayer.frame =  self.backView.bounds;
    [self.view addSubview:self.backView];
    
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).with.offset(0);
        make.right.equalTo(self.backView).with.offset(0);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.backView).with.offset(0);
    }];
}

#pragma mark ====  隐藏 显示  底部 工具栏
- (void)singleTap:(UITapGestureRecognizer *)tap{
    
    [UIView animateWithDuration:1.0 animations:^{
        if (self.bottomView.alpha == 1)
        {
            self.bottomView.alpha = 0;
        }
        else if (self.bottomView.alpha == 0)
        {
            self.bottomView.alpha = 1;
        }
    }];
}


#pragma mark ==== 点击调用  或者 拖拽完毕的时候调用
- (void)sliderTapValueChange:(UISlider *)slider
{
    //  seektotime  获取精准定位
    // 直接用秒来获取CMTime
    // 当前视频播放到的帧数的具体时间,每秒的帧数
    [self.player seekToTime:CMTimeMakeWithSeconds(slider.value, self.playerItem.currentTime.timescale)];
}


#pragma mark    ====  点击Slider
- (void)touchSlider:(UITapGestureRecognizer *)tap
{
    // 根据点击的坐标计算对应的比例
    CGPoint touch = [tap locationInView:self.slider];
    //  占总厂的比例
    CGFloat scale = touch.x / self.slider.bounds.size.width;
    //CMTimeGetSeconds  获取时间的秒数
    self.slider.value = CMTimeGetSeconds(self.playerItem.duration) * scale;
    //  精准  具体时间,每秒的帧数
    [self.player seekToTime:CMTimeMakeWithSeconds(self.slider.value, self.playerItem.currentTime.timescale)];
    if (self.player.rate != 1)
    {
        // 1的时候播放   0暂停
        [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [self.player play];
    }
}


#pragma mark ==== 监听播放器的变化属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //  播放时
    if ([keyPath isEqualToString:@"status"])
    {
        //  播放器状态
        AVPlayerItemStatus statues = [change[NSKeyValueChangeNewKey] integerValue];
        switch (statues) {
            case AVPlayerItemStatusReadyToPlay:
                //  滑动条最大值  =   持续时间(播放总时间)
                //self.slider.maximumValue = CMTimeGetSeconds(self.playerItem.duration);
                //随时间移动
                [self initTimer];
                
                //  计时器为空时创建计时器
                if (!self.autoDismissTimer)
                {
                    // 8秒执行一次  自动隐藏底栏
                    self.autoDismissTimer = [NSTimer timerWithTimeInterval:8.0 target:self selector:@selector(autoDismissView:) userInfo:nil repeats:YES];
                    // 主线程 不需要 return
                    [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
                }
                break;
            case AVPlayerItemStatusUnknown:
                //   未知状态
                break;
            case AVPlayerItemStatusFailed:
                //    播放失败
                break;
                
            default:
                break;
        }
    }
}



//调用plaer进行页面更新
- (void)initTimer
{
    //player的定时器
    __weak typeof(self)weakSelf = self;
    // 每秒更新一次UI Slider            CMTimeMake(表示 当前视频播放到的第几桢数,每秒的帧数)
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        weakSelf.slider.value = CMTimeGetSeconds(weakSelf.playerItem.currentTime);
    }];
}


//自动隐藏底部功能栏
- (void)autoDismissView:(NSTimer *)timer{
    // 0  暂停   1时正在播放视频
    if (self.player.rate == 1)
    {
        [UIView animateWithDuration:2.0 animations:^{
            self.bottomView.alpha = 0;
        }];
    }
}



@end

