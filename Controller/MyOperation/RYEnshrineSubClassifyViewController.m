//
//  RYEnshrineSubClassifyViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYEnshrineSubClassifyViewController.h"
#import "RYEnshrineTableViewCell.h"

@interface RYEnshrineSubClassifyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView        *theTableView;
    NSArray            *dataArray;
}
@end

@implementation RYEnshrineSubClassifyViewController

- (id)initWithDataArray:(NSArray *)arr
{
    self = [super init];
    if ( self ) {
//        dataArray = arr;
        dataArray = [self setdata];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (NSArray *)setdata
{
    NSMutableArray *arr = [NSMutableArray array];
    for ( int i = 0 ; i < 2; i ++ ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *title = @"护肤品中的生长因子安全吗。护肤品中的生长因子安全吗。护肤品中的生长因子安全吗。护肤品中的生长因子安全吗。护肤品中的生长因子安全吗。";
        [dic setValue:title forKey:@"title"];
        [dic setValue:@"2015-04-23" forKey:@"time"];
        if ( i%2 == 0) {
            [dic setValue:@"护肤品成分" forKey:@"class"];
        }
        else{
            [dic setValue:@"护肤品成分护肤品成分" forKey:@"class"];
        }
        
        [arr addObject:dic];
    }
    return arr;
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
    NSString *identifier = @"cell";
    RYEnshrineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell ) {
        cell = [[RYEnshrineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ( dataArray.count ) {
        [cell setValueWithDict:[dataArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
