//
//  RYNewsPage.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYNewsPage : UIView

@property (nonatomic , strong) NSDictionary   *adverData;

@property (nonatomic , strong) NSArray        *listData;

@property (nonatomic , strong) NSDictionary    *dataSource;

- (NSInteger)newsNumberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)newsTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)newsTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)newsTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(CGFloat)newsTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

-(CGFloat)newsTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

@end
