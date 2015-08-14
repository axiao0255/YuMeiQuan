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
#define USERNAME  @"userName"
#define PASSWORD  @"password"
#define ISLOGIN   @"islogin"

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
////判断是否为4或者3.5寸屏
//#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
//
//#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
//#define IS_IPHONE_6Plus ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kMY_USER_ID @"myUserId"
#define MY_USER_ID [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID]


#define SHARE_URL         @"shareUrl"     // 分享的网页地址
#define SHARE_TEXT        @"shareText"    // 分享文章内容
#define SHARE_CALLBACK_DI @"callback_id"  // 分享成功把该id回传给后台
#define SHARE_PIC         @"sharePic"     // 分享图片地址
#define SHARE_TID         @"share_tid"    // 分享的文章id




#endif
