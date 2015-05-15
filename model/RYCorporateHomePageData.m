//
//  RYCorporateHomePageData.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/13.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYCorporateHomePageData.h"

@implementation RYCorporateHomePageData

- (NSMutableArray *)corporateArticles
{
    if (_corporateArticles == nil ) {
        _corporateArticles = [NSMutableArray array];
    }
    return _corporateArticles;
}

@end
