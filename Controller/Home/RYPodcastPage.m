//
//  RYPodcastPage.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/15.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYPodcastPage.h"
#import "RYNewsPageTableViewCell.h"

@implementation RYPodcastPage

- (NSArray *)listData
{
    if ( _listData == nil ) {
        _listData = [NSArray array];
    }
    return _listData;
}

- (NSInteger)podcastNumberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}
- (NSInteger)podcastTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)podcastTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 180;
    return SCREEN_WIDTH * 9 / 16.0;
}

- (UITableViewCell *)podcastTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *podcastCell = @"podcastCell";
    RYAdverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:podcastCell];
    if ( !cell ) {
        cell = [[RYAdverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:podcastCell];
    }
    if ( self.listData.count ) {
        [cell setValueWithDict:[self.listData objectAtIndex:indexPath.section]];
    }
    return cell;
}

- (CGFloat)podcastTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)podcastTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

@end
