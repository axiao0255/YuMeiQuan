//
//  RYCorporateViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/13.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"
#import "RYCorporateHomePageData.h"

@protocol RYCorporateViewControllerDelegate <NSObject>

// 收藏状态变化之后 通知刷新数据
-(void)statesChange;

@end

@interface RYCorporateViewController : RYBaseViewController

@property (nonatomic , weak) id <RYCorporateViewControllerDelegate>delegate;

-(id)initWithCategoryData:(RYCorporateHomePageData *)data;

@end
