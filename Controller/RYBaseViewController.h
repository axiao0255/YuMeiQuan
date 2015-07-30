//
//  RYBaseViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/8.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYBaseViewController.h"

@interface RYBaseViewController : UIViewController

// 删除错误提示
-(void)removeErroeView;
-(void)showErrorView:(UIView*)parent;
//-(void)showErrorView:(UIView*)parent Info:(NSString*)info Image:(UIImage*)image;

@end
