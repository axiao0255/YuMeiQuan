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
#import "HTCopyableLabel.h"

#import "RYShareSheet.h"
#import "RYTokenView.h"

#define BROWSER_TITLE_LBL_TAG 12731
@interface RYLiteratureDetailsViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate,CXPhotoBrowserDelegate,CXPhotoBrowserDataSource,RYShareSheetDelegate,HTCopyableLabelDelegate>

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

@property (strong, nonatomic)  UIView           *originalAddressView;       // 复制地址和密码 的view

@property (strong, nonatomic)  HTCopyableLabel  *showAddressLabel;          // 显示url
@property (strong, nonatomic)  HTCopyableLabel  *showPasswordLabel;         // 显示密码
@property (strong, nonatomic)  HTCopyableLabel  *copyAddressAndPassword;    // 复制原文地址和密码
@property (strong, nonatomic)  UILabel          *suggestLabel;              // 建议label

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

@end

@implementation RYLiteratureDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    showButtomView = YES;
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}


- (void)setup
{
    [self setupMainView];
    [self getBodyData];
    [self setNavigationItem];
}

- (void)setNavigationItem
{
    UIBarButtonItem *stowItem = [[UIBarButtonItem alloc] initWithCustomView:self.stowButton];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    self.navigationItem.rightBarButtonItems = @[shareItem,stowItem];
}

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
    [self.scrollView addSubview:self.originalAddressView];
    [self.view addSubview:self.scrollView];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)getBodyData
{
    NSString *url = @"http://yimeiquan.cn/forum.php?mod=viewthread&tid=1016575&page=1&mobile=2&yy=1";
    //    NSString *url = @"http://121.40.151.63/ios.php?mod=forum&uid=2&tid=12";
    __weak typeof(self) wSelf = self;
    [NetManager JSONDataWithUrl:url parameters:nil success:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        [wSelf setBodDatayWithDict:dic];
    } fail:^(id error) {
        NSLog(@"error : %@",error);
    }];
}

- (void)setBodDatayWithDict:(NSDictionary *)dic
{
    if ( !dic ) {
        return;
    }
    self.articleData.author = [dic getStringValueForKey:@"author" defaultValue:@""];
    self.articleData.dateline = [dic getStringValueForKey:@"dateline" defaultValue:@""];
    self.articleData.message = [dic getStringValueForKey:@"message" defaultValue:@""];
    self.articleData.subject = [dic getStringValueForKey:@"subject" defaultValue:@""];
    self.articleData.subhead = @"adsjkfhakjdhfasdkjfhsadjkhfsakjhdfkas";
    self.articleData.periodical = @"jshfghsjghsfjhgsdjghewowtywug";
    self.articleData.DOI = @"1233816875698423756";
    self.articleData.originalAddress = @"http://pan.baidu.com/s/1o6qUur4";
    self.articleData.password = @"3typ";
    
    [self refreshMainView];
}

- (void)refreshMainView
{
    self.textShareButton.height = 35;
    
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
    
    
    //
    NSMutableString *htmlString = [NSMutableString stringWithFormat:@"<div id='webHeight' style=\"padding-left:7px;padding-right:8px;line-height:24px;\">%@</div>", self.articleData.message ];
    //    NSString *webviewText = @"<style>body{margin:10;background-color:transparent;font:80px/18px Custom-Font-Name}</style>";
    //        NSString *htmlString = [webviewText stringByAppendingFormat:@"%@", self.bodyModel.message];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://yimeiquan.cn"]];
    UIEdgeInsets insets = self.webView.scrollView.contentInset;
    insets.top = self.topTextDemarcation.bottom;
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
        _stowButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_stowButton setImage:[UIImage imageNamed:@"ic_stow_normal.png"] forState:UIControlStateNormal];
        [_stowButton setImage:[UIImage imageNamed:@"ic_stow_highlighted.png"] forState:UIControlStateHighlighted];
        [_stowButton addTarget:self action:@selector(stowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stowButton;
}

- (UIButton *)shareButton
{
    if ( _shareButton == nil ) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
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
        NSArray *arr = @[@"护肤品成分",@"新闻",@"护肤品成分护肤品成分",@"lalala",@"唷唷唷唷"];
        _tokenView = [[RYTokenView alloc] initWithTokenArray:arr];
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
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}


- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
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

- (UIView *)originalAddressView
{
    if ( _originalAddressView == nil ) {
        _originalAddressView = [[UIView alloc] initWithFrame:CGRectZero];
        _originalAddressView.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
        _originalAddressView.left = 0;
        _originalAddressView.width = SCREEN_WIDTH;
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 8, SCREEN_WIDTH - 80, 12)];
        addressLabel.font = [UIFont systemFontOfSize:12];
        addressLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        addressLabel.text = @"原文地址";
        addressLabel.hidden = YES;
        [_originalAddressView addSubview:addressLabel];
        
        self.showAddressLabel.top = addressLabel.bottom + 8;
        [_originalAddressView addSubview:self.showAddressLabel];
        
        passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.showAddressLabel.bottom + 8, SCREEN_WIDTH - 80, 12)];
        passwordLabel.font = [UIFont systemFontOfSize:12];
        passwordLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        passwordLabel.text = @"密码";
        passwordLabel.hidden = YES;
        [_originalAddressView addSubview:passwordLabel];
        
        self.showPasswordLabel.top = passwordLabel.bottom + 8;
        [_originalAddressView addSubview:self.showPasswordLabel];
        
        self.copyAddressAndPassword.top = self.showPasswordLabel.bottom + 8;
        [_originalAddressView addSubview:self.copyAddressAndPassword];
        
        self.suggestLabel.top = self.copyAddressAndPassword.bottom + 8;
        [_originalAddressView addSubview:self.suggestLabel];
    }
    return _originalAddressView;
}

- (HTCopyableLabel *)showAddressLabel
{
    if ( _showAddressLabel == nil ) {
        _showAddressLabel = [[HTCopyableLabel alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 80, 40)];
        _showAddressLabel.copyableLabelDelegate = self;
        _showAddressLabel.backgroundColor = [UIColor whiteColor];
        _showAddressLabel.font = [UIFont systemFontOfSize:14];
        _showAddressLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        _showAddressLabel.layer.cornerRadius = 5;
        _showAddressLabel.layer.masksToBounds = YES;
        _showAddressLabel.hidden = YES;
    }
    return _showAddressLabel;
}

- (HTCopyableLabel *)showPasswordLabel
{
    if ( _showPasswordLabel == nil ) {
        _showPasswordLabel = [[HTCopyableLabel alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 80, 40)];
        _showPasswordLabel.copyableLabelDelegate = self;
        _showPasswordLabel.backgroundColor = [UIColor whiteColor];
        _showPasswordLabel.font = [UIFont systemFontOfSize:14];
        _showPasswordLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        _showPasswordLabel.layer.cornerRadius = 5;
        _showPasswordLabel.layer.masksToBounds = YES;
        _showPasswordLabel.hidden = YES;

    }
    return _showPasswordLabel;
}

- (HTCopyableLabel *)copyAddressAndPassword
{
    if ( _copyAddressAndPassword == nil ) {
        _copyAddressAndPassword = [[HTCopyableLabel alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 80, 40)];
        _copyAddressAndPassword.copyableLabelDelegate = self;
        _copyAddressAndPassword.backgroundColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
        _copyAddressAndPassword.textAlignment = NSTextAlignmentCenter;
        _copyAddressAndPassword.font = [UIFont boldSystemFontOfSize:18];
        _copyAddressAndPassword.textColor = [UIColor whiteColor];
        _copyAddressAndPassword.text = @"复制地址和密码";
        _copyAddressAndPassword.layer.cornerRadius = 5;
        _copyAddressAndPassword.layer.masksToBounds = YES;
        _copyAddressAndPassword.hidden = YES;
        
    }
    return _copyAddressAndPassword;
}

- (UILabel *)suggestLabel
{
    if ( _suggestLabel == nil ) {
        _suggestLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 80, 12)];
        _suggestLabel.font = [UIFont systemFontOfSize:12];
        _suggestLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        _suggestLabel.text = @"建议使用电脑设备浏览";
        _suggestLabel.textAlignment = NSTextAlignmentCenter;
        _suggestLabel.hidden = YES;
    }
    return _suggestLabel;
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
    if ( showButtomView ) {
        self.originalAddressView.hidden = NO;
        self.originalAddressView.height = 220;
        self.showAddressLabel.hidden = NO;
        self.showAddressLabel.text = [NSString stringWithFormat:@"   %@",self.articleData.originalAddress];
        self.showPasswordLabel.hidden = NO;
        self.showPasswordLabel.text = [NSString stringWithFormat:@"   %@",self.articleData.password];;

        
        self.copyAddressAndPassword.hidden = NO;
        self.suggestLabel.hidden = NO;
        addressLabel.hidden = NO;
        passwordLabel.hidden = NO;
    }
    else{
        self.originalAddressView.hidden = YES;
        self.originalAddressView.height = 0;
        self.showAddressLabel.hidden = YES;
        self.showPasswordLabel.hidden = YES;
        self.copyAddressAndPassword.hidden = YES;
        self.suggestLabel.hidden = YES;
        addressLabel.hidden = YES;
        passwordLabel.hidden = YES;
    }
    self.originalAddressView.top = self.webViewHeight + self.topTextDemarcation.bottom;
    
//    CGSize scrollViewContentSize = self.scrollView.contentSize;
//     scrollViewContentSize.height = self.webViewHeight + self.topTextDemarcation.bottom + self.originalAddressView.height;
//    self.scrollView.contentSize = scrollViewContentSize ;
    self.webView.height = self.webViewHeight + self.originalAddressView.height + self.topTextDemarcation.bottom - 100;
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
            scrollViewContentSize.height = size.height + self.topTextDemarcation.bottom;
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

#pragma mark - HTCopyableLabelDelegate

- (NSString *)stringToCopyForCopyableLabel:(HTCopyableLabel *)copyableLabel
{
    NSString *stringToCopy = @"";
    if ( copyableLabel == self.showAddressLabel ) {
        stringToCopy = self.articleData.originalAddress;
    }
    else if ( copyableLabel == self.showPasswordLabel ){
        stringToCopy = self.articleData.password;
    }
    else if (copyableLabel == self.copyAddressAndPassword){
        stringToCopy = [NSString stringWithFormat:@"%@ %@",self.articleData.originalAddress,self.articleData.password];
    }
    return stringToCopy;
}

//- (CGRect)copyMenuTargetRectInCopyableLabelCoordinates:(HTCopyableLabel *)copyableLabel
//{
//    
//}

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

- (void)stowButtonClick:(id)sender
{
    NSLog(@"收藏");
    [self.view addSubview:self.tokenView];
    [self.tokenView showTokenView];
}

- (void)shareButtonClick:(id)sender
{
    NSLog(@"分享");
    self.shareSheet.delegate = self;
    [self.shareSheet showShareView];
}


@end
