//
//  NetManager.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface NetManager : NSObject

+ (id)sharedManager;

@property(nonatomic,retain)NSMutableArray *requestArray;

-(void)cancelAllURLRequest;

/**
 * get 方式 请求   返回 JSON 数据
 */
- (void)JSONDataWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id json))success fail:(void (^)(id error))fail;

/**
 * post提交json数据
 */
- (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(id error))fail;


/**
 * 上传图片
 */
- (void)uploadImageWithUrl:(NSString *)urlStr image:(UIImage *)image parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(id error))fail;

/**
 *上传录音
 */
- (void)uploadFileWithUrl:(NSString *)urlStr filePath:(NSURL *)_filePath parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(id error))fail;


@end
