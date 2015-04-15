//
//  MJScrollPageView.h
//  MJRefreshExample
//
//  Created by 陈中笑 on 15-4-3.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshTableView.h"

@protocol MJScrollPageViewDelegate <NSObject>

#pragma mark 刷新某个页面
@required
// 刷新数据 isHead      YES 为上拉刷新
-(void)freshContentTableAtIndex:(NSInteger)aIndex isHead:(BOOL)isHead;
// 当前滚动到 第几页
-(void)currentMoveToPageAtIndex:(NSInteger)aIndex;

- (NSInteger)mScreollTabel:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)mScreollTabel:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)mScreollTabel:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MJScrollPageView : UIView <UIScrollViewDelegate,MJRefershTableViewDelegate>
{
     NSInteger mCurrentPage;
}

@property (nonatomic,strong) NSMutableArray              *totlePages;
@property (nonatomic,strong) NSMutableArray              *currentPages;
@property (nonatomic,strong) NSMutableArray              *dataSources;

@property (nonatomic,strong) UIScrollView                *scrollView;
@property (nonatomic,strong) NSMutableArray              *contentItems;
@property (nonatomic,weak) id <MJScrollPageViewDelegate> delegate;

#pragma mark 添加ScrollowViewd的ContentView
-(void)setContentOfTables:(NSInteger)aNumerOfTables;
#pragma mark 滑动到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex;
#pragma mark 设置 totlePage
-(void)setTotlePageWithNum:(NSInteger)aTotlePage atIndex:(NSInteger)aIndex;
#pragma mark 刷新结束
-(void)refreshEnd;

@end
