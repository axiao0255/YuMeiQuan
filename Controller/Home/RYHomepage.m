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

#import "RYWebViewController.h"
#import "RYLiteratureDetailsViewController.h"
#import "RYArticleViewController.h"
#import "RYCorporateHomePageViewController.h"
#import "RYNavigationViewController.h"

#import "RYEditInformationViewController.h"
#import "RYRegisterSelectViewController.h"

#import <SafariServices/SafariServices.h>

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
            if ( [[RYUserInfo sharedManager].groupid isEqualToString:@"42"] ) {
                return 1;
            }
            else{
                return 3;
            }
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
            return SCREEN_WIDTH * 9 / 16.0;
        }
        else{
            if ( [ShowBox isLogin] ) {
                if ( [[RYUserInfo sharedManager].groupid isEqualToString:@"42"] ) {
                    if ( IS_IPHONE_6 || IS_IPHONE_6P ) {
                        return VIEW_HEIGHT - 100 - SCREEN_WIDTH*9/16;
                    }
                    else{
                        return 220;
                    }
                }
                else{
                    return 85 * SCREEN_WIDTH / 320;
                }
            }
            else{
                if (  IS_IPHONE_6 || IS_IPHONE_6P ) {
                    return VIEW_HEIGHT - 100 - SCREEN_WIDTH*9/16;
                }
                else{
                    return 300;
                }
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
                if ( [[RYUserInfo sharedManager].groupid isEqualToString:@"42"] ) {
                    // 42 审核失败  提醒用户 重新上传资料
                    NSString *edit_cell = @"edit_cell";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:edit_cell];
                    if (!cell ) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:edit_cell];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        
                        CGFloat height = [self homepageTableView:tableView heightForRowAtIndexPath:indexPath];
                        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
                        imgView.image = [UIImage imageNamed:@"ic_editInformation_background.png"];
                        [cell.contentView addSubview:imgView];
                    }
                    return cell;
                }
                else{
                    return [self loginTopCellTableView:tableView cellForRowAtIndexPath:indexPath];
                }
            }
            else{
                return [self notloginCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
//                NSString *log_cell = @"log_cell";
//                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:log_cell];
//                if (!cell ) {
//                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:log_cell];
//                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//                    
//                    CGFloat height = [self homepageTableView:tableView heightForRowAtIndexPath:indexPath];
//                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
//                    imgView.image = [UIImage imageNamed:@"ic_log_cell.png"];
//                    [cell.contentView addSubview:imgView];
//                }
//                return cell;
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
        if ( indexPath.row == 1 ){
//            // 广告点击
//            NSString *type = [self.advmessage getStringValueForKey:@"type" defaultValue:@""];
//            NSString *content = [self.advmessage getStringValueForKey:@"content" defaultValue:@""];
//            if ( [type isEqualToString:@"url"] ) {
//                // 网页打开
//                RYWebViewController *vc = [[RYWebViewController alloc] initWithUrl:content];
//                [self.viewControll.navigationController pushViewController:vc animated:YES];
//            }
//            else if ( [type isEqualToString:@"137"] ){
//                // 进入文献
//                RYLiteratureDetailsViewController *vc = [[RYLiteratureDetailsViewController alloc] initWithTid:content];
//                [self.viewControll.navigationController pushViewController:vc animated:YES];
//            }
//            else if ( [type isEqualToString:@"136"] ){
//                // 进入文章
//                RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:content];
//                [self.viewControll.navigationController pushViewController:vc animated:YES];
//            }
//            else if ( [type isEqualToString:@"company"] ){
//                // 进入企业微主页
//                RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] initWithCorporateID:content];
//                [self.viewControll.navigationController pushViewController:vc animated:YES];
//            }
            
#warning 验证safari
//            NSString *url = @"http://news.sohu.com/20151111/n425994082.shtml";
            NSString *url = @"http://f.hd.baofeng.com/detail/276/detail-106776.html?fid=1379";
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url] entersReaderIfAvailable:YES];
            [self.viewControll presentViewController:safariVC animated:YES completion:nil];
//#warning 验证微博接口
//            [NetRequestAPI testWeiboAPIWithUrl:@"https://api.weibo.com/oauth2/authorize"
//                                        appKey:@"3850180031"
//                                  redirect_uri:@"http://yimeiquan.cn/index.php"
//                                       success:^(id responseDic) {
//                                           NSLog(@"responseDic :%@",responseDic);
//                
//            } failure:^(id errorString) {
//                NSLog(@"errorString :%@",errorString);
//            }];
//            
            
        }
        if ( indexPath.row == 2 ) {
            if ( [[RYUserInfo sharedManager].groupid isEqualToString:@"42"] ) {
                // 审核失败  进入重新提交数据 界面
                RYEditInformationViewController *vc = [[RYEditInformationViewController alloc] init];
                [self.viewControll.navigationController pushViewController:vc animated:YES];
            }
            else{
                if ( ![ShowBox isLogin] ) {
//                    [self gotoLogin:nil];
                }
            }
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
/**
 * 未登录时的cell
 */
- (UITableViewCell *)notloginCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *log_cell = @"log_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:log_cell];
    if (!cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:log_cell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
//        CGFloat height = [self homepageTableView:tableView heightForRowAtIndexPath:indexPath];
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
//        imgView.image = [UIImage imageNamed:@"ic_log_cell.png"];
//        [cell.contentView addSubview:imgView];
        UILabel *hanJoinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 16)];
        hanJoinLabel.textColor = [Utils getRGBColor:0x22 g:0x9c b:0xf4 a:1.0];
        hanJoinLabel.textAlignment = NSTextAlignmentCenter;
        hanJoinLabel.font = [UIFont systemFontOfSize:16];
        hanJoinLabel.text = @"加入我们，您将获得以下权限";
        [cell.contentView addSubview:hanJoinLabel];
        
        UILabel *englishJoinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, hanJoinLabel.bottom+5, SCREEN_WIDTH, 10)];
        englishJoinLabel.textColor = [Utils getRGBColor:0x22 g:0x9c b:0xf4 a:1.0];
        englishJoinLabel.textAlignment = NSTextAlignmentCenter;
        englishJoinLabel.font = [UIFont systemFontOfSize:10];
        englishJoinLabel.text = @"Join us,you will get the following permissions";
        [cell.contentView addSubview:englishJoinLabel];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-160, englishJoinLabel.bottom+10, 320, 5)];
        line.image = [UIImage imageNamed:@"ic_divider_home.png"];
        [cell.contentView addSubview:line];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(40, englishJoinLabel.bottom+10, SCREEN_WIDTH-80, 1.5)];
//        line.backgroundColor = [Utils getRGBColor:0x56 g:0xbb b:0xff a:1.0];
//        [cell.contentView addSubview:line];
        
        NSArray *titleArr = @[@"查询文献",@"阅读专家评论",@"浏览全站内容",@"桌面端同步阅读"];
        for (NSInteger i = 0 ; i < titleArr.count ; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i%2 * (SCREEN_WIDTH/2), line.bottom + 20 + (i/2*20 + i/2*13), SCREEN_WIDTH/2, 13)];
            label.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.text = [titleArr objectAtIndex:i];
            [cell.contentView addSubview:label];
        }
        
        NSArray *arr = @[@"注册",@"登录"];
        CGFloat btnWidth = 133;
        CGFloat btnHeight = 40;
        if ( IS_IPHONE_6P ) {
            btnWidth = 173;
            btnHeight = 52;
        }
        else if ( IS_IPHONE_6 ){
            btnWidth = 160;
            btnHeight = 40;
        }
        for (NSInteger i = 0 ; i < 2; i ++ ) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i%2 * (SCREEN_WIDTH/2), 152, SCREEN_WIDTH/2, btnHeight)];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake( view.width/2-btnWidth/2, 0, btnWidth, btnHeight)];
            btn.layer.cornerRadius = 5;
            btn.layer.borderColor = [Utils getRGBColor:0xe2 g:0xe2 b:0xe2 a:1.0].CGColor;
            btn.layer.borderWidth = 1.0;
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            btn.layer.masksToBounds = 20;
            btn.tag = 1400+i;
            [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
            if ( i == 0 ) {
                [btn setTitleColor:[Utils getRGBColor:0x2c g:0xa2 b:0xf6 a:1.0] forState:UIControlStateNormal];
            }
            else{
                [btn setTitleColor:[Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0] forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(registerOrLoginCilcked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            [cell.contentView addSubview:view];
        }
        
        
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 172 + btnHeight, SCREEN_WIDTH-60, 60)];
        
        bottomLabel.textColor = [Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0];
        bottomLabel.font = [UIFont systemFontOfSize:13];
        bottomLabel.numberOfLines = 2;
        
        NSString *content = @"登录后，您的系统消息、有奖消息、企业消息、积分会显示在这里，您可以随时查看";
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:content];;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:10];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
        
        bottomLabel.attributedText = attributedString;
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:bottomLabel];
       
        
    }
    return cell;
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
        UIButton  *integralBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0, 85 * SCREEN_WIDTH/320)];
        [integralBtn addTarget:self action:@selector(integralBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [integralBtn setBackgroundImage:[UIImage imageNamed:@"ic_big_diamond.png"] forState:UIControlStateNormal];
        [cell.contentView addSubview:integralBtn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(integralBtn.width/2-44, integralBtn.height - 25, 30, 14)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
        label.text = @"积分";
        [integralBtn addSubview:label];
        
        UILabel *integralLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right + 5, label.top , 80, 14)];
        integralLabel.font = [UIFont boldSystemFontOfSize:14];
        integralLabel.textColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
        integralLabel.tag = 1212;
        [integralBtn addSubview:integralLabel];

        // 分界线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(integralBtn.right, 0, 0.5, integralBtn.height)];
        line.backgroundColor = [Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0];
        [cell.contentView addSubview:line];
        
        // 右边
        UIButton *signInBtn = [[UIButton alloc] initWithFrame:CGRectMake(line.right, 0, SCREEN_WIDTH - line.right, integralBtn.height)];
        [signInBtn addTarget:self action:@selector(signInBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [signInBtn setBackgroundImage:[UIImage imageNamed:@"ic_big_register.png"] forState:UIControlStateNormal];
        [cell.contentView addSubview:signInBtn];
        
        UILabel *inviteSignInLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, signInBtn.height - 25, signInBtn.width, 14)];
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
    RYNavigationViewController* nc = [[RYNavigationViewController alloc]initWithRootViewController:vc];
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
}

-(void)gotoLogin:(id)sender
{
    RYLoginViewController *vc = [[RYLoginViewController alloc] init];
    [self.viewControll.navigationController pushViewController:vc animated:YES];
}


- (void)registerOrLoginCilcked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 1400;
    if ( index == 0 ) {
        RYRegisterSelectViewController *vc = [[RYRegisterSelectViewController alloc] init];
        [self.viewControll.navigationController pushViewController:vc animated:YES];
    }else{
        [self gotoLogin:btn];
    }
}

@end
