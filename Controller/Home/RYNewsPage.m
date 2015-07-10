//
//  RYNewsPage.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYNewsPage.h"
#import "RYNewsPageTableViewCell.h"
#import "RYArticleViewController.h"

@implementation RYNewsPage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSArray *)listData
{
    if ( _listData == nil ) {
        _listData = [NSArray array];
    }
    return _listData;
}

- (NSDictionary *)dataSource
{
    if ( _dataSource == nil ) {
        _dataSource = [[NSDictionary alloc] init];
    }
    return _dataSource;
}

- (NSInteger)newsNumberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)newsTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSString *adverPic = [self.adverData getStringValueForKey:@"pic" defaultValue:@""];
        if ( self.adverData && ![ShowBox isEmptyString:adverPic]) {
            return 1;
        }
        else{
            return 0;
        }
    }
    else{
        return self.listData.count;
    }
}

- (CGFloat)newsTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        NSString *adverPic = [self.adverData getStringValueForKey:@"pic" defaultValue:@""];
        if ( self.adverData && ![ShowBox isEmptyString:adverPic]) {
            return 180;
        }
        else{
            return 0;
        }
    }
    else{
        return 90;
    }
}

- (UITableViewCell *)newsTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        NSString *adverPic = [self.adverData getStringValueForKey:@"pic" defaultValue:@""];
        if ( self.adverData && ![ShowBox isEmptyString:adverPic]) {
            NSString *adverCell = @"adverCell";
            RYAdverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:adverCell];
            if ( !cell ) {
                cell = [[RYAdverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adverCell];
            }
            [cell setValueWithDict:self.adverData];
            return cell;
        }
        else{
            return [[UITableViewCell alloc] init];
        }
    }
    else{
        NSString *listCell = @"listCell";
        RYNewsPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
        if ( !cell ) {
            cell = [[RYNewsPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listCell];
        }
        if ( self.listData.count ) {
            [cell setValueWithDict:[self.listData objectAtIndex:indexPath.row]];
        }
        return cell;
    }
}

- (void)newsTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        NSLog(@"点击广告");
    }
    else{
        NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
        RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:[dict getStringValueForKey:@"tid" defaultValue:@""]];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)newsTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    NSString *adverPic = [self.adverData getStringValueForKey:@"pic" defaultValue:@""];
    if ( section == 0 && ![ShowBox isEmptyString:adverPic] ) {
        return 8;
    }
    else{
        return 0;
    }
}

-(CGFloat)newsTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0;
}


@end
