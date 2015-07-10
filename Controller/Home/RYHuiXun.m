//
//  RYHuiXun.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYHuiXun.h"
#import "RYHuiXunTableViewCell.h"
#import "RYArticleViewController.h"

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
        if ( ![ShowBox isEmptyString:pic] ) {
            return 112;
        }
        else{
            NSString *title = [dic getStringValueForKey:@"subject" defaultValue:@""];
            NSDictionary *titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
            CGRect titleRect = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 39)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:titleAttributes
                                                    context:nil];
            
            NSString *organizer = [dic getStringValueForKey:@"organizer" defaultValue:@""];
            NSDictionary *organizerAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
            CGRect organizerRect = [organizer boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 30)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:organizerAttributes
                                                    context:nil];
            
            return 10 + titleRect.size.height + 10 + organizerRect.size.height + 10 + 12 + 10;
            
        }
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

- (void)huiXunPageTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
    RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:[dict getStringValueForKey:@"tid" defaultValue:@""]];
    [self.viewController.navigationController pushViewController:vc animated:YES];
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
