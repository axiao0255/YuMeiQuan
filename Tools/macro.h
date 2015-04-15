//
//  macro.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/10.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#ifndef YuMeiQuan_macro_h
#define YuMeiQuan_macro_h

#import <Foundation/Foundation.h>

#define RELEASEADDRESS @""            // 正式服地址
#define DEBUGADDRESS   @""            // 测试服地址

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SELF_WIDTH (self.bounds.size.width)
#define SELF_HEIGHT (self.bounds.size.height)

#define VIEW_WIDTH (self.view.bounds.size.width)
#define VIEW_HEIGHT [UIScreen mainScreen].bounds.size.height - 64 // 64是导航的高度


#endif
