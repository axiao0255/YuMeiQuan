//
//  RYMyJiFenViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/4.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyJiFenViewController.h"
#import "RFSegmentView.h"
#import "RYMyLiteratureViewController.h"
#import "RYMyInviteViewController.h"
#import "RYInviteMakeMoneyViewController.h"

@interface RYMyJiFenViewController ()<UITableViewDelegate,UITableViewDataSource,RFSegmentViewDelegate>
{
    NSArray        *imgsArray;
}

@property (nonatomic , strong) UITableView    *tableView;
@property (nonatomic , assign) NSInteger      currentIndex;
@end

@implementation RYMyJiFenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的积分";
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentIndex = 0;
    imgsArray = [self getImgArrayWithIndex:self.currentIndex];
    
    [self getNetData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getNetData
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
        [NetRequestAPI getMyCreditsWithSessionId:[RYUserInfo sharedManager].session
                                         success:^(id responseDic) {
                                             NSLog(@"我的积分 responseDic :: %@",responseDic);
                                             [wSelf analysisDataWithDict:responseDic];
            
        } failure:^(id errorString) {
            NSLog(@"我的积分 errorString :: %@",errorString);
            [SVProgressHUD dismiss];
        }];
    }
}
//
- (void)analysisDataWithDict:(NSDictionary *)responseDic
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        int  login = [meta getIntValueForKey:@"login" defaultValue:0];
        if ( login == 2 ) {  // login == 2 表示用户已过期 需要重新登录
              __weak typeof(self) wSelf = self;
            [RYUserInfo automateLoginWithLoginSuccess:^(BOOL isSucceed) {
                // 自动登录一次
                if ( isSucceed ) { // 自动登录成功 刷新数据，
                    [wSelf getNetData];
                }
                else{// 登录失败 打开登录界面 手动登录
                    [SVProgressHUD dismiss];
                    [wSelf openLoginVC];
                }
            } failure:^(id errorString) {
                [SVProgressHUD dismiss];
                [wSelf openLoginVC];
            }];
            return;
        }
    }
    [SVProgressHUD dismiss];
    [self removeErroeView];
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
     // 刷新 userinfo的数据
    NSDictionary *usermassage = [info getDicValueForKey:@"usermassage" defaultValue:nil];
    if ( usermassage ) {
        [[RYUserInfo sharedManager] refreshUserInfoDataWithDict:usermassage];
    }
    [self.view addSubview:self.tableView];
}

- (NSArray *)getImgArrayWithIndex:(NSInteger )index
{
    NSArray *arr;
    if ( index==0 ) {
        arr = [NSArray arrayWithArray:[Utils getImageArrWithImgName:@"jifen_img" andMaxIndex:2]];
    }
    else{
        arr = @[@"jifen_img_literature.png"];
    }
    return arr;
}

- (UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

#pragma mark  UITableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 1;
    }
    else{
         return imgsArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        return 250;
    }
    else{
        
        if ( IS_IPHONE_6P || IS_IPHONE_6 ) {
            return 55;
        }
        else{
            return 43;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        return [self topCellTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else{
        NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if ( !cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
            imgView.tag = 1010;
            [cell.contentView addSubview:imgView];
        }
        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1010];
        NSString *imgName = [imgsArray objectAtIndex:indexPath.row];
        imgView.image = [UIImage imageNamed:imgName];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld",(long)indexPath.row);
    if ( self.currentIndex == 1 ) {
        if ( indexPath.row == 0 && indexPath.section == 1 ) {
            RYMyLiteratureViewController *vc = [[RYMyLiteratureViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else{
        if ( indexPath.row == 2 ) {
            RYMyInviteViewController *vc = [[RYMyInviteViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            RYInviteMakeMoneyViewController *inviteVC;
            if ( indexPath.row == 0 ) {
                inviteVC = [[RYInviteMakeMoneyViewController alloc] initWithInviteType:transmit];
            }
            else{
                inviteVC = [[RYInviteMakeMoneyViewController alloc] initWithInviteType:survey];
            }
            [self.navigationController pushViewController:inviteVC animated:YES];
        }
    }
}

- (UITableViewCell *)topCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *top_cell = @"top_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:top_cell];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:top_cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-82+24, 24, 164, 164)];
        iconImageView.image = [UIImage imageNamed:@"ic_jifen_jewel.png"];
        [cell.contentView addSubview:iconImageView];
        
        UILabel *jifenTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80, 161, 80, 14)];
        jifenTitleLabel.text = @"积分余额";
        jifenTitleLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        jifenTitleLabel.font = [UIFont systemFontOfSize:14];
        [jifenTitleLabel sizeToFit];
        [cell.contentView addSubview:jifenTitleLabel];
        
        // 显示积分
        UILabel *showJifenLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80,
                                                                            jifenTitleLabel.bottom + 8,
                                                                            170,
                                                                            35)];
        showJifenLabel.backgroundColor = [UIColor clearColor];
        showJifenLabel.font = [UIFont systemFontOfSize:35];
        showJifenLabel.textColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
        showJifenLabel.textAlignment = NSTextAlignmentRight;
        showJifenLabel.tag = 110;
        [cell.contentView addSubview:showJifenLabel];
    }
    
    UILabel *showJifenLabel= (UILabel *)[cell.contentView viewWithTag:110];
    showJifenLabel.text = [RYUserInfo sharedManager].credits;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 43;
    }
    else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( section == 0 ) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
        view.backgroundColor = [UIColor whiteColor];
        RFSegmentView *segmentView = [[RFSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28) items:@[@"赚积分",@"使用积分"]];
        segmentView.tintColor = [Utils getRGBColor:0x00 g:0x91 b:0xea a:1.0];
        segmentView.delegate = self;
        [view addSubview:segmentView];
        return view;
    }
    else{
        return nil;
    }
}

#pragma mark - RFSegmentView delegate
- (void)segmentViewSelectIndex:(NSInteger)index
{
    if ( self.currentIndex != index ) {
        self.currentIndex = index;
        imgsArray = [self getImgArrayWithIndex:self.currentIndex];
        [self.tableView beginUpdates];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

#pragma mark 打开登录界面重现登录
- (void)openLoginVC
{
    __weak typeof(self) wSelf = self;
    RYLoginViewController *nextVC = [[RYLoginViewController alloc] initWithFinishBlock:^(BOOL isLogin, NSError *error) {
        if ( isLogin ) {
            NSLog(@"登录完成");
            // 登录完成 重新获取数据
            [wSelf getNetData];
        }
    }];
    [self.navigationController pushViewController:nextVC animated:YES];
}



@end
