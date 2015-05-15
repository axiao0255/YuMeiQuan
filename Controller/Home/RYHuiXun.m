//
//  RYHuiXun.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYHuiXun.h"
#import "RYHuiXunTableViewCell.h"

@implementation RYHuiXun

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


- (NSInteger)huiXunNumberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)huiXunTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.listData.count;
}
- (CGFloat)huiXunTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.listData.count == 0 ) {
        return 0;
    }
    else{
        NSDictionary *dic = [self.listData objectAtIndex:indexPath.row];
        NSString *pic = [dic getStringValueForKey:@"pic" defaultValue:@""];
        CGFloat titleLabelWidth;
        if ( ![ShowBox isEmptyString:pic] ) {
            titleLabelWidth = SCREEN_WIDTH - 30 - 58;
        }else{
            titleLabelWidth = SCREEN_WIDTH - 30;
        }
        NSString *title = [dic getStringValueForKey:@"title" defaultValue:@""];
        CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(titleLabelWidth, 35)];
        
        return 8 + titleSize.height + 8 + 10 + 8 + 10 + 8;
    }
}
- (UITableViewCell *)huiXunTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *huiXunCell = @"huiXunCell";
    RYHuiXunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:huiXunCell];
    if ( !cell ) {
        cell = [[RYHuiXunTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:huiXunCell];
    }
    if ( self.listData.count ) {
        [cell setValueWithDict:[self.listData objectAtIndex:indexPath.row]];
    }
    return cell;
   
}
- (CGFloat)huiXunTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)huiXunTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}



@end
