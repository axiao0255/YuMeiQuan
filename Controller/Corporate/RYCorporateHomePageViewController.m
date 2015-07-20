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
@property (nonatomic,strong) UIButton                 *bottomView;

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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView headerBeginRefreshing];
    [self.view addSubview:self.bottomView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];    
    UIViewController *vc = [self.navigationController.viewControllers lastObject];
    if ( ![vc isKindOfClass:[RYArticleViewController class]] ) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _tableView = [[MJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
- (UIView*)bottomView
{
    if (_bottomView==nil) {
        _bottomView = [[UIButton alloc] initWithFrame:CGRectMake(7, SCREEN_HEIGHT - 3 - 80 , 80, 80)];
        [_bottomView setImage:[UIImage imageNamed:@"ic_company_toTop.png"] forState:UIControlStateNormal];
        [_bottomView addTarget:self action:@selector(toTop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
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
            return 1;
        }
    }
    else{
        return self.dataModel.corporateArticles.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        return 160;
    }
    else{
        NSDictionary *dic = [self.dataModel.corporateArticles objectAtIndex:indexPath.row];
        NSString *pic = [dic getStringValueForKey:@"pic" defaultValue:@""];
        if ( ![ShowBox isEmptyString:pic] ) {
            return 90;
        }
        else{
            NSString *subject = [dic getStringValueForKey:@"subject" defaultValue:@""];
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
            CGRect rect = [subject boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil];
            return 42 + rect.size.height;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        NSString *topCell = @"topCell";
        RYCorporateHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topCell];
        if ( !cell ) {
            cell = [[RYCorporateHomePageTableViewCell alloc] initWithTopCellStyle:UITableViewCellStyleDefault reuseIdentifier:topCell];
        }
        [cell setValueWithDic:self.dataModel.corporateBody];
        
        if (self.dataModel.isAttention) {
            [cell.attentionBtn setImage:[UIImage imageNamed:@"ic_company_attent.png"] forState:UIControlStateNormal];
        }
        else{
            [cell.attentionBtn setImage:[UIImage imageNamed:@"ic_company_cancel.png"] forState:UIControlStateNormal];
        }
        [cell.attentionBtn addTarget:self action:@selector(attentionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.aboutCompanyBtn addTarget:self action:@selector(aboutCompanyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
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
    if ( indexPath.section != 0 ) {
        NSDictionary *dict = [self.dataModel.corporateArticles  objectAtIndex:indexPath.row];
        RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:[dict getStringValueForKey:@"tid" defaultValue:@""]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( section == 0 && [self.dataModel.corporateBody allKeys].count ) {
        return 40;
    }
    else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( [self.dataModel.corporateBody allKeys].count ) {
        if ( section == 0 ) {
            UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            view.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 42, 40)];
            titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.text = @"分类：";
            [view addSubview:titleLabel];
            
            UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right+5, 0, 225, 40)];
            categoryLabel.font = [UIFont boldSystemFontOfSize:16];
            categoryLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
            
            NSArray *arr = self.dataModel.categoryArray;
            NSString *title = @"全部";
            for ( NSInteger i = 0 ; i < arr.count; i ++ ) {
                NSDictionary *dict = [arr objectAtIndex:i];
                NSString *fid = [dict getStringValueForKey:@"fid" defaultValue:@""];
                if ( [self.corporateFid isEqualToString:fid] ) {
                    title = [dict getStringValueForKey:@"name" defaultValue:@""];
                    break;
                }
            }
            categoryLabel.text = title;
            [view addSubview:categoryLabel];
            
            UIImageView *arrows = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 10, 13, 10, 14)];
            arrows.image =[UIImage imageNamed:@"ic_right_arrow.png"];;
            [view addSubview:arrows];
            
            [view addTarget:self action:@selector(categorySelect:) forControlEvents:UIControlEventTouchUpInside];
            
            return view;
            
        }else{
            return nil;
        }
    }
    return nil;
}

- (void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)aboutCompanyBtnClick:(id)sender
{
    RYCorporateViewController *vc = [[RYCorporateViewController alloc] initWithCategoryData:self.dataModel];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)categorySelect:(id)sender
{
    if ( self.dataModel.categoryArray.count == 0) {
        [ShowBox showError:@"数据出错"];
        return;
    }
    RYCorporateProductCategoryViewController *vc = [[RYCorporateProductCategoryViewController alloc] initWithCategoryData:self.dataModel];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)attentionButtonClick:(id)sender
{
    if ( ![ShowBox isLogin] ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else{
        if ( [ShowBox checkCurrentNetwork] ) {
            UIButton *btn = (UIButton *)sender;
            __weak typeof(self) wSelf = self;
            if ( self.dataModel.isAttention ) {
                [NetRequestAPI delFriendactionWithSessionId:[RYUserInfo sharedManager].session
                                                     foruid:self.corporateID
                                                    success:^(id responseDic) {
                                                        
                                                        NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                                        BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                                        if ( !success ) {
                                                            [ShowBox showError:@"取消收藏失败,请稍候重试"];
                                                            return ;
                                                        }
                                                        wSelf.dataModel.isAttention = NO;
                                                        [btn setImage:[UIImage imageNamed:@"ic_company_cancel.png"] forState:UIControlStateNormal];
                                                        
                                                    } failure:^(id errorString) {
                                                        [ShowBox showError:@"取消收藏失败,请稍候重试"];
                                                    }];
            }
            else{
                [NetRequestAPI addFriendactionWithSessionId:[RYUserInfo sharedManager].session
                                                     foruid:self.corporateID
                                                    success:^(id responseDic) {
        
                                                        NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                                        BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                                        if ( !success ) {
                                                            [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"收藏失败，请稍候重试"]];
                                                            return ;
                                                        }

                                                        wSelf.dataModel.isAttention = YES;
                                                        [btn setImage:[UIImage imageNamed:@"ic_company_attent.png"] forState:UIControlStateNormal];
                                                    } failure:^(id errorString) {
                                                        NSLog(@"收藏失败 %@",errorString);
                                                        [ShowBox showError:@"收藏失败，请稍候重试"];
                                                    }];
            }
        }
    }
}

- (void)afreshData
{
    [self.tableView headerBeginRefreshing];
}

#pragma mark RYCorporateViewControllerDelegate
-(void)statesChange
{
    [self afreshData];
}

-(void)categorySelectDidWithFid:(NSString *)fid
{
    if ( ![self.corporateFid isEqualToString:fid] ) {
        self.corporateFid = fid;
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


-(void)toTop
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
