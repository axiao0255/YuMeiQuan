//
//  RYMyEnshrineViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyEnshrineViewController.h"
#import "RYEnshrineTableViewCell.h"
#import "RYEnshrineClassifyViewController.h"

@interface RYMyEnshrineViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITableView         *theTableView;
    NSMutableArray      *dataArray;
}
@end

@implementation RYMyEnshrineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    dataArray = [[self setdata] mutableCopy];
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
    for ( int i = 0 ; i < 5; i ++ ) {
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
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

// head 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    headView.backgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 4, 260, 28)];
    searchBar.layer.cornerRadius = 5.0f;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = @"搜索收藏";
    searchBar.delegate = self;
    searchBar.backgroundImage = [UIImage new];
    [headView addSubview:searchBar];
    
    UIImage *selectImg = [UIImage imageNamed:@"icon_select.png"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - selectImg.size.width, 0, selectImg.size.width, 35)];
    btn.backgroundColor = [UIColor clearColor];
    [btn setBackgroundImage:selectImg forState:UIControlStateNormal];
    [btn setAdjustsImageWhenHighlighted:NO];
    [btn addTarget:self action:@selector(goToClassify) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:btn];
    
    return headView;
}

#pragma mark - 进入分类界面
- (void)goToClassify
{
    NSLog(@"分类");
    RYEnshrineClassifyViewController *vc = [[RYEnshrineClassifyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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





@end
