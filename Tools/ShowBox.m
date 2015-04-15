//
//  ShowBox.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "ShowBox.h"

@implementation ShowBox

+(void)showError:(NSString *)content
{
    if (content == nil || ![content isKindOfClass:[NSString class]])
    {
        if ([content isKindOfClass:[NSError class]])
        {
            content = [(NSError *)content localizedDescription];
        }
        else
        {
            content = [NSString stringWithFormat:@"%@",content];
        }
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

+(void)showSuccess:(NSString *)content
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

+(BOOL)alertEmail:(NSString *)Email
{
    if (Email.length==0) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写邮箱！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return YES;
    }
    else
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:Email options:0 range:NSMakeRange(0, [Email length])];
        if(numberOfMatches !=1 ){
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"邮箱格式不正确"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return YES;
        }
        else
            return NO;
    }
}


+(BOOL)alertPhoneNo:(NSString *)phoneNo
{
    if (phoneNo.length==0) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return YES;
    }
    else
    {
        NSRegularExpression *phone = [NSRegularExpression regularExpressionWithPattern:@"\\b(1)[3458][0-9]{9}\\b" options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger phoneMatches = [phone numberOfMatchesInString:phoneNo options:0 range:NSMakeRange(0, [phoneNo length])];
        if(phoneMatches !=1){
            
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请确认手机号码是否输入正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            return YES;
        }

        if (phoneNo.length != 11)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确地手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

+(BOOL)isEmptyString:(id)str
{
    //NSLog(@"strclasstype %@",[NSString stringWithUTF8String:object_getClassName(str)]);
    if (!str || [str isKindOfClass:[NSNull class]] || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSString class]]) {
        if ([str isEqualToString:@""] || [str isEqualToString:@"null"] || [str isEqualToString:@"<null>"]) {
            return YES;
        }
    }
    return NO;
}

+(void)checknetwork:(void(^)(BOOL status))netStatus
{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    AFHTTPSessionManager *_sharedClient  = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch ( status ) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"3G网络");
                netStatus(YES);
            
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"wifi");
                 netStatus(YES);
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"未连接");
                netStatus(NO);
            }
                break;
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"未知错误");
                netStatus(NO);
            }
                break;
            default:
            {
                NSLog(@"未知错误");
                netStatus(NO);
            }
                break;
        }
    }];
    [_sharedClient.reachabilityManager startMonitoring];
}




@end