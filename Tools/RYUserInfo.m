//
//  RYUserInfo.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/28.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYUserInfo.h"

static RYUserInfo * _userInfo;

@implementation RYUserInfo

#pragma mark - 获取单例
+ (instancetype)sharedManager{
    if (!_userInfo) {
        _userInfo = [[RYUserInfo alloc]init];
    }
    
    return _userInfo;
}

- (id)init
{
    self = [super init];
    if ( self ) {
        [self getuserInfoFromDisk];
    }
    return self;
}

- (void)getuserInfoFromDisk
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.session = [userDefaults stringForKey:sessionKey];
    self.groupid = [userDefaults stringForKey:groupidKey];
    self.status = [userDefaults stringForKey:statusKey];
    self.credits = [userDefaults stringForKey:creditsKey];
    self.realname = [userDefaults stringForKey:realnameKey];
}


- (void)storeuserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.session forKey:sessionKey];
    [userDefaults setObject:self.groupid forKey:groupidKey];
    [userDefaults setObject:self.status forKey:statusKey];
    [userDefaults setObject:self.credits forKey:creditsKey];
    [userDefaults setObject:self.realname forKey:realnameKey];
    [userDefaults synchronize];
}


- (void)refreshUserInfoDataWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        [[RYUserInfo sharedManager] setSession:@""];
        [[RYUserInfo sharedManager] setGroupid:@""];
        [[RYUserInfo sharedManager] setStatus:@""];
        [[RYUserInfo sharedManager] setCredits:@""];
        [[RYUserInfo sharedManager] setRealname:@""];
    }
    else{
        
        NSArray *keys = [dict allKeys];    // 此处的 keys 是变化的
        for (NSString *key in keys) {
            if ( [key isEqualToString:@"sid"] ) {
              [[RYUserInfo sharedManager] setSession:[dict getStringValueForKey:@"sid" defaultValue:@""]];
            }
            if ( [key isEqualToString:@"groupid"] ) {
                [[RYUserInfo sharedManager] setGroupid:[dict getStringValueForKey:@"groupid" defaultValue:@""]];
            }
            if ( [key isEqualToString:@"status"] ) {
                [[RYUserInfo sharedManager] setStatus:[dict getStringValueForKey:@"status" defaultValue:@""]];
            }
            if ( [key isEqualToString:@"credits"] ) {
                [[RYUserInfo sharedManager] setCredits:[dict getStringValueForKey:@"credits" defaultValue:@""]];
            }
            if ( [key isEqualToString:@"realname"] ) {
                [[RYUserInfo sharedManager] setRealname:[dict getStringValueForKey:@"realname" defaultValue:@""]];
            }
        }
    }
    
    [self storeuserInfo];
}

+ (void)logout
{
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }

    //  注销
    __weak typeof(self) wSelf = self;
    [NetRequestAPI userLogoutWithSessionId:[RYUserInfo sharedManager].session
                                   success:^(id responseDic) {
                                       NSLog(@"退出 登录 responseDic : %@",responseDic);
                                       [wSelf clearCache];

                                   } failure:^(id errorString) {
                                       [wSelf clearCache];
                                       NSLog(@"退出 登录 errorString : %@",errorString);

                                   }];
    
}


+(void)clearCache
{
    [[RYUserInfo sharedManager] refreshUserInfoDataWithDict:nil];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:LoginText];
    NSDictionary *savedDic = [NSDictionary dictionaryWithContentsOfFile:path];
    [savedDic setValue:@"0" forKey:@"islogin"];
    [savedDic writeToFile:path atomically:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStateChange" object:nil];
}


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
                  success:(void (^)(BOOL))success
                  failure:(void (^)(id))failure
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    [NetRequestAPI userLoginWithUserName:userName password:password success:^(id responseDic) {
        NSLog(@"responseDic : %@",responseDic);
        
        if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
            [ShowBox showError:@"登录失败，请稍候重试"];
            success(NO);
            return ;
        }
        
        NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
        if ( meta == nil || [meta isKindOfClass:[NSNull class]]) {
            [ShowBox showError:@"登录失败，请稍候重试"];
            success(NO);
            return ;
        }
        
        BOOL su = [meta getBoolValueForKey:@"success" defaultValue:NO];
        if ( !su ) {
            [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"登录失败，请稍候重试"]];
            success(NO);
            return;
        }
        // 登录成功后 记住用户名和密码
        NSMutableDictionary *savedDic = [[NSMutableDictionary alloc] init];
        [savedDic setObject:userName forKey:@"userName"];
        [savedDic setObject:password forKey:@"password"];
        [savedDic setObject:@"1" forKey:@"islogin"];
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [docPath stringByAppendingPathComponent:LoginText];
        [savedDic writeToFile:path atomically:YES];
        
        NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
        [[RYUserInfo sharedManager] refreshUserInfoDataWithDict:info];
        
        success(YES);
        
    } failure:^(id errorString) {
        failure(@"网络出现问题，请稍候重试！");
    }];
}

/**
 *自动登录接口，自动获取之前保存的 用户名和密码
 */
+ (void)automateLoginWithLoginSuccess:(void (^)(BOOL isSucceed))success
                              failure:(void (^)(id errorString))failure
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:LoginText];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
   [[self class] loginWithUserName:[dict getStringValueForKey:@"userName" defaultValue:@""]
                          password:[dict getStringValueForKey:@"password" defaultValue:@""]
                           success:^(BOOL isSucceed) {
                               success (isSucceed);
   } failure:^(id errorString) {
       failure(errorString);
   }];
}



@end
