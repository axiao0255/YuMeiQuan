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

#import "RYMyHomeLeftViewController.h"
#import "SlideNavigationController.h"

#import "RYArticleViewController.h"
#import "RYCorporateHomePageViewController.h"
#import "RYMoviePlayerViewController.h"
#import "RYAuthorArticleViewController.h"
#import "RYLiteratureDetailsViewController.h"
#import "RYWeeklyViewController.h"

#import "RYHomepage.h"
#import "RYNewsPage.h"
#import "RYHuiXun.h"
#import "RYPodcastPage.h"
#import "RYBaiJiaPage.h"
#import "RYLiteraturePage.h"

#import "RYLiteratureCategoryView.h"

/**
 *  随机数据
 */
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]


@interface RYNewsViewController ()<MJScrollBarViewDelegate,MJScrollPageViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,RFSegmentViewDelegate,GridMenuViewDelegate,RYLiteratureCategoryViewDelegate,UISearchBarDelegate>
{
    MJScrollBarView    *scrollBarView;
    MJScrollPageView   *scrollPageView;
    NSInteger          currentIndex;
    newsBarData        *newsData;
}

@property (strong, nonatomic) NSMutableArray   *fakeData;
@property (strong, nonatomic) NSArray          *categoryArray;

@property (strong, nonatomic) UIButton         *selectCategoryBtn;
@property (strong, nonatomic) UIView           *categoryGridView;
@property (strong, nonatomic) UISearchBar      *searchBar;
@property (strong, nonatomic) UILabel          *weeklyLabel;

@property (strong, nonatomic) RYHomepage       *homePage;
@property (strong, nonatomic) RYNewsPage       *newsPage;
@property (strong, nonatomic) RYHuiXun         *huiXun;
@property (strong, nonatomic) RYPodcastPage    *podcastPage;
@property (strong, nonatomic) RYBaiJiaPage     *baiJiaPage;
@property (strong, nonatomic) RYLiteraturePage *literaturePage;


@property (assign, nonatomic) NSInteger        baiJiaCurrentSelectIndex;


@property (strong, nonatomic) RYLiteratureCategoryView    *literatureCategoryView;

@end

@implementation RYNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self commInit];
    [self setNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationItem
{
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [loginButton setExclusiveTouch:YES];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithCustomView:loginButton];
    self.navigationItem.rightBarButtonItem = loginItem;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton setTitle:@"我的" forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark 点击滑出侧边拦
- (void)leftButtonClick:(id)sender
{
    NSLog(@"我的");
    if ( self.selectCategoryBtn.selected ) {
        [self.literatureCategoryView dismissCategoryView];
    }
    else{
        [[SlideNavigationController sharedInstance] openMenu:MenuLeft withCompletion:nil];
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
                                    TITLEKEY:@"会训",
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
    self.title = [newsData currentTitleWithIndex:0];
    self.baiJiaCurrentSelectIndex = 0;
    
    if ( scrollBarView == nil ) {
        scrollBarView = [[MJScrollBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35) ButtonItems:vButtonItemArray];
        scrollBarView.delegate = self;
    }
    if ( scrollPageView == nil ) {
        scrollPageView = [[MJScrollPageView alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, VIEW_HEIGHT - 35)];
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
                    tableView.tableHeaderView = [self baiJiaTableViewHeadView];
                    [tableView setSectionIndexColor:[Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0]];
                }
                else if ( aIndex == 3 ){
                    [scrollPageView.scrollView addSubview:[self literatureCategory]];
                }
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
    UIView   *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = [UIColor whiteColor];
    GridMenuView *gridMenu = [[GridMenuView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH / 5.0 ) * 4, 20)
                                                       imgUpName:@"ic_grid_default.png"
                                                     imgDownName:@"ic_grid_highlighted.png"
                                                      titleArray:@[@"鼻整形",@"眼整形",@"整形外科",@"乳房整形"]
                                                  titleDownColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0]
                                                    titleUpColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0]
                                                       perRowNum:4
                                             andCanshowHighlight:YES];
    gridMenu.delegate = self;
    gridMenu.backgroundColor = [UIColor redColor];
    [view addSubview:gridMenu];
    
    [view addSubview:self.selectCategoryBtn];
    return view;
}

#pragma mark - GridMenuViewDelegate
-(void)GridMenuViewButtonSelected:(NSInteger)btntag selfTag:(NSInteger)selftag
{
    NSLog(@"btntag : %ld, selftag : %ld" ,btntag,selftag);
    [self.literatureCategoryView dismissCategoryView];
}

#pragma  mark - RYLiteratureCategoryViewDelegate

- (void)literatureCategorySelected:(NSInteger)btntag selfTag:(NSInteger)selftag
{
    NSLog(@"btntag : %ld, selftag : %ld" ,btntag,selftag);
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
        _selectCategoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 64, 0, 64, 20)];
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
    self.title = [newsData currentTitleWithIndex:index];
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

- (void)net
{
    NSString *url = @"http://api2.rongyi.com/app/v5/home/index.htm;jsessionid=?type=latest&areaName=%E4%B8%8A%E6%B5%B7&cityId=51f9d7f231d6559b7d000002&lng=121.439659&lat=31.194059&currentPage=1&pageSize=20&version=v5_6";
//    [NetManager JSONDataWithUrl:url success:^(id json) {
//         NSLog(@" 成功 %@",json);
//    } fail:^(id error) {
//        NSLog(@"错误 %@",error);
//    }];
}

#pragma mark 获取数据
- (void)freshContentTableAtIndex:(NSInteger)aIndex isHead:(BOOL)isHead
{
    NSLog(@"%ld,%d",(long)aIndex, isHead);
//    [self net];
    
    for ( int i = 0;  i < 5; i ++ ) {
        [self.fakeData addObject:MJRandomData];
    }
    if ( aIndex == 0 ) {
        
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
        [tmpDic setObject:@"http://image.tianjimedia.com/uploadImages/2015/131/49/6FPNGYZA50BS_680x500.jpg" forKey:@"pic"];
        [tmpDic setObject:@"段涛：移动互联网精神已医学专业移动互联网精神已医学专业移动互联网精神已" forKey:@"title"];
        self.homePage.adverData = tmpDic;
        
        NSMutableArray *arr = [NSMutableArray array];
        for ( int i = 0 ; i < 6; i ++ ) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"http://image.tianjimedia.com/uploadImages/2015/131/49/6FPNGYZA50BS_680x500.jpg" forKey:@"pic"];
            [dic setObject:@"2015-05-08" forKey:@"time"];
            if ( i % 2 == 0 ) {
                [dic setObject:@"电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影" forKey:@"title"];
                [dic setObject:@"文献" forKey:@"belongs"];
                [dic setObject:@"中国医生协会美容与整形医生分会。激光激光激光" forKey:@"subhead"];
            }
            else{
                [dic setObject:@"视频视频视频视频视频视频视频视频视频视" forKey:@"title"];
                [dic setObject:@"会讯" forKey:@"belongs"];
                [dic setObject:@"" forKey:@"subhead"];
            }
            [arr addObject:dic];
        }
        
        self.homePage.listData = arr;
    }
    else if ( aIndex == 1 ) {
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
        [tmpDic setObject:@"http://image.tianjimedia.com/uploadImages/2015/131/49/6FPNGYZA50BS_680x500.jpg" forKey:@"pic"];
        [tmpDic setObject:@"段涛：移动互联网精神已医学专业移动互联网精神已医学专业移动互联网精神已" forKey:@"title"];
        
        self.newsPage.adverData = tmpDic;
        
        NSMutableArray *arr = [NSMutableArray array];
        for ( int i = 0 ; i < 10; i ++ ) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3661783255,1817185932&fm=116&gp=0.jpg" forKey:@"pic"];
            [dic setObject:@"护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，" forKey:@"title"];
            [dic setObject:@"2015-04-23" forKey:@"time"];
            [arr addObject:dic];
        }
        self.newsPage.listData = arr;
    }
    else if ( aIndex == 2 )
    {
        NSMutableArray *arr = [NSMutableArray array];
        for ( int i = 0; i < 10; i ++ ) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if ( i % 2 == 0 ) {
                [dic setObject:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3661783255,1817185932&fm=116&gp=0.jpg" forKey:@"pic"];
            }
            else{
                [dic setObject:@"" forKey:@"pic"];
            }
            [dic setObject:@"2015-04-23" forKey:@"time"];
            [dic setObject:@"第五届全国激光美容与面部年轻化学术大会" forKey:@"title"];
            [dic setObject:@"中国医师协会美容仪整形医师分会.激光亚专业委员会" forKey:@"subhead"];
            
            [arr addObject:dic];
        }
        self.huiXun.listData = arr;
    }
    else if ( aIndex == 3 )
    {
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
        [tmpDic setObject:@"http://image.tianjimedia.com/uploadImages/2015/131/49/6FPNGYZA50BS_680x500.jpg" forKey:@"pic"];
        [tmpDic setObject:@"段涛：移动互联网精神已医学专业移动互联网精神已医学专业移动互联网精神已" forKey:@"title"];
        
        self.literaturePage.adverData = tmpDic;
        
        NSMutableArray *arr = [NSMutableArray array];
        for ( int i = 0 ; i < 10; i ++ ) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3661783255,1817185932&fm=116&gp=0.jpg" forKey:@"pic"];
            [dic setObject:@"护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，" forKey:@"title"];
            [dic setObject:@"2015-04-23" forKey:@"time"];
            [arr addObject:dic];
        }
        self.literaturePage.listData = arr;
        
        self.categoryArray = @[@"身体塑形",@"面部塑形",@"毛发移植",@"皮肤外科",@"外科综合",@"激光物理",@"注射美容",@"生活美容",@"皮肤科综合",@"牙科美容",@"中医美容",@"护肤品",@"市场营销",@"口腔",@"书讯",@"图书馆",@"全部"];
        self.literatureCategoryView.categoryData = self.categoryArray;
        self.literatureCategoryView.offSetY = 55;

    }
    else if ( aIndex == 4 )
    {
        NSMutableArray *arr = [NSMutableArray array];
        for ( int i = 0 ; i < 6; i ++ ) {
             NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"http://image.tianjimedia.com/uploadImages/2015/131/49/6FPNGYZA50BS_680x500.jpg" forKey:@"pic"];
            if ( i % 2 == 0 ) {
                [dic setObject:@"http://hot.vrs.sohu.com/ipad1407291_4596271359934_4618512.m3u8" forKey:@"movier"];
                [dic setObject:@"电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影电影" forKey:@"title"];
            }
            else{
                [dic setObject:@"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA" forKey:@"movier"];
                [dic setObject:@"视频视频视频视频视频视频视频视频视频视" forKey:@"title"];
            }
            [arr addObject:dic];
        }
        
        self.podcastPage.listData = arr;
    }
    else if ( aIndex == 5 )
    {
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
        [tmpDic setObject:@"http://image.tianjimedia.com/uploadImages/2015/131/49/6FPNGYZA50BS_680x500.jpg" forKey:@"pic"];
        [tmpDic setObject:@"段涛：移动互联网精神已医学专业移动互联网精神已医学专业移动互联网精神已" forKey:@"title"];
        self.baiJiaPage.adverData = tmpDic;
        
        NSMutableArray *arr = [NSMutableArray array];
        for ( int i = 0; i < 10; i ++ ) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"http://image.tianjimedia.com/uploadImages/2015/131/49/6FPNGYZA50BS_680x500.jpg" forKey:@"pic"];
            [dic setObject:@"护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，" forKey:@"title"];
            [arr addObject:dic];
        }
        self.baiJiaPage.listData = arr;
        
        NSMutableArray *authorArr = [NSMutableArray array];
        
        for ( char c = 'A'; c <= 'Z'; c ++  ) {
            
            NSArray *subArr = @[@"赛诺龙",@"赛诺秀"];
            NSString *key = [NSString stringWithFormat:@"%c",c];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:subArr forKey:key];
            
            [authorArr addObject:dic];
        }
        self.baiJiaPage.authorList = authorArr;
    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [scrollPageView refreshEnd];
        
        //        [[scrollPageView.dataSources objectAtIndex:aIndex] removeAllObjects];
        [[scrollPageView.dataSources objectAtIndex:aIndex] addObjectsFromArray:self.fakeData];
        [scrollPageView setTotlePageWithNum:10 atIndex:aIndex];
        // 刷新表格
        [[scrollPageView.contentItems objectAtIndex:aIndex] reloadData];
    });
}

#pragma mark  UITableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 0 ) {
        return [self.homePage homepageNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 1 ) {
        return [self.newsPage newsNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 2 ){
        return [self.huiXun huiXunNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 3 ){
        return [self.literaturePage literatureNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 4 ){
        return  [self.podcastPage podcastNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 5 ){
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
        RYLiteratureDetailsViewController *vc = [[RYLiteratureDetailsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        if ( indexPath.row <= 3 ) {
            RYArticleViewController *vc = [[RYArticleViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
        RYArticleViewController *vc = [[RYArticleViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        RYAuthorArticleViewController *vc = [[RYAuthorArticleViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
    NSDictionary *dic = [self.podcastPage.listData objectAtIndex:indexPath.section];
    NSURL *movieURL = [NSURL URLWithString:[dic objectForKey:@"movier"]];
    RYMoviePlayerViewController *playerViewController = [[RYMoviePlayerViewController alloc] initWithContentURL:movieURL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:[playerViewController moviePlayer]];
    
    playerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:playerViewController animated:YES completion:^{
        MPMoviePlayerController *player = [playerViewController moviePlayer];
        [player play];
    }];
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
    searchBar.placeholder = @"输入企业直达号，例如：赛诺龙、赛诺秀";
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
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 90, 16)];
    imgView.image = [UIImage imageNamed:@"ic_weekly.png"];
    [btn addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right + 4, 12, 45, 16)];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [Utils getRGBColor:0xff g:0x82 b:0x21 a:1.0];
    label.backgroundColor = [UIColor whiteColor];
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    self.weeklyLabel = label;
    self.weeklyLabel.text = @"第204期";
    [btn addSubview:label];

    return view;
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

- (void)gotoweekly
{
    NSLog(@"周报");
    RYWeeklyViewController *vc = [[RYWeeklyViewController alloc] init];
    vc.listData = self.homePage.listData;
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



@end
