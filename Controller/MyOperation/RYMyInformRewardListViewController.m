//
//  RYMyInformRewardListViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyInformRewardListViewController.h"
#import "RYArticleViewController.h"

@interface RYMyInformRewardListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic) UITableView         *tableView;
@property (strong , nonatomic) NSArray             *listData;

@end

@implementation RYMyInformRewardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"有奖活动";
    self.listData = [self getdata];
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
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

- (NSArray *)getdata;
{
    NSMutableArray *arr = [NSMutableArray array];
    for ( int i = 0 ; i < 6; i ++ ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if ( i % 2 == 0 ) {
            [dic setObject:@"电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影" forKey:@"title"];
        }
        else{
            [dic setObject:@"视频视频视频视频视频视频视频视频视频视" forKey:@"title"];
        }
        [arr addObject:dic];
    }
    return arr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.listData.count ) {
        NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
        NSString *title = [dict getStringValueForKey:@"title" defaultValue:@""];
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
        return size.height + 16;
    }
    else{
        return 0;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reward_cell = @"reward_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reward_cell];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reward_cell];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.left = 15;
        label.width = SCREEN_WIDTH - 30;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        label.numberOfLines = 0;
        label.tag = 1010;
        [cell.contentView addSubview:label];
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1010];
    if ( self.listData.count ) {
        NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
        NSString *title = [dict getStringValueForKey:@"title" defaultValue:@""];
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
        label.height = size.height + 16;
        
        label.text = title;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RYArticleViewController *vc = [[RYArticleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
