//
//  AppDelegate.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/12.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#define LanguageKey @"appLanguage"

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navController;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

