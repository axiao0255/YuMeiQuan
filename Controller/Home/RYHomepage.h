//
//  RYHomepage.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYHomepage : UIView

@property (nonatomic , strong) NSDictionary   *adverData;
@property (nonatomic , strong) NSArray        *listData;

- (NSInteger)homepageNumberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)homepageTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)homepageTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)homepageTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

//-(CGFloat)homepageTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
//
//-(CGFloat)homepageTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;


@end
