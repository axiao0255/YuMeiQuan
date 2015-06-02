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

#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

#define LoginText @"loginnew.text"

#define RELEASEADDRESS @""            // 正式服地址
#define DEBUGADDRESS   @"http://121.40.151.63"            // 测试服地址

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SELF_WIDTH (self.bounds.size.width)
#define SELF_HEIGHT (self.bounds.size.height)

#define VIEW_WIDTH (self.view.bounds.size.width)
#define VIEW_HEIGHT [UIScreen mainScreen].bounds.size.height - 64 // 64是导航的高度

//判断系统是否为大于7的
#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
//判断是否为4或者3.5寸屏
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )



#endif
