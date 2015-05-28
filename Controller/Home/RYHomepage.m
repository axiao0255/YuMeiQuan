//
//  RYHomepage.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYHomepage.h"
#import "RYNewsPageTableViewCell.h"

@implementation RYHomepage


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


- (NSInteger)homepageNumberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)homepageTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
        return 1;
    }

}
- (CGFloat)homepageTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
        return 180;
    }
}

- (UITableViewCell *)homepageTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        NSString *adverCell = @"adverCell";
        RYAdverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:adverCell];
        if ( !cell ) {
            cell = [[RYAdverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adverCell];
        }
        if ( self.listData.count ) {
            [cell setValueWithDict:[self.listData objectAtIndex:0]];
        }
        return cell;
    }
}

//-(CGFloat)homepageTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{}
//
//-(CGFloat)homepageTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

@end
