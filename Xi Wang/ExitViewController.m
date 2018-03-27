//
//  ExitViewController.m
//  Xi Wang
//
//  Created by Jessie on 2018/3/13.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "ExitViewController.h"
#import "SettingsViewController.h"
#import "LanguageTool.h"
@interface ExitViewController ()

@end

@implementation ExitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LanguageTool initUserLanguage];
    self.systemLabel.text = [[LanguageTool bundle] localizedStringForKey:@"系統訊息" value:nil table:@"Xi_Wang"];
    self.exitOrNot.text = [[LanguageTool bundle] localizedStringForKey:@"確定結束播放？" value:nil table:@"Xi_Wang"];
    [self.confirmBtn setTitle:[[LanguageTool bundle] localizedStringForKey:@"確認" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.cancleBtn setTitle:[[LanguageTool bundle] localizedStringForKey:@"取消" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
}
- (IBAction)confirmBtn:(id)sender {
    exit(0);
}

- (IBAction)cancleBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
