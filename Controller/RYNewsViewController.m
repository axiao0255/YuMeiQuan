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

#import "RYNewsPage.h"
#import "RYHuiXun.h"
#import "RYPodcastPage.h"
#import "RYBaiJiaPage.h"

/**
 *  随机数据
 */
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]


@interface RYNewsViewController ()<MJScrollBarViewDelegate,MJScrollPageViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,RFSegmentViewDelegate>
{
    MJScrollBarView    *scrollBarView;
    MJScrollPageView   *scrollPageView;
    NSInteger          currentIndex;
    newsBarData        *newsData;
}

@property (strong, nonatomic) NSMutableArray *fakeData;

@property (strong, nonatomic) RYNewsPage     *newsPage;
@property (strong, nonatomic) RYHuiXun       *huiXun;
@property (strong, nonatomic) RYPodcastPage  *podcastPage;
@property (strong, nonatomic) RYBaiJiaPage   *baiJiaPage;

@property (assign, nonatomic) NSInteger      baiJiaCurrentSelectIndex;

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
    [[SlideNavigationController sharedInstance] openMenu:MenuLeft withCompletion:nil];
}

/**
 * 登陆按钮点击
 */
- (void)loginButtonClick:(id)sender
{
    RYLoginViewController *loginVC = [[RYLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
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
            }
        }
    }
    [self.view addSubview:scrollBarView];
    [self.view addSubview:scrollPageView];
}

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

-(void)didMenuClickedButtonAtIndex:(NSInteger)index
{
    NSLog(@" dianji %ld",(long)index);
    self.title = [newsData currentTitleWithIndex:index];
    if (currentIndex != index ) {
        currentIndex = index;
        [scrollPageView moveScrollowViewAthIndex:currentIndex];
    }
}

- (void)currentMoveToPageAtIndex:(NSInteger)aIndex
{
    NSLog(@"滑动列表 %ld",(long)aIndex);
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

- (void)freshContentTableAtIndex:(NSInteger)aIndex isHead:(BOOL)isHead
{
    NSLog(@"%ld,%d",(long)aIndex, isHead);
//    [self net];
    
    for ( int i = 0;  i < 5; i ++ ) {
        [self.fakeData addObject:MJRandomData];
    }
    
    if ( aIndex == 1 ) {
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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor redColor];
//    return view;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 1 ) {
        return [self.newsPage newsNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 2 ){
        return [self.huiXun huiXunNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 4 ){
        return  [self.podcastPage podcastNumberOfSectionsInTableView:tableView];
    }
    else if ( aIndex == 5 ){
        return [self.baiJiaPage baiJiaNumberOfSectionsInTableView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 1 ) {
        return [self.newsPage newsTableView:tableView numberOfRowsInSection:section];
    }
    else if ( aIndex == 2 ){
        return [self.huiXun huiXunTableView:tableView numberOfRowsInSection:section];
    }
    else if ( aIndex == 4 ){
        return [self.podcastPage podcastTableView:tableView numberOfRowsInSection:section];
    }
    else if ( aIndex == 5 ){
        return [self.baiJiaPage baiJiaTableView:tableView numberOfRowsInSection:section];
    }
    NSArray *dataSource = [scrollPageView.dataSources objectAtIndex:aIndex];
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 1 ) {
        return [self.newsPage newsTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 2 ){
        return [self.huiXun huiXunTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 4 ){
        return [self.podcastPage podcastTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 5 ){
        return [self.baiJiaPage baiJiaTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else{
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 1 ) {
        return [self.newsPage newsTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 2 ){
        return [self.huiXun huiXunTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 4 ){
        return [self.podcastPage podcastTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 5 ){
        return [self.baiJiaPage baiJiaTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else{
        return [UITableViewCell new];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    if ( aIndex == 4 ) { // 播客点击，进入播放
        [self podcastTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else if ( aIndex == 5 ){
        [self baiJiaTableView:tableView didSelectRowAtIndexPath:indexPath];
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
    if ( aIndex == 1 ) {
        return [self.newsPage newsTableView:tableView heightForHeaderInSection:section];
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
    if ( aIndex == 5 ) {
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





//- (NSInteger)mScreollTabel:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
//    NSArray *dataSource = [scrollPageView.dataSources objectAtIndex:aIndex];
//    return dataSource.count;
//}
//
//- (CGFloat)msScreollTabel:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}
//
//- (UITableViewCell *)mScreollTabel:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *identifier = @"identifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if ( !cell ) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    }
//    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
//    NSArray *dataSource = [scrollPageView.dataSources objectAtIndex:aIndex];
//    if ( dataSource.count ) {
//        cell.textLabel.text = dataSource[indexPath.row];
//    }
//    return cell;
//}
//
//- (void)mScreollTabel:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if ( indexPath.row <= 3 ) {
//        RYArticleViewController *vc = [[RYArticleViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else{
//        RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
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
