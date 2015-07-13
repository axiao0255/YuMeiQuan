//
//  RYBaiJiaPage.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    articleType = 0,
    authorType,
} BAIJIATYPE;

@interface RYBaiJiaPage : UIView

@property (nonatomic , strong) NSArray      *listData;
@property (nonatomic , strong) NSDictionary *adverData;
@property (nonatomic , strong) NSArray      *authorList;
@property (nonatomic , assign) BAIJIATYPE   currentType;

- (NSInteger)baiJiaNumberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)baiJiaTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)baiJiaTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)baiJiaTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)baiJiaTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)baiJiaTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)baiJiaTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)baiJiaTableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (NSArray *)baiJiaSectionIndexTitlesForTableView:(UITableView *)tableView;
- (NSInteger)baiJiaTableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;


@end
