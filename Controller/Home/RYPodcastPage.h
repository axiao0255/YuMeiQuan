//
//  RYPodcastPage.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/15.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYPodcastPage : UIView

@property (nonatomic , strong) NSArray          *listData;

- (NSInteger)podcastNumberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)podcastTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)podcastTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)podcastTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)podcastTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)podcastTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;


@end
