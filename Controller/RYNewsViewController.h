//
//  RYNewsViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/8.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYBaseViewController.h"
#import "MJScrollBarView.h"
#import "MJScrollPageView.h"


@interface RYNewsViewController : RYBaseViewController


/**
 * 收到 云推送 后 的处理
 */
-(void)receivePushNoticeWithUserinfo:(NSDictionary *)userInfo;


@end
