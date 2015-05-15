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
 *  上拉 获取更多数据
 */
- (void)footerRereshingData;
/**
 *  下拉 刷新
 */
- (void)headerRereshingData;

@end


@interface MJRefreshTableView : UITableView

@property (weak  ,nonatomic)id<MJRefershTableViewDelegate>delegateRefersh;

/**
 *  初始化方法
 */
- (id)initWithFrame:(CGRect)frame;
/**
 *  上拉 结束
 */
- (void)footerFinishRereshing;
/**
 *  下拉 结束
 */
- (void)headerFinishRefreshing;

@end
