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

+(BOOL)checkCurrentNetwork
{
    BOOL isExistenceNetwork;
    //此处优化，避免多次创建网络的监听，
    static Reachability *r;
    if (r == nil)
    {
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress,sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        r = [Reachability reachabilityWithAddress:&zeroAddress];
//        r = [Reachability reachabilityWithHostname:@"www.apple.com"];
    }
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=TRUE;
            break;
    }
    if (!isExistenceNetwork) {
        UIAlertView *myalert = [[UIAlertView alloc] initWithTitle:@"网络错误"
                                                          message:@"Whoops！网络不给力，快找个信号满满的地方再刷新一下吧！"
                                                         delegate:self
                                                cancelButtonTitle:@"确认"
                                                otherButtonTitles:nil,nil];
        [myalert show];
    }
    return isExistenceNetwork;

}

#pragma mark -过滤表情
+(BOOL)isContainsEmoji:(NSString *)string {
    
    __block BOOL isEomji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         
         
         const unichar hs = [substring characterAtIndex:0];
         
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             
             if (substring.length > 1) {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
                     isEomji = YES;
                     
                 }
                 
             }
             
         } else if (substring.length > 1) {
             
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3 || ls == 0xfe0f ) {
                 
                 isEomji = YES;
                 
             }
             
         } else {
             
             // non surrogate
             
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 
                 isEomji = YES;
                 
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 
                 isEomji = YES;
                 
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 
                 isEomji = YES;
                 
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 
                 isEomji = YES;
                 
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 
                 isEomji = YES;
                 
             }
             
         }
     }];
    
    return isEomji;
    
}






@end
