//
//  newsBarData.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/8.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "newsBarData.h"

@implementation newsBarData

- (NSArray *)dataArray
{
    if ( _dataArray == nil ) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}


- (NSString *)currentTitleWithIndex:(NSInteger)index
{

    if ( self.dataArray.count <= 0 || self.dataArray == nil || index < 0 || index >= self.dataArray.count ) {
        return @"";
    }
    NSDictionary *dict = [self.dataArray objectAtIndex:index];
    NSString *vTitleStr = [dict objectForKey:TITLEKEY];
    return vTitleStr;
}

@end
