//
//  BroadcastViewController.m
//  Xi Wang
//
//  Created by Jessie on 2018/3/13.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "BroadcastViewController.h"
#import "TableViewCell.h"
#import "VLCViewController.h"
#import "LanguageTool.h"

@interface BroadcastViewController ()

@end

@implementation BroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *lan = [LanguageTool userLanguage];
    if([lan isEqualToString:@"zh-Hans"]){//判断当前的语言，进行改变
        [self addBackButtonWithTitle:@"回主页"];
    }else{
        [self addBackButtonWithTitle:@"回主頁"];
    }
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.broadcastTableView.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.broadcastTableView.delegate = self;
    self.broadcastTableView.dataSource = self;
    NSURL *url=[NSURL URLWithString:@"http://www.xiwangradio.org/api/?cmd=cate"];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error ==nil){
            NSError * error = nil;
            self.dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            self.dataArray =(NSMutableArray *)[media handleData:self.dataDic withType:_listType];
            NSLog(@"下載:%@",self.dataArray);
        }else{
            NSLog(@"下載錯誤:%@",error);
        }
        
        //        UINavigationController *navcvc=self.navigationController.parentViewController.childViewControllers[1];
        //        CollectionViewController *cvc=navcvc.viewControllers[0];
        //        cvc.dataArray=self.dataArray;
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.broadcastTableView reloadData];
        }];
        // });
        
    }];
    [dataTask resume];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    switch (_listType) {
        case kListTypeBroadcastList:
            self.navigationItem.title=@"廣播類別";
            break;
        case kListTypeBroadcastList_CN:
            self.navigationItem.title=@"广播类别";
            break;
        default:
            break;
    }
    
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (_listType) {
        case kListTypeBroadcastList:
        case kListTypeBroadcastList_CN:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            switch (_listType) {
                case kListTypeBroadcastList:
                case kListTypeBroadcastList_CN:
                    return [[self.dataArray valueForKey:@"broadcastlist"] count];
                    break;
            }
        default:
            break;
   
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"Cell";
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        UINib *nib=[UINib nibWithNibName:@"TableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    if(_listType==kListTypeBroadcastList_CN){
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text=@"线上直播";
                break;
            case 1:
            {
                media * item = [_dataArray valueForKey:@"broadcastlist"][indexPath.row];
                cell.textLabel.text = item.mediaTitle_cn;
                break;
            }
            default:
                break;
        }
        
    }else{
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text=@"線上直播";
                break;
            case 1:
            {
                media * item = [_dataArray valueForKey:@"broadcastlist"][indexPath.row];
                cell.textLabel.text = item.mediaTitle_tw;
                break;
            }
            default:
                break;
        }
        
    }
    cell.backgroundColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor colorWithRed:0.09 green:0.42 blue:0.72 alpha:1.0] ForCell:cell];  //highlight colour
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Reset Colour.
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1] ForCell:cell]; //normal color
    
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){
        VLCViewController *vlcVc = [[VLCViewController  alloc] init];
        if(_listType==kListTypeBroadcastList_CN){
        vlcVc.playName = @"线上直播";
        }else{
            vlcVc.playName = @"線上直播";
        }
        vlcVc.playURL = [NSURL URLWithString:@"rtmp://vohc.no-ip.org:5119/live/vohc"];
        
        [self.navigationController pushViewController:vlcVc animated:YES];
        
    }else{
    media * item = [_dataArray valueForKey:@"broadcastlist"][indexPath.row];
    
    BroadcastDetailListViewController *vc=[[BroadcastDetailListViewController alloc]init];
        if(_listType==kListTypeBroadcastList_CN){
            vc.listType=kListTypeBroadcastDetailList_CN;
            vc.broadcastVrid=item.mediaVrid;
            NSString *labelStr=[NSString stringWithFormat:@"%@-%@ %@ ",item.mediaBroadcastHostname,item.mediaTitle_cn,item.mediaBroadcastWeekly];
            vc.labelStr=labelStr;
        }else{
            vc.listType=kListTypeBroadcastDetailList;
            vc.broadcastVrid=item.mediaVrid;
            NSString *labelStr=[NSString stringWithFormat:@"%@-%@ %@",item.mediaBroadcastHostname,item.mediaTitle_tw,item.mediaBroadcastWeekly];
            vc.labelStr=labelStr;
        }
    
    
    [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)addBackButtonWithTitle:(NSString *)title {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

/**
 *  @brief set left bar button with custom image (or custom view)
 */
- (void)addBackButtonWithImageName:(NSString *)imageName {
    // init your custom button, or your custom view
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 22); // custom frame
    [backButton setTitle:@"back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // set left barButtonItem with custom view
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
