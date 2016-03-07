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
@property (nonatomic , strong) NSString       *authorId;

@end

@implementation RYAuthorArticleViewController

-(id)initWithAuthorID:(NSString *)authorID
{
    self = [super init];
    if ( self ) {
        self.authorId = authorID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"文章列表";
    
    [self getData];
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

- (void)getData
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
        [NetRequestAPI getAuthorArticleWithSessionId:[RYUserInfo sharedManager].session
                                                wuid:self.authorId
                                             success:^(id responseDic) {
                                                 [SVProgressHUD dismiss];
                                                 NSLog(@"文章l :%@",responseDic);
                                                 [wSelf analysisDataWithDict:responseDic];
            
        } failure:^(id errorString) {
            NSLog(@"文章errorString :%@",errorString);
            [SVProgressHUD dismiss];
            if ( self.articleLists.count == 0 ) {
                [self showErrorView:self.tableView];
            }
        }];
    }
    else{
        if ( self.articleLists.count == 0 ) {
            [self showErrorView:self.tableView];
        }
    }
}

- (void)analysisDataWithDict:(NSDictionary *)responseDic
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        if ( self.articleLists.count == 0 ) {
            [self showErrorView:self.tableView];
        }
        return;
    }
    [self removeErroeView];
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    NSArray *writertheradmessage = [info getArrayValueForKey:@"writertheradmessage" defaultValue:nil];
    if ( writertheradmessage.count ) {
        self.articleLists = writertheradmessage;
    }
    [self.tableView reloadData];
    if ( self.articleLists.count == 0 ) {
        [self showErrorView:self.tableView];
    }
}


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
    return 90;
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
    NSDictionary *articleDict = [self.articleLists objectAtIndex:indexPath.row];
    NSString *tid = [articleDict getStringValueForKey:@"tid" defaultValue:@""];
    if ( ![ShowBox isEmptyString:tid] ) {
        RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:tid];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [ShowBox showError:@"数据出错"];
    }
}


@end
