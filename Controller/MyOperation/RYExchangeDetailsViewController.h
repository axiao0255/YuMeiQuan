//
//  RYExchangeDetailsViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"

@protocol RYExchangeDetailsViewControllerDelegate <NSObject>

- (void)exchangeDidSuccess;

@end


@interface RYExchangeDetailsViewController : RYBaseViewController

@property (nonatomic,weak) id<RYExchangeDetailsViewControllerDelegate> delegate;

-(id)initWithExchangeDict:(NSDictionary *)dict;

@end
