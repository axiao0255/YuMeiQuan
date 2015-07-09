//
//  RYWeeklyPage.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYWeeklyPage.h"
#import "RYWeeklyPageTableViewCell.h"
#import "RYWeeklyViewController.h"

@implementation RYWeeklyPage

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

- (NSInteger)weeklyPageNumberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}
- (NSInteger)weeklyPageTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)weeklyPageTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.listData.count ) {
        NSDictionary * dict = [self.listData objectAtIndex:indexPath.section];
        NSString *subject = [dict getStringValueForKey:@"subject" defaultValue:@""];
        NSDictionary *praiseAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGRect praiseRect = [subject boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:praiseAttributes
                                               context:nil];
        if ( praiseRect.size.height > 28 ) {
            return 240 + 15;
        }
        else{
            return 220 + 15;
        }
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)weeklyPageTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *week_cell = @"week_cell";
    RYWeeklyPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:week_cell];
    if ( !cell ) {
        cell = [[RYWeeklyPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:week_cell];
    }
    if ( self.listData.count ) {
        NSDictionary *dict = [self.listData objectAtIndex:indexPath.section];
        [cell setValueWithDict:dict];
    }
    return cell;
}

- (void)weeklyPageTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RYWeeklyViewController *vc = [[RYWeeklyViewController alloc] init];
    //    vc.listData = self.homePage.listData;
    vc.weeklyDict = [self.listData objectAtIndex:indexPath.section];
    [self.viewController.navigationController pushViewController:vc animated:YES];

}

- (CGFloat)weeklyPageTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (UIView *)weeklyPageTableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)weeklyPageTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (UIView *)weeklyPageTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}


@end
