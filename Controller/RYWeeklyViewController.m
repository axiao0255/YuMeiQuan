//
//  RYWeeklyViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYWeeklyViewController.h"
#import "RYNewsPageTableViewCell.h"
#import "RYWeeklyTableViewCell.h"
#import "RYArticleViewController.h"
#import "RYLiteratureDetailsViewController.h"
#import "RYWeeklyCategoryViewController.h"


@interface RYWeeklyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView      *tableView;
@property (nonatomic , strong) NSString         *cateid;      //分类的id

@end

@implementation RYWeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
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

- (NSArray *)listData
{
    if ( _listData == nil ) {
        _listData = [NSArray array];
    }
    return _listData;
}

- (UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
         _tableView.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
        [Utils setExtraCellLineHidden:_tableView];
        
    }
    return _tableView;
}

- (void)setup
{
    self.cateid = nil;
    [self.view addSubview:self.tableView];
    [self getNetData];
}

- (void)getNetData
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getSelectWeeklyDataWithSessionId:[RYUserInfo sharedManager].session
                                               weeklyId:[self.weeklyDict objectForKey:@"id"]
                                                 cateid:self.cateid
                                                success:^(id responseDic) {
                                                    NSLog(@"选择的周报 responseDic: %@",responseDic);
                                                    [wSelf analysisDataWithDict:responseDic];
            
        } failure:^(id errorString) {
            NSLog(@"选择的周报 errorString: %@",errorString);
        }];
    }
}

-(void)analysisDataWithDict:(NSDictionary *)responseDic
{
    if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
        [ShowBox showError:@"数据错误，请稍候重试"];
        return;
    }
    
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    if ( !meta ) {
        [ShowBox showError:@"数据错误，请稍候重试"];
        return;
    }
    
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"数据错误，请稍候重试"]];
        return;
    }
    
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    if ( info == nil ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"数据错误，请稍候重试"]];
        return;
    }
    // 取周报 发布时间 和多少期
//    NSDictionary *weeklymessage = [info getDicValueForKey:@"weeklymessage" defaultValue:nil];
//    self.weeklyTimeDict = weeklymessage;
    
    self.title = [NSString stringWithFormat:@"第%@期",[self.weeklyDict objectForKey:@"id"]];
    
    // 取周报内容
    NSArray *weeklydetailmessage = [info getArrayValueForKey:@"weeklydetailmessage" defaultValue:nil];
    self.listData = weeklydetailmessage;
    [self.tableView reloadData];

}


#pragma mark  UITableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.listData.count ) {
        return self.listData.count;
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.listData.count ) {
        if ( indexPath.row == 0 ) {
            return 180;
        }
        else{
            return 90;
        }
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 ) {
        NSString *adverCell = @"adverCell";
        RYAdverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:adverCell];
        if ( !cell ) {
            cell = [[RYAdverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adverCell];
        }
        if ( self.listData.count ) {
            [cell setValueWithDict:[self.listData objectAtIndex:0]];
        }
        return cell;
    }
    else{
        NSString *weekly_cell = @"weekly_cell";
        RYWeeklyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:weekly_cell];
        if ( !cell ) {
            cell = [[RYWeeklyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:weekly_cell];
        }
        if ( self.listData.count ) {
            [cell setValueWithDict:[self.listData objectAtIndex:indexPath.row]];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( self.listData.count > 0 ) {
        if ( section == 0 ) {
            return 40;
        }
        else{
            return 0;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( self.listData.count ) {
        if ( section == 0 ) {
            UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            view.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 42, 40)];
            titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.text = @"分类：";
            [view addSubview:titleLabel];
            
            UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right+5, 0, 225, 40)];
            categoryLabel.font = [UIFont boldSystemFontOfSize:16];
            categoryLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
            categoryLabel.text = @"全部";
            [view addSubview:categoryLabel];
            
            UIImageView *arrows = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 10, 13, 10, 14)];
            arrows.image =[UIImage imageNamed:@"ic_right_arrow.png"];;
            [view addSubview:arrows];
            
            [view addTarget:self action:@selector(categorySelect:) forControlEvents:UIControlEventTouchUpInside];
            
            
            return view;
            
        }else{
            return nil;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [self.listData objectAtIndexedSubscript:indexPath.row];
    NSString *fid = [dict getStringValueForKey:@"fid" defaultValue:@""];
    NSString *tid = [dict getStringValueForKey:@"tid" defaultValue:@""];
    
    if ( [fid isEqualToString:@"137"] ) {
        RYLiteratureDetailsViewController *vc = [[RYLiteratureDetailsViewController alloc] initWithTid:tid];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:tid];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)categorySelect:(id)sender
{
    NSLog(@"分类选择");
    RYWeeklyCategoryViewController *vc = [[RYWeeklyCategoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
