//
//  RYInviteMakeMoneyViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/6/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"

typedef enum : NSUInteger {
    survey,         // 调研
    transmit,       // 转发
} InviteType;

@interface RYInviteMakeMoneyViewController : RYBaseViewController

- (id)initWithInviteType:(InviteType)type;

@end
