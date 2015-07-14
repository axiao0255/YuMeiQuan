//
//  RYMyExchangeViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyExchangeViewController.h"
#import "RYMyExchangeTableViewCell.h"
#import "RYExchangeDetailsViewController.h"

@interface RYMyExchangeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)  UITableView     *tableView;
@property (nonatomic , strong)  NSArray         *listData;

@end

@implementation RYMyExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"积分兑换";
    
    NSMutableArray *arr = [NSMutableArray array];
    for ( NSInteger i = 0 ; i < 10; i ++ ) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"http://img1.cache.netease.com/catchpic/3/35/35AFDF1C4CFF12DDB31C9811E4F1441A.jpg" forKey:@"pic"];
        [dict setValue:@"精美礼品，吊坠挂件" forKey:@"name"];
        [dict setValue:@"足球主题曲响彻操场，足球舞蹈展示着运动活力。在精彩的节目演出后，重庆市教委副巡视员帅逊、万盛经开区党工委副书记肖猛" forKey:@"subject"];
        [dict setValue:@"5" forKey:@"jifen"];
        [arr addObject:dict];
    }
    
    self.listData = arr;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 1;
    }
    else{
        return self.listData.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        return 54;
    }
    else{
        return 90;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        NSString *jifen_cell = @"jifen_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jifen_cell];
        if ( !cell ) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jifen_cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 55, 54)];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
            titleLabel.text = @"积分余额";
            [cell.contentView addSubview:titleLabel];
            
            UILabel *jifenLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right+10, 0, 200, 54)];
            jifenLabel.font = [UIFont boldSystemFontOfSize:18];
            jifenLabel.textColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
            jifenLabel.tag = 110;
            [cell.contentView addSubview:jifenLabel];
        }
        UILabel  *jifenLabel = (UILabel *)[cell.contentView viewWithTag:110];
        jifenLabel.text = [RYUserInfo sharedManager].credits;
        return cell;
    }
    else{
        NSString *exchange_cell = @"exchange_cell";
        RYMyExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:exchange_cell];
        if ( !cell ) {
            cell = [[RYMyExchangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:exchange_cell];
        }
        if ( self.listData.count ) {
            NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
            [cell setValueWithDict:dict];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( indexPath.section == 1 ) {
        NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
        RYExchangeDetailsViewController *vc = [[RYExchangeDetailsViewController alloc] initWithExchangeDict:dict];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
