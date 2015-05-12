//
//  UIButton+Expand.h
//  OneStore
//
//  Created by airspuer on 14-5-13.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OTSUIButtonLayoutStyle) {
	OTSImageLeftTitleRightStyle = 0, //默认的方式 image左 title右
	OTSTitleLeftImageRightStyle = 1, // image右,title左
	OTSImageTopTitleBootomStyle = 2, //image上，title下
	OTSTitleTopImageBootomStyle = 3, // image下,title上
};
@interface UIButton(Expand)

/**
 *	功能:设置UIButton的布局，图片和文字按照指定方向显示
 *
 *	@param aLayoutStyle:参见OTSUIButtonLayoutStyle
 *	@param aSpacing:图片和文字之间的间隔
 */
- (void)setLayout:(OTSUIButtonLayoutStyle )aLayoutStyle
		  spacing:(CGFloat)aSpacing;
@end
