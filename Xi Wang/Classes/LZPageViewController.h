//
//  LZPageViewController.h
//  LZSegmentPageController
//
//  Created by nacker on 16/3/25.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZPageContentView.h"

@interface LZPageViewController : UIViewController
@property UILabel *videoInfoLabel;
@property NSString *videoVrid;
@property NSString *mediaTitle;
- (instancetype)initWithTitles:(NSArray *)titlesArray controllersClass:(NSArray *)controllersClass;
@property (nonatomic, weak) LZPageContentView *contentViews;
@end
