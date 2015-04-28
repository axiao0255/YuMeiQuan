//
//  UINavigationBar+JSDropShadow.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "UINavigationBar+JSDropShadow.h"

@implementation UINavigationBar (JSDropShadow)

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    
    // Creating shadow path for better performance
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, self.bounds);
//    self.layer.shadowPath = path;
//    CGPathCloseSubpath(path);
//    CGPathRelease(path);
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.clipsToBounds = NO;
    
}

@end
