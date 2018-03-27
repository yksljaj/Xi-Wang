//
//  ImageDownloader.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/15.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class media;
@interface ImageDownloader : NSObject

@property (nonatomic,copy) NSString * imageUrl;
@property (nonatomic,retain) media * mediaItem; //下载图像所属的新闻


//图像下载完成后，使用block实现回调
@property (nonatomic,copy) void (^completionHandler)(void);


//开始下载图像
- (void)startDownloadImage:(NSString *)imageUrl;


//从本地加载图像
- (UIImage *)loadLocalImage:(NSString *)imageUrl;

@end
