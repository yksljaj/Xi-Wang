//
//  LiveViewController.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/13.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "media.h"
@import BrightcovePlayerSDK;

@interface LiveViewController : UIViewController<BCOVPlaybackControllerDelegate, BCOVPUIPlayerViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) AVPlayer *avPlayer;
//@property (nonatomic, strong) LiveViewController *playerView;
@property (strong, nonatomic) IBOutlet UIView *videoContainer;
@property (strong, nonatomic) IBOutlet UITableView *liveTbv;
@property NSMutableArray *dataArray;
@property NSDictionary *dataDic;
@property ENUM_LIST_TYPE listType;

@end
