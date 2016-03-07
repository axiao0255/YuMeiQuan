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

//#import "RYMyNoticeModel.h"


#import "RYMyCollectViewController.h"
#import "RYMyEnshrineViewController.h"
#import "RYMyShareViewController.h"
#import "RYMyJiFenViewController.h"
//#import "RYMyInformViewController.h"
#import "RYMyInviteViewController.h"
#import "RYMyLiteratureViewController.h"
#import "RYMyAnswersRecordViewController.h"
#import "RYMyExchangeViewController.h"

@interface RYMyHomeLeftViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView      *theTableView;
    
    NSArray          *highlightedImgArrs;// 高亮图片组
    NSArray          *normalImageArrs;   // 普通图片组
    
    NSArray          *recusalImgeArrs;   // 不可选 图片数组
    
    BOOL             islogin;
}

//@property (nonatomic , strong) RYMyNoticeModel   *noticeModel;

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
}

// 获取图片数组
- (void)setdatas
{
    highlightedImgArrs = [NSArray arrayWithArray:[Utils getImageArrWithImgName:@"ic_highlighted_" andMaxIndex:5]];
    normalImageArrs = [NSArray arrayWithArray:[Utils getImageArrWithImgName:@"ic_normalImage_" andMaxIndex:5]];
    
    recusalImgeArrs = [NSArray arrayWithArray:[Utils getImageArrWithImgName:@"ic_recusalImge_" andMaxIndex:5]];
}

- (void)initSubviews
{
    UIImageView *topBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 55, 195*SCREEN_WIDTH/320)];
    topBackground.image = [UIImage imageNamed:@"ic_leftVIew_background.png"];
    [self.view addSubview:topBackground];
    
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [theTableView setScrollEnabled:NO];
    [theTableView setDelegate:self];
    [theTableView setDataSource:self];
    theTableView.backgroundColor = [UIColor clearColor];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:theTableView];
}

#pragma mark - UITableView 代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 1;
    }
    else{
        return 6;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        return 195*SCREEN_WIDTH/320;
    }
    else{
        return 40*SCREEN_WIDTH/320;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *nameBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 45*SCREEN_WIDTH/320, 160*SCREEN_WIDTH/320, 30)];
        [nameBtn setBackgroundImage:[UIImage imageNamed:@"ic_leftview_name.png"] forState:UIControlStateNormal];
        nameBtn.adjustsImageWhenHighlighted = NO;
        [nameBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [cell.contentView addSubview:nameBtn];
        
        UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(nameBtn.right + 44, nameBtn.top, 30, 30)];
        [loginBtn addTarget:self action:@selector(headButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:loginBtn];
        if ( islogin ) {
            [loginBtn setBackgroundImage:[UIImage imageNamed:@"ic_leftView_exit.png"] forState:UIControlStateNormal];
            if ( [[[RYUserInfo sharedManager] groupid] isEqualToString:@"10"] ) {
                [nameBtn setTitle:@"账号审核中" forState:UIControlStateNormal];
            }
            else if ( [[[RYUserInfo sharedManager] groupid] isEqualToString:@"42"] ){
                [nameBtn setTitle:@"账号审核失败" forState:UIControlStateNormal];
            }
            else{
                [nameBtn setTitle:[[RYUserInfo sharedManager] realname] forState:UIControlStateNormal];
            }
        }
        else{
            [nameBtn setTitle:@"未登录" forState:UIControlStateNormal];
            [loginBtn setBackgroundImage:[UIImage imageNamed:@"ic_leftView_login.png"] forState:UIControlStateNormal];
        }

        return cell;
    }
    else{
        
        NSString *commonCell = @"commonCell";
        RYMyHomeLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCell];
        if ( !cell ) {
            cell = [[RYMyHomeLeftTableViewCell alloc] initWithCommonStyle:UITableViewCellStyleDefault reuseIdentifier:commonCell];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if ( islogin  ) {
            [cell setUserInteractionEnabled:YES];
            if ( [[[RYUserInfo sharedManager] groupid] isEqualToString:@"10"] || [[[RYUserInfo sharedManager] groupid] isEqualToString:@"42"] ) {
                [cell setUserInteractionEnabled:NO];
                NSString *normalImageName = [recusalImgeArrs objectAtIndex:indexPath.row];
                cell.normalImage = [UIImage imageNamed:normalImageName];
            }
            else{
                //高亮图片的名字
                NSString *highlightedImgName = [highlightedImgArrs objectAtIndex:indexPath.row];
                //normal图片的名字
                NSString *normalImageName = [normalImageArrs objectAtIndex:indexPath.row];
                cell.normalImage = [UIImage imageNamed:normalImageName];
                cell.highlightImage = [UIImage imageNamed:highlightedImgName];
            }
        }
        else{
            [cell setUserInteractionEnabled:NO];
            NSString *normalImageName = [recusalImgeArrs objectAtIndex:indexPath.row];
            cell.normalImage = [UIImage imageNamed:normalImageName];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section != 0 ) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIViewController *vc;
        switch ( indexPath.row ) {
            case 0: //  收藏
                 vc = [[RYMyEnshrineViewController alloc] init];
                break;
            case 1: //关注
                 vc = [[RYMyCollectViewController alloc] init];
                break;
            case 2: // 分享记录
                 vc = [[RYMyShareViewController alloc] init];
                break;
            case 3: // 积分商城
                vc = [[RYMyExchangeViewController alloc] init];
                break;
            case 4: // 文献查询
                 vc = [[RYMyLiteratureViewController alloc] init];
                break;
            case 5: // 问答记录
                vc = [[RYMyAnswersRecordViewController alloc] init];
                break;
            default:
                break;
        }
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                 withSlideOutAnimation:NO
                                                                         andCompletion:nil];
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
    else{
        [self exitButtonClick];
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
