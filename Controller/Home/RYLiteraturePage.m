//
//  RYLiteraturePage.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYLiteraturePage.h"
#import "RYNewsPageTableViewCell.h"

@implementation RYLiteraturePage

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

- (NSInteger)literatureNumberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)literatureTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
- (CGFloat)literatureTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
        return 66;
    }
}

- (UITableViewCell *)literatureTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        [cell setValueWithDict:[self.listData objectAtIndex:indexPath.row]];
        return cell;
    }
}

-(CGFloat)literatureTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSString *adverPic = [self.adverData getStringValueForKey:@"pic" defaultValue:@""];
    if ( section == 0 && ![ShowBox isEmptyString:adverPic] ) {
        return 8;
    }
    else{
        return 0;
    }
}

-(CGFloat)literatureTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

@end
