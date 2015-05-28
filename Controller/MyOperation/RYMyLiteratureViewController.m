//
//  RYMyLiteratureViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/6.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyLiteratureViewController.h"
#import "RYMyLiteratureTableViewCell.h"
#import "RYLiteratureQueryViewController.h"


@interface RYMyLiteratureViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (strong , nonatomic) UITableView    *tableView;
@property (strong , nonatomic) UISearchBar    *searchBar;
@property (strong , nonatomic) UILabel        *hintLabel;     // 每次消耗多少积分 提示

@property (strong , nonatomic) NSArray        *dataArray;

@end

@implementation RYMyLiteratureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"文献查询";
    self.dataArray = [self setdata];
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

- (NSArray *)setdata
{
    NSMutableArray *arr = [NSMutableArray array];
    for ( NSUInteger i = 0 ; i < 10; i ++ ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *title = @"移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，移动互联网的革命性的创新，";
        [dic setValue:title forKey:@"title"];
        [dic setValue:@"2015-04-23" forKey:@"time"];
        
        BOOL state = NO;
        if (i%2 == 0) {
            state = YES;
        }
        [dic setObject:[NSNumber numberWithBool:state] forKey:@"state"];
        
        [arr addObject:dic];
    }
    return arr;
}


- (void) setup
{
    [self.view addSubview:self.tableView];
//    self.tableView.tableHeaderView = [self tableViewHeadView];
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

- (UIView *)tableViewHeadView
{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 105)];
    view.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
    
    UIView *searchBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    searchBG.backgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
    [view addSubview:searchBG];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 4, SCREEN_WIDTH - 20, 28)];
    searchBar.layer.cornerRadius = 5.0f;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = @"请输入需要查询的DOI";
    searchBar.delegate = self;
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.font = [UIFont systemFontOfSize:12];
    searchBar.backgroundImage = [UIImage new];
    self.searchBar = searchBar;
    [searchBG addSubview:searchBar];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, searchBG.bottom + 8, SCREEN_WIDTH - 30, 10)];
    hintLabel.font = [UIFont systemFontOfSize:10];
    hintLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
    hintLabel.text = @"每次查询需要使用100积分";
    self.hintLabel = hintLabel;
    [view addSubview:hintLabel];
    
    UIButton *submitBtn = [Utils getCustomLongButton:@"申请查询"];
    submitBtn.frame = CGRectMake(40, hintLabel.bottom + 8, SCREEN_WIDTH - 80, 35);
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 104.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0];
    [view addSubview:line];
    
    UILabel *history = [[UILabel alloc] initWithFrame:CGRectMake(15, line.bottom + 8, SCREEN_WIDTH - 30, 10)];
    history.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
    history.text = @"查询列表";
    history.font = [UIFont systemFontOfSize:10];
    [view addSubview:history];
    
    return view;
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"申请查询");
}

#pragma mark -UISearchBar 代理方法
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.text = @"";
    UITextField *searchBarTextField = nil;
    if([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        for (UIView *subView in searchBar.subviews){
            for (UIView *ndLeveSubView in subView.subviews){
                if ([ndLeveSubView isKindOfClass:[UITextField class]]){
                    searchBarTextField = (UITextField *)ndLeveSubView;
                    break;
                }
            }
        }
    }else{
        for (UIView *subView in searchBar.subviews){
            if ([subView isKindOfClass:[UITextField class]]){
                searchBarTextField = (UITextField *)subView;
                break;
            }
        }
    }
    searchBarTextField.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
    searchBarTextField.enablesReturnKeyAutomatically = NO;
    searchBarTextField.returnKeyType = UIReturnKeyDone;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *query_cell = @"query_cell";
    RYMyLiteratureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:query_cell];
    if ( !cell ) {
        cell = [[RYMyLiteratureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:query_cell];
    }
    if ( self.dataArray.count ) {
        [cell setValueWithDict:[self.dataArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RYLiteratureQueryViewController *vc = [[RYLiteratureQueryViewController alloc] initWithLiteratureDict:[self.dataArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 26 + 105;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self tableViewHeadView];
}

@end
