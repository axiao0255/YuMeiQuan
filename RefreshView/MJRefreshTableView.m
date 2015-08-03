//
//  MJRefreshTableView.m
//  MJRefreshExample
//
//  Created by 陈中笑 on 15-4-3.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MJRefreshTableView.h"

@implementation MJRefreshTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupRefresh];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if ( self ) {
        [self setupRefresh];
    }
    return self;
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
//    [self headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.headerPullToRefreshText = @"下拉可以刷新了";
    self.headerReleaseToRefreshText = @"松开马上刷新了";
    self.headerRefreshingText = @"MJ哥正在帮你刷新中,不客气";
    
    self.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.footerRefreshingText = @"MJ哥正在帮你加载中,不客气";
    
    
    self.currentPage = 0;
    self.totlePage = 1;
}

/**
 *  上啦 获取更多数据
 */
- (void)footerRereshing
{
     NSLog(@"脚 开始刷新");
    if ( self.isRereshing ) {
        return;
    }
  
    self.currentPage ++;
    if ( self.currentPage >= self.totlePage ) {
        self.currentPage --;
        [self footerEndRefreshing];
        self.isRereshing = NO;
        return;
    }
   
    self.isRereshing = YES;
    
    if ( [self.delegateRefersh respondsToSelector:@selector(getDataWithIsHeaderReresh:andCurrentPage:)] ) {
        [self.delegateRefersh getDataWithIsHeaderReresh:NO andCurrentPage:self.currentPage];
    }
}
/**
 *  下来 刷新
 */
- (void)headerRereshing
{
    NSLog(@"头 开始刷新");
    if ( self.isRereshing ) {
        return;
    }
    self.isRereshing = YES;
    self.currentPage = 0;
    self.totlePage = 1;
    if ( [self.delegateRefersh respondsToSelector:@selector(getDataWithIsHeaderReresh:andCurrentPage:)] ) {
        [self.delegateRefersh getDataWithIsHeaderReresh:YES andCurrentPage:self.currentPage];
    }
}


- (void)footerFinishRereshing
{
    self.isRereshing = NO;
    [self footerEndRefreshing];
   
}

- (void)headerFinishRefreshing
{
    self.isRereshing = NO;
    [self headerEndRefreshing];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
