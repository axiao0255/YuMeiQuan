//
//  RYLiteraturePage.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYLiteraturePage : UIView

@property (nonatomic , strong) NSDictionary   *adverData;

@property (nonatomic , strong) NSArray        *listData;

@property (nonatomic , strong) NSDictionary    *dataSource;

- (NSInteger)literatureNumberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)literatureTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)literatureTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)literatureTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(CGFloat)literatureTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

-(CGFloat)literatureTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;


@end
