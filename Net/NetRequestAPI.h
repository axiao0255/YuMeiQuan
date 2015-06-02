//
//  NetRequestAPI.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/28.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetRequestAPI : NSObject

#pragma mark - 用户登录
+(void)userLoginWithUserName:(NSString *)username
                    password:(NSString *)password
                     success:(void(^)(id responseDic))success
                     failure:(void(^)(id errorString))failure;

#pragma mark - 退出登录
+(void)userLogoutWithSessionId:(NSString *)session
                       success:(void(^)(id responseDic))success
                       failure:(void(^)(id errorString))failure;

#pragma mark - 首页的新闻 列表
+(void)getHomePageNewsListWithSessionId:(NSString *)session
                                    fid:(NSString *)_fid
                                   page:(NSInteger)_page
                                success:(void(^)(id responseDic))success
                                failure:(void(^)(id errorString))failure;

@end
