//
//  RYArticleData.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYArticleData.h"
#import "Base64.h"

@implementation RYArticleData

@synthesize subject,author;

- (void)setMessage:(NSString *)message
{
    if (_message != message) {
        _message = [message base64DecodedString];
    }
}

- (void)setDateline:(NSString *)dateline
{
    if (_dateline != dateline) {
        _dateline = [dateline replaceHTMLEntitiesInString];
    }
}

@end
