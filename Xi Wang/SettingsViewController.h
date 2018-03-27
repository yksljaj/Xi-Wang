//
//  SettingsViewController.h
//  Xi Wang
//
//  Created by Jessie on 2018/3/13.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DLRadioButton/DLRadioButton.h>

@interface SettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet DLRadioButton *zh_HantBtn;
@property (strong, nonatomic) IBOutlet DLRadioButton *zh_HansBtn;
@property (strong, nonatomic) IBOutlet UILabel *systemSettingLabel;
@property (strong, nonatomic) IBOutlet UILabel *languageLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancleBtn;

@end
