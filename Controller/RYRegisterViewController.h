//
//  RYRegisterViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/10.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"
#import "TextFieldWithLabel.h"

typedef enum : NSUInteger {
    typePersonal = 0,   // 个人
    typeCollective,     // 企业
} registerType;         // 注册类型

@interface RYRegisterViewController : RYBaseViewController


- (id)initWithRefisterType:(registerType) type;

@end
