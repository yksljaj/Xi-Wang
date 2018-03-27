//
//  AVPlayerViewController.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/14.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface AVPlayerModel : NSObject
//
//@property (nonatomic,strong,readonly) NSURL *url;
//@property (nonatomic,copy,readonly) NSString *name;
//
//- (instancetype)initWithName:(NSString *)name url:(NSURL *)url;

//@end


@interface AVPlayerViewController : UIViewController

//- (instancetype)initWithVideoList:(NSArray <AVPlayerModel *> *)videoList;
@property NSURL *url;

@end

