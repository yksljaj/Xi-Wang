//
//  media.m
//  Xi Wang
//
//  Created by Jessie on 2018/3/15.
//  Copyright © 2018年 Jessie. All rights reserved.
//

#import "media.h"
#import "ImageDownloader.h"
@implementation media

- (id)initWithArray:(NSMutableArray *)array withType:(ENUM_LIST_TYPE) listType
{
    self = [super init];
    if (self) {
        if(listType==kListTypeBroadcastList || listType==kListTypeBroadcastList_CN|| listType==kListTypeBroadcastDetailList|| listType==kListTypeBroadcastDetailList_CN){
            
            self.mediaTitle_tw = [array valueForKey:@"thetitle_tw"];
            self.mediaTitle_cn = [array valueForKey:@"thetitle_cn"];
            self.mediaVrid= [array valueForKey:@"vrid"];
            self.mediaPvrid=[array valueForKey:@"programsvrid"];
            self.mediaBroadcastURL=[array valueForKey:@"files_tw"];
            self.mediaBroadcastWeekly=[array valueForKey:@"weekly"];
            self.mediaBroadcastHostname=[array valueForKey:@"hostname"];

        }else if(listType==kListTypeVideoLive || listType==kListTypeVideoLive_CN){
            self.mediaTitle_tw = [array valueForKey:@"thetitle_tw"];
            self.mediaTitle_cn = [array valueForKey:@"thetitle_cn"];
            self.mediaVrid= [array valueForKey:@"vrid"];
            self.mediaXdate= [array valueForKey:@"xdate"];
            self.mediaXtime= [array valueForKey:@"xtime"];
            
        }
        else{
            self.mediaTitle_tw = [array valueForKey:@"thetitle_tw"];
            self.mediaTitle_cn = [array valueForKey:@"thetitle_cn"];
            self.mediaVrid= [array valueForKey:@"vrid"];
            self.mediaPvrid=[array valueForKey:@"pvrid"];
            self.mediaContent_tw=[array valueForKey:@"content_tw"];
            self.mediaContent_cn=[array valueForKey:@"content_cn"];
            self.mediaId=[array valueForKey:@"id"];
            self.mediaBrightcoveID=[array valueForKey:@"brightcoveid"];
            self.mediaBrightcoveImgUrl=[array valueForKey:@"brightcoveimg"];
            if(self.mediaBrightcoveImgUrl!=[NSNull null]){
            ImageDownloader * downloader = [[ImageDownloader alloc] init] ;
            self.mediaPic = [downloader loadLocalImage:_mediaBrightcoveImgUrl];
            }

        }
    }
    
    return self;
}

+ (NSMutableDictionary *)handleData:(NSDictionary *)dic withType:(ENUM_LIST_TYPE) listType
{
    
    NSMutableDictionary *resultDic = [NSMutableDictionary new];
    NSMutableArray *cateArray =[NSMutableArray new];
    if(listType==kListTypeVideoMain||listType==kListTypeVideoMain_CN){
        //解析数据
        NSMutableArray *classArray=[NSMutableArray new];
        NSMutableArray * originalArray =[[dic objectForKey:@"parent_cats"]objectForKey:@"0"];
        for (int i=0 ;i<[originalArray count]; i++) {
            NSMutableArray * mediaClassDic =[[dic objectForKey:@"categories"]objectForKey:[originalArray objectAtIndex:i]];
            media * item = [[media alloc] initWithArray:mediaClassDic withType:listType];
            [classArray addObject:item];
            
        }
        [resultDic setObject:classArray forKey:@"mainclass"];
        
    }else if(listType==kListTypeVideoList||listType==kListTypeVideoList_CN){
        // 1. find array
        NSDictionary *originalArray =[dic objectForKey:@"categories"];
        
        NSEnumerator *enumeratorForCate = [originalArray keyEnumerator];
        id keyOfThisRow;
        // extra parens to suppress warning about using = instead of ==
        while((keyOfThisRow = [enumeratorForCate nextObject])) {
            //NSLog(@"key=%@ value=%@", keyOfThisRow, [originalArray objectForKey:keyOfThisRow]);
            NSMutableArray *thisRow = [originalArray objectForKey:keyOfThisRow];
            NSMutableArray *pvrid = [thisRow valueForKey:@"pvrid"];
            if ([[pvrid description] isEqualToString:@"0"]) {
                NSLog(@"key=%@ value=%@", keyOfThisRow, [originalArray objectForKey:keyOfThisRow]);
                [cateArray addObject:thisRow];
            }
        }
        
        // 2. put videos into category structure
        
        
        for (int cateIndex = 0; cateIndex < [cateArray
                                             count] ; cateIndex++ ) {
            NSMutableArray *videoArray=[NSMutableArray new];
            NSEnumerator *enumeratorForVideos = [originalArray keyEnumerator];
            while((keyOfThisRow = [enumeratorForVideos nextObject])) {
                NSMutableArray *thisRow = [originalArray objectForKey:keyOfThisRow];
                NSMutableArray *pvrid = [thisRow valueForKey:@"pvrid"];
                NSString *thisRowCateStr = [pvrid description];
                NSString *cateString =[[cateArray[cateIndex] valueForKey:@"vrid"] description];
                if ([thisRowCateStr isEqualToString:cateString]) {
                    // add to corresponding category
                    media * item = [[media alloc] initWithArray:[originalArray objectForKey:keyOfThisRow] withType:listType];
                    [videoArray addObject:item];
                    //[classArray addObject:[originalArray objectForKey:keyOfThisRow]];
                    
                }
                
            }
            [resultDic setObject:videoArray forKey:[cateArray[cateIndex] valueForKey:@"vrid"]];
            //[videoDic setObject:resultArray forKey:[[cateArray[cateIndex] valueForKey:@"vrid"] description]];
            //switch()
        }
       
    }else if(listType==kListTypeVideoListWithImg||listType==kListTypeVideoListWithImg_CN){
        NSMutableArray *videoDetailArray=[NSMutableArray new];
        for(int i=0;i<[dic count];i++){
            media * item = [[media alloc] initWithArray:[(NSMutableArray *)dic objectAtIndex:i] withType:listType];
            [videoDetailArray addObject:item];
            
        }
        [resultDic setObject:videoDetailArray forKey:@"videodetail"];
    }else if(listType==kListTypeBroadcastList||listType==kListTypeBroadcastList_CN){
        NSMutableArray *videoDetailArray=[NSMutableArray new];
        for(int i=0;i<[dic count];i++){
            media * item = [[media alloc] initWithArray:[(NSMutableArray *)dic objectAtIndex:i] withType:listType];
            [videoDetailArray addObject:item];
            
        }
        [resultDic setObject:videoDetailArray forKey:@"broadcastlist"];
    }else if(listType==kListTypeBroadcastDetailList||listType==kListTypeBroadcastDetailList_CN){
        NSMutableArray *broadcastDetailArray=[NSMutableArray new];
        NSMutableSet *tempValues = [[NSMutableSet alloc] init];
        for(int i=0;i<[dic count];i++){
            media * item = [[media alloc] initWithArray:[(NSMutableArray *)dic objectAtIndex:i] withType:listType];
                if(![tempValues containsObject:[dic valueForKey:@"files_tw"][i]] ){
                    [tempValues addObject:[dic valueForKey:@"files_tw"][i]];
                    [broadcastDetailArray addObject:item];
                }
            
        }
        broadcastDetailArray=[[broadcastDetailArray reverseObjectEnumerator] allObjects];
        [resultDic setObject:broadcastDetailArray forKey:@"broadcastdetaillist"];
    }else if(listType==kListTypeVideoLive||listType==kListTypeVideoLive_CN){
        NSMutableArray *classArray=[NSMutableArray new];
        NSMutableArray * originalArray =[dic objectForKey:@""];
        
        for (int i=0 ;i<[dic count]; i++) {
            //NSMutableArray * liveArr =[[dic objectForKey:@"categories"]objectForKey:[originalArray objectAtIndex:i]];
            media * item = [[media alloc] initWithArray:(NSArray *)dic withType:listType];
            [classArray addObject:item];
            
        }
        [resultDic setObject:classArray forKey:@"live"];
    }
    
    return resultDic;
    
}

//- (NSMutableArray *)findflat:(NSString *)keyToFind fromDic:(NSDictionary *)dic{
//
//
//    for(id key in dic.allKeys) {
//        if (key !=keyToFind) {
//            for (id obj in [dic objectForKey:key]) {
//                if (obj!=keyToFind) {
//
//                    NSLog(@"%@",obj);
//                    }
//                }
//            }
//        }
//
//    return nil;
//}


//- (NSMutableArray *)handleClassData:(NSMutableArray *)array andDic:(NSDictionary *)dic{
//    //封装数据对象
//    NSMutableArray * resultArray = [NSMutableArray array];
//    for (int i=0 ;i<[array count]; i++) {
//        NSDictionary * mediaClassDic =[[dic objectForKey:@"categories"]objectForKey:[array objectAtIndex:i]];
//        media * item = [[media alloc] initWithDictionary:mediaClassDic];
//        [resultArray addObject:item];
//    }
//    return resultArray;
//}
@end
