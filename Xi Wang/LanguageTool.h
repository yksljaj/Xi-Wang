//
//  LanguageTool.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/23.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LanguageTool : NSObject
+(NSBundle *)bundle;//获取当前资源文件

+(void)initUserLanguage;//初始化语言文件

+(NSString *)userLanguage;//获取应用当前语言

+(void)setUserlanguage:(NSString *)language;//设置当前语言

@end
