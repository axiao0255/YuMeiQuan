//
//  RYCorporateProductCategoryViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"
#import "RYCorporateHomePageData.h"

@protocol RYCorporateProductCategoryViewControllerDelegate <NSObject>

-(void)categorySelectDidWithFid:(NSString *)fid;

@end

@interface RYCorporateProductCategoryViewController : RYBaseViewController

@property (nonatomic,weak) id<RYCorporateProductCategoryViewControllerDelegate>delegate;


-(id)initWithCategoryData:(RYCorporateHomePageData *)data;

@end
