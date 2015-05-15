//
//  RYCorporateHomePageViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/12.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYCorporateHomePageViewController.h"
#import "RYCorporateHomePageTableViewCell.h"
#import "RYCorporateHomePageData.h"
#import "RYCorporateViewController.h"

@interface RYCorporateHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView              *tableView;

@property (nonatomic,strong) RYCorporateHomePageData  *dataModel;

@end

@implementation RYCorporateHomePageViewController

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

-(void)setdata
{
    NSMutableDictionary *headDic = [NSMutableDictionary dictionary];
    [headDic setObject:@"http://d.hiphotos.baidu.com/zhidao/pic/item/562c11dfa9ec8a13e028c4c0f603918fa0ecc0e4.jpg" forKey:@"pic"];
    [headDic setObject:@"赛诺龙中国" forKey:@"name"];
    [headDic setObject:@"全球医疗美容设备市场的领导者" forKey:@"declare"];
    self.dataModel.corporateBody = headDic;
    self.dataModel.isAttention = NO;
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    for ( int i = 0 ; i < 10; i ++ ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [tmpArr addObject:dic];
        [dic setObject:@"护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，" forKey:@"content"];
        if (i%2==0) {
            [dic setObject:@"http://d.hiphotos.baidu.com/zhidao/pic/item/562c11dfa9ec8a13e028c4c0f603918fa0ecc0e4.jpg" forKey:@"pic"];
        }else{
            [dic setObject:@"" forKey:@"pic"];
        }
    }
    self.dataModel.corporateArticles = tmpArr;
}

-(UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

- (RYCorporateHomePageData *)dataModel
{
    if ( _dataModel == nil ) {
        _dataModel = [[RYCorporateHomePageData alloc] init];
    }
    return _dataModel;
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        if (self.dataModel.isAttention) {
            return 1;
        }
        else{
            return 2;
        }
    }
    else{
        return self.dataModel.corporateArticles.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            return 60;
        }
        else{
            return 45;
        }
    }
    else{
        return 66;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            NSString *topCell = @"topCell";
            RYCorporateHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topCell];
            if ( !cell ) {
                cell = [[RYCorporateHomePageTableViewCell alloc] initWithTopCellStyle:UITableViewCellStyleDefault reuseIdentifier:topCell];
            }
            [cell setValueWithDic:self.dataModel.corporateBody];
            return cell;
        }
        else{
            NSString *attention = @"attention";
            RYCorporateAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attention];
            if ( !cell ) {
                cell = [[RYCorporateAttentionTableViewCell alloc] initWithAttentionStyle:UITableViewCellStyleDefault reuseIdentifier:attention];
            }
            [cell.attentionButton addTarget:self action:@selector(attentionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
    else{
        NSString *publishedArticles = @"PublishedArticles";
        RYCorporatePublishedArticlesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishedArticles];
        if ( !cell ) {
            cell = [[RYCorporatePublishedArticlesTableViewCell alloc] initWithPublishedArticlesStyle:UITableViewCellStyleDefault reuseIdentifier:publishedArticles];
        }
        [cell setValueWithPublishedArticlesDic:[self.dataModel.corporateArticles objectAtIndex:indexPath.row]];
        return cell;
     }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            RYCorporateViewController *vc = [[RYCorporateViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


- (void)attentionButtonClick:(id)sender
{
    self.dataModel.isAttention = YES;
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

@end
