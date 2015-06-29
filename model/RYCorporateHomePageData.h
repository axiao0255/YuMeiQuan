//
//  RYCorporateHomePageData.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/13.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYCorporateHomePageData : NSObject

@property (nonatomic , strong) NSDictionary   *corporateBody;
@property (nonatomic , assign) BOOL           isAttention;
@property (nonatomic , strong) NSMutableArray *corporateArticles;

// 企业文章分类
@property (nonatomic , strong) NSArray        *categoryArray;

@end
