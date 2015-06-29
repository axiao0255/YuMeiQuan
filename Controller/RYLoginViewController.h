//
//  RYLoginViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"
#import "TextFieldWithLabel.h"

typedef void(^LoginCallBack)(BOOL isLogin,NSError *error);

@interface RYLoginViewController : RYBaseViewController
//登录的回调
@property (nonatomic, copy) LoginCallBack finishBlock;

- (id)initWithFinishBlock:(LoginCallBack)callBack;

@end
