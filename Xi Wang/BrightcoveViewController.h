//
//  BrightcoveViewController.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/19.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>
@import BrightcovePlayerSDK;
@interface BrightcoveViewController : UIViewController<BCOVPlaybackControllerDelegate>
@property (nonatomic,copy) NSString * mediaBrightcoveID;
@property (nonatomic,copy) NSString * mediaContent_tw;
@end
