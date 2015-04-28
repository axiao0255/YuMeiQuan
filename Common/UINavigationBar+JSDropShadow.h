//
//  UINavigationBar+JSDropShadow.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (JSDropShadow)

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity;

@end
