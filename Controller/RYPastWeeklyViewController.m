//
//  RYPastWeeklyViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYPastWeeklyViewController.h"
#import "RYPastWeeklyTableViewCell.h"

@interface RYPastWeeklyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView     *tableView;
@property (nonatomic , strong) NSArray         *listData;

@end

@implementation RYPastWeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"往期周报";
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


- (void)setup
{
    self.listData = [self getdata];
    [self.view addSubview:self.tableView];
}

- (NSArray *)getdata;
{
    NSMutableArray *arr = [NSMutableArray array];
    for ( int i = 0 ; i < 6; i ++ ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"http://image.tianjimedia.com/uploadImages/2015/131/49/6FPNGYZA50BS_680x500.jpg" forKey:@"pic"];
        [dic setObject:@"2015-05-08 总第219期" forKey:@"time"];
        if ( i % 2 == 0 ) {
            [dic setObject:@"电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影" forKey:@"title"];
            [dic setObject:@"文献" forKey:@"belongs"];
            [dic setObject:@"中国医生协会美容与整形医生分会。激光激光激光" forKey:@"subhead"];
        }
        else{
            [dic setObject:@"视频视频视频视频视频视频视频视频视频视" forKey:@"title"];
            [dic setObject:@"会讯" forKey:@"belongs"];
            [dic setObject:@"" forKey:@"subhead"];
        }
        [arr addObject:dic];
    }
    return arr;

}

- (UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *pastWeekly_cell = @"pastWeekly_cell";
    RYPastWeeklyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pastWeekly_cell];
    if ( !cell ) {
        cell = [[RYPastWeeklyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pastWeekly_cell];
    }
    if ( self.listData.count ) {
        [cell setValueWithDict:[self.listData objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
