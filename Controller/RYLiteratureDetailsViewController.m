//
//  RYLiteratureDetailsViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/25.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYLiteratureDetailsViewController.h"

#import "CXPhotoBrowser.h"
#import "RYArticleData.h"
#import "CXPhoto.h"
#import "GlobleModel.h"
#import "RYCorporateHomePageViewController.h"

#import "RYShareSheet.h"
#import "RYTokenView.h"
#import "RYCopyAddressView.h"
#import "RYcommentDetailsViewController.h"

#define BROWSER_TITLE_LBL_TAG 12731
@interface RYLiteratureDetailsViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate,CXPhotoBrowserDelegate,CXPhotoBrowserDataSource,RYShareSheetDelegate>

{
    CXBrowserNavBarView *navBarView;
    BOOL                showButtomView;    // 用于判断 点击下载pdf文件
    UILabel             *addressLabel;
    UILabel             *passwordLabel;
}
@property (strong, nonatomic)  UIScrollView     *scrollView;
@property (strong, nonatomic)  UIWebView        *webView;

@property (strong, nonatomic)  UILabel          *bodeyTitleLabel;         // 标题
@property (strong, nonatomic)  UILabel          *subheadLabel;            // 副标题
@property (strong, nonatomic)  UILabel          *authorLabel;             // 作者
@property (strong, nonatomic)  UILabel          *periodicalLabel;         // 期刊
@property (strong, nonatomic)  UILabel          *dateLabel;               // 日期
@property (strong, nonatomic)  UILabel          *DOILabel;                // DOI

@property (strong, nonatomic)  UIView           *topTextDemarcation;       // 标题与正文的分界

@property (strong, nonatomic)  UIButton         *textShareButton;          // 正文 头的分享 按钮

@property (strong, nonatomic)  RYArticleData    *articleData;
@property (nonatomic, strong)  NSMutableArray   *photoDataSource;
@property (nonatomic, strong)  NSArray          *imageSourceArray;

@property (nonatomic, assign)  CGFloat          webViewHeight;

@property (nonatomic, strong)  CXPhotoBrowser   *browser;

@property (nonatomic, strong)  UIImageView       *lookOriginalView;  // 查看原文 view
@property (nonatomic, strong)  UILabel           *lookOriginalLabel;  // 查看原文提示框
@property (nonatomic, strong)  RYCopyAddressView *ryCopyView;        // copy 原文地址
@property (nonatomic, strong)  UIView            *hintCoverView ;    //提示 view
@property (nonatomic, strong)  UILabel           *hintCoverLabel;    // 提示框

// 收藏和分享
@property (nonatomic, strong)   UIButton         *stowButton; // 收藏按钮
@property (nonatomic, strong)   UIButton         *shareButton;// 分享按钮
@property (nonatomic, strong)   UIButton         *commentButton;// 评论按钮

@property (nonatomic, strong)   RYShareSheet     *shareSheet; // 分享
@property (nonatomic, strong)   RYTokenView      *tokenView;  // 标签view


// 帖子id
@property (nonatomic, strong)   NSString         *tid;        // 帖子id
@property (nonatomic, assign)   BOOL             iscollect;   // 收藏ID 没有收藏时 此id 为0
@property (nonatomic, strong)   NSDictionary     *tagLibDict; // 标签库

@property (nonatomic, assign)   BOOL             isAward;        // 是否有奖转发




@property (nonatomic, strong)   UIView            *toobar;    // 下边工具条

@end

@implementation RYLiteratureDetailsViewController

- (id)initWithTid:(NSString *)tid
{
    self = [super init];
    if ( self ) {
        self.tid = tid;
    }
#warning 53 为测试数据  应删除
    //    self.tid = @"53";
    return self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    showButtomView = YES;
    [self setup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectStateChange:) name:@"collectStateChange" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)collectStateChange:(NSNotification *)notice
{
    self.iscollect = YES;
    [self.stowButton setImage:[UIImage imageNamed:@"ic_stow_highlighted.png"] forState:UIControlStateNormal];
}

- (void)setup
{
    [self setupMainView];
    [self getBodyData];
//    [self setNavigationItem];
}

//- (void)setNavigationItem
//{
//    UIBarButtonItem *stowItem = [[UIBarButtonItem alloc] initWithCustomView:self.stowButton];
//    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
//    self.navigationItem.rightBarButtonItems = @[shareItem,stowItem];
//}

- (void)setupMainView
{
    // 添加手势
    [self addTapOnWebView];
    
   
    self.webView.scrollView.scrollEnabled = NO;
    [self.scrollView addSubview:self.webView];
    [self.scrollView addSubview:self.textShareButton];
    [self.scrollView addSubview:self.bodeyTitleLabel];
    [self.scrollView addSubview:self.subheadLabel];
    [self.scrollView addSubview:self.authorLabel];
    [self.scrollView addSubview:self.periodicalLabel];
    [self.scrollView addSubview:self.dateLabel];
    [self.scrollView addSubview:self.DOILabel];
    [self.scrollView addSubview:self.topTextDemarcation];
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
    
    // 取 文章内容
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

    self.articleData.author = [dic getStringValueForKey:@"doiauthor" defaultValue:@""];
    self.articleData.dateline = [dic getStringValueForKey:@"doidate" defaultValue:@""];
    self.articleData.message = [dic getStringValueForKey:@"message" defaultValue:@""];
    self.articleData.subject = [dic getStringValueForKey:@"subject" defaultValue:@""];
    self.articleData.subhead = [dic getStringValueForKey:@"doititle" defaultValue:@""];
    self.articleData.periodical = [dic getStringValueForKey:@"doijournal" defaultValue:@""];
    self.articleData.DOI = [dic getStringValueForKey:@"doiresult" defaultValue:@""];
    self.articleData.originalAddress = [dic getStringValueForKey:@"doiurl" defaultValue:@""];
    self.articleData.password = [dic getStringValueForKey:@"doipassword" defaultValue:@""];
    self.articleData.isInquire = [dic getBoolValueForKey:@"doiqueryuid" defaultValue:NO];
    self.articleData.comment = [dic getStringValueForKey:@"comment" defaultValue:@""];
    self.articleData.check = [dic getStringValueForKey:@"check" defaultValue:@""];
    
    self.articleData.shareArticleUrl = [dic getStringValueForKey:@"spreadurl" defaultValue:@""];
    self.articleData.shareId = [dic getStringValueForKey:@"spid" defaultValue:@""];
    self.articleData.sharePicUrl = [dic getStringValueForKey:@"pic" defaultValue:@""];

    
    [self refreshMainView];
}

- (void)refreshMainView
{
    
    if ( [ShowBox isEmptyString:self.articleData.comment] ) {
        self.hintCoverView.hidden = YES;
    }
    else{
        self.hintCoverView.hidden = NO;
        self.hintCoverLabel.text = self.articleData.comment;
    }
    
    [self.view addSubview:self.hintCoverView];
    
    // 是否显示有奖转发
    if ( self.isAward ) {
        self.textShareButton.height = 35;
    }else{
        self.textShareButton.height = 0;
    }
    // 标题
    CGSize size =  [self.articleData.subject sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
    self.bodeyTitleLabel.text = self.articleData.subject;
    self.bodeyTitleLabel.height = size.height;
    self.bodeyTitleLabel.top = self.textShareButton.bottom + 6;
    // 副标题
    NSString *subhead = [NSString stringWithFormat:@"标题：%@",self.articleData.subhead];
    CGSize subheadSize = [subhead sizeWithFont:self.subheadLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
    self.subheadLabel.height = subheadSize.height;
    [self.subheadLabel setAttributedText:[Utils getAttributedString:subhead hightlightString:[subhead substringToIndex:3] hightlightColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0] andFont:self.subheadLabel.font]];
    self.subheadLabel.top = self.bodeyTitleLabel.bottom + 6;
    // 作者
    NSString *author = [NSString stringWithFormat:@"作者：%@",self.articleData.author];
    CGSize authorSize = [author sizeWithFont:self.authorLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
    self.authorLabel.height = authorSize.height;
    [self.authorLabel setAttributedText:[Utils getAttributedString:author hightlightString:[author substringToIndex:3] hightlightColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0] andFont:self.authorLabel.font]];
    self.authorLabel.top = self.subheadLabel.bottom + 6;
    // 期刊
    NSString *periodical = [NSString stringWithFormat:@"期刊：%@",self.articleData.periodical];
    CGSize periodicalSize = [periodical sizeWithFont:self.periodicalLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
    self.periodicalLabel.height = periodicalSize.height;
    [self.periodicalLabel setAttributedText:[Utils getAttributedString:periodical hightlightString:[periodical substringToIndex:3] hightlightColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0] andFont:self.periodicalLabel.font]];
    self.periodicalLabel.top = self.authorLabel.bottom + 6;
    // 日期
    NSString *date = [NSString stringWithFormat:@"日期：%@",self.articleData.dateline];
    CGSize dateSize = [date sizeWithFont:self.periodicalLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
    self.dateLabel.height = dateSize.height;
    [self.dateLabel setAttributedText:[Utils getAttributedString:date hightlightString:[date substringToIndex:3] hightlightColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0] andFont:self.dateLabel.font]];
    self.dateLabel.top = self.periodicalLabel.bottom + 6;
    // DOI
    NSString *doi = [NSString stringWithFormat:@"DOI：%@",self.articleData.DOI];
    CGSize doiSize = [doi sizeWithFont:self.periodicalLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
    self.DOILabel.height = doiSize.height;
    [self.DOILabel setAttributedText:[Utils getAttributedString:doi hightlightString:[doi substringToIndex:3] hightlightColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0] andFont:self.DOILabel.font]];
    self.DOILabel.top = self.dateLabel.bottom + 6;

    self.topTextDemarcation.top = self.DOILabel.bottom + 6;

    self.webView.top = self.topTextDemarcation.bottom;
    self.webView.height -= self.webView.top;
    
    NSMutableString *htmlString = [NSMutableString stringWithFormat:@"<div id='webHeight' style=\"padding-left:7px;padding-right:8px;line-height:24px;\">%@</div>", self.articleData.message ];
    //    NSString *webviewText = @"<style>body{margin:10;background-color:transparent;font:80px/18px Custom-Font-Name}</style>";
    //        NSString *htmlString = [webviewText stringByAppendingFormat:@"%@", self.bodyModel.message];
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

- (UIButton *)commentButton
{
    if ( _commentButton == nil ) {
        _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_commentButton setImage:[UIImage imageNamed:@"ic_comment.png"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
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
     }
    return _webView;
}

- (UILabel *)subheadLabel
{
    if ( _subheadLabel == nil ) {
        _subheadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subheadLabel.font = [UIFont systemFontOfSize:14];
        _subheadLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        _subheadLabel.left = 15;
        _subheadLabel.width = SCREEN_WIDTH - 30;
        _subheadLabel.numberOfLines = 0;
    }
    return _subheadLabel;
}

- (UILabel *)authorLabel
{
    if ( _authorLabel == nil ) {
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _authorLabel.font = [UIFont systemFontOfSize:14];
        _authorLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        _authorLabel.left = 15;
        _authorLabel.width = SCREEN_WIDTH - 30;
        _authorLabel.numberOfLines = 0;
    }
    return _authorLabel;
}

- (UILabel *)periodicalLabel
{
    if ( _periodicalLabel == nil ) {
        _periodicalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _periodicalLabel.font = [UIFont systemFontOfSize:14];
        _periodicalLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        _periodicalLabel.left = 15;
        _periodicalLabel.width = SCREEN_WIDTH - 30;
        _periodicalLabel.numberOfLines = 0;
    }
    return _periodicalLabel;
}

- (UILabel *)DOILabel
{
 
    if ( _DOILabel == nil ) {
        _DOILabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _DOILabel.font = [UIFont systemFontOfSize:14];
        _DOILabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        _DOILabel.left = 15;
        _DOILabel.width = SCREEN_WIDTH - 30;
        _DOILabel.numberOfLines = 0;
    }
    return _DOILabel;
}


- (UILabel *)dateLabel
{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.left = 15;
        _dateLabel.height = 11;
        _dateLabel.width = 200;
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont systemFontOfSize:14];
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
- (RYCopyAddressView *)ryCopyView
{
    if ( _ryCopyView == nil ) {
        _ryCopyView = [[RYCopyAddressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220) andArticleData:self.articleData];
        _ryCopyView.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
    }
    return _ryCopyView;
}

- (UIView *)hintCoverView
{
    if ( _hintCoverView == nil ) {
        _hintCoverView = [[UIView alloc] initWithFrame:self.view.bounds];
        _hintCoverView.backgroundColor = [UIColor clearColor];
        
        UIImageView *topCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 388)];
        topCoverView.backgroundColor = [Utils getRGBColor:0 g:0 b:0 a:0.56];
        [_hintCoverView addSubview:topCoverView];
        
        UIImageView *bottomCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 388, SCREEN_WIDTH, 388)];
        bottomCoverView.image = [UIImage imageNamed:@"ic_hintCover.png"];
        bottomCoverView.userInteractionEnabled = YES;
        [_hintCoverView addSubview:bottomCoverView];
        
        UIButton *dismissCoverBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80,0 , 50, 50)];
        dismissCoverBtn.backgroundColor = [UIColor clearColor];
        [dismissCoverBtn addTarget:self action:@selector(dismissCoverView:) forControlEvents:UIControlEventTouchUpInside];
        [bottomCoverView addSubview:dismissCoverBtn];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 80, 60, 180, 100)];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        self.hintCoverLabel = label;
        [bottomCoverView addSubview:label];
        
    }
    return _hintCoverView;
}

- (UIImageView *)lookOriginalView
{
    if ( _lookOriginalView == nil ) {
        _lookOriginalView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _lookOriginalView.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
        _lookOriginalView.image = [UIImage imageNamed:@"ic_mohu.jpg"];
        [_lookOriginalView setUserInteractionEnabled:YES];
        
        UIButton *lookOriginalBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-83/2, 65, 83, 83)];
        lookOriginalBtn.backgroundColor = [UIColor clearColor];
        [lookOriginalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [lookOriginalBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [lookOriginalBtn setTitle:@"获取" forState:UIControlStateNormal];
        [lookOriginalBtn setBackgroundImage:[UIImage imageNamed:@"ic_lookOriginal.png"] forState:UIControlStateNormal];
        [lookOriginalBtn addTarget:self action:@selector(lookOriginalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_lookOriginalView addSubview:lookOriginalBtn];
        
        self.lookOriginalLabel.top = lookOriginalBtn.bottom + 8;
        [_lookOriginalView addSubview:self.lookOriginalLabel];
    }
    return _lookOriginalView;
}

/**
 * 获取原文地址 提示框
 */
-(UIView *)lookOriginalLabel
{
    if ( _lookOriginalLabel == nil ) {
        _lookOriginalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _lookOriginalLabel.width = SCREEN_WIDTH;
        _lookOriginalLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        _lookOriginalLabel.textAlignment = NSTextAlignmentCenter;
        _lookOriginalLabel.height = 16;
        _lookOriginalLabel.font = [UIFont systemFontOfSize:16];
    }
    return _lookOriginalLabel;
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
        
        self.commentButton.right = SCREEN_WIDTH - 125;
        [_toobar addSubview:self.commentButton];
        
    }
    
    return _toobar;
}

- (void)lookOriginalBtnClick:(id)sender
{
    NSLog(@"点击查看原文地址");
    
    if ( [ShowBox checkCurrentNetwork] ) {
        
        __weak typeof(self) wSelf = self;
        if ( ![ShowBox isLogin] ) {
            RYLoginViewController *nextVC = [[RYLoginViewController alloc] initWithFinishBlock:^(BOOL isLogin, NSError *error) {
                if ( isLogin ) {
                    NSLog(@"登录完成");    // 重新获取数据
                    [wSelf getBodyData];  // 登录之后重新 刷新数据
                }
            }];
            [self.navigationController pushViewController:nextVC animated:YES];
            return;
        }
        
        [NetRequestAPI getShowDoiWithSessionId:[RYUserInfo sharedManager].session
                                           tid:self.tid
                                       success:^(id responseDic) {
                                           NSLog(@"获取原文权限 responseDic： %@",responseDic);
                                           [wSelf getLookResultWithDict:responseDic];
            
        } failure:^(id errorString) {
             NSLog(@"获取原文权限 errorString： %@",errorString);
            [ShowBox showError:@"网络出错，请稍候重试"];
        }];
    }
}

-(void)getLookResultWithDict:(NSDictionary *)responseDic
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"网络出错，请稍候重试"]];
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.lookOriginalView.frame = CGRectMake(0, 220, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [self.ryCopyView removeFromSuperview];
    [self.scrollView addSubview:self.ryCopyView];
    if ( showButtomView ) {
        self.ryCopyView.height = 220;
    }
    else{
        self.ryCopyView.height = 0;
    }
    
    // 判断是否有 查看原文地址的权限
    if (!self.articleData.isInquire) {
        self.lookOriginalView.hidden = NO;
    }
    else{
        self.lookOriginalView.hidden = YES;
    }
    self.lookOriginalView.frame = self.ryCopyView.bounds;
    self.lookOriginalLabel.text = self.articleData.check;
    [self.ryCopyView addSubview:self.lookOriginalView];
    
    self.ryCopyView.top = self.webViewHeight + self.topTextDemarcation.bottom;
    
    self.webView.height = self.webViewHeight + self.topTextDemarcation.bottom + self.ryCopyView.height;
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
//            scrollViewContentSize.height = size.height  + self.topTextDemarcation.bottom;
            scrollViewContentSize.height = size.height;
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
    RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)commentButtonClick:(id)sender
{
    NSLog(@"点击评论");
    RYcommentDetailsViewController *vc = [[RYcommentDetailsViewController alloc] initWithArticleData:self.articleData];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)dismissCoverView:(id)sender
{
    self.hintCoverView.hidden = YES;
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
