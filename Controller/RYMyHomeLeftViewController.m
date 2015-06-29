//
//  RYMyHomeLeftViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyHomeLeftViewController.h"
#import "RYMyHomeLeftTableViewCell.h"
#import "RYLoginViewController.h"

#import "RYMyNoticeModel.h"


#import "RYMyCollectViewController.h"
#import "RYMyEnshrineViewController.h"
#import "RYMyShareViewController.h"
#import "RYMyJiFenViewController.h"
#import "RYMyInformViewController.h"
#import "RYMyInviteViewController.h"
#import "RYMyLiteratureViewController.h"
#import "RYMyAnswersRecordViewController.h"

@interface RYMyHomeLeftViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView      *theTableView;
    
    NSArray          *highlightedImgArrs;// 高亮图片组
    NSArray          *normalImageArrs;   // 普通图片组
    
    NSArray          *recusalImgeArrs;   // 不可选 图片数组
    
    BOOL             islogin;
}

@property (nonatomic , assign) NSInteger         noticeNumber;
@property (nonatomic , strong) RYMyNoticeModel   *noticeModel;

@end

@implementation RYMyHomeLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    islogin = [ShowBox isLogin];
    [self setdatas];
    [self initSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideMenuDidOpen) name:SlideNavigationControllerDidOpen object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)slideMenuDidOpen
{
    NSLog(@"滑动 完成");
    islogin = [ShowBox isLogin];
    [theTableView reloadData];
    
    if ( islogin ) {
        [self getNoticeData];
    }
}

// 获取图片数组
- (void)setdatas
{
    highlightedImgArrs = [NSArray arrayWithArray:[Utils getImageArrWithImgName:@"ic_highlighted_" andMaxIndex:7]];
    normalImageArrs = [NSArray arrayWithArray:[Utils getImageArrWithImgName:@"ic_normalImage_" andMaxIndex:7]];
    
    recusalImgeArrs = [NSArray arrayWithArray:[Utils getImageArrWithImgName:@"ic_recusalImge_" andMaxIndex:7]];
}

- (void)initSubviews
{
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [theTableView setScrollEnabled:NO];
    [theTableView setDelegate:self];
    [theTableView setDataSource:self];
    theTableView.backgroundColor = [UIColor clearColor];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:theTableView];
}

- (void)getNoticeData
{
    __weak typeof(self) wSelf = self;
    [NetRequestAPI getMyNoticeHomePageListWithSessionId:[RYUserInfo sharedManager].session
                                                success:^(id responseDic) {
                                                    NSLog(@"responseDic 通知 ：%@",responseDic);
                                                    [wSelf analysisDataWithDict:responseDic];
        
    } failure:^(id errorString) {
        NSLog(@"errorString 通知 ：%@",errorString);
    }];
}

-(void)analysisDataWithDict:(NSDictionary *)responseDic
{
    if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
        return;
    }
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    if ( meta == nil ) {
        return;
    }
    
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        return;
    }
    
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    if ( info == nil ) {
        return;
    }
    self.noticeNumber = 0;
    // 取系统消息
    NSArray *noticesystemmessage = [info getArrayValueForKey:@"noticesystemmessage" defaultValue:nil];
    self.noticeModel.systemNoticeArray = noticesystemmessage;
    
    for ( NSInteger i = 0; i < noticesystemmessage.count; i ++ ) {
        
        NSDictionary *dict = [noticesystemmessage objectAtIndex:i];
        NSInteger number = [dict getIntValueForKey:@"count" defaultValue:0];
        if ( number > 0 ) {
            self.noticeNumber = self.noticeNumber + number;
        }
    }
    
    // 取有奖活动
    NSArray *noticespreadmessage = [info getArrayValueForKey:@"noticespreadmessage" defaultValue:nil];
    self.noticeModel.prizeNoticeArray = noticespreadmessage;
    
    for ( NSInteger i = 0; i < noticespreadmessage.count; i ++ ) {
        
        NSDictionary *dict = [noticespreadmessage objectAtIndex:i];
        NSInteger number = [dict getIntValueForKey:@"count" defaultValue:0];
        if ( number > 0 ) {
            self.noticeNumber = self.noticeNumber + number;
        }
    }
    
    // 取 公司通知列表
    NSArray      *noticethreadmessage = [info getArrayValueForKey:@"noticethreadmessage" defaultValue:nil];
    self.noticeModel.companyNoticeArray = noticethreadmessage;
    
    for ( NSInteger i = 0; i < noticethreadmessage.count; i ++ ) {
        
        NSDictionary *dict = [noticethreadmessage objectAtIndex:i];
        NSInteger number = [dict getIntValueForKey:@"count" defaultValue:0];
        if ( number > 0 ) {
            self.noticeNumber = self.noticeNumber + number;
        }
    }

    if ( self.noticeNumber > 0 ) {
        [theTableView reloadData];
    }
}

- (RYMyNoticeModel *)noticeModel
{
    if ( _noticeModel == nil ) {
        _noticeModel = [[RYMyNoticeModel alloc]init];
    }
    return _noticeModel;
}

#pragma mark - UITableView 代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 9;
    }
    else{
        if ( islogin ) {
            return 1;
        }
        else{
            return 0;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            return 80;
        }
        else{
            return 43;
        }
    }else{
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            NSString *topCell = @"topCell";
            RYMyHomeLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topCell];
            if ( !cell ) {
                cell = [[RYMyHomeLeftTableViewCell alloc] initWithTopCellStyle:UITableViewCellStyleDefault reuseIdentifier:topCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if ( !islogin ) {
                cell.headPortraitImageView.image = [UIImage imageNamed:@"user_head_no.png"];
                cell.userNameLabel.text = @"点击登录";
            }
            else{
                cell.headPortraitImageView.image = [UIImage imageNamed:@"user_head_yes.png"];
                cell.userNameLabel.text = [[RYUserInfo sharedManager] realname];
            }
            
            [cell.headPortraitButton addTarget:self action:@selector(headButtonClick) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        else{
            NSString *commonCell = @"commonCell";
            RYMyHomeLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCell];
            if ( !cell ) {
                cell = [[RYMyHomeLeftTableViewCell alloc] initWithCommonStyle:UITableViewCellStyleDefault reuseIdentifier:commonCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if ( islogin  ) {
                [cell setUserInteractionEnabled:YES];
                if ( [[[RYUserInfo sharedManager] groupid] isEqualToString:@"10"] && indexPath.row != 2 ) {
                    [cell setUserInteractionEnabled:NO];
                    NSString *normalImageName = [recusalImgeArrs objectAtIndex:indexPath.row-1];
                    cell.normalImage = [UIImage imageNamed:normalImageName];
                }
                else{
                    //高亮图片的名字
                    NSString *highlightedImgName = [highlightedImgArrs objectAtIndex:indexPath.row-1];
                    //normal图片的名字
                    NSString *normalImageName = [normalImageArrs objectAtIndex:indexPath.row-1];
                    cell.normalImage = [UIImage imageNamed:normalImageName];
                    cell.highlightImage = [UIImage imageNamed:highlightedImgName];
                }
                if ( indexPath.row == 1 ) {
                    if ( self.noticeNumber > 0 ) {
                        cell.noticeLabel.text = [NSString stringWithFormat:@"%li",(long)self.noticeNumber];
                    }
                    else{
                        cell.noticeLabel.text = @"";
                    }
                }
            }
            else{
                [cell setUserInteractionEnabled:NO];
                NSString *normalImageName = [recusalImgeArrs objectAtIndex:indexPath.row-1];
                cell.normalImage = [UIImage imageNamed:normalImageName];
            }
            return cell;
        }
    }else{
        NSString *exitCell = @"exitCell";
        RYMyHomeLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:exitCell];
        if ( !cell ) {
            cell = [[RYMyHomeLeftTableViewCell alloc] initWithExitStyle:UITableViewCellStyleDefault reuseIdentifier:exitCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.exitButton addTarget:self action:@selector(exitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row != 0 ) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIViewController *vc;
        switch ( indexPath.row ) {
            case 1: // 通知
                vc = [[RYMyInformViewController alloc] initWithNoticeModel:self.noticeModel];
                break;
            case 2: // 收藏
                vc = [[RYMyEnshrineViewController alloc] init];
                break;
            case 3: // 关注
                vc = [[RYMyCollectViewController alloc] init];
                break;
            case 4: // 积分
                vc = [[RYMyJiFenViewController alloc] init];
                break;
            case 5: // 分享记录
                vc = [[RYMyShareViewController alloc] init];
                break;
            case 6: // 邀请注册
                vc = [[RYMyInviteViewController alloc] init];
                break;
            case 7: // 文献查询
                vc = [[RYMyLiteratureViewController alloc] init];
                break;
            case 8: // 问答记录
                vc = [[RYMyAnswersRecordViewController alloc] init];
                break;
            default:
                break;
        }
        __weak typeof(self) wSelf = self;
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                 withSlideOutAnimation:NO
                                                                         andCompletion:^{
                                                                             __strong typeof(wSelf) sSelf = wSelf;
                                                                             if ( indexPath.row == 1 ) {
                                                                                 wSelf.noticeNumber = 0;
                                                                                 [sSelf->theTableView reloadData];
                                                                             }
            
        }];
    }
}

#pragma mark ----- 按钮点击事件
- (void)headButtonClick
{
    NSLog(@"头像点击");
    if ( !islogin ) {
        RYLoginViewController *loginVC = [[RYLoginViewController alloc] init];
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:loginVC
                                                                 withSlideOutAnimation:NO
                                                                         andCompletion:nil];
    }
}

- (void)exitButtonClick
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要注销用户吗？" delegate:self cancelButtonTitle:@"不注销" otherButtonTitles:@"继续注销", nil];
    alert.tag = 110;
    [alert show];
}

#pragma mark ----- UIAlertView 代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        [RYUserInfo logout];
        islogin = NO;
        [theTableView reloadData];

    }
}


@end
