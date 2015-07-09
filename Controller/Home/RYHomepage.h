//
//  RYHomepage.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYHomepage : UIView

@property (nonatomic , strong) UIViewController *viewControll;
@property (nonatomic , strong) NSArray          *listData;              //
@property (nonatomic , strong) NSDictionary     *advmessage;            //广告
@property (nonatomic , strong) NSDictionary     *descmessage;           //企业直达号等讯息
@property (nonatomic , strong) NSArray          *noticesystemmessage;   //系统消息
@property (nonatomic , strong) NSArray          *noticespreadmessage;   //有奖活动
@property (nonatomic , strong) NSArray          *noticethreadmessage;   //公司消息

- (NSInteger)homepageNumberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)homepageTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)homepageTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)homepageTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)homepageTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)homepageTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (UIView *)homepageTableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

- (CGFloat)homepageTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)homepageTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

@end
