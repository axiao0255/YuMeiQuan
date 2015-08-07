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
    self.username = [userDefaults stringForKey:usernameKey];
    self.uid = [userDefaults stringForKey:uidKey];
    self.address = [userDefaults stringForKey:addressKey];
}


- (void)storeuserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.session forKey:sessionKey];
    [userDefaults setObject:self.groupid forKey:groupidKey];
    [userDefaults setObject:self.status forKey:statusKey];
    [userDefaults setObject:self.credits forKey:creditsKey];
    [userDefaults setObject:self.realname forKey:realnameKey];
    [userDefaults setObject:self.username forKey:usernameKey];
    [userDefaults setObject:self.uid forKey:uidKey];
    [userDefaults setObject:self.address forKey:addressKey];
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
        [[RYUserInfo sharedManager] setUsername:@""];
        [[RYUserInfo sharedManager] setUid:@""];
        [[RYUserInfo sharedManager] setAddress:@""];
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
            if ( [key isEqualToString:@"username"] ){
                [[RYUserInfo sharedManager] setUsername:[dict getStringValueForKey:@"username" defaultValue:@""]];
            }
            if ( [key isEqualToString:@"uid"] ) {
                [[RYUserInfo sharedManager] setUid:[dict getStringValueForKey:@"uid" defaultValue:@""]];
            }
            if ( [key isEqualToString:@"address"] ) {
                [[RYUserInfo sharedManager] setAddress:[dict getStringValueForKey:@"address" defaultValue:@""]];
            }
        }
    }
    
    [self storeuserInfo];
}

+ (void)logout
{
    
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies])
//    {
//        [storage deleteCookie:cookie];
//    }
    [self clearCache];

//      注销
//    __weak typeof(self) wSelf = self;
//    [NetRequestAPI userLogoutWithSessionId:[RYUserInfo sharedManager].session
//                                   success:^(id responseDic) {
//                                       NSLog(@"退出 登录 responseDic : %@",responseDic);
//                                       [wSelf clearCache];
//
//                                   } failure:^(id errorString) {
//                                       [wSelf clearCache];
//                                       NSLog(@"退出 登录 errorString : %@",errorString);
//
//                                   }];
//    
}


+(void)clearCache
{
    [[RYUserInfo sharedManager] refreshUserInfoDataWithDict:nil];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:LoginText];
    NSDictionary *savedDic = [NSDictionary dictionaryWithContentsOfFile:path];
    [savedDic setValue:@"0" forKey:ISLOGIN];
//    [savedDic setValue:@"" forKey:USERNAME];
//    [savedDic setValue:@"" forKey:PASSWORD];
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
                  success:(void (^)(BOOL isSucceed ,id info))success
                  failure:(void (^)(id errorString))failure;
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    [NetRequestAPI userLoginWithUserName:userName password:password success:^(id responseDic) {
//        NSLog(@"responseDic : %@",responseDic);
        
        NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
        BOOL su = [meta getBoolValueForKey:@"success" defaultValue:NO];
        if ( !su ) {
            success(NO,nil);
            [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"登录出错"]];
            return;
        }
        // 登录成功后 记住用户名和密码
        NSMutableDictionary *savedDic = [[NSMutableDictionary alloc] init];
        [savedDic setObject:userName forKey:USERNAME];
        [savedDic setObject:password forKey:PASSWORD];
        [savedDic setObject:@"1" forKey:ISLOGIN];
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [docPath stringByAppendingPathComponent:LoginText];
        [savedDic writeToFile:path atomically:YES];
        
        NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
        [[RYUserInfo sharedManager] refreshUserInfoDataWithDict:info];
        
        success(YES,info);
        
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
    
    [[self class] loginWithUserName:[dict getStringValueForKey:USERNAME defaultValue:@""]
                           password:[dict getStringValueForKey:PASSWORD defaultValue:@""]
                            success:^(BOOL isSucceed, id info) {
                                success (isSucceed);
    } failure:^(id errorString) {
        failure(errorString);
    }];
}



@end
