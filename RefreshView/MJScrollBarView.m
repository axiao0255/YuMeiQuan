//
//  MJScrollBarView.m
//  MJRefreshExample
//
//  Created by 陈中笑 on 15-4-2.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MJScrollBarView.h"

@implementation MJScrollBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray
{
    self = [super initWithFrame:frame];
    if ( self ) {
        // 初始化 button 数组
        if ( !mButtonArray ) {
            mButtonArray = [[NSMutableArray alloc] init];
        }
        // 初始化 scrollView
        if ( !mScrollView ) {
            mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
            mScrollView.showsHorizontalScrollIndicator = NO;
            mScrollView.showsVerticalScrollIndicator = NO;
            mScrollView.backgroundColor = [UIColor whiteColor];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-0.5, CGRectGetWidth(self.frame), 0.5)];
            line.backgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
            [mScrollView addSubview:line];
           }
        // 初始化 itemArray
        if (mItemInfoArray == nil) {
            mItemInfoArray = [[NSMutableArray alloc]init];
        }

       [self createMenuItems:aItemsArray];
    }
    return self;
}


/**
 *  创建菜单
 *
 *  @param aItemsArray 菜单数据源
 */
-(void)createMenuItems:(NSArray *)aItemsArray
{
    float menuWidth = 0.0;
    for (int i = 0; i < aItemsArray.count; i ++ ) {
        NSDictionary *dict = [aItemsArray objectAtIndex:i];
        NSString *vNormalImageStr = [dict objectForKey:NOMALKEY];
        NSString *vHeligtImageStr = [dict objectForKey:HEIGHTKEY];
        NSString *vTitleStr = [dict objectForKey:TITLEKEY];
        float vButtonWidth = [[dict objectForKey:TITLEWIDTH] floatValue];
        UIButton *vButton = [UIButton buttonWithType:UIButtonTypeCustom];
        vButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [vButton setBackgroundImage:[UIImage imageNamed:vNormalImageStr] forState:UIControlStateNormal];
        [vButton setBackgroundImage:[UIImage imageNamed:vHeligtImageStr] forState:UIControlStateSelected];
        [vButton setTitle:vTitleStr forState:UIControlStateNormal];
        [vButton setTitleColor:[Utils   getRGBColor:0x66 g:0x66 b:0x66 a:1.0] forState:UIControlStateNormal];
        [vButton setTitleColor:[Utils   getRGBColor:0x00 g:0x91 b:0xea a:1.0] forState:UIControlStateHighlighted];
        [vButton setTitleColor:[Utils   getRGBColor:0x00 g:0x91 b:0xea a:1.0] forState:UIControlStateSelected];
        [vButton setTag:i];
        [vButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [vButton setFrame:CGRectMake(menuWidth, 0, vButtonWidth, self.frame.size.height)];
        [mScrollView addSubview:vButton];
        [mButtonArray addObject:vButton];
        menuWidth += vButtonWidth;
        
        //保存button资源信息，同时增加button.oringin.x的位置，方便点击button时，移动位置。
        NSMutableDictionary *vNewDic = [dict mutableCopy];
        [vNewDic setObject:[NSNumber numberWithFloat:menuWidth] forKey:TOTALWIDTH];
        [mItemInfoArray addObject:vNewDic];
    }
    [mScrollView setContentSize:CGSizeMake(menuWidth, self.frame.size.height)];
    [self addSubview:mScrollView];
    
    // 保存menu总长度，如果小于320则不需要移动，方便点击button时移动位置的判断
    mTotalWidth = menuWidth;
}
#pragma mark 选中第几个button
-(void)clickButtonAtIndex:(NSInteger)aIndex{
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self menuButtonClicked:vButton];
}

#pragma mark - 点击事件
-(void)menuButtonClicked:(UIButton *)aButton{
    [self changeButtonStateAtIndex:aButton.tag];
    if ([_delegate respondsToSelector:@selector(didMenuClickedButtonAtIndex:)]) {
        [_delegate didMenuClickedButtonAtIndex:aButton.tag];
    }
}
#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex{
    if ( aIndex >= mButtonArray.count ) {
        return;
    }
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self changeButtonsToNormalState];
    vButton.selected = YES;
    [self moveScrolViewWithIndex:aIndex];
}
#pragma mark 取消所有button点击状态
-(void)changeButtonsToNormalState{
    for (UIButton *vButton in mButtonArray) {
        vButton.selected = NO;
    }
}

#pragma mark 移动button到可视的区域
-(void)moveScrolViewWithIndex:(NSInteger)aIndex{
    if (mItemInfoArray.count < aIndex) {
        return;
    }
    //宽度小于320肯定不需要移动
    if (mTotalWidth <= 320) {
        return;
    }
    NSDictionary *vDic = [mItemInfoArray objectAtIndex:aIndex];
    float vButtonOrigin = [[vDic objectForKey:TOTALWIDTH] floatValue];
    if (vButtonOrigin >= 300) {
        if ((vButtonOrigin + 180) >= mScrollView.contentSize.width) {
            [mScrollView setContentOffset:CGPointMake(mScrollView.contentSize.width - 320, mScrollView.contentOffset.y) animated:YES];
            return;
        }
        
        float vMoveToContentOffset = vButtonOrigin - 180;
        if (vMoveToContentOffset > 0) {
            [mScrollView setContentOffset:CGPointMake(vMoveToContentOffset, mScrollView.contentOffset.y) animated:YES];
        }
        //        NSLog(@"scrollwOffset.x:%f,ButtonOrigin.x:%f,mscrollwContentSize.width:%f",mScrollView.contentOffset.x,vButtonOrigin,mScrollView.contentSize.width);
    }else{
        [mScrollView setContentOffset:CGPointMake(0, mScrollView.contentOffset.y) animated:YES];
        return;
    }
}

#pragma mark 内存相关
-(void)dealloc{
    [mButtonArray removeAllObjects],mButtonArray = nil;
}

@end
