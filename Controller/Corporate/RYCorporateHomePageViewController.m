//
//  RYCorporateHomePageViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/12.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYCorporateHomePageViewController.h"
#import "RYCorporateHomePageTableViewCell.h"
#import "RYCorporateHomePageData.h"
#import "RYCorporateViewController.h"
#import "RYCorporateProductCategoryViewController.h"
#import "MJRefreshTableView.h"
#import "RYArticleViewController.h"


@interface RYCorporateHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate,RYCorporateProductCategoryViewControllerDelegate,UIAlertViewDelegate,RYCorporateViewControllerDelegate>

@property (nonatomic,strong) MJRefreshTableView       *tableView;

@property (nonatomic,strong) RYCorporateHomePageData  *dataModel;

@property (nonatomic,strong) NSString                 *corporateID;      // 直达号id
@property (nonatomic,strong) NSString                 *corporateFid;     // 类别 id

@end

@implementation RYCorporateHomePageViewController

- (id)initWithCorporateID:(NSString *)corporateID
{
    self = [super init];
    if ( self ) {
        self.corporateID = corporateID;
    }
   
//    self.corporateFid = @"0";
//    self.totlePage = 1;
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItem];
    [self.view addSubview:self.tableView];
    [self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setNavigationItem
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 18)];
    [rightBtn setImage:[UIImage imageNamed:@"ic_default_select.png"] forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)getDataWithIsHeaderReresh:(BOOL)isHeaderReresh andCurrentPage:(NSInteger)currentPage
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getCompanyHomePageWithSessionId:[RYUserInfo sharedManager].session
                                                  cuid:self.corporateID
                                                   fid:self.corporateFid
                                                  page:currentPage
                                               success:^(id responseDic) {
                                                   NSLog(@"企业主页 ： responseDic ：%@",responseDic);
                                                   [wSelf.tableView endRefreshing];
                                                   [wSelf analysisDataWithDict:responseDic isHeadRersh:isHeaderReresh];
                                                   
                                               } failure:^(id errorString) {
                                                   NSLog(@"企业主页 ： errorString ：%@",errorString);
                                                   [wSelf.tableView endRefreshing];
                                                   if ( wSelf.dataModel.corporateArticles.count == 0 ) {
                                                       [ShowBox showError:@"数据出错"];
                                                   }

                                               }];
    }
}

- (void)analysisDataWithDict:(NSDictionary *)responseDic isHeadRersh:(BOOL)isHead
{
    if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
        [ShowBox showError:@"数据出错，请稍候重试"];
        return;
    }
    
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    if ( meta == nil ) {
        [ShowBox showError:@"数据出错，请稍候重试"];
        return;
    }
    
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"数据出错，请稍候重试"]];
        return;
    }
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    if ( info == nil ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"数据出错，请稍候重试"]];
        return;
    }
    
    self.tableView.totlePage = [info getIntValueForKey:@"total" defaultValue:1];
    
    // 文章分类
    self.dataModel.categoryArray = [info getArrayValueForKey:@"fidmessage" defaultValue:nil];
    
    // 是否关注
    NSDictionary *friendmessage = [info getDicValueForKey:@"friendmessage" defaultValue:nil];
    self.dataModel.isAttention = [friendmessage getBoolValueForKey:@"friend" defaultValue:NO];
    
    // 取公司 名称等数据
    self.dataModel.corporateBody = [info getDicValueForKey:@"companymessage" defaultValue:nil];
    
    // 取文章列表
    NSArray *articles = [info getArrayValueForKey:@"threadmessage" defaultValue:nil];
    if ( articles.count ) {
        if ( isHead ) {
            [self.dataModel.corporateArticles removeAllObjects];
        }
        [self.dataModel.corporateArticles addObjectsFromArray:articles];
    }
    [self.tableView reloadData];

}

-(MJRefreshTableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[MJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delegateRefersh = self;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

- (RYCorporateHomePageData *)dataModel
{
    if ( _dataModel == nil ) {
        _dataModel = [[RYCorporateHomePageData alloc] init];
    }
    return _dataModel;
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        if ( self.dataModel.corporateBody == nil || [self.dataModel.corporateBody allKeys].count == 0 ) {
            return 0;
        }
        else{
            if (self.dataModel.isAttention) {
                return 1;
            }
            else{
                return 2;
            }
        }
    }
    else{
        return self.dataModel.corporateArticles.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            NSString *titleStr = [self.dataModel.corporateBody getStringValueForKey:@"username" defaultValue:@""];
            CGSize size = [titleStr sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(170, 39)];
            return  size.height + 48;
        }
        else{
            return 56;
        }
    }
    else{
        return 75;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            NSString *topCell = @"topCell";
            RYCorporateHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topCell];
            if ( !cell ) {
                cell = [[RYCorporateHomePageTableViewCell alloc] initWithTopCellStyle:UITableViewCellStyleDefault reuseIdentifier:topCell];
            }
            [cell setValueWithDic:self.dataModel.corporateBody];
            return cell;
        }
        else{
            NSString *attention = @"attention";
            RYCorporateAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attention];
            if ( !cell ) {
                cell = [[RYCorporateAttentionTableViewCell alloc] initWithAttentionStyle:UITableViewCellStyleDefault reuseIdentifier:attention];
            }
            [cell.attentionButton addTarget:self action:@selector(attentionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
    else{
        NSString *publishedArticles = @"PublishedArticles";
        RYCorporatePublishedArticlesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:publishedArticles];
        if ( !cell ) {
            cell = [[RYCorporatePublishedArticlesTableViewCell alloc] initWithPublishedArticlesStyle:UITableViewCellStyleDefault reuseIdentifier:publishedArticles];
        }
        [cell setValueWithPublishedArticlesDic:[self.dataModel.corporateArticles objectAtIndex:indexPath.row]];
        return cell;
     }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            RYCorporateViewController *vc = [[RYCorporateViewController alloc] initWithCategoryData:self.dataModel];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else{
        NSDictionary *dict = [self.dataModel.corporateArticles  objectAtIndex:indexPath.row];
        RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:[dict getStringValueForKey:@"tid" defaultValue:@""]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 8;
    }
    else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


- (void)attentionButtonClick:(id)sender
{
    if ( ![ShowBox isLogin] ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else{
        
        if ( [ShowBox checkCurrentNetwork] ) {
            __weak typeof(self) wSelf = self;
            [NetRequestAPI addFriendactionWithSessionId:[RYUserInfo sharedManager].session
                                                 foruid:self.corporateID
                                                success:^(id responseDic) {
                                                    NSLog(@"收藏 : responseDic : %@",responseDic);
                                                    if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
                                                        [ShowBox showError:@"收藏失败，请稍候重试"];
                                                        return ;
                                                    }
                                                    
                                                    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                                    if (meta == nil) {
                                                        [ShowBox showError:@"收藏失败，请稍候重试"];
                                                        return ;
                                                    }
                                                    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                                    if ( !success ) {
                                                        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"收藏失败，请稍候重试"]];
                                                        return ;
                                                    }
                                                   
                                                   wSelf.dataModel.isAttention = YES;
                                                   [wSelf.tableView beginUpdates];
                                                   [wSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                   [wSelf.tableView endUpdates];

                                                   [wSelf afreshData];
            } failure:^(id errorString) {
                NSLog(@"收藏失败 %@",errorString);
                [ShowBox showError:@"收藏失败，请稍候重试"];
            }];
        }
        
    }
}

- (void)afreshData
{
//    self.dataModel = nil;
    [self.tableView headerBeginRefreshing];
}

#pragma mark RYCorporateViewControllerDelegate
-(void)statesChange
{
    [self afreshData];
}



- (void)rightBtnClick:(id)sender
{
    if ( self.dataModel.categoryArray.count == 0) {
        [ShowBox showError:@"数据出错"];
        return;
    }
    RYCorporateProductCategoryViewController *vc = [[RYCorporateProductCategoryViewController alloc] initWithCategoryData:self.dataModel];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)categorySelectDidWithFid:(NSString *)fid
{
    if ( ![self.corporateFid isEqualToString:fid] ) {
        self.corporateFid = fid;
//        self.dataModel = nil;
        [self.tableView headerBeginRefreshing];
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        RYLoginViewController *nextVC = [[RYLoginViewController alloc] initWithFinishBlock:^(BOOL isLogin, NSError *error) {
            if ( isLogin ) {
                NSLog(@"登录完成");
            }
        }];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
}


@end
