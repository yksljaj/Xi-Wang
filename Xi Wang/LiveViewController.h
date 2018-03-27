//
//  LiveViewController.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/13.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@import BrightcovePlayerSDK;

@interface LiveViewController : UIViewController<BCOVPlaybackControllerDelegate, BCOVPUIPlayerViewDelegate>
@property (nonatomic, strong) AVPlayer *avPlayer;
//@property (nonatomic, strong) LiveViewController *playerView;

@end
