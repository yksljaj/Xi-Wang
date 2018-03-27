//
//  BroadcastDetailListViewController.m
//  Xi Wang
//
//  Created by Jessie on 2018/3/20.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "BroadcastDetailListViewController.h"
#import "TableViewCell.h"
#import "VLCViewController.h"

@interface BroadcastDetailListViewController ()

@end

@implementation BroadcastDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.broadcastDetailTbv.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.broadcastDetailTbv.delegate = self;
    self.broadcastDetailTbv.dataSource = self;
    self.navigationController.navigationBar.translucent = NO;
    self.listLabel.backgroundColor=[UIColor colorWithRed:0.04 green:0.14 blue:0.25 alpha:1.0];
    self.listLabel.text=_labelStr;
    NSDate *now=[NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-89];
    NSDate *ninetyDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:now options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"Begin of this month=%@",[dateFormatter stringFromDate:ninetyDaysAgo]);
    NSString *urlStr=[NSString stringWithFormat:@"http://www.xiwangradio.org/api/?cmd=searchaudio_byparent&pvrid=%@&dateb=%@&datee=%@",_broadcastVrid,[dateFormatter stringFromDate:ninetyDaysAgo],[dateFormatter stringFromDate:now]];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSLog(@"%@",url);
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
            [self.broadcastDetailTbv reloadData];
        }];
        // });
        
    }];
    [dataTask resume];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    switch (_listType) {
        case kListTypeBroadcastDetailList:
            self.navigationItem.title=@"廣播清單";
            break;
        case kListTypeBroadcastDetailList_CN:
            self.navigationItem.title=@"广播清单";
            break;
        default:
            break;
    }
    
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (_listType) {
        case kListTypeBroadcastDetailList:
        case kListTypeBroadcastDetailList_CN:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
            switch (_listType) {
                case kListTypeBroadcastDetailList:
                case kListTypeBroadcastDetailList_CN:
                    return [[self.dataArray valueForKey:@"broadcastdetaillist"] count];
                    break;
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
    
            switch (_listType) {
                case kListTypeBroadcastDetailList:
                {
                    media * item = [_dataArray valueForKey:@"broadcastdetaillist"][indexPath.row];
                    cell.textLabel.text = item.mediaTitle_tw;
                    break;
                }
                case kListTypeBroadcastDetailList_CN:
                {
                    media * item = [_dataArray valueForKey:@"broadcastdetaillist"][indexPath.row];
                    cell.textLabel.text = item.mediaTitle_cn;
                    break;
                }
                default:
                    break;
                
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
    VLCViewController *vlcVc = [[VLCViewController  alloc] init];
    media * item = [_dataArray valueForKey:@"broadcastdetaillist"][indexPath.row];
    if(_listType==kListTypeBroadcastDetailList_CN){
        vlcVc.playName =item.mediaTitle_cn;
    }else{
            vlcVc.playName =item.mediaTitle_tw;
        }
    vlcVc.playURL = [NSURL URLWithString:item.mediaBroadcastURL];
    
    [self.navigationController pushViewController:vlcVc animated:YES];
    
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
