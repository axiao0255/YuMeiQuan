//
//  AppDelegate.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/8.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

#define    UMAPPKEY  @"55501bca67e58eb401006e3a"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow               *window;

@property (strong, nonatomic) SlideNavigationController *slideNav;

-(void)shareWithIndex:(NSUInteger) index;


@end

