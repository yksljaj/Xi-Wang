//
//  RequestVideosViewController.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/13.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "media.h"

@interface RequestVideosViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *dataArray;
@property NSDictionary *dataDic;
@property ENUM_LIST_TYPE listType;
@end
