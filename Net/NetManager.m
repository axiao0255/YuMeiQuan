//
//  NetManager.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "NetManager.h"

@implementation NetManager


+ (void)JSONDataWithUrl:(NSString *)url success:(void (^)(id json))success fail:(void (^)(id error))fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
    NSDictionary *dict = @{@"format": @"json"};
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
        else{
            NSError *error = [NSError errorWithDomain:@"请求出错" code:500 userInfo:nil];
            fail (error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
        if (fail) {
            fail(error);
        }
    }];
}

+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(id error))fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (success) {
            success(responseObject);
        }
        else{
            NSError *error = [NSError errorWithDomain:@"请求出错" code:500 userInfo:nil];
            fail (error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail(error);
        }
    }];
}

@end
