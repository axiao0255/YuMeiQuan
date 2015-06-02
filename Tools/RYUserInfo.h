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

@end
