//
//  BroadcastDetailListViewController.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/20.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "media.h"
@interface BroadcastDetailListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *broadcastDetailTbv;
@property (strong, nonatomic) IBOutlet UILabel *listLabel;
@property ENUM_LIST_TYPE listType;
@property NSMutableArray *dataArray;
@property NSDictionary *dataDic;
@property NSString *broadcastVrid;
@property NSString *labelStr;
@end
