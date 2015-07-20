//
//  GlobleModel.m
//  Yimeiquan
//
//  Created by airspuer on 14-7-25.
//  Copyright (c) 2014年 airspuer. All rights reserved.
//

#import "GlobleModel.h"

@implementation GlobleModel
DEF_SINGLETON(GlobleModel);

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSInteger)bodyFontSize
{
    NSNumber *fontSize = [[NSUserDefaults standardUserDefaults] objectForKey:AIR_BODYFONTSIZE];
    if (!fontSize) {
        fontSize = @(110);
    }
    return fontSize.floatValue;
}

- (void)setBodyFontSize:(NSInteger)bodyFontSize
{
	 [[NSUserDefaults standardUserDefaults] setObject:@(bodyFontSize) forKey:AIR_BODYFONTSIZE];
}

- (void)setBodyFontColor:(UIColor *)bodyFontColor
{
	[[NSUserDefaults standardUserDefaults] setObject:bodyFontColor forKey:AIR_BODYFONTSIZE];
}

@end
