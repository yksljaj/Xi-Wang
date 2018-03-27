//
//  SegmentedViewController.m
//  Xi Wang
//
//  Created by Jessie on 2018/3/16.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "SegmentedViewController.h"
#import "LZPageViewController.h"
#import "TableViewCell.h"
#import "media.h"
#import "VideoDetailViewController.h"
#import "LanguageTool.h"


@interface SegmentedViewController ()
{
    NSString *vcTitle;
}

@end

@implementation SegmentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Enter!");
    self.videoListTableView.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    self.videoListTableView.delegate = self;
    self.videoListTableView.dataSource = self;
    _videoVrid=((LZPageViewController *)self.parentViewController).videoVrid;
    NSURL *url=[NSURL URLWithString:@"http://210.71.250.70/video_2017/api/index.php?cmd=cate&pvid=3767205bcd683e93a47f"];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error ==nil){
            NSError * error = nil;
            self.dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            self.dataArray =(NSMutableArray *)[media handleData:self.dataDic withType:kListTypeVideoList];
            NSLog(@"下載:%@",self.dataArray);
        }else{
            NSLog(@"下載錯誤:%@",error);
        }
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.videoListTableView reloadData];
        }];
        
    }];
    [dataTask resume];
    
}

- (void)btnClick
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray valueForKey:self.videoVrid] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if(cell==nil){
            cell=[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:nil options:nil]firstObject];
        }
    
    NSString *lan = [LanguageTool userLanguage];
    if([lan isEqualToString:@"zh-Hans"]){//判断当前的语言，进行改变
        media * item = [_dataArray valueForKey:self.videoVrid][indexPath.row];
        cell.textLabel.text = item.mediaTitle_cn;
    }else{
        media * item = [_dataArray valueForKey:self.videoVrid][indexPath.row];
        cell.textLabel.text = item.mediaTitle_tw;
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
    media * item = [_dataArray valueForKey:self.videoVrid][indexPath.row];
    //_videoVrid=item.mediaVrid;
    //vcTitle=@"影片";
    UIButton *btn=[[((LZPageViewController *)self.parentViewController) contentViews] viewWithTag:1];
    [btn sendActionsForControlEvents:UIControlEventTouchDown];
    VideoDetailViewController *vc=((LZPageViewController *)self.parentViewController).childViewControllers[1];
    vc.videoVrid=item.mediaVrid;
   // [vc.view setNeedsLayout];
    //[self showViewController:vc sender:self];
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
