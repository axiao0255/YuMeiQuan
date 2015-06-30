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
#import "RYTokenView.h"

#define BROWSER_TITLE_LBL_TAG 12731
@interface RYArticleViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate,CXPhotoBrowserDelegate,CXPhotoBrowserDataSource,RYShareSheetDelegate,UIAlertViewDelegate,RYAnswerSheetDelegate,UINavigationControllerDelegate>
{
    CXBrowserNavBarView *navBarView;
    BOOL                showButtomView;    // 用于判断 点击下载pdf文件
}
@property (strong, nonatomic)  UIScrollView     *scrollView;
@property (strong, nonatomic)  UIWebView        *webView;
//@property (strong, nonatomic)  UIImageView      *backgroundView;

@property (strong, nonatomic)  UIButton         *sourceButton;
@property (strong, nonatomic)  UILabel          *sourceLabel;
@property (strong, nonatomic)  UILabel          *dateLabel;
@property (strong, nonatomic)  UILabel          *bodeyTitleLabel;
@property (strong, nonatomic)  UIView           *topTextDemarcation;       // 标题与正文的分界
//@property (strong, nonatomic)  UIButton         *originalBtn;
@property (strong, nonatomic)  UIButton         *textShareButton;          // 正文 头的分享 按钮

//@property (strong, nonatomic)  UIView           *buttomView;

@property (strong, nonatomic)  RYAnswerSheet    *answerSheet;              // 答题 view

@property (strong, nonatomic)  RYArticleData    *articleData;
@property (nonatomic, strong)  NSMutableArray   *photoDataSource;
@property (nonatomic, strong)  NSArray          *imageSourceArray;

@property (nonatomic, assign)  CGFloat          webViewHeight;

@property (nonatomic, strong)  CXPhotoBrowser   *browser;

// 收藏和分享
@property (nonatomic, strong)   UIButton         *stowButton; // 收藏按钮
@property (nonatomic, strong)   UIButton         *shareButton;// 分享按钮

@property (nonatomic, strong)   RYShareSheet     *shareSheet; // 分享
@property (nonatomic, strong)   RYTokenView      *tokenView;  // 标签view

// 帖子id
@property (nonatomic, strong)   NSString         *tid;        // 帖子id
@property (nonatomic, assign)   BOOL             iscollect;   // 收藏ID 没有收藏时 此id 为0
@property (nonatomic, strong)   NSDictionary     *tagLibDict; // 标签库

@property (nonatomic, strong)   NSDictionary     *questionsDict; // 答题信息

@property (nonatomic, assign)   BOOL             isAward;        // 是否有奖转发

@property (nonatomic, strong)   UIView           *toobar;


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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectStateChange:) name:@"collectStateChange" object:nil];
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

- (void)collectStateChange:(NSNotification *)notice
{
    self.iscollect = YES;
    [self.stowButton setImage:[UIImage imageNamed:@"ic_stow_highlighted.png"] forState:UIControlStateNormal];
}

- (void)setup
{
    [self getBodyData];
    [self setupMainView];
//    [self setNavigationItem];
}

- (void)setNavigationItem
{
    UIBarButtonItem *stowItem = [[UIBarButtonItem alloc] initWithCustomView:self.stowButton];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    self.navigationItem.rightBarButtonItems = @[shareItem,stowItem];
}

- (void)setupMainView
{
    [self addTapOnWebView];
//    [self.view addSubview:self.backgroundView];
    self.webView.scrollView.scrollEnabled = NO;
    [self.scrollView addSubview:self.webView];
    [self.scrollView addSubview:self.textShareButton];
    [self.scrollView addSubview:self.sourceLabel];
    [self.scrollView addSubview:self.dateLabel];
    [self.scrollView addSubview:self.bodeyTitleLabel];
    [self.scrollView addSubview:self.sourceButton];
//    [self.scrollView addSubview:self.originalBtn];
    [self.scrollView addSubview:self.topTextDemarcation];
//    [self.scrollView addSubview:self.buttomView];
    [self.scrollView addSubview:self.answerSheet];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.toobar];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)getBodyData
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getArticleDetailWithSessionId:[RYUserInfo sharedManager].session
                                                 tid:self.tid
                                             success:^(id responseDic) {
                                                 NSLog(@"帖子 ：responseDic %@",responseDic);
                                                 [wSelf analysisDataWithDict:responseDic];
                                             } failure:^(id errorString) {
                                                 [ShowBox showError:@"网络"];
                                                 NSLog(@"帖子 ：errorString %@",errorString);
                                             }];
    }
}

- (void)analysisDataWithDict:(NSDictionary *)responseDic
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
            [RYUserInfo logout];
            RYLoginViewController *nextVC = [[RYLoginViewController alloc] initWithFinishBlock:^(BOOL isLogin, NSError *error) {
                if ( isLogin ) {
                    NSLog(@"登录完成");
                    // 登录完成 重新获取数据
                    [self getBodyData];
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
    
//    // 取 文章内容
//    NSArray *threadmessage = [info getArrayValueForKey:@"threadmessage" defaultValue:nil];
//    if ( !threadmessage.count ) {
//        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"获取数据失败，请稍候重试"]];
//        return;
//    }
    NSDictionary *dataDict = [info getDicValueForKey:@"threadmessage" defaultValue:nil];
    [self setBodDatayWithDict:dataDict];
}

- (void)setBodDatayWithDict:(NSDictionary *)dic
{
    if ( !dic ) {
        return;
    }
    
    // 是否收藏
    if ( self.iscollect ) {
         [self.stowButton setImage:[UIImage imageNamed:@"ic_stow_highlighted.png"] forState:UIControlStateNormal];
    }
    else{
        [self.stowButton setImage:[UIImage imageNamed:@"ic_stow_normal.png"] forState:UIControlStateNormal];
    }
    
    self.articleData.author = [dic getStringValueForKey:@"author" defaultValue:@""];
    self.articleData.dateline = [dic getStringValueForKey:@"time" defaultValue:@""];
    self.articleData.message = [dic getStringValueForKey:@"message" defaultValue:@""];
    self.articleData.subject = [dic getStringValueForKey:@"subject" defaultValue:@""];
    self.articleData.isCompany = [dic getBoolValueForKey:@"ifcompany" defaultValue:NO];
    self.articleData.authorId = [dic getStringValueForKey:@"authorid" defaultValue:@""];
    
    self.articleData.shareArticleUrl = [dic getStringValueForKey:@"spreadurl" defaultValue:@""];
    self.articleData.shareId = [dic getStringValueForKey:@"spid" defaultValue:@""];
    self.articleData.sharePicUrl = [dic getStringValueForKey:@"pic" defaultValue:@""];
    
    [self refreshMainView];
}

- (void)refreshMainView
{
    self.bodeyTitleLabel.text = self.articleData.subject;
    
    self.sourceLabel.text = self.articleData.author;
    self.dateLabel.text = [NSString stringWithFormat:@"%@",self.articleData.dateline];
    
    // 是否显示有奖转发
    if ( self.isAward ) {
        self.textShareButton.height = 35;
    }else{
        self.textShareButton.height = 0;
    }
    
    CGSize size =  [self.articleData.subject sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(300, MAXFLOAT)];
    self.bodeyTitleLabel.text = self.articleData.subject;
    self.bodeyTitleLabel.height = size.height;
    self.bodeyTitleLabel.top = self.textShareButton.bottom + 8;
    self.sourceLabel.top = self.bodeyTitleLabel.bottom + 8;
    self.dateLabel.top = self.bodeyTitleLabel.bottom + 8;
    self.sourceButton.top = self.bodeyTitleLabel.bottom;
//    self.originalBtn.top = self.sourceLabel.bottom;
    self.topTextDemarcation.top = self.dateLabel.bottom + 8;
//    self.webView.top = self.originalBtn.bottom;
    self.webView.top = self.topTextDemarcation.bottom;
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
    NSLog(@"点击");
    
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
//        [_stowButton setImage:[UIImage imageNamed:@"ic_stow_highlighted.png"] forState:UIControlStateHighlighted];
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
    }
    return _shareSheet;
}

- (RYTokenView *)tokenView
{
    if ( _tokenView == nil ) {
        _tokenView = [[RYTokenView alloc] initWithTokenDict:self.tagLibDict andArticleID:self.tid];
    }
    return _tokenView;
}


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
//        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40)];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}


- (UIWebView *)webView
{
    if (_webView == nil) {
//        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40)];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.delegate = self;
//        _webView.layer.borderWidth = 1;
//        _webView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _webView;
}

//- (UIImageView *)backgroundView
//{
//    if (_backgroundView == nil) {
//        UIImage *image = [UIImage imageNamed:@"body_bg"];
//        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//        _backgroundView = [[UIImageView alloc] initWithImage:image];
//        _backgroundView.frame = self.view.bounds;
//    }
//    return _backgroundView;
//}

- (UIButton *)sourceButton
{
    if ( _sourceButton == nil ) {
        _sourceButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _sourceButton.backgroundColor = [UIColor clearColor];
        _sourceButton.width = 130;
        _sourceButton.height = 20;
        _sourceButton.left = SCREEN_WIDTH - 130 - 15;
        [_sourceButton addTarget:self action:@selector(sourceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sourceButton;
}

- (UILabel *)sourceLabel
{
    if (_sourceLabel == nil) {
        _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sourceLabel.left = SCREEN_WIDTH - 130 - 15;
        _sourceLabel.height = 12;
        _sourceLabel.width = 130;
        _sourceLabel.textAlignment = NSTextAlignmentRight;
        _sourceLabel.backgroundColor = [UIColor clearColor];
        _sourceLabel.font = [UIFont systemFontOfSize:12];
        _sourceLabel.textColor = [Utils getRGBColor:0x00 g:0xc3 b:0x8c a:1.0];
    }
    return _sourceLabel;
}

- (UILabel *)dateLabel
{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.left = 15;
        _dateLabel.height = 12;
        _dateLabel.width = 130;
        _dateLabel.backgroundColor = [UIColor clearColor];
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
        bodeyTitleLabel.top = 10;
        bodeyTitleLabel.numberOfLines = 2;
        bodeyTitleLabel.backgroundColor = [UIColor clearColor];
        bodeyTitleLabel.font = [UIFont boldSystemFontOfSize:18];
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
        _topTextDemarcation.height = 8;
    }
    return _topTextDemarcation;
}

- (UIButton *)textShareButton
{
    if ( _textShareButton == nil ) {
        _textShareButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _textShareButton.left = 15;
        _textShareButton.top = 3;
        _textShareButton.width = SCREEN_WIDTH - 30;
        [_textShareButton setImage:[UIImage imageNamed:@"ic_textShare.png"] forState:UIControlStateNormal];
        [_textShareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textShareButton;
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
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 30)];
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


//- (UIButton *)originalBtn
//{
//    if (_originalBtn == nil) {
//        _originalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _originalBtn.width = 80;
//        _originalBtn.backgroundColor = [UIColor redColor];
//        _originalBtn.height = 40;
//        _originalBtn.right = self.view.width - 10;
//        [_originalBtn setTitle:@"阅读原文>>" forState:UIControlStateNormal];
//        _originalBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_originalBtn addTarget:self action:@selector(clickOriginalBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [_originalBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    }
//    return _originalBtn;
//}

//- (UIView *)buttomView
//{
//    if (_buttomView == nil) {
//        _buttomView = [[UIView alloc]initWithFrame:CGRectZero];
//        _buttomView.backgroundColor = [UIColor orangeColor];
//        _buttomView.width = 300;
//        _buttomView.left = 10;
//        _buttomView.height = 200;
//        _buttomView.top = CGRectGetHeight(self.view.bounds);
//        _buttomView.hidden = YES;
//    }
//    return _buttomView;
//}

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

#pragma mark RYAnswerSheetDelegate
- (void)submitAnawerDidFinish
{
    [self getBodyData];
}

- (void)clickOriginalBtn:(id)sender {
//    NSString *requestStr = [NSString stringWithFormat:@"http://yimeiquan.cn/thread-%@-1-1.html",self.newsColumnModel.tid];
//    NSURL *openUrl = [NSURL URLWithString:requestStr];
//    if (openUrl) {
//        [[UIApplication sharedApplication] openURL:openUrl];
//    }
    NSLog(@"阅读原文");
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
   
    self.answerSheet.top = self.webViewHeight + self.topTextDemarcation.bottom;
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    scrollViewContentSize.height = self.webViewHeight + self.topTextDemarcation.bottom + self.answerSheet.height;
    self.scrollView.contentSize = scrollViewContentSize ;
    self.webView.height = self.webViewHeight + self.answerSheet.height + self.topTextDemarcation.bottom;
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
            self.scrollView.contentSize = scrollViewContentSize ;
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
        titleLabel.text = [NSString stringWithFormat:@"%lu of %lu", index+1, (unsigned long)photoBrowser.photoCount];
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
            [self.view addSubview:self.tokenView];
            [self.tokenView showTokenView];
        }
    }
    else{
        RYLoginViewController *nextVC = [[RYLoginViewController alloc] initWithFinishBlock:^(BOOL isLogin, NSError *error) {
            if ( isLogin ) {
                NSLog(@"登录完成");
                [self getBodyData]; // 登录之后重新 刷新数据
            }
        }];
        
        [self.navigationController pushViewController:nextVC animated:YES];
    }

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
    if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
        [ShowBox showError:@"取消收藏失败，请稍候重试"];
        return;
    }
    
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    if ( meta == nil ) {
        [ShowBox showError:@"取消收藏失败，请稍候重试"];
        return;
    }
    
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"取消收藏失败，请稍候重试"]];
        return;
    }
    self.iscollect = NO;
    [self.stowButton setImage:[UIImage imageNamed:@"ic_stow_normal.png"] forState:UIControlStateNormal];
    
}

@end
