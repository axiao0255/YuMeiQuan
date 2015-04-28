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
    if ( _currentPages == nil ) {
        _currentPages = [[NSMutableArray alloc] init];
    }
    if ( _totlePages == nil ) {
        _totlePages = [[NSMutableArray alloc] init];
    }
    mCurrentPage = 0;
    [self addSubview:_scrollView];
    
}

-(void)setContentOfTables:(NSInteger)aNumerOfTables
{
    for ( int i = 0;  i < aNumerOfTables; i ++ ) {
        MJRefreshTableView *refreshTableV = [[MJRefreshTableView alloc] initWithFrame:CGRectMake(self.frame.size.width * i , 0, self.bounds.size.width, self.bounds.size.height)];
        refreshTableV.delegate = self;
        refreshTableV.dataSource = self;
        [_contentItems addObject:refreshTableV];
        [_scrollView addSubview:refreshTableV];
        
        [_totlePages addObject:[NSNumber numberWithInt:1]];
        [_currentPages addObject:[NSNumber numberWithInt:0]];
        [_dataSources addObject:[NSMutableArray array]];
    }
    [self headerRereshingData];
    
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width * aNumerOfTables, self.frame.size.height)];
}

-(void)setTotlePageWithNum:(NSInteger)aTotlePage atIndex:(NSInteger)aIndex
{
    if (aTotlePage < 0 || aIndex < 0 || aIndex >= _contentItems.count) {
        return ;
    }
    
    [_totlePages removeObjectAtIndex:aIndex];
    [_totlePages insertObject:[NSNumber numberWithInteger:aTotlePage] atIndex:aIndex];
}

- (void)headerRereshingData
{
    // 下拉 刷新 重新设置 页码
    [_currentPages removeObjectAtIndex:mCurrentPage];
    [_currentPages insertObject:[NSNumber numberWithInt:0] atIndex:mCurrentPage];
    
    [_totlePages removeObjectAtIndex:mCurrentPage];
    [_totlePages insertObject:[NSNumber numberWithInt:1] atIndex:mCurrentPage];
    
    // 清空 数据
    NSMutableArray *arr = [_dataSources objectAtIndex:mCurrentPage];
    [arr removeAllObjects];
    
    if ( [self.delegate respondsToSelector:@selector(freshContentTableAtIndex:isHead:)] ) {
        [self.delegate freshContentTableAtIndex:mCurrentPage isHead:YES];
    }
}

- (void)footerRereshingData
{
    NSInteger currentPage = [[_currentPages objectAtIndex:mCurrentPage]intValue];
    currentPage ++ ;
    
    NSInteger totlePage = [[_totlePages objectAtIndex:mCurrentPage] intValue];
    if ( currentPage >= totlePage ) {
        [self refreshEnd];
        return;
    }
    
    if ( [self.delegate respondsToSelector:@selector(freshContentTableAtIndex:isHead:)] ) {
        [self.delegate freshContentTableAtIndex:mCurrentPage isHead:NO];
    }
}

-(void)refreshEnd
{
    MJRefreshTableView *v = [_contentItems objectAtIndex:mCurrentPage];
    [v footerFinishRereshing];
    [v headerFinishRefreshing];
}

-(void)moveScrollowViewAthIndex:(NSInteger)aIndex
{
//    CGRect vMoveRect = CGRectMake(self.frame.size.width * aIndex, 0, self.frame.size.width, self.frame.size.width);
//    mCurrentPage= aIndex;
//    [_scrollView scrollRectToVisible:vMoveRect animated:YES];
    CGPoint point = CGPointMake(self.frame.size.width *aIndex, 0);
    [_scrollView setContentOffset:point animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSInteger page = (_scrollView.contentOffset.x+self.frame.size.width/2.0) / self.frame.size.width;
//    if (mCurrentPage == page) {
//        return;
//    }
//    mCurrentPage= page;
//    // 当前滑动到 第几页
//    if ( [self.delegate respondsToSelector:@selector(currentMoveToPageAtIndex:)] ) {
//        [self.delegate currentMoveToPageAtIndex:mCurrentPage];
//    }
//    
//    NSArray *dataSource = [self.dataSources objectAtIndex:mCurrentPage];
//    if ( dataSource.count > 0) {
//         MJRefreshTableView *v = [_contentItems objectAtIndex:mCurrentPage];
//        [v reloadData];
//        return ;
//    }
//    if ( [self.delegate respondsToSelector:@selector(freshContentTableAtIndex:isHead:)] ) {
//        [self.delegate freshContentTableAtIndex:mCurrentPage isHead:YES];
//    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = (_scrollView.contentOffset.x+self.frame.size.width/2.0) / self.frame.size.width;
    if (mCurrentPage == page) {
        return;
    }
    mCurrentPage= page;
    // 当前滑动到 第几页
    if ( [self.delegate respondsToSelector:@selector(currentMoveToPageAtIndex:)] ) {
        [self.delegate currentMoveToPageAtIndex:mCurrentPage];
    }
    
    NSArray *dataSource = [self.dataSources objectAtIndex:mCurrentPage];
    if ( dataSource.count > 0) {
        MJRefreshTableView *v = [_contentItems objectAtIndex:mCurrentPage];
        [v reloadData];
        return ;
    }
    if ( [self.delegate respondsToSelector:@selector(freshContentTableAtIndex:isHead:)] ) {
        [self.delegate freshContentTableAtIndex:mCurrentPage isHead:YES];
    }

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger page = (_scrollView.contentOffset.x+self.frame.size.width/2.0) / self.frame.size.width;
    if (mCurrentPage == page) {
        return;
    }
    mCurrentPage= page;
    NSArray *dataSource = [self.dataSources objectAtIndex:mCurrentPage];
    if ( dataSource.count > 0) {
        MJRefreshTableView *v = [_contentItems objectAtIndex:mCurrentPage];
        [v reloadData];
        return ;
    }
    if ( [self.delegate respondsToSelector:@selector(freshContentTableAtIndex:isHead:)] ) {
        [self.delegate freshContentTableAtIndex:mCurrentPage isHead:YES];
    }

}

#pragma mark -设置 UITableView 代理方法
-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate mScreollTabel:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate mScreollTabel:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [self.delegate respondsToSelector:@selector(mScreollTabel:didSelectRowAtIndexPath:)] ) {
        [self.delegate mScreollTabel:tableView didSelectRowAtIndexPath:indexPath];
    }
}


@end
