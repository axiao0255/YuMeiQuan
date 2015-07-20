//
//  AppDelegate.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/8.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

#define    UMAPPKEY  @"55501bca67e58eb401006e3a"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow               *window;

@property (strong, nonatomic) SlideNavigationController *slideNav;

/*
 * 分享数据 配置
 */
-(void)shareWithIndex:(NSUInteger) index shareContent:(NSString *)content sharePicUrl:(NSString *)picUrl callbackId:(NSString *)_callbackId shareUrl:(NSString *)_shareUrl thid:(NSString *)_thid andPresentController:(UIViewController *)viewController;


@end

