//
//  MJScrollBarView.h
//  MJRefreshExample
//
//  Created by 陈中笑 on 15-4-2.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOMALKEY   @"normalKey"      // 菜单 默认图
#define HEIGHTKEY  @"helightKey"     // 菜单 高亮图
#define TITLEKEY   @"titleKey"       // 菜单 名称
#define TITLEWIDTH @"titleWidth"     // 菜单 宽度
#define TOTALWIDTH @"totalWidth"     // button所在的位置 方便点击button时，移动位置。

@protocol MJScrollBarViewDelegate <NSObject>

@optional
/**
 *  菜单选择
 *
 *  @param index 选择的 下标
 */
-(void)didMenuClickedButtonAtIndex:(NSInteger)index;

@end

@interface MJScrollBarView : UIView
{
    UIScrollView        *mScrollView;
    NSMutableArray      *mItemInfoArray;
    NSMutableArray      *mButtonArray;
    float               mTotalWidth;
}
@property (nonatomic,weak) id<MJScrollBarViewDelegate>delegate;

#pragma mark 初始化菜单
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray;

#pragma mark 选中某个button
-(void)clickButtonAtIndex:(NSInteger)aIndex;

#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex;

@end
