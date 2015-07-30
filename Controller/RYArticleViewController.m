//
//  RYArticleViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYArticleViewController.h"
#import "CXPhotoBrowser.h"
#import "RYArticleData.h"
#import "CXPhoto.h"
#import "GlobleModel.h"
#import "RYCorporateHomePageViewController.h"

#import "RYAnswerSheet.h"
#import "RYShareSheet.h"
//#import "RYTokenView.h"
#import "RYBillboardView.h"

#define BROWSER_TITLE_LBL_TAG 12731
@interface RYArticleViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate,CXPhotoBrowserDelegate,CXPhotoBrowserDataSource,RYShareSheetDelegate,UIAlertViewDelegate,RYAnswerSheetDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,RYBillboardViewDelegate>
{
    CXBrowserNavBarView *navBarView;
    BOOL                showButtomView;    // 用于判断 点击下载pdf文件
}
@property (strong, nonatomic)  UIScrollView     *scrollView;
@property (strong, nonatomic)  UIWebView        *webView;


@property (strong, nonatomic)  UIButton         *sourceButton;             // 作者 按钮
@property (strong, nonatomic)  UILabel          *dateLabel;                // 日期
@property (strong, nonatomic)  UILabel          *bodeyTitleLabel;          // 文章标题
@property (strong, nonatomic)  UIView           *topTextDemarcation;       // 作者的背景


@property (strong, nonatomic)  RYAnswerSheet    *answerSheet;              // 答题 view

@property (strong, nonatomic)  RYArticleData    *articleData;
@property (nonatomic, strong)  NSMutableArray   *photoDataSource;
@property (nonatomic, strong)  NSArray          *imageSourceArray;

@property (nonatomic, assign)  CGFloat          webViewHeight;

@property (nonatomic, strong)  CXPhotoBrowser   *browser;

@property (nonatomic, strong)  RYBillboardView  *billboardView;      // top 答题或分享的提示页
@property (nonatomic, strong)  UIButton         *billboardLucencyBtn;// 答题和分享提示页出现时的透明背景
@property (nonatomic, strong)  NSMutableDictionary *billboardDict;   // 答题和分享提示页的数据

// 收藏和分享
@property (nonatomic, strong)   UIButton         *stowButton;       // 收藏按钮
@property (nonatomic, strong)   UIButton         *shareButton;      // 分享按钮

@property (nonatomic, strong)   RYShareSheet     *shareSheet;       // 分享
//@property (nonatomic, strong)   RYTokenView      *tokenView;        // 标签view

// 帖子id
@property (nonatomic, strong)   NSString         *tid;              // 帖子id
@property (nonatomic, assign)   BOOL             iscollect;         // 收藏ID 没有收藏时 此id 为0
@property (nonatomic, strong)   NSDictionary     *tagLibDict;       // 标签库

@property (nonatomic, strong)   NSDictionary     *questionsDict;    // 答题信息

@property (nonatomic, assign)   BOOL             isAward;           // 是否有奖转发

@property (nonatomic, strong)   UIView           *toobar;

@property (nonatomic, assign)   BOOL             isCanNnswer;       // 有答题权限


@end

@implementation RYArticleViewController

- (id)initWithTid:(NSString *)tid
{
    self = [super init];
    if ( self ) {
        self.tid = tid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"文章";
    showButtomView = YES;
    [self setup];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectStateChange:) name:@"collectStateChange" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIViewController *vc = [self.navigationController.viewControllers lastObject];
    if ( ![vc isKindOfClass:[RYCorporateHomePageViewController class]] ) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)collectStateChange:(NSNotification *)notice
//{
//    self.iscollect = YES;
//    [self.stowButton setImage:[UIImage imageNamed:@"ic_stow_highlighted.png"] forState:UIControlStateNormal];
//}

- (void)setup
{
    [self getBodyData];
    [self setupMainView];
}

- (void)setupMainView
{
    [self addTapOnWebView];
    self.webView.scrollView.scrollEnabled = NO;
    [self.scrollView addSubview:self.webView];
    [self.scrollView addSubview:self.topTextDemarcation];
    [self.topTextDemarcation addSubview:self.sourceButton];
    [self.topTextDemarcation addSubview:self.dateLabel];
    [self.scrollView addSubview:self.bodeyTitleLabel];
    [self.scrollView addSubview:self.answerSheet];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.toobar];
    [self.view addSubview:self.billboardLucencyBtn];
    [self.view addSubview:self.billboardView];
    
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)getBodyData
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
        [NetRequestAPI getArticleDetailWithSessionId:[RYUserInfo sharedManager].session
                                                 tid:self.tid
                                             success:^(id responseDic) {
                                                 NSLog(@"帖子 ：responseDic %@",responseDic);
                                                 [wSelf analysisDataWithDict:responseDic];
                                             } failure:^(id errorString) {
                                                 [wSelf showErrorView:wSelf.scrollView];
                                                 NSLog(@"帖子 ：errorString %@",errorString);
                                                 [SVProgressHUD dismiss];
                                             }];
    }else{
        [self showErrorView:self.scrollView];
    }
}

- (void)analysisDataWithDict:(NSDictionary *)responseDic
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        NSInteger  login = [meta getIntValueForKey:@"login" defaultValue:0];
        if ( login == 2 ) {  // login == 2 表示用户已过期 需要重新登录
            [RYUserInfo logout];
            __weak typeof(self) wSelf = self;
            [RYUserInfo automateLoginWithLoginSuccess:^(BOOL isSucceed) {
                // 自动登录一次
                if ( isSucceed ) { // 自动登录成功 刷新数据，
                    [wSelf getBodyData];
                }
                else{// 登录失败 打开登录界面 手动登录
                    [SVProgressHUD dismiss];
                    [wSelf openLoginVC];
                }
            } failure:^(id errorString) {
                [SVProgressHUD dismiss];
                [wSelf openLoginVC];
            }];
            return;
        }
        else{
            [SVProgressHUD dismiss];
            [self showErrorView:self.scrollView];
            return;
        }
    }
    [SVProgressHUD dismiss];
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    if ( !info ) {
        [self showErrorView:self.view];
        return;
    }
    [self removeErroeView];
    // 刷新 userinfo的数据
    NSDictionary *usermassage = [info getDicValueForKey:@"usermassage" defaultValue:nil];
    if ( usermassage ) {
        [[RYUserInfo sharedManager] refreshUserInfoDataWithDict:usermassage];
    }
    
    // 取收藏
    self.iscollect = [info getIntValueForKey:@"favoritemessage" defaultValue:0];
    
    // 系统标签
    NSMutableDictionary *tempTagsDict = [NSMutableDictionary dictionary];
    NSArray *tagsmessage = [info getArrayValueForKey:@"tagsmessage" defaultValue:nil];
    if (tagsmessage.count) {
        [tempTagsDict setObject:tagsmessage forKey:@"official"];
    }
    // 自定义标签
    NSArray *customTagsArray = [info getArrayValueForKey:@"favoritecatmessage" defaultValue:nil];
    if ( customTagsArray.count ) {
        [tempTagsDict setObject:customTagsArray forKey:@"custom"];
    }
    
    if ( tempTagsDict.allKeys.count ) {
        self.tagLibDict = tempTagsDict;
    }
    
    // 是否有奖转发
    self.isAward = [info getBoolValueForKey:@"spreadmessage" defaultValue:NO];
    
    // 取答题
    self.questionsDict = [info getDicValueForKey:@"questionsmessage" defaultValue:nil];
    // 是否有答题权限
    self.isCanNnswer = [self.questionsDict getBoolValueForKey:@"questions" defaultValue:NO];
    
    NSDictionary *dataDict = [info getDicValueForKey:@"threadmessage" defaultValue:nil];
    [self setBodDatayWithDict:dataDict];
}

- (void)setBodDatayWithDict:(NSDictionary *)dic
{
    if ( !dic ) {
        return;
    }
    self.articleData.author = [dic getStringValueForKey:@"author" defaultValue:@""];
    self.articleData.dateline = [dic getStringValueForKey:@"time" defaultValue:@""];
    self.articleData.message = [dic getStringValueForKey:@"message" defaultValue:@""];
    self.articleData.subject = [dic getStringValueForKey:@"subject" defaultValue:@""];
    self.articleData.isCompany = [dic getBoolValueForKey:@"ifcompany" defaultValue:NO];
    self.articleData.authorId = [dic getStringValueForKey:@"authorid" defaultValue:@""];
    self.articleData.slogan = [dic getStringValueForKey:@"slogan" defaultValue:@""];
    
    self.articleData.shareArticleUrl = [dic getStringValueForKey:@"spreadurl" defaultValue:@""];
    self.articleData.shareId = [dic getStringValueForKey:@"spid" defaultValue:@""];
    self.articleData.sharePicUrl = [dic getStringValueForKey:@"pic" defaultValue:@""];
    
    [self refreshMainView];
}

- (void)refreshMainView
{
    // 是否收藏
    if ( self.iscollect ) {
        [self.stowButton setImage:[UIImage imageNamed:@"ic_stow_highlighted.png"] forState:UIControlStateNormal];
    }
    else{
        [self.stowButton setImage:[UIImage imageNamed:@"ic_stow_normal.png"] forState:UIControlStateNormal];
    }
    self.topTextDemarcation.height = 35;
    if ( !self.isCanNnswer && !self.isAward) {  // 没有答题权限同时也没用转发
        self.topTextDemarcation.top = 0;
        self.billboardView.hidden = YES;
        self.billboardView.height = 0;
    }
    else{
        self.topTextDemarcation.top = 55;
        self.billboardView.hidden = NO;
        self.billboardView.height = 380;
        self.billboardView.top = -332;
        
        //设置 分享或答题 提示页的 数据
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        if ( self.isCanNnswer ) {
            [mutableDict setValue:@"阅读本文答对问题" forKey:@"topTitle"];
            NSString *jifen = [self.questionsDict getStringValueForKey:@"jifen" defaultValue:@""];
            [mutableDict setValue:[NSString stringWithFormat:@"奖励%@积分",jifen] forKey:@"jiangli"];
            [mutableDict setValue:@"(积分可以兑换服务／实物礼品)" forKey:@"duihuan"];
            [mutableDict setValue:[NSString stringWithFormat:@"由%@提供",self.articleData.author] forKey:@"zanzhu"];
            [mutableDict setValue:@"answer" forKey:@"type"];
            [mutableDict setValue:self.articleData.slogan forKey:@"slogan"];
        }
        else{
            [mutableDict setValue:@"分享本文" forKey:@"topTitle"];
            [mutableDict setValue:@"获得积分奖励" forKey:@"jiangli"];
            [mutableDict setValue:@"(阅读次数越多，获得奖励越多)" forKey:@"duihuan"];
            [mutableDict setValue:[NSString stringWithFormat:@"由%@提供",self.articleData.author] forKey:@"zanzhu"];
            [mutableDict setValue:@"share" forKey:@"type"];
            [mutableDict setValue:@"" forKey:@"slogan"];
        }
        self.billboardDict = mutableDict;
    }
    self.dateLabel.text = self.articleData.dateline;
    self.billboardView.dataDict = self.billboardDict;
    
    // 设置 作者名称
    NSDictionary *nameAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect nameRect = [self.articleData.author boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 95, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:nameAttributes
                                        context:nil];
    self.sourceButton.width = nameRect.size.width + 30;
    [self.sourceButton setTitle:self.articleData.author forState:UIControlStateNormal];
    
    // 设置标题
    NSDictionary *bodeyAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:21]};
    CGRect bodeyRect = [self.articleData.subject boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:bodeyAttributes
                                                            context:nil];
    self.bodeyTitleLabel.top = self.topTextDemarcation.bottom + 15;
    self.bodeyTitleLabel.height = bodeyRect.size.height;
    self.bodeyTitleLabel.text = self.articleData.subject;
    
    self.webView.top  = self.bodeyTitleLabel.bottom + 15;
    self.webView.height -= self.webView.top;

    //
    NSMutableString *htmlString = [NSMutableString stringWithFormat:@"<div id='webHeight' style=\"padding-left:7px;padding-right:7px;line-height:24px;\">%@</div>", self.articleData.message ];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://yimeiquan.cn"]];
//    UIEdgeInsets insets = self.webView.scrollView.contentInset;
//    insets.top = self.topTextDemarcation.bottom;
}

-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.webView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:self.webView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];
    if (urlToSave.length > 0 && self.imageSourceArray.count > 0) {
        NSInteger index = [self.imageSourceArray indexOfObject:urlToSave];
        [self.browser setInitialPageIndex:index];
        [self presentViewController:self.browser animated:YES completion:^{
        }];
    }
    else{
        return;
    }
}

- (UIButton *)stowButton
{
    if ( _stowButton == nil ) {
        _stowButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_stowButton setImage:[UIImage imageNamed:@"ic_stow_normal.png"] forState:UIControlStateNormal];
        [_stowButton addTarget:self action:@selector(stowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stowButton;
}

- (UIButton *)shareButton
{
    if ( _shareButton == nil ) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_shareButton setImage:[UIImage imageNamed:@"ic_share.png"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (RYShareSheet *)shareSheet
{
    if ( _shareSheet == nil ) {
        _shareSheet = [[RYShareSheet alloc] init];
        _shareSheet.viewController = self;
    }
    return _shareSheet;
}

//- (RYTokenView *)tokenView
//{
//    if ( _tokenView == nil ) {
//        _tokenView = [[RYTokenView alloc] initWithTokenDict:self.tagLibDict andArticleID:self.tid];
//    }
//    return _tokenView;
//}


- (RYArticleData *)articleData
{
    if ( _articleData == nil ) {
        _articleData = [[RYArticleData alloc] init];
    }
    return _articleData;
}

- (NSMutableArray *)photoDataSource
{
    if (_photoDataSource == nil) {
        _photoDataSource = [[NSMutableArray alloc] init];
    }
    return _photoDataSource;
}

- (CXPhotoBrowser *)browser
{
    if (_browser == nil) {
        _browser = [[CXPhotoBrowser alloc] initWithDataSource:self delegate:self];
    }
    return _browser;
}


- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}


- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40)];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.delegate = self;
//        _webView.layer.borderWidth = 1;
//        _webView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _webView;
}

- (UIButton *)sourceButton
{
    if ( _sourceButton == nil ) {
        _sourceButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _sourceButton.backgroundColor = [Utils getRGBColor:0x31 g:0x55 b:0x6b a:1.0];
        _sourceButton.height = 35;
        _sourceButton.left = 0;
        _sourceButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_sourceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sourceButton addTarget:self action:@selector(sourceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sourceButton;
}

- (UILabel *)dateLabel
{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.left = SCREEN_WIDTH - 15 - 80;;
        _dateLabel.height = 35;
        _dateLabel.width = 80;
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
    }
    return _dateLabel;
}

- (UILabel *)bodeyTitleLabel
{
    if (_bodeyTitleLabel == nil) {
        UILabel *bodeyTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        bodeyTitleLabel.width = SCREEN_WIDTH - 30;
        bodeyTitleLabel.left = 15;
        bodeyTitleLabel.numberOfLines = 0;
        bodeyTitleLabel.backgroundColor = [UIColor clearColor];
        bodeyTitleLabel.font = [UIFont boldSystemFontOfSize:21];
        bodeyTitleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        _bodeyTitleLabel = bodeyTitleLabel;
    }
    return _bodeyTitleLabel;
}

- (UIView *)topTextDemarcation
{
    if ( _topTextDemarcation == nil ) {
        _topTextDemarcation = [[UIView alloc] initWithFrame:CGRectZero];
        _topTextDemarcation.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
        _topTextDemarcation.left = 0;
        _topTextDemarcation.width = SCREEN_WIDTH;
    }
    return _topTextDemarcation;
}


- (UIView *)toobar
{
    if ( _toobar == nil ) {
        _toobar = [[UIView alloc] initWithFrame:CGRectZero];
        _toobar.backgroundColor = [UIColor whiteColor];
        _toobar.height = 40;
        _toobar.left = 0;
        _toobar.top = SCREEN_HEIGHT - 40;
        _toobar.width = SCREEN_WIDTH;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _toobar.width, 0.5)];
        line.backgroundColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0];
        [_toobar addSubview:line];
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 40, 40)];
        [backBtn setImage:[UIImage imageNamed:@"ic_back.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_toobar addSubview:backBtn];
        
        self.shareButton.right = SCREEN_WIDTH - 15;
        [_toobar addSubview:self.shareButton];
        
        self.stowButton.right = SCREEN_WIDTH - 70;
        [_toobar addSubview:self.stowButton];
    }
    
    return _toobar;
}

- (void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (RYAnswerSheet *)answerSheet
{
    if ( _answerSheet == nil ) {
        // 取问题的id
        NSString *questionID = [self.questionsDict getStringValueForKey:@"id" defaultValue:nil];
        if ( [ShowBox isEmptyString:questionID] ) {
            self.questionsDict = nil;
        }
        _answerSheet = [[RYAnswerSheet alloc] initWithDataSource:self.questionsDict];
        _answerSheet.top = CGRectGetHeight(self.view.bounds);
        _answerSheet.hidden = YES;
        _answerSheet.delegate = self;
    }
    return _answerSheet;
}

- (RYBillboardView *)billboardView
{
    if ( _billboardView == nil ) {
        _billboardView = [[RYBillboardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 380)];
        _billboardView.hidden = YES;
        _billboardView.delegate = self;
    }
    return _billboardView;
}

- (UIButton *)billboardLucencyBtn
{
    if ( _billboardLucencyBtn == nil ) {
        _billboardLucencyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _billboardLucencyBtn.left = 0;
        _billboardLucencyBtn.top = 0;
        _billboardLucencyBtn.width = SCREEN_WIDTH;
        [_billboardLucencyBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [_billboardLucencyBtn addTarget:self action:@selector(billboardLucencyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _billboardLucencyBtn;
}

- (NSMutableDictionary *)billboardDict
{
    if ( _billboardDict == nil ) {
        _billboardDict = [NSMutableDictionary dictionary];
    }
    return _billboardDict;
}

#pragma mark RYAnswerSheetDelegate
- (void)submitAnawerDidFinish
{
    [self getBodyData];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //调整文字大小
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",(long)[GlobleModel sharedInstance].bodyFontSize];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    //适配图片大小
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth,oldheight;"
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "oldwidth = myimg.width;"
     "myimg.width = oldwidth/2 - 17;"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    //获取当前网页所有图片
    NSString *imageURLString = [webView stringByEvaluatingJavaScriptFromString:@"(function() {var images=document.querySelectorAll(\"img\");var imageUrls=[];[].forEach.call(images, function(el) { imageUrls[imageUrls.length] = el.src;}); return JSON.stringify(imageUrls);})()"];
    NSError *jsonError = nil;
    NSArray *imageUrlsArray = [NSJSONSerialization JSONObjectWithData:[imageURLString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonError];
    
    if (imageUrlsArray.count > 0) {
        for (int i = 0; i < [imageUrlsArray count]; i++)
        {
            NSURL *imgURL = [NSURL URLWithString:[imageUrlsArray objectAtIndex:i]];
            CXPhoto *photo = [[CXPhoto alloc] initWithURL:imgURL];
            
            [self.photoDataSource addObject:photo];
        }
        self.imageSourceArray = imageUrlsArray;
    }
    CGFloat topLayoutGuide = 0.0;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        topLayoutGuide = 20.0;
        if (self.navigationController && !self.navigationController.navigationBarHidden) {
            topLayoutGuide += self.navigationController.navigationBar.frame.size.height;
        }
    }
    
    NSString *htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"webHeight\").offsetHeight;"];
    self.webViewHeight = htmlHeight.integerValue;
    
    // 取问题的id
    NSString *questionID = [self.questionsDict getStringValueForKey:@"id" defaultValue:nil];
    if ( ![ShowBox isEmptyString:questionID] ) { // 有答题
        if ( showButtomView ) {
            self.answerSheet.dataDict = self.questionsDict;
            self.answerSheet.hidden = NO;
            self.answerSheet.height = [self.answerSheet getAnswerSheetHeight];
            self.answerSheet.thid = self.tid;
        }
        else{
            self.answerSheet.height = 0;
            self.answerSheet.hidden = YES;
        }
    }
    else{
        self.answerSheet.height = 0;
        self.answerSheet.hidden = YES;
    }
   
    self.answerSheet.top = self.webViewHeight + self.bodeyTitleLabel.bottom + 15;
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    scrollViewContentSize.height = self.webViewHeight + self.bodeyTitleLabel.bottom + 25 + self.answerSheet.height;
    self.scrollView.contentSize = scrollViewContentSize ;
    self.webView.height = self.webViewHeight + self.answerSheet.height + self.bodeyTitleLabel.bottom + 25;
 }

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"request :: %@",request.URL);
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString * requesturl = request.URL.absoluteString;
        if ([requesturl rangeOfString:@"mod=image"].location != NSNotFound
            ||[requesturl rangeOfString:@".jpg"].location != NSNotFound) {
            return NO;
        }
        //非这个域名的url使用safari打开
        if ([requesturl rangeOfString:@"yimeiquan.cn"].location == NSNotFound) {
            NSURL *openUrl = [NSURL URLWithString:requesturl];
            if (openUrl) {
                [[UIApplication sharedApplication] openURL:openUrl];
            }
            return NO;
        }
        else{
            showButtomView = NO;
        }
        
    } else if (navigationType == UIWebViewNavigationTypeOther) {
        NSURL *url = request.URL;
        if ([[url scheme] isEqualToString:@"ready"]) {
            float contentHeight = [[url host] floatValue];
            NSLog(@"contentHeight:%f",contentHeight);
            return NO;
        }
    }
    return YES;
}

// 观察者。 观察self.scrollView和self.webView的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize  size = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
        if (size.height > 0) {
            CGSize scrollViewContentSize = self.scrollView.contentSize;
//            scrollViewContentSize.height = size.height + self.originalBtn.bottom;
//             scrollViewContentSize.height = size.height + self.topTextDemarcation.bottom;
            self.scrollView.contentSize = scrollViewContentSize;
            self.webView.height = size.height;
        }
    }
}


#pragma mark - CXPhotoBrowserDataSource
- (NSUInteger)numberOfPhotosInPhotoBrowser:(CXPhotoBrowser *)photoBrowser
{
    return [self.photoDataSource count];
}
- (id <CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photoDataSource.count)
        return [self.photoDataSource objectAtIndex:index];
    return nil;
}
- (BOOL)supportReload
{
    return YES;
}
// 浏览全图 完成按钮的点击事件
- (void)photoBrowserDidTapDoneButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 设置 完成 按钮
- (CXBrowserNavBarView *)browserNavigationBarViewOfOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = size;
    if (!navBarView)
    {
        navBarView = [[CXBrowserNavBarView alloc] initWithFrame:frame];
        
        [navBarView setBackgroundColor:[UIColor clearColor]];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.]];
        [doneButton setTitle:NSLocalizedString(@"完成",@"Dismiss button title") forState:UIControlStateNormal];
        [doneButton setFrame:CGRectMake(size.width - 60, 20, 40, 25)];
        [doneButton addTarget:self action:@selector(photoBrowserDidTapDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton.layer setMasksToBounds:YES];
        [doneButton.layer setCornerRadius:4.0];
        [doneButton.layer setBorderWidth:1.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
        [doneButton.layer setBorderColor:colorref];
        doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [navBarView addSubview:doneButton];
        
        UIView  * titleView = [[UIView alloc] initWithFrame:CGRectMake((size.width - 100)/2, 0, 100, size.height)];
        titleView.backgroundColor = [UIColor clearColor];
        [navBarView addSubview:titleView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFrame:CGRectMake(0, 20, 100, 20)];
//        [titleLabel setCenter:navBarView.center];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:20.]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [titleLabel setTag:BROWSER_TITLE_LBL_TAG];
        [titleView addSubview:titleLabel];
    }
    return navBarView;
}
#pragma mark - CXPhotoBrowserDelegate

- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    UILabel *titleLabel = (UILabel *)[navBarView viewWithTag:BROWSER_TITLE_LBL_TAG];
    if (titleLabel)
    {
        titleLabel.text = [NSString stringWithFormat:@"%u of %lu", index+1, (unsigned long)photoBrowser.photoCount];
    }
}

// 加载图片成功或失败
- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didFinishLoadingWithCurrentImage:(UIImage *)currentImage
{
    if (currentImage) {
        //loading success
    }
    else {
        //loading failure
    }
}
- (void)sourceButtonClick:(id)sender
{
    NSLog(@"直达号");
    if ( self.articleData.isCompany ) {
        RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] initWithCorporateID:self.articleData.authorId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)shareButtonClick:(id)sender
{
    NSLog(@"分享");
    if ( [ShowBox isEmptyString:self.articleData.subject] ) {
        return;
    }
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    [tempDict setValue:self.articleData.shareArticleUrl forKey:SHARE_URL];
    [tempDict setValue:self.articleData.subject forKey:SHARE_TEXT];
    [tempDict setValue:self.articleData.shareId forKey:SHARE_CALLBACK_DI];
    [tempDict setValue:self.articleData.sharePicUrl forKey:SHARE_PIC];
    [tempDict setValue:self.tid forKey:SHARE_TID];
    
    self.shareSheet.shareDataDict = tempDict;
    self.shareSheet.delegate = self;

    [self.shareSheet showShareView];
}


- (void)stowButtonClick:(id)sender
{
    NSLog(@"收藏");
    if ( [ShowBox isLogin] ) {
        if ( self.iscollect  ) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定取消收藏" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 9090;
            [alertView show];
        }
        else{
//            [self.view addSubview:self.tokenView];
//            [self.tokenView showTokenView];
            __weak typeof(self) wSelf = self;
            [NetRequestAPI additionCollectWithSessionId:[RYUserInfo sharedManager].session
                                                   thid:self.tid
                                                   tags:nil
                                                success:^(id responseDic) {
                                                    NSLog(@"添加收藏 responseDic : %@",responseDic);
                                                    [wSelf collectWithDict:responseDic];
                                                } failure:^(id errorString) {
                                                    //        NSLog(@"添加收藏 errorString :%@",errorString);
                                                    [ShowBox showError:@"收藏失败，请稍候重试"];
                                                }];
            
        }
    }
    else{
        [self openLoginVC];
    }

}

- (void)collectWithDict:(NSDictionary *)responseDic
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"收藏失败，请稍候重试"]];
        return;
    }
    self.iscollect = YES;
    [self.stowButton setImage:[UIImage imageNamed:@"ic_stow_highlighted.png"] forState:UIControlStateNormal];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == 9090 ) {
        // 取消收藏
        if ( buttonIndex == 1 ) {
            __weak typeof(self) wSelf = self;
            [NetRequestAPI cancelCollectWithSessionId:[RYUserInfo sharedManager].session
                                                 thid:self.tid
                                              success:^(id responseDic) {
                                                  NSLog(@"取消收藏responseDic : %@",responseDic);
                                                  [wSelf cancelCollectWithDict:responseDic];
                
            } failure:^(id errorString) {
                NSLog(@"取消收藏 errorString : %@",errorString);
                [ShowBox showError:@"取消收藏失败，请稍候重试"];
            }];
        }
}}

- (void)cancelCollectWithDict:(NSDictionary *)responseDic
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"取消收藏失败，请稍候重试"]];
        return;
    }
    self.iscollect = NO;
    [self.stowButton setImage:[UIImage imageNamed:@"ic_stow_normal.png"] forState:UIControlStateNormal];
    
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if ( offsetY >= 50 ) {
        offsetY = 50;
    }
    
    if ( offsetY <= 0 ) {
        offsetY = 0;
    }
    self.billboardView.top = -332 - offsetY;
}

#pragma mark RYBillboardViewDelegate
-(void)bottomBtnClickIsShow:(BOOL)isShow
{
    CGFloat   height;
    if ( isShow ) {
        height = 0;
        self.billboardLucencyBtn.height = SCREEN_HEIGHT;
    }
    else{
        height = -332;
        self.billboardLucencyBtn.height = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.billboardView.top = height;
    } completion:^(BOOL finished) {
        
    }];
}

// 立即转发按钮的点击
- (void)billboardViewShareBtnDidCilck:(id)sender
{
    [self shareButtonClick:sender];
}

#pragma mark RYBillboardView弹出时  背景点击
- (void)billboardLucencyBtnClick:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        self.billboardView.top = -332;
    } completion:^(BOOL finished) {
        [self.billboardView.bottomBtn setSelected:NO];
        self.billboardLucencyBtn.height = 0;
    }];
}


#pragma mark 打开登录界面重现登录
- (void)openLoginVC
{
    __weak typeof(self) wSelf = self;
    RYLoginViewController *nextVC = [[RYLoginViewController alloc] initWithFinishBlock:^(BOOL isLogin, NSError *error) {
        if ( isLogin ) {
            NSLog(@"登录完成");
            // 登录完成 重新获取数据
            [wSelf getBodyData];
        }
    }];
    [self.navigationController pushViewController:nextVC animated:YES];
}


@end
