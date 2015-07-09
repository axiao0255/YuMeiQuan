//
//  RYWeeklyPage.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYWeeklyPage : UIView

@property (nonatomic , strong) UIViewController *viewController;
@property (nonatomic , strong) NSArray          *listData;              //数据列表

- (NSInteger)weeklyPageNumberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)weeklyPageTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)weeklyPageTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)weeklyPageTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)weeklyPageTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)weeklyPageTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (UIView *)weeklyPageTableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

- (CGFloat)weeklyPageTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)weeklyPageTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;


@end
