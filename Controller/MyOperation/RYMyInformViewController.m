//
//  RYMyInformViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/5.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyInformViewController.h"
#import "RYMyInformTableViewCell.h"
#import "RYMyInformListViewController.h"
#import "RYMyInformRewardListViewController.h"
#import "RYCorporateHomePageViewController.h"

@interface RYMyInformViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView      *theTableView;
}
@end

@implementation RYMyInformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通知";
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubviews
{
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    theTableView.backgroundColor = [UIColor clearColor];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [Utils setExtraCellLineHidden:theTableView];
    [self.view addSubview:theTableView];
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch ( section ) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 4;
            break;
            
        default:
            return 0;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *inform = @"inform";
    RYMyInformTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inform];
    if ( !cell ) {
        cell = [[RYMyInformTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inform];
    }
    if ( indexPath.section == 0 ) {
        cell.titleLabel.text = @"系统消息";
        cell.numLabel.text = @"3";
    }
    else if ( indexPath.section == 1 ){
        cell.titleLabel.text = @"有奖活动";
        cell.numLabel.text = @"4";
    }
    else{
        cell.titleLabel.text = @"赛诺秀：什么乱七八糟的什么乱七八糟的什么乱七八糟的什么乱七八糟的什么乱七八糟的什么乱七八糟的什么乱七八糟的什么乱七八糟的";
        cell.numLabel.text = @"99+";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( indexPath.section == 0 || indexPath.section == 1 ) {
        if ( indexPath.section == 0 ) {
            RYMyInformListViewController *vc = [[RYMyInformListViewController alloc] initWithInfomType:InformSystem];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            RYMyInformRewardListViewController *vc = [[RYMyInformRewardListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else{
        RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 8;
    }
    else{
        return 28;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( section == 1 ) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28)];
        bgView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 30, 28)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        titleLabel.text = @"企业通知";
        [bgView addSubview:titleLabel];
        return bgView;
    }else{
        return [UIView new];
    }
}



@end
