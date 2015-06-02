//
//  RYAuthorArticleViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYAuthorArticleViewController.h"
#import "RYBaiJiaPageTableViewCell.h"
#import "RYArticleViewController.h"

@interface RYAuthorArticleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView    *tableView;

@end

@implementation RYAuthorArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for ( int i = 0; i < 10; i ++ ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"http://image.tianjimedia.com/uploadImages/2015/131/49/6FPNGYZA50BS_680x500.jpg" forKey:@"pic"];
        [dic setObject:@"护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，" forKey:@"title"];
        [arr addObject:dic];
    }
    self.articleLists = arr;
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

- (NSArray *)articleLists
{
    if ( _articleLists == nil ) {
        _articleLists = [NSArray array];
    }
    return _articleLists;
}

- (UITableView *)tableView
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articleLists.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *baiJiaArticle = @"baiJiaArticle";
    RYBaiJiaPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baiJiaArticle];
    if ( !cell ) {
        cell = [[RYBaiJiaPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baiJiaArticle];
    }
    if ( self.articleLists.count ) {
        [cell setValueWithDict:[self.articleLists objectAtIndex:indexPath.row]];
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RYArticleViewController *vc = [[RYArticleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
