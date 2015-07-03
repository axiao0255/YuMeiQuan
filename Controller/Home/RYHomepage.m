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
#import "RYCorporateSearchViewController.h"
#import "RYLoginViewController.h"

@interface RYHomepage ()<UISearchBarDelegate,UINavigationControllerDelegate>

@end

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
//    if ( self.listData.count ) {
//        return 2;
//    }
//    else{
//        return 0;
//    }
    if ( self.listData.count ) {
        if ( [ShowBox isLogin] ) {
            return 3;
        }
        else{
            return 1;
        }
    }
    else{
        return 0;
    }
}
- (NSInteger)homepageTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 1;
//    }
//    else{
//        return 1;
//    }
    
    if ( section == 0 ) {
        return 3;
    }
    else if ( section == 1){
        return 2;
    }
    else{
        return 10;
    }

}
- (CGFloat)homepageTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
//        BOOL isLogin = YES;
//        if ( isLogin ) {
//            return 180;
//        }
//        else{
//            NSString *adverPic = [self.adverData getStringValueForKey:@"pic" defaultValue:@""];
//            if ( self.adverData && ![ShowBox isEmptyString:adverPic]) {
//                return 180;
//            }
//            else{
//                return 0;
//            }
//        }
        if ( indexPath.row == 0 ) {
            return 50;
        }
        else if ( indexPath.row == 1 ) {
            return 180;
        }
        else{
            if ( [ShowBox isLogin] ) {
                return 80;
            }
            else{
                if ( IS_IPHONE_5 ) {
                    return 220;
                }
                return 172;
            }
        }
     }
    else if ( indexPath.section == 1 ){
        return 70;
    }
    else{
        return 180;
    }
}

- (UITableViewCell *)homepageTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        
//        NSString *adverPic = [self.adverData getStringValueForKey:@"pic" defaultValue:@""];
//        if ( self.adverData && ![ShowBox isEmptyString:adverPic] ) { // 判断是否有广告
//            NSString *adverCell = @"adverCell";
//            RYAdverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:adverCell];
//            if ( !cell ) {
//                cell = [[RYAdverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adverCell];
//            }
//            [cell setValueWithDict:self.adverData];
//            return cell;
//        }
//        else{
//            return [self loginTopCellTableView:tableView cellForRowAtIndexPath:indexPath];
//        }
        if ( indexPath.row == 0 ) {
            NSString *searchBar_cell = @"searchBar_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchBar_cell];
            if ( !cell ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchBar_cell];
                cell.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
                
                UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, 40)];
                searchBar.layer.cornerRadius = 5.0f;
                searchBar.layer.masksToBounds = YES;
                searchBar.placeholder = [self.descmessage getStringValueForKey:@"zhidahaoshili" defaultValue:@"输入直达号"];
                searchBar.delegate = self;
                searchBar.backgroundImage = [UIImage new];
                UITextField *searchField = [searchBar valueForKey:@"_searchField"];
                searchField.font = [UIFont systemFontOfSize:12];
//                self.searchBar = searchBar;
                [cell.contentView addSubview:searchBar];

            }
            return cell;
        }
        else if ( indexPath.row == 1 ) {
            NSString *adverCell = @"adver_Cell";
            RYAdverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:adverCell];
            if ( !cell ) {
                cell = [[RYAdverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adverCell];
            }
            [cell setValueWithDict:self.adverData];
            return cell;
        }
        else{
            if ( [ShowBox isLogin] ) {
                return [self loginTopCellTableView:tableView cellForRowAtIndexPath:indexPath];
            }
            else{
                
                NSString *log_cell = @"log_cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:log_cell];
                if (!cell ) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:log_cell];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 172)];
                    imgView.image = [UIImage imageNamed:@"ic_log_cell.jpg"];
                    [cell.contentView addSubview:imgView];
                    
                    UIButton *gotoLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(128, 30, 67, 67)];
                    [gotoLoginBtn setTitle:@"登录" forState:UIControlStateNormal];
                    [gotoLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [gotoLoginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    [gotoLoginBtn addTarget:self action:@selector(gotoLogin:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell.contentView addSubview:gotoLoginBtn];
                    
                }
                return cell;
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

- (void)homepageTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( indexPath.section == 0 ) {
        if ( ![ShowBox isLogin] && indexPath.row == 2 ) {
            [self gotoLogin:nil];
        }
    }
}

- (CGFloat)homepageTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (UIView *)homepageTableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)homepageTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)homepageTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
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
    integralLabel.text = [RYUserInfo sharedManager].credits;
    
    // 注册积分
    UILabel *hintLabel = (UILabel *)[cell.contentView viewWithTag:1313];
    NSString *originalStr = [self.descmessage getStringValueForKey:@"zhucejifen" defaultValue:@""];
    NSInteger number = [Utils findNumFormOriginalStr:originalStr];
    NSString *integralNum = [NSString stringWithFormat:@"%li",(long)number];
    [hintLabel setAttributedText:[Utils getAttributedString:originalStr hightlightString:integralNum hightlightColor:[UIColor redColor] andFont:hintLabel.font]];

    // 邀请注册 积分
    UILabel *inviteHintLabel = (UILabel *)[cell.contentView viewWithTag:1414];
    NSString *inviteStr = [self.descmessage getStringValueForKey:@"yaoqingjifen" defaultValue:@""];
    NSInteger inviteNumber = [Utils findNumFormOriginalStr:inviteStr];
    NSString *inviterStr = [NSString stringWithFormat:@"%li",(long)inviteNumber];
    [inviteHintLabel setAttributedText:[Utils getAttributedString:inviteStr hightlightString:inviterStr hightlightColor:[UIColor redColor] andFont:hintLabel.font]];
    
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

#pragma mark - UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSString *placeholder = searchBar.placeholder;
    RYCorporateSearchViewController *vc = [[RYCorporateSearchViewController alloc] initWithSearchBarPlaceholder:placeholder];
    UINavigationController* nc = [[UINavigationController alloc]initWithRootViewController:vc];
    nc.delegate = self;
    [self.viewControll.navigationController presentViewController:nc animated:YES completion:^{
        [searchBar resignFirstResponder];
    }];

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIBarButtonItem *back=[[UIBarButtonItem alloc] init];
    
    back.title = @" ";
    UIImage *backbtn = [UIImage imageNamed:@"back_btn_icon.png"];
    [back setBackButtonBackgroundImage:backbtn forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [back setBackButtonBackgroundImage:[UIImage imageNamed:@"back_btn_icon.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [back setStyle:UIBarButtonItemStylePlain];
    
    viewController.navigationItem.backBarButtonItem = back;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    NSLog(@"点击搜索框");
}

-(void)gotoLogin:(id)sender
{
    RYLoginViewController *vc = [[RYLoginViewController alloc] init];
    [self.viewControll.navigationController pushViewController:vc animated:YES];
}


@end
