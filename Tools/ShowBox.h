//
//  ShowBox.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import  "RYLoginViewController.h"



@interface ShowBox : NSObject

#pragma mark 弹出成功信息的弹窗
+(void)showSuccess:(NSString *)content;

#pragma mark 弹出失败信息的弹窗
+(void)showError:(NSString *)content;

#pragma mark 检测Email格式
+(BOOL)alertEmail:(NSString *)Email;

#pragma mark 检测手机号码格式
+(BOOL)alertPhoneNo:(NSString *)phoneNo;

#pragma mark 检查数据是否为空或null
+(BOOL)isEmptyString:(id)str;

#pragma mark 检查网络
+(void)checknetwork:(void(^)(BOOL status))netStatus;

#pragma mark 检测是否当前是否有网络
+(BOOL)checkCurrentNetwork;

#pragma mark -过滤表情
+(BOOL)isContainsEmoji:(NSString *)string;

#pragma mark -检查是否登录
+(BOOL)isLogin;

#pragma mark 判断是否登录，未登录则跳转到登录页面
+(BOOL)alertNoLoginWithPush:(UIViewController *) view;

#pragma mark 保存 点击文献分类的tag字典
+(void)saveLiteratureTagDict:(NSDictionary *)dict;

#pragma mark 取出 文献分类的tag字典
+(NSDictionary *)getLiteratureTagDict;

@end
