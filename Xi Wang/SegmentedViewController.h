//
//  SegmentedViewController.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/16.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *videoInfo;
@property (strong, nonatomic) IBOutlet UITableView *videoListTableView;
@property NSInteger listType;
@property NSString *videoVrid;
@property NSDictionary *dataDic;
@property NSMutableArray *dataArray;

@end
