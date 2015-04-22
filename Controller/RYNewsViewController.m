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

/**
 *  随机数据
 */
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]


@interface RYNewsViewController ()<MJScrollBarViewDelegate,MJScrollPageViewDelegate>
{
    MJScrollBarView    *scrollBarView;
    MJScrollPageView   *scrollPageView;
    NSInteger          currentIndex;
    
    newsBarData        *newsData;
    
}

@property (strong, nonatomic) NSMutableArray *fakeData;

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
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [loginButton setExclusiveTouch:YES];
    [loginButton setTitle:@"登陆/注册" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundColor:[UIColor redColor]];
    
    UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithCustomView:loginButton];
    self.navigationItem.rightBarButtonItem = loginItem;
}

/**
 * 登陆按钮点击
 */
- (void)loginButtonClick:(id)sender
{
    NSLog(@"登陆按钮");
    RYLoginViewController *loginVC = [[RYLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark UI初始化
-(void)commInit{
    NSArray *vButtonItemArray = @[@{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"helight.png",
                                    TITLEKEY:@"头条",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"helight.png",
                                    TITLEKEY:@"推荐",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"娱乐",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"体育",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"科技",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"轻松一刻",
                                    TITLEWIDTH:[NSNumber numberWithFloat:40*2]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"新闻",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"美女",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"帅哥",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"帅哥",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"帅哥",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"帅哥",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"帅哥",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  ];
    
    newsData = [[newsBarData alloc] init];
    newsData.dataArray = vButtonItemArray;
    self.title = [newsData currentTitleWithIndex:0];
    
    if ( scrollBarView == nil ) {
        scrollBarView = [[MJScrollBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) ButtonItems:vButtonItemArray];
        scrollBarView.delegate = self;
    }
    if ( scrollPageView == nil ) {
        scrollPageView = [[MJScrollPageView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, VIEW_HEIGHT - 40)];
        scrollPageView.delegate = self;
        [scrollBarView changeButtonStateAtIndex:currentIndex];
        [scrollPageView setContentOfTables:vButtonItemArray.count];
    }
    [self.view addSubview:scrollBarView];
    [self.view addSubview:scrollPageView];
    
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

- (NSInteger)mScreollTabel:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    NSArray *dataSource = [scrollPageView.dataSources objectAtIndex:aIndex];
    return dataSource.count;
}


- (UITableViewCell *)mScreollTabel:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSInteger aIndex = [scrollPageView.contentItems indexOfObject:tableView];
    NSArray *dataSource = [scrollPageView.dataSources objectAtIndex:aIndex];
    if ( dataSource.count ) {
        cell.textLabel.text = dataSource[indexPath.row];
    }
    return cell;
}

- (void)mScreollTabel:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath :: %@",indexPath);
}


@end
