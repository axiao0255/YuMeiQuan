//
//  RYPastWeeklyViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"

@protocol RYPastWeeklyViewControllerDelegate <NSObject>

-(void)selectWeeklyWithWeeklyDict:(NSDictionary *)dict;

@end

@interface RYPastWeeklyViewController : RYBaseViewController

@property (nonatomic,strong) id <RYPastWeeklyViewControllerDelegate>delegate;

@end
