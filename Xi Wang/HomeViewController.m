//
//  HomeViewController.m
//  Xi Wang
//
//  Created by Jessie on 2018/3/12.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "HomeViewController.h"
#import "LiveViewController.h"
#import "RequestVideosViewController.h"
#import "BroadcastViewController.h"
#import "SettingsViewController.h"
#import "ExitViewController.h"
#import "AVPlayerViewController.h"
#import "media.h"
#import "LanguageTool.h"
#import "ExitViewController.h"
#import "NavViewControllerPlus.h"
@interface HomeViewController ()

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //initial Language
    [LanguageTool initUserLanguage];
    [self.liveBtn setTitle:[[LanguageTool bundle] localizedStringForKey:@"直播" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.requestBtn setTitle:[[LanguageTool bundle] localizedStringForKey:@"點播" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.broadcastBtn setTitle:[[LanguageTool bundle] localizedStringForKey:@"廣播" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.settingBtn setTitle:[[LanguageTool bundle] localizedStringForKey:@"設定" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.exitBtn setTitle:[[LanguageTool bundle] localizedStringForKey:@"結束" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:@"changeLanguage" object:nil];
    self.view.backgroundColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.tabbarView.backgroundColor=[UIColor colorWithRed:0.04 green:0.14 blue:0.25 alpha:1.0];
    self.homeWebView.delegate=self;
    
    
    //link weburl
    NSString *urlAddress = [[LanguageTool bundle] localizedStringForKey:@"weburl" value:nil table:@"Xi_Wang"];
    NSURL *url = [[NSURL alloc] initWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.homeWebView loadRequest:requestObj];
    self.homeWebView.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.homeWebView.opaque=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
}

-(void)changeLanguage{
    NSLog(@"enter");
    [self viewDidLoad];
}


- (IBAction)live:(id)sender {
    LiveViewController *lvc= [[LiveViewController alloc]init];
    NavViewControllerPlus *nav = [[NavViewControllerPlus alloc] initWithRootViewController:lvc];
    [self presentViewController:nav animated:YES completion:nil];
    
}


- (IBAction)requestVideos:(id)sender {
    RequestVideosViewController *rvc= [[RequestVideosViewController alloc]init];
    NSString *lan = [LanguageTool userLanguage];
    if([lan isEqualToString:@"zh-Hans"]){//判断当前的语言，进行改变
        rvc.listType=kListTypeVideoMain_CN;
    }else{
        rvc.listType=kListTypeVideoMain;
    }
    NavViewControllerPlus *nav = [[NavViewControllerPlus alloc] initWithRootViewController:rvc];
    [self presentViewController:nav animated:YES completion:nil];
    //[self.navigationController pushViewController:rvc animated:YES];
}

- (IBAction)broadcast:(id)sender {
    BroadcastViewController *bvc= [[BroadcastViewController alloc]init];
    NSString *lan = [LanguageTool userLanguage];
    if([lan isEqualToString:@"zh-Hans"]){//判断当前的语言，进行改变
        bvc.listType=kListTypeBroadcastList_CN;
    }else{
        bvc.listType=kListTypeBroadcastList;
    }
    NavViewControllerPlus *nav = [[NavViewControllerPlus alloc] initWithRootViewController:bvc];
    [self presentViewController:nav animated:YES completion:nil];
    //[self.navigationController pushViewController:bvc animated:YES];
}

- (IBAction)settings:(id)sender {
    SettingsViewController *nvc=[[SettingsViewController alloc] init];
    self.definesPresentationContext = YES;
    nvc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    nvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)exit:(id)sender {
    ExitViewController *nvc=[[ExitViewController alloc] init];
    self.definesPresentationContext = YES;
    nvc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    nvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:nvc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//白色
}




- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self preferredStatusBarStyle];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [super viewWillDisappear:animated];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
