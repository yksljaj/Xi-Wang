//
//  BroadcastViewController.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/13.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "media.h"
#import "BroadcastDetailListViewController.h"

@interface BroadcastViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *broadcastTableView;
@property ENUM_LIST_TYPE listType;
@property NSMutableArray *dataArray;
@property NSDictionary *dataDic;
@end
