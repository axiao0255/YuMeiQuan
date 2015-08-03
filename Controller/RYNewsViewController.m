//
//  RYNewsViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/8.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYNewsViewController.h"
#import "newsBarData.h"
#import "NetManager.h"
#import "RYLoginViewController.h"
#import "RFSegmentView.h"

#import "SlideNavigationController.h"

#import "RYArticleViewController.h"
#import "RYCorporateHomePageViewController.h"
#import "RYMoviePlayerViewController.h"
#import "RYAuthorArticleViewController.h"
#import "RYLiteratureDetailsViewController.h"
#import "RYWeeklyViewController.h"

#import "RYCorporateSearchViewController.h"

#import "RYHomepage.h"
#import "RYNewsPage.h"
#import "RYHuiXun.h"
#import "RYPodcastPage.h"
#import "RYBaiJiaPage.h"
#import "RYLiteraturePage.h"
#import "RYWeeklyPage.h"

#import "RYMyInformListViewController.h"
#import "RYCorporateHomePageViewController.h"
#import "RYLiteratureCategoryViewController.h"
#import "RYQRcodeViewViewController.h"
#import "RYWebViewController.h"

@interface RYNewsViewController ()<MJScrollBarViewDelegate,MJScrollPageViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,RFSegmentViewDelegate,RYLiteratureCategoryViewControllerDelegate>
{
    MJScrollBarView    *scrollBarView;
    MJScrollPageView   *scrollPageView;
    NSInteger          currentIndex;
    newsBarData        *newsData;
    
    GridMenuView       *gridMenu; // 文献页 分类 top 三个菜单
}

@property (strong, nonatomic) NSArray          *categoryArray;

@property (strong, nonatomic) NSDictionary     *selectLiteratureDict;

@property (strong, nonatomic) RYHomepage       *homePage;
@property (strong, nonatomic) RYNewsPage       *newsPage;
@property (strong, nonatomic) RYHuiXun         *huiXun;
@property (strong, nonatomic) RYPodcastPage    *podcastPage;
@property (strong, nonatomic) RYBaiJiaPage     *baiJiaPage;
@property (strong, nonatomic) RYLiteraturePage *literaturePage;
@property (strong, nonatomic) RYWeeklyPage     *weeklyPage;

@property (assign, nonatomic) NSInteger        noticecount;
@property (assign, nonatomic) NSInteger        baiJiaCurrentSelectIndex;

@property (assign, nonatomic) CGFloat          barlastOffsetY;
@property (assign, nonatomic) NSInteger        lastTabelViewIndex;
@property (assign, nonatomic) CGFloat          scrollLastOffsetY;
@property (assign, nonatomic) BOOL             notStretch;         // 不是上下啦刷新。 用于自动登录 ， 避免试图上移引起bug

@end

@implementation RYNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self commInit];
    [self setNavigationItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:@"loginStateChange" object:nil];
    NSTimer *peakTimer = [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(updatePeak:) userInfo:nil repeats:YES];
    [peakTimer fire];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginStateChange:(NSNotification *)notice
{
     self.notStretch = YES;
    [scrollPageView removeAlldataSources];
}

- (void)setNavigationItem
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 24)];
    [leftButton setImage:[UIImage imageNamed:@"ic_home_head.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 20)];
    logoView.image = [UIImage imageNamed:@"ic_yimeiquan_logo.png"];
    self.navigationItem.titleView = logoView;
    
    //右边 二维码扫描
    UIImage *img = [UIImage imageNamed: @"erweima.png"];
    UIButton *rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width , img.size.height)];
    [rightbutton setExclusiveTouch:YES];
    [rightbutton setBackgroundImage:img forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(gotoQRcode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *qrButton = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = qrButton;
}

- (void)gotoQRcode
{
    NSLog(@"二维码");
    RYQRcodeViewViewController *vc = [[RYQRcodeViewViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updatePeak:(NSTimer *)timer
{
    NSLog(@"time");
    // 获取消息
    [self getNoticeData];
}

#pragma mark 点击滑出侧边拦
- (void)leftButtonClick:(id)sender
{
    NSLog(@"我的");
    [[SlideNavigationController sharedInstance] openMenu:MenuLeft withCompletion:^{
        NSLog(@"222");
    }];
}

#pragma mark UI初始化
-(void)commInit{
    NSArray *vButtonItemArray = @[@{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"ic_helight",
                                    TITLEKEY:@"首页",
                                    TITLEWIDTH:[NSNumber numberWithFloat:64]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"ic_helight",
                                    TITLEKEY:@"周报",
                                    TITLEWIDTH:[NSNumber numberWithFloat:64]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"ic_helight",
                                    TITLEKEY:@"新闻",
                                    TITLEWIDTH:[NSNumber numberWithFloat:64]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"ic_helight",
                                    TITLEKEY:@"会讯",
                                    TITLEWIDTH:[NSNumber numberWithFloat:64]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"ic_helight",
                                    TITLEKEY:@"文献",
                                    TITLEWIDTH:[NSNumber numberWithFloat:64]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"ic_helight",
                                    TITLEKEY:@"播客",
                                    TITLEWIDTH:[NSNumber numberWithFloat:64]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"ic_helight",
                                    TITLEKEY:@"百家",
                                    TITLEWIDTH:[NSNumber numberWithFloat:64]
                                    },
                                ];
    
    newsData = [[newsBarData alloc] init];
    newsData.dataArray = vButtonItemArray;
    self.baiJiaCurrentSelectIndex = 0;
    if ( scrollBarView == nil ) {
        scrollBarView = [[MJScrollBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55) ButtonItems:vButtonItemArray];
        scrollBarView.delegate = self;
        scrollBarView.backgroundColor = [UIColor whiteColor];
    }
    
    if ( scrollPageView == nil ) {
        scrollPageView = [[MJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        scrollPageView.delegate = self;
        [scrollBarView changeButtonStateAtIndex:currentIndex];
        [scrollPageView setContentOfTables:vButtonItemArray.count];
        
        for ( UIView *view in scrollPageView.scrollView.subviews ) {
            if ( [view isKindOfClass:[MJRefreshTableView class]] ) {
                MJRefreshTableView *tableView = (MJRefreshTableView *)view;
                tableView.delegate = self;
                tableView.dataSource = self;
                tableView.contentInset = UIEdgeInsetsMake(55, 0, 0, 0);
                NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
                if ( aIndex == 6 ) {
                    [tableView setSectionIndexColor:[Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0]];
                    tableView.tableHeaderView = [self baiJiaTableViewHeadView];
                }
            }
        }
    }
    [self.view addSubview:scrollPageView];
    [self.view addSubview:scrollBarView];
}

/**
 * 文献 top 的分类选择
 */
- (UIView *)literatureCategory
{
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
    
    // 取出上次 保存的 tagDict
    NSDictionary *saveDict = [ShowBox getLiteratureTagDict];
    if ( saveDict == nil ) {
        saveDict = [self.categoryArray lastObject];
    }
    NSString *saveTitle = [saveDict getStringValueForKey:@"tagname" defaultValue:@""];
    categoryLabel.text = saveTitle;
    [view addSubview:categoryLabel];
    
    UIImageView *arrows = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 10, 13, 10, 14)];
    arrows.image =[UIImage imageNamed:@"ic_right_arrow.png"];;
    [view addSubview:arrows];
    
    [view addTarget:self action:@selector(categorySelect:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

#pragma mark 文献分类选择
- (void)categorySelect:(id)sender
{
    RYLiteratureCategoryViewController *vc = [[RYLiteratureCategoryViewController alloc] initWithCategoryArray:self.categoryArray];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectLiteratureCategoryWithIndex:(NSInteger)index
{
    // 保存 所选择的 标签
    NSDictionary *selectDict = [self.categoryArray objectAtIndex:index];
    if ( ![self.selectLiteratureDict isEqualToDictionary:selectDict] ) {
        [ShowBox saveLiteratureTagDict:selectDict];
        MJRefreshTableView *v = [scrollPageView.contentItems objectAtIndex:4];
        [v headerBeginRefreshing];
    }
}

/**
 * 百家 top 的分段选择器
 */
-(UIView *)baiJiaTableViewHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    headView.backgroundColor = [UIColor whiteColor];
    RFSegmentView *segmentView = [[RFSegmentView alloc] initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH, 28) items:@[@"文章",@"作者"]];
    segmentView.tintColor = [Utils getRGBColor:0x00 g:0x91 b:0xea a:1.0];
    segmentView.delegate = self;
    [headView addSubview:segmentView];
    return headView;
}

- (NSArray *)categoryArray
{
    if ( _categoryArray == nil ) {
        _categoryArray = [NSArray array];
    }
    return _categoryArray;
}

- (RYHomepage *)homePage
{
    if ( !_homePage ) {
        _homePage = [[RYHomepage alloc] init];
        _homePage.viewControll = self;
    }
    return _homePage;
}

- (RYNewsPage *)newsPage
{
    if ( _newsPage == nil ) {
        _newsPage = [[RYNewsPage alloc] init];
        _newsPage.viewController = self;
    }
    return _newsPage;
}

- (RYHuiXun *)huiXun
{
    if ( _huiXun == nil ) {
        _huiXun = [[RYHuiXun alloc] init];
        _huiXun.viewController = self;
    }
    return _huiXun;
}

- (RYPodcastPage *)podcastPage
{
    if ( _podcastPage == nil ) {
        _podcastPage = [[RYPodcastPage alloc] init];
    }
    return _podcastPage;
}

- (RYBaiJiaPage *)baiJiaPage
{
    if ( _baiJiaPage == nil ) {
        _baiJiaPage = [[RYBaiJiaPage alloc] init];
    }
    return _baiJiaPage;
}

- (RYLiteraturePage *)literaturePage
{
    if ( _literaturePage == nil ) {
        _literaturePage = [[RYLiteraturePage alloc] init];
    }
    return _literaturePage;
}

- (RYWeeklyPage *)weeklyPage
{
    if ( _weeklyPage == nil ) {
        _weeklyPage = [[RYWeeklyPage alloc] init];
        _weeklyPage.viewController = self;
    }
    return _weeklyPage;
}

#pragma mark 头部tabbar 分类 选择
-(void)didMenuClickedButtonAtIndex:(NSInteger)index
{
    NSLog(@" dianji %ld",(long)index);
    if (currentIndex != index ) {
        currentIndex = index;
        [scrollPageView moveScrollowViewAthIndex:currentIndex];
    }
 }

#pragma mark 列表滚动后 设置 tabbar 的状态
- (void)currentMoveToPageAtIndex:(NSInteger)aIndex
{
    NSLog(@"滑动列表 %ld",(long)aIndex);
    if ( currentIndex != aIndex ) {
        currentIndex = aIndex;
        [scrollBarView clickButtonAtIndex:currentIndex];
        [scrollBarView changeButtonStateAtIndex:currentIndex];
    }
}

#pragma mark 获取数据

-(void)freshContentTableWithCurrentPage:(NSInteger)currentPage andTableIndex:(NSInteger)aIndex isHead:(BOOL)isHead
{
    __weak typeof(self) sSelf = self;
    RYNewsViewController *wSelf = sSelf;
    if ( aIndex == 0 ) {
        NSInteger tempIndex = aIndex;
        [NetRequestAPI getHomePageWithSessionId:[RYUserInfo sharedManager].session
                                        success:^(id responseDic) {
                                            NSLog(@"首页 responseDic： %@",responseDic);
                                            [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                            [wSelf setValueWithDict:responseDic andIndex:tempIndex isHead:isHead];
                                            
                                        } failure:^(id errorString) {
                                            //                                            NSLog(@"首页 ： %@",errorString);
                                            NSArray *arr = [scrollPageView.dataSources objectAtIndex:aIndex];
                                            if ( [arr count] == 0  ) {
                                                [wSelf showErrorView:[scrollPageView.contentItems objectAtIndex:aIndex]];
                                            }
                                            [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                        }];
    }
    else if ( aIndex == 1 ){
        NSInteger tempIndex = aIndex;
        [NetRequestAPI getPastweeklylistWithSessionId:[RYUserInfo sharedManager].session
                                                 page:currentPage
                                              success:^(id responseDic) {
                                                  NSLog(@"往期周报 responseDic : %@",responseDic);
                                                  [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                                  [wSelf setValueWithDict:responseDic andIndex:tempIndex isHead:isHead];
                                                  
                                              } failure:^(id errorString) {
//                                                  NSLog(@"往期周报 errorString : %@",errorString);
                                                  NSArray *arr = [scrollPageView.dataSources objectAtIndex:aIndex];
                                                  if ( [arr count] == 0  ) {
                                                       [wSelf showErrorView:[scrollPageView.contentItems objectAtIndex:aIndex]];
                                                  }
                                                  [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                              }];
    }
    else if ( aIndex == 2 ) {
        NSInteger tempIndex = aIndex;
        [NetRequestAPI getHomePageNewsListWithSessionId:[RYUserInfo sharedManager].session
                                                    fid:@"136"
                                                   page:currentPage
                                                success:^(id responseDic) {
                                                    NSLog(@"新闻 ：responseDic  %@",responseDic);
                                                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                                                    [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                                    [wSelf setValueWithDict:responseDic andIndex:tempIndex isHead:isHead];
                                                } failure:^(id errorString) {
                                                    NSArray *arr = [scrollPageView.dataSources objectAtIndex:aIndex];
                                                    if ( [arr count] == 0  ) {
                                                        [wSelf showErrorView:[scrollPageView.contentItems objectAtIndex:aIndex]];
                                                    }
                                                    NSLog(@"新闻 ：errorString  %@",errorString);
                                                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                                                    [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                                }];
    }
    else if ( aIndex == 3 )
    {
        NSInteger tempIndex = aIndex;
        [NetRequestAPI getHomePageNewsListWithSessionId:[RYUserInfo sharedManager].session
                                                    fid:@"142"
                                                   page:currentPage
                                                success:^(id responseDic) {
                                                    NSLog(@"会讯 ：responseDic  %@",responseDic);
                                                    [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                                    [wSelf setValueWithDict:responseDic andIndex:tempIndex isHead:isHead];
                                                    
                                                    
                                                } failure:^(id errorString) {
                                                    //            NSLog(@"会讯 ： %@",errorString);
                                                    NSArray *arr = [scrollPageView.dataSources objectAtIndex:aIndex];
                                                    if ( [arr count] == 0  ) {
                                                        [wSelf showErrorView:[scrollPageView.contentItems objectAtIndex:aIndex]];
                                                    }
                                                    [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                                }];
        
    }
    else if ( aIndex == 4 )
    {
        NSInteger tempIndex = aIndex;
        NSDictionary *tagDict = [ShowBox getLiteratureTagDict];
        NSString *tagid;
        if ( tagDict ) {
            tagid = [tagDict getStringValueForKey:@"tagid" defaultValue:@"0"];
            self.selectLiteratureDict = tagDict;
        }
        else{
            tagid = @"0";
        }
        [NetRequestAPI getHomeLiteratureListWithSessionId:[RYUserInfo sharedManager].session
                                                      fid:@"137"
                                                    tagid:tagid
                                                     page:currentPage
                                                  success:^(id responseDic) {
                                                     NSLog(@"文献 ：responseDic  %@",responseDic);
                                                      [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                                      [wSelf setValueWithDict:responseDic andIndex:tempIndex isHead:isHead];
                                                      
                                                  } failure:^(id errorString) {
                                                      //            NSLog(@"文献 ： %@",errorString);
                                                      NSArray *arr = [scrollPageView.dataSources objectAtIndex:aIndex];
                                                      if ( [arr count] == 0  ) {
                                                          [wSelf showErrorView:[scrollPageView.contentItems objectAtIndex:aIndex]];
                                                      }
                                                     [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                                  }];
    }
    else if ( aIndex == 5 )
    {
        NSInteger tempIndex = aIndex;
        [NetRequestAPI getPodcastListWithSessionId:[RYUserInfo sharedManager].session
                                             tagid:@"284"
                                              page:currentPage
                                           success:^(id responseDic) {
                                               NSLog(@"播客 ：responseDic  %@",responseDic);
                                               [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                               [wSelf setValueWithDict:responseDic andIndex:tempIndex isHead:isHead];
                                               
                                           } failure:^(id errorString) {
                                               //            NSLog(@"播客 ： %@",errorString);
                                               NSArray *arr = [scrollPageView.dataSources objectAtIndex:aIndex];
                                               if ( [arr count] == 0  ) {
                                                   [wSelf showErrorView:[scrollPageView.contentItems objectAtIndex:aIndex]];
                                               }
                                               [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                               
                                           }];
    }
    else
    {
         NSInteger tempIndex = aIndex;
        [NetRequestAPI getHomeBaijiaListWithSessionId:[RYUserInfo sharedManager].session
                                                 page:currentPage
                                              success:^(id responseDic) {
                                                  NSLog(@"百家 responseDic：%@",responseDic);
                                                  [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                                  [wSelf setValueWithDict:responseDic andIndex:tempIndex isHead:isHead];
                                                  
                                              } failure:^(id errorString) {
                                                  NSLog(@"百家 errorString：%@",errorString);
                                                  NSArray *arr = [scrollPageView.dataSources objectAtIndex:aIndex];
                                                  if ( [arr count] == 0  ) {
                                                      [wSelf showErrorView:[scrollPageView.contentItems objectAtIndex:aIndex]];
                                                  }
                                                  [wSelf tableViewRefreshEndAtTableViewIndex:tempIndex isHeadRefresh:isHead];
                                              }];
    }
}


// 获取数据之后，tableview回到原来的位置
- (void)tableViewRefreshEndAtTableViewIndex:(NSInteger)index isHeadRefresh:(BOOL)isHead
{
    if ( !self.notStretch ) { // 为 NO tableView上啦或下啦刷新，需要调此才能回到原来的位置
        [scrollPageView refreshEndAtTableViewIndex:index isHead:isHead];
    }
    else{
        // 此为 自动登录或 从登录界面登录之后调用，没用下拉刷新
        self.notStretch = NO;
    }
}

- (void)setValueWithDict:(NSDictionary *)responseDic andIndex:(NSInteger)aIndex isHead:(BOOL)isHead
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        int  login = [meta getIntValueForKey:@"login" defaultValue:0];
        if ( login == 2 ) {  // login == 2 表示用户已过期 需要重新登录
            __weak typeof(self) wSelf = self;
            [RYUserInfo automateLoginWithLoginSuccess:^(BOOL isSucceed) {
                // 自动登录一次
                if ( isSucceed ) { // 自动登录成功 刷新数据，
                    wSelf.notStretch = YES;
                    [scrollPageView removeAlldataSources];
                }
                else{// 登录失败 打开登录界面 手动登录
                    [wSelf openLoginVC];
                }
            } failure:^(id errorString) {
                [wSelf openLoginVC];
            }];
            return;
        }
        else{
            NSArray *arr = [scrollPageView.dataSources objectAtIndex:aIndex];
            if ( [arr count] == 0  ) {
                [self showErrorView:[scrollPageView.contentItems objectAtIndex:aIndex]];
            }
            return;
        }
    }
    
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    if ( !info ) {
        NSArray *arr = [scrollPageView.dataSources objectAtIndex:aIndex];
        if ( [arr count] == 0  ) {
            [self showErrorView:[scrollPageView.contentItems objectAtIndex:aIndex]];
        }
        return;
    }
    [self removeErroeView];
    // 刷新 userinfo的数据 
    NSDictionary *usermassage = [info getDicValueForKey:@"usermassage" defaultValue:nil];
    if ( usermassage ) {
        [[RYUserInfo sharedManager] refreshUserInfoDataWithDict:usermassage];
    }
    
    // 通知条数
    NSDictionary *noticemessage = [info getDicValueForKey:@"noticemessage" defaultValue:nil];
    if ( noticemessage ) {
        self.noticecount = [noticemessage getIntValueForKey:@"noticecount" defaultValue:0];
    }
    
    if ( aIndex == 0 ) { // 首页
        [[scrollPageView.dataSources objectAtIndex:aIndex] removeAllObjects];
        [[scrollPageView.dataSources objectAtIndex:aIndex] addObject:info];
        // 设置总页数
       [scrollPageView setTotlePageWithNum:1 atIndex:aIndex];
        // 刷新表格
        [[scrollPageView.contentItems objectAtIndex:aIndex] reloadData];
        // 获取消息
        [self getNoticeData];
    }
    else{
        // 取周报
        if ( aIndex == 1 ) {
            NSArray *weeklylistmessage = [info getArrayValueForKey:@"weeklylistmessage" defaultValue:nil];
            if ( weeklylistmessage.count ) {
                if ( isHead ) { // 下拉刷新 头部 ， 需要清空数组
                    [[scrollPageView.dataSources objectAtIndex:aIndex] removeAllObjects];
                }
                [[scrollPageView.dataSources objectAtIndex:aIndex] addObjectsFromArray:weeklylistmessage];
            }
        }
        // 取新闻
        if ( aIndex == 2 ) {
            // 取广告
            NSDictionary *admessage = [info getDicValueForKey:@"advmessage" defaultValue:nil];
            self.newsPage.adverData = admessage;
            // 取列表
            NSArray *dataArray = [info getArrayValueForKey:@"threadmessage" defaultValue:nil];
            if ( dataArray.count ) {
                if ( isHead ) { // 下拉刷新 头部 ， 需要清空数组
                    [[scrollPageView.dataSources objectAtIndex:aIndex] removeAllObjects];
                }
                [[scrollPageView.dataSources objectAtIndex:aIndex] addObjectsFromArray:dataArray];
            }
        }
        // 取会讯
        if ( aIndex == 3 ) {
            // 取列表
            NSArray *dataArray = [info getArrayValueForKey:@"threadmessage" defaultValue:nil];
            if ( dataArray.count ) {
                if ( isHead ) { // 下拉刷新 头部 ， 需要清空数组
                    [[scrollPageView.dataSources objectAtIndex:aIndex] removeAllObjects];
                }
                [[scrollPageView.dataSources objectAtIndex:aIndex] addObjectsFromArray:dataArray];
            }
        }
        // 文献
        if ( aIndex == 4 ) {
            // 取广告
            NSDictionary *admessage = [info getDicValueForKey:@"advmessage" defaultValue:nil];
            self.literaturePage.adverData = admessage;
            
            // 取tag array
            NSArray *tagArray = [info getArrayValueForKey:@"tagmessage" defaultValue:nil];
            if ( tagArray.count ) {
                self.categoryArray = tagArray;
            }
            
            // 此处添加 view 是为了 获得数据 才创建试图
            UIView *view = [scrollPageView.scrollView viewWithTag:9999];
            [view removeFromSuperview];
            view = [self literatureCategory];
            view.tag = 9999;            
            MJRefreshTableView *tableView = (MJRefreshTableView *)[scrollPageView.contentItems objectAtIndex:aIndex];
            tableView.tableHeaderView = view;
            
            // 取列表
            NSArray *dataArray = [info getArrayValueForKey:@"threadmessage" defaultValue:nil];
            if ( dataArray.count ) {
                if ( isHead ) { // 下拉刷新 头部 ， 需要清空数组
                    [[scrollPageView.dataSources objectAtIndex:aIndex] removeAllObjects];
                }
                [[scrollPageView.dataSources objectAtIndex:aIndex] addObjectsFromArray:dataArray];
            }
        }
        // 取播客
        if ( aIndex == 5 ) {
            // 取列表
            NSArray *dataArray = [info getArrayValueForKey:@"threadmessage" defaultValue:nil];
            if ( dataArray.count ) {
                if ( isHead ) { // 下拉刷新 头部 ， 需要清空数组
                    [[scrollPageView.dataSources objectAtIndex:aIndex] removeAllObjects];
                }
                [[scrollPageView.dataSources objectAtIndex:aIndex] addObjectsFromArray:dataArray];
            }
        }
        // 取百家
        if ( aIndex == 6 ){
            // 取作者
            NSArray *authorList = [info getArrayValueForKey:@"writerlistmessage" defaultValue:nil];
            if ( authorList.count ) {
                self.baiJiaPage.authorList = [Utils findSameKeyWithArray:authorList];
            }
            
            // 取列表
            NSArray *dataArray = [info getArrayValueForKey:@"artfromwritermessage" defaultValue:nil];
            if ( dataArray.count ) {
                if ( isHead ) { // 下拉刷新 头部 ， 需要清空数组
                    [[scrollPageView.dataSources objectAtIndex:aIndex] removeAllObjects];
                }
                [[scrollPageView.dataSources objectAtIndex:aIndex] addObjectsFromArray:dataArray];
            }
        }
        
        // 设置 总共多少 页
        NSInteger totalPage = [info getIntValueForKey:@"total" defaultValue:1];
        [scrollPageView setTotlePageWithNum:totalPage atIndex:aIndex];
        // 刷新表格
        [[scrollPageView.contentItems objectAtIndex:aIndex] reloadData];
    }
}

- (void)getNoticeData
{
    __weak typeof(self) wSelf = self;
    [NetRequestAPI getMyNoticeHomePageListWithSessionId:[RYUserInfo sharedManager].session
                                                success:^(id responseDic) {
                                                    NSLog(@"responseDic 通知 ：%@",responseDic);
                                                    [wSelf analysisNoticeDataWithDict:responseDic];
                                                    
                                                } failure:^(id errorString) {
                                                    NSLog(@"errorString 通知 ：%@",errorString);
                                                }];
}

-(void)analysisNoticeDataWithDict:(NSDictionary *)responseDic
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        return;
    }
    
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    if ( info == nil ) {
        return;
    }
    // 取系统消息
    NSArray *noticesystemmessage = [info getArrayValueForKey:@"noticesystemmessage" defaultValue:nil];
    self.homePage.noticesystemmessage = noticesystemmessage;
    // 取有奖活动
    NSArray *noticespreadmessage = [info getArrayValueForKey:@"noticespreadmessage" defaultValue:nil];
    self.homePage.noticespreadmessage = noticespreadmessage;
    
    // 取 公司通知列表
    NSArray  *noticethreadmessage = [info getArrayValueForKey:@"noticethreadmessage" defaultValue:nil];
    self.homePage.noticethreadmessage = noticethreadmessage;
    [[scrollPageView.contentItems objectAtIndex:0] reloadData];
}

#pragma mark  UITableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 0 ) {
        self.homePage.listData = [scrollPageView.dataSources objectAtIndex:aIndex];
        return [self.homePage homepageNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 1 ){
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.weeklyPage.listData = [scrollPageView.dataSources objectAtIndex:aIndex];
        return [self.weeklyPage weeklyPageNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 2 ) {
        self.newsPage.listData = [scrollPageView.dataSources objectAtIndex:aIndex];
        return [self.newsPage newsNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 3 ){
        self.huiXun.listData = [scrollPageView.dataSources objectAtIndex:aIndex];
        return [self.huiXun huiXunNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 4 ){
        self.literaturePage.listData = [scrollPageView.dataSources objectAtIndex:aIndex];
        return [self.literaturePage literatureNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 5 ){
        self.podcastPage.listData = [scrollPageView.dataSources objectAtIndex:aIndex];
        return  [self.podcastPage podcastNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 6 ){
        self.baiJiaPage.listData = [scrollPageView.dataSources objectAtIndex:aIndex];
        return [self.baiJiaPage baiJiaNumberOfSectionsInTableView:tableView];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 0 ) {
        return [self.homePage homepageTableView:tableView numberOfRowsInSection:section];
    }
    else if ( aIndex == 1 ){
        return [self.weeklyPage weeklyPageTableView:tableView numberOfRowsInSection:section];
    }
    else if ( aIndex == 2 ) {
        return [self.newsPage newsTableView:tableView numberOfRowsInSection:section];
    }
    else if ( aIndex == 3 ){
        return [self.huiXun huiXunTableView:tableView numberOfRowsInSection:section];
    }
    else if ( aIndex == 4 ){
        return [self.literaturePage literatureTableView:tableView numberOfRowsInSection:section];
    }
    else if ( aIndex == 5 ){
        return [self.podcastPage podcastTableView:tableView numberOfRowsInSection:section];
    }
    else {
        return [self.baiJiaPage baiJiaTableView:tableView numberOfRowsInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 0 ) {
        return [self.homePage homepageTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 1 ){
        return [self.weeklyPage weeklyPageTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 2 ) {
        return [self.newsPage newsTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 3 ){
        return [self.huiXun huiXunTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 4 ){
        return [self.literaturePage literatureTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 5 ){
        return [self.podcastPage podcastTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else{
        return [self.baiJiaPage baiJiaTableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 0 ) {
        return [self.homePage homepageTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 1 ){
        return [self.weeklyPage weeklyPageTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 2 ) {
        return [self.newsPage newsTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 3 ){
        return [self.huiXun huiXunTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 4 ){
        return [self.literaturePage literatureTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 5 ){
        return [self.podcastPage podcastTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else {
        return [self.baiJiaPage baiJiaTableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 0 ) {
        [self.homePage homepageTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 1 ) {
        [self.weeklyPage weeklyPageTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 2 ) {
        [self.newsPage newsTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 3 ) {
        [self.huiXun huiXunPageTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 5 ) { // 播客点击，进入播放
        [self podcastTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 6 ){
        [self baiJiaTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 4 ){
        if ( indexPath.section == 0 ) {
            // 广告点击
            NSString *type = [self.literaturePage.adverData getStringValueForKey:@"type" defaultValue:@""];
            NSString *content = [self.literaturePage.adverData getStringValueForKey:@"content" defaultValue:@""];
            if ( [type isEqualToString:@"url"] ) {
                // 网页打开
                RYWebViewController *vc = [[RYWebViewController alloc] initWithUrl:content];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ( [type isEqualToString:@"137"] ){
                // 进入文献
                RYLiteratureDetailsViewController *vc = [[RYLiteratureDetailsViewController alloc] initWithTid:content];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ( [type isEqualToString:@"136"] ){
                // 进入文章
                RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:content];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ( [type isEqualToString:@"company"] ){
                // 进入企业微主页
                RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] initWithCorporateID:content];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else{
            NSDictionary *dict = [self.literaturePage.listData objectAtIndex:indexPath.row];
            RYLiteratureDetailsViewController *vc = [[RYLiteratureDetailsViewController alloc] initWithTid:[dict getStringValueForKey:@"tid" defaultValue:@""]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 0 ) {
        return [self.homePage homepageTableView:tableView heightForFooterInSection:section];
    }
    else if ( aIndex == 1 ){
        return [self.weeklyPage weeklyPageTableView:tableView heightForFooterInSection:section];
    }
    else if ( aIndex == 2 ) {
        return [self.newsPage newsTableView:tableView heightForFooterInSection:section];
    }
    else if ( aIndex == 4 ){
        return [self.literaturePage literatureTableView:tableView heightForFooterInSection:section];
    }
    else if ( aIndex == 5 ){
        return [self.podcastPage podcastTableView:tableView heightForFooterInSection:section];
    }
    else if ( aIndex == 6 ){
        return [self.baiJiaPage baiJiaTableView:tableView heightForFooterInSection:section];
    }
    else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 0 ) {
        return [self.homePage homepageTableView:tableView heightForHeaderInSection:section];
    }
    else if ( aIndex == 1 ){
        return [self.weeklyPage weeklyPageTableView:tableView heightForHeaderInSection:section];
    }
    else if ( aIndex == 2 ) {
        return [self.newsPage newsTableView:tableView heightForHeaderInSection:section];
    }
    else if ( aIndex == 4 ){
        return [self.literaturePage literatureTableView:tableView heightForHeaderInSection:section];
    }
    else if ( aIndex == 5 ){
        return [self.podcastPage podcastTableView:tableView heightForHeaderInSection:section];
    }
    else if ( aIndex == 6 ){
        return [self.baiJiaPage baiJiaTableView:tableView heightForHeaderInSection:section];
    }
    else{
        return 0;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 0 ) {
        return [self.homePage homepageTableView:tableView viewForHeaderInSection:section];
    }
    else if ( aIndex == 1 ){
        return [self.weeklyPage weeklyPageTableView:tableView viewForHeaderInSection:section];
    }
    else if ( aIndex == 6 ) {
        return [self.baiJiaPage baiJiaTableView:tableView viewForHeaderInSection:section];
    }
    else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 0 ) {
        return [self.homePage homepageTableView:tableView viewForFooterInSection:section];
    }
    else if ( aIndex == 1 ){
        return [self.weeklyPage weeklyPageTableView:tableView viewForFooterInSection:section];
    }
    else if ( aIndex ==6 ){
        return [self.baiJiaPage baiJiaTableView:tableView viewForFooterInSection:section];
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 6 ) {
        return [self.baiJiaPage baiJiaSectionIndexTitlesForTableView:tableView];
    }
    else{
        return nil;
    }
}

// 右边选择拦 点击选择
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 6 ) {
        return [self.baiJiaPage baiJiaTableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
    else {
        return 0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollPageView scrollViewDidScroll:scrollView];
}

- (void)scrollPageViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    offsetY += 55;
    if ( [scrollView isKindOfClass:[MJRefreshTableView class]] ) {
        NSInteger index = [scrollPageView.contentItems indexOfObject:scrollView];
        if ( index != self.lastTabelViewIndex ) {
            self.barlastOffsetY = 0;
            self.lastTabelViewIndex = index;
            self.scrollLastOffsetY = 0;
        }
        
        if ( index == 6 && self.baiJiaCurrentSelectIndex == 1 ) {
            [UIView animateWithDuration:0.25 animations:^{
                scrollBarView.frame = CGRectMake(0, 0, scrollBarView.frame.size.width, scrollBarView.frame.size.height);
            } completion:^(BOOL finished) {
                self.barlastOffsetY = offsetY;
            }];
            
            return;
        }
        
        if ( self.scrollLastOffsetY - offsetY < 0 ) {
            self.scrollLastOffsetY = offsetY;
            self.barlastOffsetY = offsetY;
            if ( offsetY >= 0 ) {
                if ( offsetY >= 55 ) {
                    offsetY = 55;
                }
                scrollBarView.frame = CGRectMake(0, offsetY >= 55 ? - 55: - offsetY, scrollBarView.frame.size.width, scrollBarView.frame.size.height);
            }
            else{
                [UIView animateWithDuration:0.25 animations:^{
                    scrollBarView.frame = CGRectMake(0, 0, scrollBarView.frame.size.width, scrollBarView.frame.size.height);
                } completion:^(BOOL finished) {
                    
                }];
                
            }
        }
        else{
            self.scrollLastOffsetY = offsetY;
            if (  self.barlastOffsetY - offsetY  > 20 ) {
                [UIView animateWithDuration:0.25 animations:^{
                    scrollBarView.frame = CGRectMake(0, 0, scrollBarView.frame.size.width, scrollBarView.frame.size.height);
                } completion:^(BOOL finished) {
                    self.barlastOffsetY = offsetY;
                }];
            }
        }

    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            scrollBarView.frame = CGRectMake(0, 0, scrollBarView.frame.size.width, scrollBarView.frame.size.height);
        } completion:^(BOOL finished) {
            self.barlastOffsetY = 0;
        }];
    }
}

#pragma mark - 百家cell的点击方法
- (void)baiJiaTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.baiJiaPage.currentType == articleType ) {
        NSDictionary *dict = [self.baiJiaPage.listData objectAtIndex:indexPath.row];
        RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:[dict getStringValueForKey:@"tid" defaultValue:@""]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        NSArray *authorList = [self.baiJiaPage.authorList objectAtIndex:indexPath.section];
        NSDictionary *authorDict = [authorList objectAtIndex:indexPath.row];
        
        NSString *authorID = [authorDict getStringValueForKey:@"uid" defaultValue:@""];
        if ( ![ShowBox isEmptyString:authorID] ) {
            RYAuthorArticleViewController *vc = [[RYAuthorArticleViewController alloc] initWithAuthorID:authorID];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - 播客点击播放视频
- (void)podcastTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dic = [self.podcastPage.listData objectAtIndex:indexPath.section];
//    NSURL *movieURL = [NSURL URLWithString:[dic objectForKey:@"movier"]];
//    RYMoviePlayerViewController *playerViewController = [[RYMoviePlayerViewController alloc] initWithContentURL:movieURL];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:[playerViewController moviePlayer]];
//    
//    playerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [self presentViewController:playerViewController animated:YES completion:^{
//        MPMoviePlayerController *player = [playerViewController moviePlayer];
//        [player play];
//    }];
    NSDictionary *dic = [self.podcastPage.listData objectAtIndex:indexPath.section];
    NSString *fid = [dic getStringValueForKey:@"fid" defaultValue:@""];
    if ( [fid isEqualToString:@"137"] ) { // 属于文献
        RYLiteratureDetailsViewController *vc = [[RYLiteratureDetailsViewController alloc] initWithTid:[dic getStringValueForKey:@"tid" defaultValue:@""]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:[dic getStringValueForKey:@"tid" defaultValue:@""]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//- (void) playVideoFinished:(NSNotification *)theNotification//当点击Done按键或者播放完毕时调用此函数
//{
//    MPMoviePlayerController *player = [theNotification object];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
//    [player stop];
//    //    [playerViewController dismissModalViewControllerAnimated:YES];
//}

#pragma mark    滑出侧边拦，需要实现该代理方法
-(BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
   return YES;
}

#pragma mark MJScrollPageView 手势代理
// ---------------- 为了解决 滚动出侧边拦的手势冲突 begin——————————————————————
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    [[SlideNavigationController sharedInstance]panDetected:gesture];
}
// ---------------- 为了解决 滚动出侧边拦的手势冲突 end——————————————————————

#pragma mark - RFSegmentView delegate  百家 文章和作者切换
- (void)segmentViewSelectIndex:(NSInteger)index
{
    if ( self.baiJiaCurrentSelectIndex != index ) {
        self.baiJiaCurrentSelectIndex = index;
        self.baiJiaPage.currentType = self.baiJiaCurrentSelectIndex;
        MJRefreshTableView *tableView = [scrollPageView.contentItems objectAtIndex:6];
        [tableView reloadData];
    }
}

#pragma mark 收到云推送后的处理
-(void)receivePushNoticeWithUserinfo:(NSDictionary *)userInfo
{
    NSString *noticeType = [userInfo getStringValueForKey:@"type" defaultValue:@""];
    if ( [noticeType isEqualToString:@"system"] ) {
        RYMyInformListViewController *vc = [[RYMyInformListViewController alloc] initWithInfomType:InformSystem];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( [noticeType isEqualToString:@"literature"] ){
        NSString *tid = [userInfo getStringValueForKey:@"id" defaultValue:@""];
        RYLiteratureDetailsViewController *vc = [[RYLiteratureDetailsViewController alloc] initWithTid:tid];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( [noticeType isEqualToString:@"article"] ){
        NSString *tid = [userInfo getStringValueForKey:@"id" defaultValue:@""];
        RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:tid];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( [noticeType isEqualToString:@"company"] ){
        NSString *companyId = [userInfo getStringValueForKey:@"id" defaultValue:@""];
        RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] initWithCorporateID:companyId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma  mark 如果自动登录不上则 需要打开登录界面手动登录
-(void)openLoginVC
{
    RYLoginViewController *nextVC = [[RYLoginViewController alloc] initWithFinishBlock:^(BOOL isLogin, NSError *error) {
        if ( isLogin ) {
            NSLog(@"登录完成"); // 重新获取数据  由于本ViewController中有注册通知，登录成功后通知能重新刷新数据，所有在此不做任何操作
        }
    }];
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
