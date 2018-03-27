//
//  SettingsViewController.m
//  Xi Wang
//
//  Created by Jessie on 2018/3/13.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "SettingsViewController.h"
#import "LanguageTool.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor clearColor];
    //注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:@"changeLanguage" object:nil];
    NSString *lan = [LanguageTool userLanguage];
    if([lan isEqualToString:@"zh-Hans"]){//判断当前的语言，进行改变
        self.zh_HansBtn.selected=YES;
    }else{
        self.zh_HantBtn.selected=YES;
    }
    
    self.systemSettingLabel.text = [[LanguageTool bundle] localizedStringForKey:@"系統設定" value:nil table:@"Xi_Wang"];
    self.languageLabel.text = [[LanguageTool bundle] localizedStringForKey:@"語系" value:nil table:@"Xi_Wang"];
    [self.zh_HantBtn setTitle:[[LanguageTool bundle] localizedStringForKey:@"繁體中文" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.zh_HansBtn setTitle:[[LanguageTool bundle] localizedStringForKey:@"簡體中文" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.confirmBtn setTitle:[[LanguageTool bundle] localizedStringForKey:@"確認" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.cancleBtn setTitle:[[LanguageTool bundle] localizedStringForKey:@"取消" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeToTraditional:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    self.systemSettingLabel.text = [bundle localizedStringForKey:@"系統設定" value:nil table:@"Xi_Wang"];
    self.languageLabel.text = [bundle localizedStringForKey:@"語系" value:nil table:@"Xi_Wang"];
    [self.zh_HantBtn setTitle:[bundle localizedStringForKey:@"繁體中文" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.zh_HansBtn setTitle:[bundle localizedStringForKey:@"簡體中文" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.confirmBtn setTitle:[bundle localizedStringForKey:@"確認" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.cancleBtn setTitle:[bundle localizedStringForKey:@"取消" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
}
- (IBAction)changeToSimplified:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
    
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    self.systemSettingLabel.text = [bundle localizedStringForKey:@"系統設定" value:nil table:@"Xi_Wang"];
    self.languageLabel.text = [bundle localizedStringForKey:@"語系" value:nil table:@"Xi_Wang"];
    [self.zh_HantBtn setTitle:[bundle localizedStringForKey:@"繁體中文" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.zh_HansBtn setTitle:[bundle localizedStringForKey:@"簡體中文" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.confirmBtn setTitle:[bundle localizedStringForKey:@"確認" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
    [self.cancleBtn setTitle:[bundle localizedStringForKey:@"取消" value:nil table:@"Xi_Wang"] forState:UIControlStateNormal];
}
- (IBAction)confirmLanguage:(id)sender {
    NSString *lan = [LanguageTool userLanguage];
    NSString *btnLan;
    if([self.languageLabel.text isEqualToString:@"语系"]){
        btnLan=@"zh-Hans";
    }else{
        btnLan=@"en";
    }
    
    if([lan isEqualToString:btnLan]){//判断当前的语言，进行改变
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [LanguageTool setUserlanguage:btnLan];
        //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}
- (IBAction)cancle:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)changeLanguage{
    NSLog(@"Enter");
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
