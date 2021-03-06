//
//  MJRefreshTableView.h
//  MJRefreshExample
//
//  Created by 陈中笑 on 15-4-3.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@protocol MJRefershTableViewDelegate <NSObject>

@required
/**
 * 上啦或下拉 获取数据
 * isHeaderReresh  YES 头刷新,  NO 脚刷新
 * currentPage 当前获取第几页的数据
 */
-(void)getDataWithIsHeaderReresh:(BOOL)isHeaderReresh andCurrentPage:(NSInteger)currentPage;


@end


@interface MJRefreshTableView : UITableView

@property (weak  ,nonatomic)id<MJRefershTableViewDelegate>delegateRefersh;

@property (assign,nonatomic)NSInteger                     currentPage;
@property (assign,nonatomic)NSInteger                     totlePage;
@property (assign,nonatomic)BOOL                          isRereshing;

/**
 *  初始化方法
 */
- (id)initWithFrame:(CGRect)frame;

/**
 *
 */
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

/**
 *  上拉 结束
 */
- (void)footerFinishRereshing;
/**
 *  下拉 结束
 */
- (void)headerFinishRefreshing;

@end
