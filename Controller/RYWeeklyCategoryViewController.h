//
//  RYWeeklyCategoryViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/10.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

@protocol RYWeeklyCategoryViewControllerDelegate <NSObject>

-(void)selectDidCategoryDict:(NSDictionary *)dict;

@end

#import "RYBaseViewController.h"

@interface RYWeeklyCategoryViewController : RYBaseViewController

@property (nonatomic,weak) id <RYWeeklyCategoryViewControllerDelegate>delegate;

-(id)initWithCategory:(NSArray *)categoryArray;

@end
