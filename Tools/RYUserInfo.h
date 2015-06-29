//
//  RYUserInfo.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/28.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>


#define sessionKey     @"sessionKey"
#define groupidKey     @"groupidKey"
#define statusKey      @"statusKey"
#define creditsKey     @"creditsKey"
#define realnameKey    @"realnameKey"

@interface RYUserInfo : NSObject

@property (nonatomic ,strong) NSString       *session;
@property (nonatomic ,strong) NSString       *groupid;
@property (nonatomic ,strong) NSString       *status;
@property (nonatomic ,strong) NSString       *credits;
@property (nonatomic ,strong) NSString       *realname;

+ (instancetype)sharedManager;

- (void)refreshUserInfoDataWithDict:(NSDictionary *)dict;

+ (void)logout;


/**
 *  登录方法
 *  此处写登录方法，主要是处理 密码加密等.
 *  登录的流程为 首先获取公钥， 再用公钥加密 完成登录
 *  @param userName
 *  @param password
 *  @param success
 *  @param failure
 */
+ (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                  success:(void (^)(BOOL isSucceed))success
                  failure:(void (^)(id errorString))failure;


/**
 *自动登录接口，自动获取之前保存的 用户名和密码
 */
+ (void)automateLoginWithLoginSuccess:(void (^)(BOOL isSucceed))success
                              failure:(void (^)(id errorString))failure;


@end
