//
//  RYHomepage.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYHomepage.h"
#import "RYNewsPageTableViewCell.h"
#import "RYMyJiFenViewController.h"
#import "RYMyInviteViewController.h"

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
        BOOL isLogin = YES;
        if ( isLogin ) {
            return 1;
        }
        else{
            NSString *adverPic = [self.adverData getStringValueForKey:@"pic" defaultValue:@""];
            if ( self.adverData && ![ShowBox isEmptyString:adverPic]) {
                return 1;
            }
            else{
                return 0;
            }
        }
    }
    else{
        return 1;
    }

}
- (CGFloat)homepageTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        BOOL isLogin = YES;
        if ( isLogin ) {
            return 180;
        }
        else{
            NSString *adverPic = [self.adverData getStringValueForKey:@"pic" defaultValue:@""];
            if ( self.adverData && ![ShowBox isEmptyString:adverPic]) {
                return 180;
            }
            else{
                return 0;
            }
        }
     }
    else{
        return 180;
    }
}

- (UITableViewCell *)homepageTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        
        BOOL isLogin = YES;
        if ( isLogin ) {
            return [self loginTopCellTableView:tableView cellForRowAtIndexPath:indexPath];
        }
        else{
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

// 登录时的 top cell
- (UITableViewCell *)loginTopCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *login_cell = @"login_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:login_cell];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:login_cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 左边
        UIButton  *integralBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0, 180)];
        [integralBtn addTarget:self action:@selector(integralBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:integralBtn];
        
        UIImageView *diamondView = [[UIImageView alloc] initWithFrame:CGRectMake(37, 8, 90, 90)];
        diamondView.image = [UIImage imageNamed:@"ic_big_diamond.png"];
        [integralBtn addSubview:diamondView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(36, diamondView.bottom + 4, 90, 14)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        label.text = @"积分余额";
        [integralBtn addSubview:label];
        
        UILabel *integralLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, label.bottom + 4 , integralBtn.width - 72, 20)];
        integralLabel.font = [UIFont systemFontOfSize:20];
        integralLabel.textColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
        integralLabel.tag = 1212;
        integralLabel.textAlignment = NSTextAlignmentRight;
        [integralBtn addSubview:integralLabel];
        
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, integralLabel.bottom + 8, integralBtn.width, 12)];
        hintLabel.font = [UIFont systemFontOfSize:12];
        hintLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        hintLabel.textAlignment = NSTextAlignmentCenter;
        hintLabel.tag = 1313;
        [integralBtn addSubview:hintLabel];
        
        // 分界线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(integralBtn.right, 0, 0.5, 180)];
        line.backgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
        [cell.contentView addSubview:line];
        
        // 右边
        UIButton *signInBtn = [[UIButton alloc] initWithFrame:CGRectMake(line.right, 0, SCREEN_WIDTH - line.right, 180)];
        [signInBtn addTarget:self action:@selector(signInBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:signInBtn];
        
        UIImageView *signInView = [[UIImageView alloc] initWithFrame:CGRectMake(37, 8, 90, 90)];
        signInView.image = [UIImage imageNamed:@"ic_big_register.png"];
        [signInBtn addSubview:signInView];
        
        UILabel *inviteSignInLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, signInView.bottom + 14, signInBtn.width, 20)];
        inviteSignInLabel.font = [UIFont systemFontOfSize:20];
        inviteSignInLabel.textColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
        inviteSignInLabel.textAlignment = NSTextAlignmentCenter;
        inviteSignInLabel.text = @"邀请注册";
        [signInBtn addSubview:inviteSignInLabel];
        
        UILabel *inviteHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, inviteSignInLabel.bottom + 15, signInBtn.width, 12)];
        inviteHintLabel.font = [UIFont systemFontOfSize:12];
        inviteHintLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        inviteHintLabel.textAlignment = NSTextAlignmentCenter;
        inviteHintLabel.tag = 1414;
        [signInBtn addSubview:inviteHintLabel];
    }
    UILabel *integralLabel = (UILabel *)[cell.contentView viewWithTag:1212];
    integralLabel.text = @"50000";
    UILabel *hintLabel = (UILabel *)[cell.contentView viewWithTag:1313];
    NSString *integralNum = @"1000";
    NSString *str = [NSString stringWithFormat:@"首次注册可获得%@积分",integralNum];
    [hintLabel setAttributedText:[Utils getAttributedString:str hightlightString:integralNum hightlightColor:[UIColor redColor] andFont:hintLabel.font]];
    
    UILabel *inviteHintLabel = (UILabel *)[cell.contentView viewWithTag:1414];
    NSString *inviteNum = @"2000";
    NSString *inviteStr = [NSString stringWithFormat:@"邀请注册可获得%@积分",inviteNum];
    [inviteHintLabel setAttributedText:[Utils getAttributedString:inviteStr hightlightString:inviteNum hightlightColor:[UIColor redColor] andFont:hintLabel.font]];
    
    return cell;
}


- (void)integralBtnClick:(id)sender
{
    RYMyJiFenViewController *vc = [[RYMyJiFenViewController alloc] init];
    [self.viewControll.navigationController pushViewController:vc animated:YES];
}

- (void)signInBtnClick:(id)sender
{
    RYMyInviteViewController *vc = [[RYMyInviteViewController alloc] init];
    [self.viewControll.navigationController pushViewController:vc animated:YES];
}

@end
