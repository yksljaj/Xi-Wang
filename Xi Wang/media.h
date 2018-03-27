//
//  media.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/15.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum  {
    kListTypeVideoMain = 0,
    kListTypeVideoMain_CN,
    kListTypeVideoList,
    kListTypeVideoList_CN,
    kListTypeVideoListWithImg,
    kListTypeVideoListWithImg_CN,
    kListTypeBroadcastList,
    kListTypeBroadcastList_CN,
    kListTypeBroadcastDetailList,
    kListTypeBroadcastDetailList_CN,
    
} ENUM_LIST_TYPE;

@interface media : NSObject
@property (nonatomic,copy) NSString * mediaBroadcastWeekly;
@property (nonatomic,copy) NSString * mediaBroadcastHostname;
@property (nonatomic,copy) NSString * mediaBroadcastURL;
@property (nonatomic,copy) NSString * mediaId;
@property (nonatomic,copy) NSString * mediaPvrid;
@property (nonatomic,copy) NSString * mediaVrid;
@property (nonatomic,copy) NSString * mediaTitle_tw;
@property (nonatomic,copy) NSString * mediaTitle_cn;
@property (nonatomic,copy) NSString * mediaContent_tw;
@property (nonatomic,copy) NSString * mediaContent_cn;
@property (nonatomic,copy) NSString * mediaBrightcoveID;
@property (nonatomic,copy) NSString * mediaBrightcoveImgUrl;
@property (nonatomic,retain) UIImage * mediaPic; //  存储每个新闻自己的image对象
@property NSInteger listType;
- (id)initWithArray:(NSMutableArray *)array withType:(ENUM_LIST_TYPE) listType;
//- (NSMutableArray *)handleClassData:(NSMutableArray *)array andDic:(NSDictionary *)dic;
+ (NSMutableDictionary *)handleData:(NSMutableDictionary *)dic withType:(ENUM_LIST_TYPE) listType;

@end
