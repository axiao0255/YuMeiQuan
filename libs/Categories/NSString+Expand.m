//
//  NSString+Expand.m
//  Yimeiquan
//
//  Created by airspuer on 14-7-25.
//  Copyright (c) 2014年 airspuer. All rights reserved.
//

#import "NSString+Expand.h"

@implementation NSString(Expand)
- (NSString *) replaceHTMLEntitiesInString {
    NSString *htmlString = [self stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    return htmlString;
}
@end
