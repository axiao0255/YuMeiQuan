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
        [[RYUserInfo sharedManager] setSession:[dict getStringValueForKey:@"sid" defaultValue:@""]];
        [[RYUserInfo sharedManager] setGroupid:[dict getStringValueForKey:@"groupid" defaultValue:@""]];
        [[RYUserInfo sharedManager] setStatus:[dict getStringValueForKey:@"status" defaultValue:@""]];
        [[RYUserInfo sharedManager] setCredits:[dict getStringValueForKey:@"credits" defaultValue:@""]];
        [[RYUserInfo sharedManager] setRealname:[dict getStringValueForKey:@"realname" defaultValue:@""]];
    }
    
    [self storeuserInfo];
}

@end
