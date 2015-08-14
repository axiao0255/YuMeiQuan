//
//  MJScrollPageView.m
//  MJRefreshExample
//
//  Created by 陈中笑 on 15-4-3.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MJScrollPageView.h"

@implementation MJScrollPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commInit];
    }
    return self;
}

-(void)commInit
{
    if ( !_scrollView ) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    if (_contentItems == nil) {
        _contentItems = [[NSMutableArray alloc] init];
    }
    
    if ( _dataSources == nil ) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    tableIndex = 0;
    // ---------------- 为了解决 滚动出侧边拦的手势冲突 begin——————————————————————
    _scrollView.bounces = NO;
    [_scrollView.panGestureRecognizer addTarget:self action:@selector(paningGestureReceive:)];
    // ---------------- 为了解决 滚动出侧边拦的手势冲突 end——————————————————————
    [self addSubview:_scrollView];
    
}

-(void)setContentOfTables:(NSInteger)aNumerOfTables
{
    for ( int i = 0;  i < aNumerOfTables; i ++ ) {
        MJRefreshTableView *refreshTableV = [[MJRefreshTableView alloc] initWithFrame:CGRectMake(self.frame.size.width * i , 0, self.bounds.size.width,self.bounds.size.height) style:UITableViewStylePlain];
        refreshTableV.backgroundColor = [UIColor clearColor];
        refreshTableV.delegateRefersh = self;
        [Utils setExtraCellLineHidden:refreshTableV];
        [_contentItems addObject:refreshTableV];
        [_scrollView addSubview:refreshTableV];
        if ( i == 0 ) {
            [refreshTableV headerBeginRefreshing];
        }
        [_dataSources addObject:[NSMutableArray array]];
    }
     [_scrollView setContentSize:CGSizeMake(self.frame.size.width * aNumerOfTables, self.frame.size.height)];
}

-(void)setTotlePageWithNum:(NSInteger)aTotlePage atIndex:(NSInteger)aIndex
{
    if (aTotlePage < 0 || aIndex < 0 || aIndex >= _contentItems.count) {
        return ;
    }
    MJRefreshTableView *v = [_contentItems objectAtIndex:aIndex];
    v.totlePage = aTotlePage;
}

- (void) getDataWithIsHeaderReresh:(BOOL)isHeaderReresh andCurrentPage:(NSInteger)currentPage
{
    if ( [self.delegate respondsToSelector:@selector(freshContentTableWithCurrentPage:andTableIndex:isHead:)]) {
        [self.delegate freshContentTableWithCurrentPage:currentPage andTableIndex:tableIndex isHead:isHeaderReresh];
    }
}
-(void)refreshEndAtTableViewIndex:(NSInteger) index isHead:(BOOL)ishead
{
    MJRefreshTableView *v = [_contentItems objectAtIndex:index];
    if ( ishead ) {
        [v headerFinishRefreshing];
    }
    else{
        [v footerFinishRereshing];
    }
}

-(void)moveScrollowViewAthIndex:(NSInteger)aIndex
{
    CGPoint point = CGPointMake(self.frame.size.width *aIndex, 0);
    [_scrollView setContentOffset:point animated:YES];
}

// ---------------- 为了解决 滚动出侧边拦的手势冲突 begin——————————————————————
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if ( canShowView ) {
        if ( [self.delegate respondsToSelector:@selector(handlePanGesture:)] ) {
            [self.delegate handlePanGesture:recoginzer];
        }
    }
}
// ---------------- 为了解决 滚动出侧边拦的手势冲突 end——————————————————————


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     // ---------------- 为了解决 滚动出侧边拦的手势冲突 begin——————————————————————
    CGFloat offx = scrollView.contentOffset.x;
    if ( offx <= 0 && offx >= lastOffx ) {
        canShowView = YES;
    }
    else{
        canShowView = NO;
    }
    // ---------------- 为了解决 滚动出侧边拦的手势冲突 end——————————————————————
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // ---------------- 为了解决 滚动出侧边拦的手势冲突 begin——————————————————————
    CGFloat offx = scrollView.contentOffset.x;
    if ( offx <= 0 ) {
        canShowView = YES;
    }
    else{
        canShowView = NO;
    }
    lastOffx = offx;
    // ----------------为了解决 滚动出侧边拦的手势冲突 end——————————————————————
    if ( [self.delegate respondsToSelector:@selector(scrollPageViewDidScroll:)] ) {
        [self.delegate scrollPageViewDidScroll:scrollView];
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    NSLog(@"结束 %ld",targetContentOffset);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = (_scrollView.contentOffset.x+self.frame.size.width/2.0) / self.frame.size.width;
    if (tableIndex == page) {
        return;
    }
    tableIndex= page;
    // 当前滑动到 第几页
    if ( [self.delegate respondsToSelector:@selector(currentMoveToPageAtIndex:)] ) {
        [self.delegate currentMoveToPageAtIndex:tableIndex];
    }
    
    NSArray *dataSource = [self.dataSources objectAtIndex:tableIndex];
    MJRefreshTableView *v = [_contentItems objectAtIndex:tableIndex];
    if ( dataSource.count > 0) {
        [v reloadData];
        return ;
    }
    [v headerBeginRefreshing];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger page = (_scrollView.contentOffset.x+self.frame.size.width/2.0) / self.frame.size.width;
    if (tableIndex == page) {
        return;
    }
    tableIndex= page;
    NSArray *dataSource = [self.dataSources objectAtIndex:tableIndex];
     MJRefreshTableView *v = [_contentItems objectAtIndex:tableIndex];
    if ( dataSource.count > 0) {
        [v reloadData];
        return ;
    }
    [v headerBeginRefreshing];
}


#pragma mark 清楚所有数据
-(void)removeAlldataSources
{
    for ( NSInteger i = 0; i < self.dataSources.count; i ++ ) {
        [[self.dataSources objectAtIndex:i]removeAllObjects];
         MJRefreshTableView *v = [_contentItems objectAtIndex:i];
        v.totlePage = 1;
        v.currentPage = 0;
        // 刷新表格
        [v reloadData];
    }
    MJRefreshTableView *v = [_contentItems objectAtIndex:tableIndex];
    [self getDataWithIsHeaderReresh:YES andCurrentPage:v.currentPage];
}

@end
