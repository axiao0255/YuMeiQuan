//
//  GridMenuView.h
//  RongYi
//
//  九宫格按钮组控件
//
//  Created by udspj on 13-11-1.
//  Copyright (c) 2013年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GridMenuViewDelegate

/**
 * @param btntag 被选中的按钮的tag
 * @param selftag GridMenuView自己的tag
 */
- (void)GridMenuViewButtonSelected:(NSInteger)btntag selfTag:(NSInteger)selftag;

@end

@interface GridMenuView : UIView
{
    NSMutableArray *itemViewsArray;
    NSArray *btnuparray;
    NSArray *btndownarray;

    __unsafe_unretained id<GridMenuViewDelegate> delegate;
    
    UIColor *myTitledowncolor;
    UIColor *myTitleupcolor;
}

@property(assign)NSInteger selectedbtnnum;//指示哪个按钮被选中

@property(assign)BOOL canshowdownimg;//是否保留按钮的选中状态

@property(nonatomic, readwrite, assign) id<GridMenuViewDelegate> delegate;

/**
 * 创建背景图不同、无title的按钮组，图片都从本地获取
 *
 * @param frame 整个按钮组的位置和宽高
 * @param imguparray 普通状态的按钮图片数组
 * @param imgdownarray 按下状态的按钮图片数组
 * @param perrownum 每一行最多放几个按钮
 *
 * @return 按钮组view
 */
- (id)initWithFrame:(CGRect)frame imgUpArray:(NSArray *)imguparray imgDownArray:(NSArray *)imgdownarray perRowNum:(int)perrownum;

/**
 * 创建背景图不同、有title的按钮组，图片都从本地获取
 *
 * @param frame 整个按钮组的位置和宽高
 * @param imguparray 普通状态的按钮图片数组
 * @param imgdownarray 按下状态的按钮图片数组
 * @param perrownum 每一行最多放几个按钮
 * @param titlearray title数组
 *
 * @return 按钮组view
 */

- (id)initWithFrame:(CGRect)frame imgUpArray:(NSArray *)imguparray imgDownArray:(NSArray *)imgdownarray perRowNum:(int)perrownum titleArray:(NSArray *)titlearray;

/**
 * 创建背景图不同、无title的按钮组，图片都从本地获取
 *
 * @param frame 整个按钮组的位置和宽高
 * @param imgurlarray 图片url数组
 * @param imgsize 按钮尺寸
 * @param imgdefault 默认图片名称
 * @param perrownum 每一行最多放几个按钮
 *
 * @return 按钮组view
 */
- (id)initWithFrame:(CGRect)frame imgURLArray:(NSArray *)imgurlarray imgSize:(CGSize)imgsize imgDefault:(NSString *)imgdefault perRowNum:(int)perrownum;

/**
 * 创建相同背景图、有title的按钮组，图片从本地获取
 *
 * @param frame 整个按钮组的位置和宽高
 * @param imgupname 普通状态的按钮图片名称
 * @param imgdownname 按下状态的按钮图片名称
 * @param titlearray 按钮标题array
 * @param titledowncolor 按下时按钮标题的颜色
 * @param titleupcolor 按钮标题的颜色
 * @param perrownum 每一行最多放几个按钮
 *
 * @return 按钮组view
 */
- (id)initWithFrame:(CGRect)frame imgUpName:(NSString *)imgupname imgDownName:(NSString *)imgdownname titleArray:(NSArray *)titlearray titleDownColor:(UIColor *)titledowncolor titleUpColor:(UIColor *)titleupcolor perRowNum:(int)perrownum;

/**
 * 创建相同背景图、有title的按钮组，图片从本地获取
 *
 * @param frame 整个按钮组的位置和宽高
 * @param imgupname 普通状态的按钮图片名称
 * @param imgdownname 按下状态的按钮图片名称
 * @param titlearray 按钮标题array
 * @param titledowncolor 按下时按钮标题的颜色
 * @param titleupcolor 按钮标题的颜色
 * @param perrownum 每一行最多放几个按钮
 *
 * @return 按钮组view
 */
- (id)initWithFrame:(CGRect)frame imgUpName:(NSString *)imgupname imgDownName:(NSString *)imgdownname titleArray:(NSArray *)titlearray titleDownColor:(UIColor *)titledowncolor titleUpColor:(UIColor *)titleupcolor perRowNum:(int)perrownum andCanshowHighlight:(BOOL)showhight;

@end
