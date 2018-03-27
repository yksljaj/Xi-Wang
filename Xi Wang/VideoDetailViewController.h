//
//  VideoDetailViewController.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/19.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "media.h"
@import BrightcovePlayerSDK;

@interface VideoDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,BCOVPlaybackControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *videoDetailTableView;
@property NSMutableArray *dataArray;
@property NSDictionary *dataDic;
@property ENUM_LIST_TYPE listType;
@property NSString * mediaBrightcoveID;
@property NSString *videoVrid;
@property (strong, nonatomic) IBOutlet UIView *indicatorView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void)actIndicatorBegin;
-(void)actIndicatorEnd;

@end
