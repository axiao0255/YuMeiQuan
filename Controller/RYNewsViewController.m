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

#import "RYLiteratureCategoryView.h"

#import "RYMyInformListViewController.h"
#import "RYCorporateHomePageViewController.h"


/**
 *  随机数据
 */
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]


@interface RYNewsViewController ()<MJScrollBarViewDelegate,MJScrollPageViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,RFSegmentViewDelegate,GridMenuViewDelegate,RYLiteratureCategoryViewDelegate,UISearchBarDelegate,UINavigationControllerDelegate>
{
    MJScrollBarView    *scrollBarView;
    MJScrollPageView   *scrollPageView;
    NSInteger          currentIndex;
    newsBarData        *newsData;
    
    GridMenuView       *gridMenu; // 文献页 分类 top 三个菜单
}

@property (strong, nonatomic) NSMutableArray   *fakeData;
@property (strong, nonatomic) NSArray          *categoryArray;

@property (strong, nonatomic) UIButton         *selectCategoryBtn;
@property (strong, nonatomic) UIView           *categoryGridView;
@property (strong, nonatomic) UISearchBar      *searchBar;
@property (strong, nonatomic) UILabel          *weeklyLabel;

@property (strong, nonatomic) NSDictionary     *selectLiteratureDict;

@property (strong, nonatomic) RYHomepage       *homePage;
@property (strong, nonatomic) RYNewsPage       *newsPage;
@property (strong, nonatomic) RYHuiXun         *huiXun;
@property (strong, nonatomic) RYPodcastPage    *podcastPage;
@property (strong, nonatomic) RYBaiJiaPage     *baiJiaPage;
@property (strong, nonatomic) RYLiteraturePage *literaturePage;

@property (strong, nonatomic) UILabel          *noticeLabel;
@property (assign, nonatomic) NSInteger        noticecount;
@property (assign, nonatomic) NSInteger        baiJiaCurrentSelectIndex;


@property (strong, nonatomic) RYLiteratureCategoryView    *literatureCategoryView;

@end

@implementation RYNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self commInit];
    [self setNavigationItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:@"loginStateChange" object:nil];
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
    [scrollPageView removeAlldataSources];
}

- (void)setNavigationItem
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 24)];
    [leftButton setImage:[UIImage imageNamed:@"ic_home_head.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.noticeLabel.left = leftButton.right - 15;
    self.noticeLabel.top = 3;
    [leftButton addSubview:self.noticeLabel];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 20)];
    logoView.image = [UIImage imageNamed:@"ic_yimeiquan_logo.png"];
    self.navigationItem.titleView = logoView;
}

#pragma mark 点击滑出侧边拦
- (void)leftButtonClick:(id)sender
{
    NSLog(@"我的");
    if ( self.selectCategoryBtn.selected ) {
        [self.literatureCategoryView dismissCategoryView];
    }
    else{
        [[SlideNavigationController sharedInstance] openMenu:MenuLeft withCompletion:^{
            NSLog(@"222");
        }];
    }
}

/**
 * 登陆按钮点击
 */
- (void)loginButtonClick:(id)sender
{
    if ( self.selectCategoryBtn.selected ) {
        [self.literatureCategoryView dismissCategoryView];
    }
    else{
        RYLoginViewController *loginVC = [[RYLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark UI初始化
-(void)commInit{
    NSArray *vButtonItemArray = @[@{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"ic_helight",
                                    TITLEKEY:@"首页",
                                    TITLEWIDTH:[NSNumber numberWithFloat:54]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"ic_helight",
                                    TITLEKEY:@"新闻",
                                    TITLEWIDTH:[NSNumber numberWithFloat:53]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"ic_helight",
                                    TITLEKEY:@"会讯",
                                    TITLEWIDTH:[NSNumber numberWithFloat:53]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"ic_helight",
                                    TITLEKEY:@"文献",
                                    TITLEWIDTH:[NSNumber numberWithFloat:53]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"ic_helight",
                                    TITLEKEY:@"播客",
                                    TITLEWIDTH:[NSNumber numberWithFloat:53]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"ic_helight",
                                    TITLEKEY:@"百家",
                                    TITLEWIDTH:[NSNumber numberWithFloat:54]
                                    },
                                ];
    
    newsData = [[newsBarData alloc] init];
    newsData.dataArray = vButtonItemArray;
//    self.title = [newsData currentTitleWithIndex:0];
    self.baiJiaCurrentSelectIndex = 0;
    
    if ( scrollBarView == nil ) {
        scrollBarView = [[MJScrollBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) ButtonItems:vButtonItemArray];
        scrollBarView.delegate = self;
    }
    if ( scrollPageView == nil ) {
        scrollPageView = [[MJScrollPageView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, VIEW_HEIGHT - 40)];
        scrollPageView.delegate = self;
        [scrollBarView changeButtonStateAtIndex:currentIndex];
        [scrollPageView setContentOfTables:vButtonItemArray.count];
        
        for ( UIView *view in scrollPageView.scrollView.subviews ) {
            if ( [view isKindOfClass:[MJRefreshTableView class]] ) {
                MJRefreshTableView *tableView = (MJRefreshTableView *)view;
                tableView.delegate = self;
                tableView.dataSource = self;
                
                NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
                if ( aIndex == 5 ) {
                    [tableView setSectionIndexColor:[Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0]];
                    tableView.tableHeaderView = [self baiJiaTableViewHeadView];

                }
//                else if ( aIndex == 3 ){
//                    [scrollPageView.scrollView addSubview:[self literatureCategory]];
//                }
            }
        }
    }
    [self.view addSubview:scrollBarView];
    [self.view addSubview:scrollPageView];
}

/**
 * 文献 top 的分类选择
 */
- (UIView *)literatureCategory
{
    UIView   *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, 32)];
    view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *titleArray = [NSMutableArray array];
    NSInteger length = (self.categoryArray.count >= 3)?3:self.categoryArray.count;
    for (int i = 0 ; i < length; i ++ ) {
        NSDictionary *tagDict = [self.categoryArray objectAtIndex:i];
        NSString *title = [tagDict getStringValueForKey:@"tagname" defaultValue:@""];
        if ( ![ShowBox isEmptyString:title] ) {
            [titleArray addObject:title];
        }
    }
   
    gridMenu = [[GridMenuView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH / 4.0 ) * 3, 32)
                                                       imgUpName:@"ic_grid_default.png"
                                                     imgDownName:@"ic_grid_highlighted.png"
                                                      titleArray:titleArray
                                                  titleDownColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0]
                                                    titleUpColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0]
                                                       perRowNum:3
                                             andCanshowHighlight:YES];
    gridMenu.delegate = self;
    gridMenu.backgroundColor = [UIColor clearColor];

    // 取出上次 保存的 tagDict
    NSDictionary *saveDict = [ShowBox getLiteratureTagDict];
    NSInteger index = -1;
    for ( int i = 0 ; i < titleArray.count; i ++ ) {
        NSString *saveTitle = [saveDict getStringValueForKey:@"tagname" defaultValue:@""];
        NSString *title = [titleArray objectAtIndex:i];
        
        if ( [saveTitle isEqualToString:title] ) {
            index = i;
        }
    }
    
    if ( index != -1 ) {
        [gridMenu changeSelectStatesWithIndex:index];
    }
    
    [view addSubview:gridMenu];
    
    [view addSubview:self.selectCategoryBtn];
    return view;
}

#pragma mark - GridMenuViewDelegate
-(void)GridMenuViewButtonSelected:(NSInteger)btntag selfTag:(NSInteger)selftag
{
//    NSLog(@"btntag : %ld, selftag : %ld" ,btntag,selftag); 
    [self.literatureCategoryView dismissCategoryView];
    [self.literatureCategoryView literatureCancelSelectStates];
    // 保存 所选择的 标签
    NSDictionary *selectDict = [self.categoryArray objectAtIndex:btntag];
    if ( ![self.selectLiteratureDict isEqualToDictionary:selectDict] ) {
        [ShowBox saveLiteratureTagDict:selectDict];
        MJRefreshTableView *v = [scrollPageView.contentItems objectAtIndex:3];
        [v headerBeginRefreshing];
    }
    
}

#pragma  mark - RYLiteratureCategoryViewDelegate

- (void)literatureCategorySelected:(NSInteger)btntag selfTag:(NSInteger)selftag
{
//    NSLog(@"btntag : %ld, selftag : %ld" ,btntag,selftag);
    [gridMenu cancelSelectStates];
    
    // 保存 所选择的 标签
    NSDictionary *selectDict = [self.categoryArray objectAtIndex:btntag+3];
    if ( ![self.selectLiteratureDict isEqualToDictionary:selectDict] ) {
        [ShowBox saveLiteratureTagDict:selectDict];
        MJRefreshTableView *v = [scrollPageView.contentItems objectAtIndex:3];
        [v headerBeginRefreshing];
    }
}

- (void)dismissCompletion
{
    [self.selectCategoryBtn setSelected:NO];
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

#pragma mark - 初始化
/**
 *  数据的懒加载
 */
- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData = [NSMutableArray array];
        
        for (int i = 0; i<5; i++) {
            [self.fakeData addObject:MJRandomData];
        }
    }
    return _fakeData;
}


- (NSArray *)categoryArray
{
    if ( _categoryArray == nil ) {
        _categoryArray = [NSArray array];
    }
    return _categoryArray;
}

/**
 * 选择分类的按钮
 */
- (UIButton *)selectCategoryBtn
{
    if (_selectCategoryBtn == nil) {
        _selectCategoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 0, 80, 32)];
        [_selectCategoryBtn setImage:[UIImage imageNamed:@"ic_adown_arrow.png"] forState:UIControlStateNormal];
        [_selectCategoryBtn setImage:[UIImage imageNamed:@"ic_up_arrow.png"] forState:UIControlStateSelected];
        [_selectCategoryBtn addTarget:self action:@selector(selectCategoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectCategoryBtn;
}
/**
 *更多分类 的显示框
 */
- (UIView *)categoryGridView
{
    if ( _categoryGridView == nil ) {
        _categoryGridView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _categoryGridView;
}

- (RYLiteratureCategoryView *)literatureCategoryView
{
    if ( _literatureCategoryView == nil ) {
        _literatureCategoryView = [[RYLiteratureCategoryView alloc] init];
        _literatureCategoryView.delegate = self;
    }
    return _literatureCategoryView;
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
    }
    return _newsPage;
}

- (RYHuiXun *)huiXun
{
    if ( _huiXun == nil ) {
        _huiXun = [[RYHuiXun alloc] init];
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

- (UILabel *)noticeLabel
{
    if (_noticeLabel == nil) {
        _noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _noticeLabel.backgroundColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
        _noticeLabel.hidden = YES;
        
        _noticeLabel.layer.cornerRadius = 4;
        _noticeLabel.layer.masksToBounds = YES;
        
        _noticeLabel.layer.borderWidth = 1;
        _noticeLabel.layer.borderColor = [Utils getRGBColor:0x00 g:0x91 b:0xea a:1.0].CGColor;
    }
    return _noticeLabel;
}

/**
 * 文献更多按钮点击
 */
-(void)selectCategoryBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ( btn.selected ) {
        [self.literatureCategoryView dismissCategoryView];
    }
    else{ // 展开
        self.literatureCategoryView.hidden = NO;
         self.literatureCategoryView.offSetY = 72;
        [self.view addSubview:self.literatureCategoryView];
        [self.literatureCategoryView showCategoryView];
    }
    [btn setSelected:!btn.selected];
}

#pragma mark 头部tabbar 分类 选择
-(void)didMenuClickedButtonAtIndex:(NSInteger)index
{
    NSLog(@" dianji %ld",(long)index);
    if ( self.selectCategoryBtn.selected ) {
        self.literatureCategoryView.hidden = YES;
        [self.literatureCategoryView dismissCategoryView];
    }
//    self.title = [newsData currentTitleWithIndex:index];
    if (currentIndex != index ) {
        currentIndex = index;
        [scrollPageView moveScrollowViewAthIndex:currentIndex];
    }
 }

#pragma mark 列表滚动后 设置 tabbar 的状态
- (void)currentMoveToPageAtIndex:(NSInteger)aIndex
{
    NSLog(@"滑动列表 %ld",(long)aIndex);
   [self.literatureCategoryView dismissCategoryView];
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
                                            [wSelf->scrollPageView refreshEndAtTableViewIndex:tempIndex];
                                            [wSelf setValueWithDict:responseDic andIndex:tempIndex isHead:isHead];
                                            
                                        } failure:^(id errorString) {
                                            //                                            NSLog(@"首页 ： %@",errorString);
                                            [ShowBox showError:@"获取数据失败，请稍候重试"];
                                            [wSelf->scrollPageView refreshEndAtTableViewIndex:tempIndex];
                                        }];
        
        
    }
    else if ( aIndex == 1 ) {
        NSInteger tempIndex = aIndex;
        [NetRequestAPI getHomePageNewsListWithSessionId:[RYUserInfo sharedManager].session
                                                    fid:@"136"
                                                   page:currentPage
                                                success:^(id responseDic) {
                                                    //                                                    NSLog(@"新闻 ：responseDic  %@",responseDic);
                                                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                                                    [wSelf->scrollPageView refreshEndAtTableViewIndex:tempIndex];
                                                    [wSelf setValueWithDict:responseDic andIndex:tempIndex isHead:isHead];
                                                } failure:^(id errorString) {
                                                    [ShowBox showError:@"获取数据失败，请稍候重试"];
                                                    //                                                    NSLog(@"新闻 ：errorString  %@",errorString);
                                                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                                                     [wSelf->scrollPageView refreshEndAtTableViewIndex:tempIndex];
                                                }];
    }
    else if ( aIndex == 2 )
    {
        NSInteger tempIndex = aIndex;
        [NetRequestAPI getHomePageNewsListWithSessionId:[RYUserInfo sharedManager].session
                                                    fid:@"142"
                                                   page:currentPage
                                                success:^(id responseDic) {
                                                    //                                                   NSLog(@"会讯 ：responseDic  %@",responseDic);
                                                    [wSelf->scrollPageView refreshEndAtTableViewIndex:tempIndex];
                                                    [wSelf setValueWithDict:responseDic andIndex:tempIndex isHead:isHead];
                                                    
                                                    
                                                } failure:^(id errorString) {
                                                    //            NSLog(@"会讯 ： %@",errorString);
                                                    [ShowBox showError:@"获取数据失败，请稍候重试"];
                                                    [wSelf->scrollPageView refreshEndAtTableViewIndex:tempIndex];
                                                }];
        
    }
    else if ( aIndex == 3 )
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
                                                      //                                                      NSLog(@"文献 ：responseDic  %@",responseDic);
                                                       [wSelf->scrollPageView refreshEndAtTableViewIndex:tempIndex];
                                                      [wSelf setValueWithDict:responseDic andIndex:tempIndex isHead:isHead];
                                                      
                                                  } failure:^(id errorString) {
                                                      //            NSLog(@"文献 ： %@",errorString);
                                                      [ShowBox showError:@"获取数据失败，请稍候重试"];
                                                     [wSelf->scrollPageView refreshEndAtTableViewIndex:tempIndex];
                                                  }];
        
    }
    else if ( aIndex == 4 )
    {
        NSInteger tempIndex = aIndex;
        [NetRequestAPI getPodcastListWithSessionId:[RYUserInfo sharedManager].session
                                             tagid:@"284"
                                              page:currentPage
                                           success:^(id responseDic) {
                                               //                                                NSLog(@"播客 ：responseDic  %@",responseDic);
                                               [wSelf->scrollPageView refreshEndAtTableViewIndex:tempIndex];
                                               [wSelf setValueWithDict:responseDic andIndex:tempIndex isHead:isHead];
                                               
                                           } failure:^(id errorString) {
                                               //            NSLog(@"播客 ： %@",errorString);
                                               [ShowBox showError:@"获取数据失败，请稍候重试"];
                                               [wSelf->scrollPageView refreshEndAtTableViewIndex:tempIndex];
                                               
                                           }];
        
    }
    else
    {
         NSInteger tempIndex = aIndex;
        [NetRequestAPI getHomeBaijiaListWithSessionId:[RYUserInfo sharedManager].session
                                                 page:currentPage
                                              success:^(id responseDic) {
                                                  NSLog(@"百家 responseDic：%@",responseDic);
                                                  [wSelf->scrollPageView refreshEndAtTableViewIndex:tempIndex];
                                                  [wSelf setValueWithDict:responseDic andIndex:tempIndex isHead:isHead];
                                                  
                                              } failure:^(id errorString) {
                                                  NSLog(@"百家 errorString：%@",errorString);
                                                  [ShowBox showError:@"获取数据失败，请稍候重试"];
                                                  [wSelf->scrollPageView refreshEndAtTableViewIndex:tempIndex];
                                              }];
    }
 
}

- (void)setValueWithDict:(NSDictionary *)responseDic andIndex:(NSInteger)aIndex isHead:(BOOL)isHead
{
    if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
        [ShowBox showError:@"获取数据失败，请稍候重试"];
        return ;
    }
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    if ( !meta ) {
        [ShowBox showError:@"获取数据失败，请稍候重试"];
        return ;
    }
    
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        int  login = [meta getIntValueForKey:@"login" defaultValue:0];
        if ( login == 2 ) {  // login == 2 表示用户已过期 需要重新登录
            
            RYLoginViewController *nextVC = [[RYLoginViewController alloc] initWithFinishBlock:^(BOOL isLogin, NSError *error) {
                if ( isLogin ) {
                    NSLog(@"登录完成"); // 重新获取数据 
//                    MJRefreshTableView *v = [scrollPageView.contentItems objectAtIndex:aIndex];
//                    [v headerBeginRefreshing];
                }
            }];
            [self.navigationController pushViewController:nextVC animated:YES];
            return;
        }
        else{
            [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"获取数据失败，请稍候重试"]];
            return;
        }
    }
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    if ( !info ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"获取数据失败，请稍候重试"]];
        return;
    }
    
    // 刷新 userinfo的数据 
    NSDictionary *usermassage = [info getDicValueForKey:@"usermassage" defaultValue:nil];
    if ( usermassage ) {
        [[RYUserInfo sharedManager] refreshUserInfoDataWithDict:usermassage];
    }
    
    // 通知条数
    NSDictionary *noticemessage = [info getDicValueForKey:@"noticemessage" defaultValue:nil];
    if ( noticemessage ) {
        self.noticecount = [noticemessage getIntValueForKey:@"noticecount" defaultValue:0];
        #warning 此处 显示消息 图标
        if ( self.noticecount > 0) {
            self.noticeLabel.hidden = NO;
        }else{
            self.noticeLabel.hidden = YES;
        }
    }
    
    
    if ( aIndex == 0 ) { // 首页
        // 取周报
        NSDictionary *weeklymessage = [info getDicValueForKey:@"weeklymessage" defaultValue:nil];
        if ( weeklymessage.allKeys.count ) {
            NSArray *dataArray = [NSArray arrayWithObject:weeklymessage];
            // 首页 周报 先删除 原来的 在添加新的  保持最新
            [[scrollPageView.dataSources objectAtIndex:aIndex] removeAllObjects];
            [[scrollPageView.dataSources objectAtIndex:aIndex] addObjectsFromArray:dataArray];
        }
        // 取 登录 邀请等信息
        NSDictionary *descmessage = [info getDicValueForKey:@"descmessage" defaultValue:nil];
        if ( descmessage.allKeys.count ) {
            self.homePage.descmessage = descmessage;
        }
        // 取广告
        NSDictionary *admessage = [info getDicValueForKey:@"advmessage" defaultValue:nil];
        self.homePage.adverData = admessage;
       [scrollPageView setTotlePageWithNum:1 atIndex:aIndex];
        // 刷新表格
        [[scrollPageView.contentItems objectAtIndex:aIndex] reloadData];
    }
    else{
        
        // 取广告
        NSDictionary *admessage = [info getDicValueForKey:@"advmessage" defaultValue:nil];
        if ( admessage.allKeys.count ) {
            if ( aIndex == 1 ) { // 新闻
                self.newsPage.adverData = admessage;
            }
            else if ( aIndex == 3 ){ // 文献
                self.literaturePage.adverData = admessage;
            }
        }
        
        if ( aIndex == 3 ) { // 文献
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
            [scrollPageView.scrollView addSubview:view];
            
            NSMutableArray *titleArray = [NSMutableArray array];
            if ( self.categoryArray.count > 3 ) {
                for ( int i = 3 ; i < self.categoryArray.count; i ++ ) {
                    NSDictionary *tagDict = [self.categoryArray objectAtIndex:i];
                    NSString *title = [tagDict getStringValueForKey:@"tagname" defaultValue:@""];
                    if ( ![ShowBox isEmptyString:title] ) {
                        [titleArray addObject:title];
                    }
                }
            }
            self.literatureCategoryView.categoryData = titleArray;
        }
        else if ( aIndex == 5 ){
            // 取作者
            NSArray *authorList = [info getArrayValueForKey:@"writerlistmessage" defaultValue:nil];
            if ( authorList.count ) {
                self.baiJiaPage.authorList = [Utils findSameKeyWithArray:authorList];
            }
        }
        
        // 设置 总共多少 页
        NSInteger totalPage = [info getIntValueForKey:@"total" defaultValue:1];
        [scrollPageView setTotlePageWithNum:totalPage atIndex:aIndex];
        
        NSArray *dataArray;
        if ( aIndex == 5 ) {
            dataArray = [info getArrayValueForKey:@"artfromwritermessage" defaultValue:nil];
        }
        else{
            dataArray = [info getArrayValueForKey:@"threadmessage" defaultValue:nil];
        }
        
        if ( dataArray.count ) {
            if ( isHead ) { // 下拉刷新 头部 ， 需要清空数组
                [[scrollPageView.dataSources objectAtIndex:aIndex] removeAllObjects];
            }
            [[scrollPageView.dataSources objectAtIndex:aIndex] addObjectsFromArray:dataArray];
        }
        // 刷新表格
        [[scrollPageView.contentItems objectAtIndex:aIndex] reloadData];
    }
   
    
//    if ( aIndex == 1 ) {
//         self.newsPage.listData = [scrollPageView.dataSources objectAtIndex:aIndex];
//        // 刷新表格
//        [[scrollPageView.contentItems objectAtIndex:aIndex] reloadData];
//    }
}

#pragma mark  UITableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 0 ) {
        self.homePage.listData = [scrollPageView.dataSources objectAtIndex:aIndex];
        return [self.homePage homepageNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 1 ) {
        self.newsPage.listData = [scrollPageView.dataSources objectAtIndex:aIndex];
        return [self.newsPage newsNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 2 ){
        self.huiXun.listData = [scrollPageView.dataSources objectAtIndex:aIndex];
        return [self.huiXun huiXunNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 3 ){
        self.literaturePage.listData = [scrollPageView.dataSources objectAtIndex:aIndex];
        return [self.literaturePage literatureNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 4 ){
        self.podcastPage.listData = [scrollPageView.dataSources objectAtIndex:aIndex];
        return  [self.podcastPage podcastNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 5 ){
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
    else if ( aIndex == 1 ) {
        return [self.newsPage newsTableView:tableView numberOfRowsInSection:section];
    }
    else if ( aIndex == 2 ){
        return [self.huiXun huiXunTableView:tableView numberOfRowsInSection:section];
    }
    else if ( aIndex == 3 ){
        return [self.literaturePage literatureTableView:tableView numberOfRowsInSection:section];
    }
    else if ( aIndex == 4 ){
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
    else if ( aIndex == 1 ) {
        return [self.newsPage newsTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 2 ){
        return [self.huiXun huiXunTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 3 ){
        return [self.literaturePage literatureTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 4 ){
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
    else if ( aIndex == 1 ) {
        return [self.newsPage newsTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 2 ){
        return [self.huiXun huiXunTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 3 ){
        return [self.literaturePage literatureTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 4 ){
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
        [self weeklyTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 4 ) { // 播客点击，进入播放
        [self podcastTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 5 ){
        [self baiJiaTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 3 ){
        NSDictionary *dict = [self.literaturePage.listData objectAtIndex:indexPath.row];
        RYLiteratureDetailsViewController *vc = [[RYLiteratureDetailsViewController alloc] initWithTid:[dict getStringValueForKey:@"tid" defaultValue:@""]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( aIndex == 1 ){
        if ( indexPath.section == 1 ) {
            NSDictionary *dict = [self.newsPage.listData objectAtIndex:indexPath.row];
            RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:[dict getStringValueForKey:@"tid" defaultValue:@""]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ( aIndex == 2 ){
        NSDictionary *dict = [self.huiXun.listData objectAtIndex:indexPath.row];
        RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:[dict getStringValueForKey:@"tid" defaultValue:@""]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 1 ) {
        return [self.newsPage newsTableView:tableView heightForFooterInSection:section];
    }
    else if ( aIndex == 3 ){
        return [self.literaturePage literatureTableView:tableView heightForFooterInSection:section];
    }
    else if ( aIndex == 4 ){
        return [self.podcastPage podcastTableView:tableView heightForFooterInSection:section];
    }
    else if ( aIndex == 5 ){
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
        if ( section == 1 )return 84;
        else return 0;
    }
    else if ( aIndex == 1 ) {
        return [self.newsPage newsTableView:tableView heightForHeaderInSection:section];
    }
    else if ( aIndex == 3 ){
        return [self.literaturePage literatureTableView:tableView heightForHeaderInSection:section];
    }
    else if ( aIndex == 4 ){
        return [self.podcastPage podcastTableView:tableView heightForHeaderInSection:section];
    }
    else if ( aIndex == 5 ){
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
        return [self homePageDirectSearchView];
    }
    else if ( aIndex == 5 ) {
        return [self.baiJiaPage baiJiaTableView:tableView viewForHeaderInSection:section];
    }
    else{
        return nil;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 5 ) {
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
    if ( aIndex == 5 ) {
        return [self.baiJiaPage baiJiaTableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
    else {
        return 0;
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

#pragma mark 进入周报 进入周报页
- (void)weeklyTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section != 0 ) {
        [self gotoweekly];
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

- (void) playVideoFinished:(NSNotification *)theNotification//当点击Done按键或者播放完毕时调用此函数
{
    MPMoviePlayerController *player = [theNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    //    [playerViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark 直达号搜索框
- (UIView *)homePageDirectSearchView
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    view.backgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 8, SCREEN_WIDTH - 20, 28)];
    searchBar.layer.cornerRadius = 5.0f;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = [self.homePage.descmessage getStringValueForKey:@"zhidahaoshili" defaultValue:@"输入直达号"];
    searchBar.delegate = self;
    searchBar.backgroundImage = [UIImage new];
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.font = [UIFont systemFontOfSize:12];
    self.searchBar = searchBar;
    [view addSubview:searchBar];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 40)];
    btn.backgroundColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
    [btn addTarget:self action:@selector(gotoweekly) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 106, 18)];
    imgView.image = [UIImage imageNamed:@"ic_weekly.png"];
    [btn addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right + 4, 12, 65, 18)];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [Utils getRGBColor:0xff g:0x82 b:0x21 a:1.0];
    label.backgroundColor = [UIColor whiteColor];
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    self.weeklyLabel = label;
    
    NSDictionary *weeklyDic;
    if (self.homePage.listData.count) {
        weeklyDic = [self.homePage.listData objectAtIndex:0];
    }
    NSString *weeklyNum = [weeklyDic getStringValueForKey:@"id" defaultValue:@"0"];
    self.weeklyLabel.text = [NSString stringWithFormat:@"总第%@期",weeklyNum];
    [btn addSubview:label];

    return view;
}

#pragma mark - UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if ( searchBar == self.searchBar ) {
        NSString *placeholder = searchBar.placeholder;
        RYCorporateSearchViewController *vc = [[RYCorporateSearchViewController alloc] initWithSearchBarPlaceholder:placeholder];
        UINavigationController* nc = [[UINavigationController alloc]initWithRootViewController:vc];
        nc.delegate = self;
        [self presentViewController:nc animated:YES completion:^{
            [searchBar resignFirstResponder];
        }];
    }
    else{
        [searchBar resignFirstResponder];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIBarButtonItem *back=[[UIBarButtonItem alloc] init];
    
    back.title = @" ";
    UIImage *backbtn = [UIImage imageNamed:@"back_btn_icon.png"];
    [back setBackButtonBackgroundImage:backbtn forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [back setBackButtonBackgroundImage:[UIImage imageNamed:@"back_btn_icon.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [back setStyle:UIBarButtonItemStylePlain];
    
    viewController.navigationItem.backBarButtonItem = back;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    NSLog(@"点击搜索框");
}


- (void)gotoweekly
{
    NSLog(@"周报");
    RYWeeklyViewController *vc = [[RYWeeklyViewController alloc] init];
//    vc.listData = self.homePage.listData;
    vc.weeklyDict = [self.homePage.listData objectAtIndex:0];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark    滑出侧边拦，需要实现该代理方法
-(BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    if ( self.selectCategoryBtn.selected ) {
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark MJScrollPageView 手势代理
// ---------------- 为了解决 滚动出侧边拦的手势冲突 begin——————————————————————
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    [[SlideNavigationController sharedInstance]panDetected:gesture];
}
// ---------------- 为了解决 滚动出侧边拦的手势冲突 end——————————————————————

#pragma mark - RFSegmentView delegate
- (void)segmentViewSelectIndex:(NSInteger)index
{
    if ( self.baiJiaCurrentSelectIndex != index ) {
        self.baiJiaCurrentSelectIndex = index;
        self.baiJiaPage.currentType = self.baiJiaCurrentSelectIndex;
        MJRefreshTableView *tableView = [scrollPageView.contentItems objectAtIndex:5];
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


@end
