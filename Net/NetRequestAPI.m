//
//  NetRequestAPI.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/28.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "NetRequestAPI.h"

@implementation NetRequestAPI

// 拼接 参数
+ (NSString *)getParamWithParamDic:(NSDictionary *)parmDic
{
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [parmDic keyEnumerator])
    {
        if (!([[parmDic valueForKey:key] isKindOfClass:[NSString class]]))
        {
            continue;
        }
        
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@",[Utils getEncodingWithUTF8:key], [Utils getEncodingWithUTF8:[parmDic objectForKey:key]]]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}


#pragma mark - 用户登录
+(void)userLoginWithUserName:(NSString *)username
                    password:(NSString *)password
                     success:(void(^)(id responseDic))success
                     failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"logging" forKey:@"mod"];
    [parDic setValue:@"login" forKey:@"action"];
    [parDic setValue:username?username:@"" forKey:@"username"];
    [parDic setValue:password?password:@"" forKey:@"password"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php?%@",DEBUGADDRESS,[self getParamWithParamDic:parDic]];
    
    [NetManager JSONDataWithUrl:url parameters:nil success:success fail:false];
}

#pragma mark - 退出登录
+(void)userLogoutWithSessionId:(NSString *)session
                       success:(void(^)(id responseDic))success
                       failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"logging" forKey:@"mod"];
    [parDic setValue:@"logout" forKey:@"action"];
    [parDic setValue:session forKey:@"sid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 首页的新闻 列表
+(void)getHomePageNewsListWithSessionId:(NSString *)session
                                    fid:(NSString *)_fid
                                   page:(NSInteger)_page
                                success:(void(^)(id responseDic))success
                                failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"forumlist" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_fid forKey:@"fid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
    
}



@end
