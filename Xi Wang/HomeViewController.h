//
//  HomeViewController.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/12.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface HomeViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *homeWebView;
@property (strong, nonatomic) IBOutlet UIView *tabbarView;
@property (strong, nonatomic) IBOutlet UIButton *liveBtn;
@property (strong, nonatomic) IBOutlet UIButton *requestBtn;
@property (strong, nonatomic) IBOutlet UIButton *broadcastBtn;
@property (strong, nonatomic) IBOutlet UIButton *settingBtn;
@property (strong, nonatomic) IBOutlet UIButton *exitBtn;


@end
