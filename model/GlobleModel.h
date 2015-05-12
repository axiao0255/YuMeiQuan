//
//  GlobleModel.h
//  Yimeiquan
//
//  Created by airspuer on 14-7-25.
//  Copyright (c) 2014年 airspuer. All rights reserved.
//

#define   AIR_BODYFONTSIZE  @"AIR_BODYFONTSIZE"

#define   AIR_BODYFONTCOLOR  @"AIR_BODYFONTCOLOR"

#import <Foundation/Foundation.h>


@interface GlobleModel : NSObject
AS_SINGLETON(GlobleModel);
@property(nonatomic, assign)NSInteger bodyFontSize;

@property(nonatomic, strong)UIColor	 *bodyFontColor;

@end
