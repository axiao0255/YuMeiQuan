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
#import "RYMyInformTableViewCell.h"
#import "RYMyInformListViewController.h"
#import "RYMyInformRewardListViewController.h"
#import "RYCorporateHomePageViewController.h"

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


- (void)decomposeData
{
    if ( self.listData.count ) {
        NSDictionary *info = [self.listData objectAtIndex:0];
        self.descmessage = [info getDicValueForKey:@"descmessage" defaultValue:nil];
        self.advmessage = [info getDicValueForKey:@"advmessage" defaultValue:nil];
    }
}

- (NSInteger)homepageNumberOfSectionsInTableView:(UITableView *)tableView
{
    [self decomposeData];
    
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
    if ( section == 0 ) {
        return 3;
    }
    else if ( section == 1){
        return 2;
    }
    else{
        if ( self.noticethreadmessage.count ) {
            return self.noticethreadmessage.count;
        }
        else{
            return 1;
        }
    }

}
- (CGFloat)homepageTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            return 50;
        }
        else if ( indexPath.row == 1 ) {
            return 180;
        }
        else{
            if ( [ShowBox isLogin] ) {
                return 85;
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
        return 44;
    }
    else{
        if ( self.noticethreadmessage.count ) {
            return 60;
        }
        else{
            return 44;
        }
    }
}

- (UITableViewCell *)homepageTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            NSString *searchBar_cell = @"searchBar_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchBar_cell];
            if ( !cell ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchBar_cell];
                cell.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
                
                UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, 40)];
                searchBar.layer.cornerRadius = 5.0f;
                searchBar.layer.masksToBounds = YES;
                searchBar.delegate = self;
                searchBar.tag = 110;
                searchBar.backgroundImage = [UIImage new];
                UITextField *searchField = [searchBar valueForKey:@"_searchField"];
                searchField.font = [UIFont systemFontOfSize:12];
                [cell.contentView addSubview:searchBar];
            }
            
            UISearchBar *searchBar = (UISearchBar *)[cell.contentView viewWithTag:110];
            searchBar.placeholder = [self.descmessage getStringValueForKey:@"zhidahaoshili" defaultValue:@"输入直达号"];
            return cell;
        }
        else if ( indexPath.row == 1 ) {
            NSString *adverCell = @"adver_Cell";
            RYAdverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:adverCell];
            if ( !cell ) {
                cell = [[RYAdverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adverCell];
            }
            [cell setValueWithDict:self.advmessage];
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
    else if ( indexPath.section == 1 )
    {
        NSString *inform = @"inform";
        RYMyInformTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inform];
        if ( !cell ) {
            cell = [[RYMyInformTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inform];
        }
        if ( indexPath.row == 0 ) {
            cell.titleLabel.text = @"系统消息";
            cell.leftImgView.image = [UIImage imageNamed:@"system_notice.png"];
           for ( NSInteger i = 0; i < self.noticesystemmessage.count; i ++ ) {
          
               NSDictionary *dict = [self.noticesystemmessage objectAtIndex:i];
               NSInteger number = [dict getIntValueForKey:@"count" defaultValue:0];
               if ( number > 0 ) {
                   cell.numLabel.hidden = NO;
                   cell.numLabel.text = [NSString stringWithFormat:@"%li",(long)number];
               }
               else{
                   cell.numLabel.hidden = YES;
               }
           }
        }
        else{
            cell.titleLabel.text = @"有奖活动";
            cell.leftImgView.image = [UIImage imageNamed:@"award_notice.png"];
            for ( NSInteger i = 0; i < self.noticespreadmessage.count; i ++ ) {
                
                NSDictionary *dict = [self.noticespreadmessage objectAtIndex:i];
                NSInteger number = [dict getIntValueForKey:@"count" defaultValue:0];
                if ( number > 0 ) {
                    cell.numLabel.hidden = NO;
                    cell.numLabel.text = [NSString stringWithFormat:@"%li",(long)number];
                }
                else{
                    cell.numLabel.hidden = YES;
                }
            }
        }
        return cell;
    }
    else{
        if ( self.noticethreadmessage.count == 0 ) {
            NSString *hint_cell = @"hint_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hint_cell];
            if ( !cell ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hint_cell];
                cell.imageView.image = [UIImage imageNamed:@"ic_wushuju.png"];
                cell.textLabel.text = @"暂无数据";
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.textLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
            }
            return cell;
        }
        else{
            
            NSString *company_notice = @"company_notice";
            RYCompanyNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:company_notice];
            
            if ( !cell ) {
                cell = [[RYCompanyNoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:company_notice];
            }
            
            if ( self.noticethreadmessage.count ) {
                NSDictionary *dict = [self.noticethreadmessage objectAtIndex:indexPath.row];
                [cell setValueWithDict:dict];
            }
            
            return cell;
        }
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
    if ( indexPath.section == 1 ) {
        RYMyInformTableViewCell *cell = (RYMyInformTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if ( indexPath.row == 0 ) {
            RYMyInformListViewController *vc = [[RYMyInformListViewController alloc] initWithInfomType:InformSystem];
            [self.viewControll.navigationController pushViewController:vc animated:YES];
            cell.numLabel.hidden = YES;
        }
        else{
            
            RYMyInformRewardListViewController *vc = [[RYMyInformRewardListViewController alloc] init];
            [self.viewControll.navigationController pushViewController:vc animated:YES];
            cell.numLabel.hidden = YES;
        }
    }
    if ( indexPath.section == 2 ) {
        if ( self.noticethreadmessage.count ) {
            RYCompanyNoticeTableViewCell *cell = (RYCompanyNoticeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            NSDictionary *dict = [self.noticethreadmessage objectAtIndex:indexPath.row];
            NSString *companyId = [dict getStringValueForKey:@"authorid" defaultValue:@""];
            RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] initWithCorporateID:companyId];
            [self.viewControll.navigationController pushViewController:vc animated:YES];
            cell.numLabel.hidden = YES;
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
    
    if ( section == 1 || section == 2 ) {
        return 23;
    }
    else{
        return 0;
    }
}

- (UIView *)homepageTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if ( section == 1 || section == 2 ) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 23)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 23)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [view addSubview:label];
        if ( section == 1 ) {
            label.text = @"通知消息";
        }
        else{
            label.text = @"企业消息";
        }
        return view;
        
    }
    else{
        return nil;
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
        UIButton  *integralBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0, 85)];
        [integralBtn addTarget:self action:@selector(integralBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [integralBtn setBackgroundImage:[UIImage imageNamed:@"ic_big_diamond.png"] forState:UIControlStateNormal];
        [cell.contentView addSubview:integralBtn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(41, 60, 30, 14)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
        label.text = @"积分";
        [integralBtn addSubview:label];
        
        UILabel *integralLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right + 5, 60 , 80, 14)];
        integralLabel.font = [UIFont boldSystemFontOfSize:14];
        integralLabel.textColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
        integralLabel.tag = 1212;
        [integralBtn addSubview:integralLabel];

        // 分界线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(integralBtn.right, 0, 0.5, 85)];
        line.backgroundColor = [Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0];
        [cell.contentView addSubview:line];
        
        // 右边
        UIButton *signInBtn = [[UIButton alloc] initWithFrame:CGRectMake(line.right, 0, SCREEN_WIDTH - line.right, 85)];
        [signInBtn addTarget:self action:@selector(signInBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [signInBtn setBackgroundImage:[UIImage imageNamed:@"ic_big_register.png"] forState:UIControlStateNormal];
        [cell.contentView addSubview:signInBtn];
        
     
        UILabel *inviteSignInLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, signInBtn.width, 14)];
        inviteSignInLabel.font = [UIFont systemFontOfSize:14];
        inviteSignInLabel.textColor = [Utils getRGBColor:0x00 g:0x91 b:0xea a:1.0];
        inviteSignInLabel.textAlignment = NSTextAlignmentCenter;
        inviteSignInLabel.text = @"邀请注册奖积分";
        [signInBtn addSubview:inviteSignInLabel];
    }
    UILabel *integralLabel = (UILabel *)[cell.contentView viewWithTag:1212];
    integralLabel.text = [RYUserInfo sharedManager].credits;
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
