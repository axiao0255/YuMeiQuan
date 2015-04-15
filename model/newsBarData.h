//
//  newsBarData.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/8.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJScrollBarView.h"

@interface newsBarData : NSObject

@property (nonatomic,strong) NSArray *dataArray;

/**
 * 获取当前 第几个新闻的 title
 */

- (NSString *)currentTitleWithIndex:(NSInteger)index;


@end
