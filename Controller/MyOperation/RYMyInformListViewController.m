//
//  RYMyInformListViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/5.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyInformListViewController.h"
#import "RYMyInformListTableViewCell.h"

@interface RYMyInformListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    InformType       informType;
    UITableView      *theTableView;
    
    NSArray          *dadaArray;
}
@end

@implementation RYMyInformListViewController

- (id)initWithInfomType:(InformType)type
{
    self = [super init];
    if ( self ) {
        informType = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ( informType == InformSystem ) {
        self.title = @"系统消息";
    }else{
        self.title = @"有奖活动";
    }
    dadaArray = [self setdata];
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

- (void)initSubviews
{
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    theTableView.backgroundColor = [UIColor clearColor];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [Utils setExtraCellLineHidden:theTableView];
    [self.view addSubview:theTableView];
}

- (NSArray *)setdata
{
    NSMutableArray *arr = [NSMutableArray array];
    for ( NSUInteger i = 0 ; i < 5; i ++ ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *title = @"护肤品中的生长因子安全吗?";
        [dic setValue:title forKey:@"title"];
        NSString *content = @"移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，";
        [dic setValue:content forKey:@"content"];
        [dic setValue:@"2015-04-23" forKey:@"time"];
        [arr addObject:dic];
    }
    return arr;
}


#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dadaArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cell_identifier = @"cell_identifier";
    RYMyInformListTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier];
    if ( !cell ) {
        cell = [[RYMyInformListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identifier];
    }
    [cell setValueWithDict:[dadaArray objectAtIndex:indexPath.section]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
     return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


@end
