//
//  RYMyInformListViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/5.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"

typedef enum : NSUInteger {
    InformSystem,
    InformActivity,
} InformType;

@interface RYMyInformListViewController : RYBaseViewController

- (id)initWithInfomType:(InformType)type;

@end
