//
//  RYCorporateViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/13.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYCorporateViewController.h"
#import "RYCorporateTableViewCell.h"
#import "RYCorporateModel.h"

@interface RYCorporateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView      *tableView;
@property (nonatomic , strong) RYCorporateModel *corporateModel;

@end

@implementation RYCorporateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"赛诺龙中国";
    [self setdata];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setdata
{
    self.corporateModel.corporateName = @"苏州赛诺龙医疗设备有限公司";
    self.corporateModel.corporateRecommend = @"赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点，赛诺龙独有的eMatrix水滴点";
    self.corporateModel.phone = @"123456789";
    self.corporateModel.isAttention = YES;
}

-(UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

-(RYCorporateModel *)corporateModel
{
    if ( _corporateModel == nil ) {
        _corporateModel = [[RYCorporateModel alloc] init];
    }
    return _corporateModel;
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        CGSize nameSize = [self.corporateModel.corporateName sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGSize  recommendSize = [self.corporateModel.corporateRecommend sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        
        return nameSize.height + recommendSize.height + 80 + 16 + 16 + 28;
    }
    else{
         return 94;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"identifier";
    RYCorporateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell ) {
        cell = [[RYCorporateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ( indexPath.section == 0 ) {
        [cell setValueWithModel:self.corporateModel];
        [cell.attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        cell.corporateTitleLabel.font = [UIFont systemFontOfSize:16];
        cell.corporateTitleLabel.text = [NSString stringWithFormat:@"联系方式：%@",self.corporateModel.phone];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( indexPath.section == 1 ) {
        [Utils makeTelephoneCall:self.corporateModel.phone];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


- (void)attentionBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.corporateModel.isAttention = !self.corporateModel.isAttention;
    if (self.corporateModel.isAttention) {
        [btn setImage:[UIImage imageNamed:@"ic_no_attention.png"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"ic_attention.png"] forState:UIControlStateNormal];
    }

}


@end
