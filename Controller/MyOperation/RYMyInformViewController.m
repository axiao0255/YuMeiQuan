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

@property (nonatomic ,strong) RYMyNoticeModel *noticeModel;

@end

@implementation RYMyInformViewController

-(id)initWithNoticeModel:(RYMyNoticeModel *)model
{
    self = [super init];
    if ( self ) {
        self.noticeModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通知";
    [self initSubviews];
    
    if ( self.noticeModel.systemNoticeArray.count == 0 && self.noticeModel.prizeNoticeArray.count == 0 && self.noticeModel.companyNoticeArray.count == 0 ) {
        [self getNoticeData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    // 取系统消息
    NSArray *noticesystemmessage = [info getArrayValueForKey:@"noticesystemmessage" defaultValue:nil];
    self.noticeModel.systemNoticeArray = noticesystemmessage;
    
//    for ( NSInteger i = 0; i < noticesystemmessage.count; i ++ ) {
//        
//        NSDictionary *dict = [noticesystemmessage objectAtIndex:i];
//        NSInteger number = [dict getIntValueForKey:@"count" defaultValue:0];
//        if ( number > 0 ) {
//            self.noticeNumber = self.noticeNumber + number;
//        }
//    }
    
    // 取有奖活动
    NSArray *noticespreadmessage = [info getArrayValueForKey:@"noticespreadmessage" defaultValue:nil];
    self.noticeModel.prizeNoticeArray = noticespreadmessage;
    
//    for ( NSInteger i = 0; i < noticespreadmessage.count; i ++ ) {
//        
//        NSDictionary *dict = [noticespreadmessage objectAtIndex:i];
//        NSInteger number = [dict getIntValueForKey:@"count" defaultValue:0];
//        if ( number > 0 ) {
//            self.noticeNumber = self.noticeNumber + number;
//        }
//    }
    
    // 取 公司通知列表
    NSArray      *noticethreadmessage = [info getArrayValueForKey:@"noticethreadmessage" defaultValue:nil];
    self.noticeModel.companyNoticeArray = noticethreadmessage;
    
//    for ( NSInteger i = 0; i < noticethreadmessage.count; i ++ ) {
//        
//        NSDictionary *dict = [noticethreadmessage objectAtIndex:i];
//        NSInteger number = [dict getIntValueForKey:@"count" defaultValue:0];
//        if ( number > 0 ) {
//            self.noticeNumber = self.noticeNumber + number;
//        }
//    }
    
//    if ( self.noticeNumber > 0 ) {
//        [theTableView reloadData];
//    }
    [theTableView reloadData];
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
            return self.noticeModel.systemNoticeArray.count;
            break;
        case 1:
            return self.noticeModel.prizeNoticeArray.count;
            return 1;
            break;
        case 2:
            return self.noticeModel.companyNoticeArray.count;
            break;
        default:
            return 0;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
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
        cell.leftImgView.image = [UIImage imageNamed:@"system_notice.png"];
        if ( self.noticeModel.systemNoticeArray.count ) {
            NSDictionary *dict = [self.noticeModel.systemNoticeArray objectAtIndex:indexPath.row];
            NSInteger count = [dict getIntValueForKey:@"count" defaultValue:0];
            if ( count > 0 ) {
                cell.numLabel.hidden = NO;
                cell.numLabel.text = [NSString stringWithFormat:@"%li",(long)count];
            }
            else{
                cell.numLabel.hidden = YES;
            }
        }
    }
    else if ( indexPath.section == 1 ){
        cell.titleLabel.text = @"有奖活动";
        cell.leftImgView.image = [UIImage imageNamed:@"award_notice.png"];
        if ( self.noticeModel.prizeNoticeArray.count ) {
            NSDictionary *dict = [self.noticeModel.prizeNoticeArray objectAtIndex:indexPath.row];
            NSInteger count = [dict getIntValueForKey:@"count" defaultValue:0];
            if ( count > 0 ) {
                cell.numLabel.hidden = NO;
                cell.numLabel.text = [NSString stringWithFormat:@"%li",(long)count];
            }
            else{
                cell.numLabel.hidden = YES;
            }
        }
    }
    else{
        if ( self.noticeModel.companyNoticeArray.count ) {
            NSDictionary *dict = [self.noticeModel.companyNoticeArray objectAtIndex:indexPath.row];
            cell.titleLabel.text = [dict getStringValueForKey:@"author" defaultValue:@""];
            cell.subheadLabel.text = [dict getStringValueForKey:@"note" defaultValue:@""];
            NSInteger count = [dict getIntValueForKey:@"count" defaultValue:0];
            if ( count > 0 ) {
                cell.numLabel.hidden = NO;
                cell.numLabel.text = [NSString stringWithFormat:@"%li",(long)count];
            }
            else{
                cell.numLabel.hidden = YES;
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RYMyInformTableViewCell *cell = (RYMyInformTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ( indexPath.section == 0 || indexPath.section == 1 ) {
        if ( indexPath.section == 0 ) {
            RYMyInformListViewController *vc = [[RYMyInformListViewController alloc] initWithInfomType:InformSystem];
            [self.navigationController pushViewController:vc animated:YES];
             cell.numLabel.hidden = YES;
        }
        else{
           
            RYMyInformRewardListViewController *vc = [[RYMyInformRewardListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            cell.numLabel.hidden = YES;
        }
    }
    else{
        
        NSDictionary *dict = [self.noticeModel.companyNoticeArray objectAtIndex:indexPath.row];
        NSString *companyId = [dict getStringValueForKey:@"authorid" defaultValue:@""];
        RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] initWithCorporateID:companyId];
        [self.navigationController pushViewController:vc animated:YES];
        cell.numLabel.hidden = YES;
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
        if (self.noticeModel.companyNoticeArray.count == 0 ) {
            return nil;
        }
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
