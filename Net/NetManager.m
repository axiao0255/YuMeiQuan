//
//  NetManager.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "NetManager.h"

@implementation NetManager

static NetManager *_manager;

@synthesize requestArray;

#pragma mark - 获取单例
+ (id)sharedManager{
    if (!_manager) {
        _manager = [[NetManager alloc] init];
    }
    return _manager;
}

-(void)cancelAllURLRequest{
    
    NSInteger  requestcount = [[NetManager sharedManager] requestArray].count;
    for (int i = 0; i < requestcount; i ++) {
        [[[[NetManager sharedManager] requestArray] objectAtIndex:i] cancelAllOperations];
    }
    [[[NetManager sharedManager] requestArray] removeAllObjects];
}


- (void)JSONDataWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id json))success fail:(void (^)(id error))fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
//    [manager.requestSerializer setValue:@"V5" forHTTPHeaderField:@"Accept"];
    
    __weak typeof(self) wSelf = self;
    @synchronized(wSelf){
        [[[NetManager sharedManager] requestArray] addObject:manager];
    }

  
//    NSDictionary *dict = @{@"format": @"json"};
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog ( @"operation: %@" , operation. responseString );
        /**
         *  需要将该请求移除队列
         */
        @synchronized(wSelf){
            [operation cancel];
            [manager.operationQueue cancelAllOperations];
            [[[NetManager sharedManager] requestArray] removeObject:manager];
        }

        if (success) {
            success(responseObject);
        }
        else{
            NSError *error = [NSError errorWithDomain:@"请求出错" code:500 userInfo:nil];
            fail (error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        /**
         *  需要将该请求移除队列
         */
        @synchronized(wSelf){
            [operation cancel];
            [manager.operationQueue cancelAllOperations];
            [[[NetManager sharedManager] requestArray] removeObject:manager];
        }
        
        NSLog(@"%@", error);
        if (fail) {
            fail(error);
        }
    }];
}

- (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(id error))fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    [manager.requestSerializer setValue:@"V5" forHTTPHeaderField:@"Accept"];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __weak typeof(self) wSelf = self;
    @synchronized(wSelf){
        [[[NetManager sharedManager] requestArray] addObject:manager];
    }
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog ( @"operation: %@" , operation. responseString );
        /**
         *  需要将该请求移除队列
         */
        @synchronized(wSelf){
            [operation cancel];
            [manager.operationQueue cancelAllOperations];
            [[[NetManager sharedManager] requestArray] removeObject:manager];
        }

        if (success) {
            success(responseObject);
        }
        else{
            NSError *error = [NSError errorWithDomain:@"请求出错" code:500 userInfo:nil];
            fail (error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        /**
         *  需要将该请求移除队列
         */
        @synchronized(wSelf){
            [operation cancel];
            [manager.operationQueue cancelAllOperations];
            [[[NetManager sharedManager] requestArray] removeObject:manager];
        }

        NSLog(@"%@", error);
        if (fail) {
            fail(error);
        }
    }];
}

- (void)uploadImageWithUrl:(NSString *)urlStr image:(UIImage *)image parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(id error))fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];
    
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if ( image ) {
           
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            
//            NSLog(@"图片数据 ： %@",imageData);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            // 上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject isKindOfClass:[NSData class]] ) {
            NSDictionary *jsonObject =[NSJSONSerialization
                         JSONObjectWithData:responseObject
                         options:NSJSONReadingMutableLeaves
                         error:nil];
            success(jsonObject);
        }
        else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
    
}

/**
 *上传录音
 */
- (void)uploadFileWithUrl:(NSString *)urlStr filePath:(NSURL *)_filePath parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(id error))fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];
    
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        NSLog(@"音乐文件路径 _filePath: %@ ",_filePath);
//        NSData *data = [NSData dataWithContentsOfURL:_filePath];
//        NSLog(@"data : %@", data);
        if ( _filePath != nil ) {
            [formData appendPartWithFileURL:_filePath name:@"file" error:nil];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ( [responseObject isKindOfClass:[NSData class]] ) {
            NSDictionary *jsonObject =[NSJSONSerialization
                                       JSONObjectWithData:responseObject
                                       options:NSJSONReadingMutableLeaves
                                       error:nil];
            success(jsonObject);
        }
        else{
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];

    
}

@end
