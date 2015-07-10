//
//  RYHuiXun.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYHuiXun : UIView

@property (nonatomic , strong) UIViewController *viewController;
@property (nonatomic , strong) NSArray *listData;



- (NSInteger)huiXunNumberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)huiXunTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)huiXunTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)huiXunTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)huiXunPageTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)huiXunTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)huiXunTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;


@end
