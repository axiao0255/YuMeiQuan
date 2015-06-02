//
//  RYMyShareViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/4.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyShareViewController.h"
#import "RYMyShareTableViewCell.h"

@interface RYMyShareViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView         *theTableView;
    NSMutableArray      *dataArray;
}

@end

@implementation RYMyShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的分享";
    dataArray = [[self setdata] mutableCopy];
    [self initSubviews];
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

- (NSArray *)setdata
{
    NSMutableArray *arr = [NSMutableArray array];
    for ( NSUInteger i = 0 ; i < 5; i ++ ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *title = @"护肤品中的生长因子安全吗。护肤品中的生长因子安全吗。护肤品中的生长因子安全吗。护肤品中的生长因子安全吗。护肤品中的生长因子安全吗。";
        [dic setValue:title forKey:@"title"];
        [dic setValue:@"2015-04-08" forKey:@"time"];
        if ( i%2 == 0) {
            [dic setValue:@"50" forKey:@"jifen"];
        }
        else{
            [dic setValue:@"100" forKey:@"jifen"];
        }
        [arr addObject:dic];
    }
    return arr;
}

-(void)initSubviews
{
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
    theTableView.backgroundColor = [UIColor clearColor];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [Utils setExtraCellLineHidden:theTableView];
    [self.view addSubview:theTableView];
}

#pragma mark - UITableView 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *share_cell = @"share_cell";
    RYMyShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:share_cell];
    if ( !cell ) {
        cell = [[RYMyShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:share_cell];
    }
    [cell setValueWithDict:[dataArray objectAtIndex:indexPath.row]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
