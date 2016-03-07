//
//  RYSystemInformDetailsViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/8/17.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYSystemInformDetailsViewController.h"
#import "RYWebViewController.h"
#import "RYCorporateHomePageViewController.h"
#import "RYLiteratureDetailsViewController.h"
#import "RYArticleViewController.h"

@interface RYSystemInformDetailsViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic)  RYArticleData    *articleData;
@property (strong, nonatomic)  UIScrollView     *scrollView;
@property (strong, nonatomic)  UIWebView        *webView;
@property (strong, nonatomic)  UILabel          *topTitleView;
@property (strong, nonatomic)  NSArray          *breakArray;        // 将url拆分成的数组
@property (nonatomic, assign)  CGFloat          webViewHeight;



@end

@implementation RYSystemInformDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统消息";
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
- (id)initWithArticleData:(RYArticleData *)articleData;
{
    self = [super init];
    if ( self ) {
        self.articleData = articleData;
    }
    return self;
}

- (void)setup
{
    [self setupMainView];
}

- (void)setupMainView
{
    [self addTapOnWebView];
    self.webView.scrollView.scrollEnabled = NO;
    [self.scrollView addSubview:self.webView];
    [self.scrollView addSubview:self.topTitleView];
    [self.view addSubview:self.scrollView];
    
    // 设置标题
    NSString *title = self.articleData.subject;
    NSDictionary *titleAttributes = @{NSFontAttributeName:self.topTitleView.font};
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:titleAttributes
                                                              context:nil];
    self.topTitleView.height = titleRect.size.height + 16;
    self.topTitleView.text = title;
    
    self.webView.top  = self.topTitleView.bottom + 10;
    self.webView.height -= self.webView.top;
    
    //
    NSMutableString *htmlString = [NSMutableString stringWithFormat:@"<div id='webHeight' style=\"padding-left:7px;padding-right:7px;line-height:24px;\">%@</div>", self.articleData.message ];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://yimeiquan.cn"]];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"webHeight\").offsetHeight;"];
    self.webViewHeight = htmlHeight.integerValue;
    
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    scrollViewContentSize.height = self.webViewHeight + self.topTitleView.bottom + 20;
    self.scrollView.contentSize = scrollViewContentSize ;
    self.webView.height = self.webViewHeight + self.topTitleView.bottom + 20;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"request :: %@",request.URL);
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        // 点击时做处理
        NSString * requesturl = request.URL.absoluteString;
        //非这个域名的url使用safari打开
        if ([requesturl rangeOfString:DOMAINNAME].location == NSNotFound) {
            NSURL *openUrl = [NSURL URLWithString:requesturl];
            if (openUrl) {
                [[UIApplication sharedApplication] openURL:openUrl];
            }
            return NO;
        }
        else{
            NSArray *array = [requesturl componentsSeparatedByString:@"?"];
            //            NSLog(@"array : %@",array);
            NSString *QRString = [array lastObject];
            self.breakArray = [QRString componentsSeparatedByString:@"&"];
            //            NSLog(@"QRarray : %@",QRarray);
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            for ( NSInteger i = 0 ; i < self.breakArray.count; i ++ ) {
                NSString *Qstr = [self.breakArray objectAtIndex:i];
                NSArray *tempArray = [Qstr componentsSeparatedByString:@"="];
                if ( tempArray.count >= 2) {
                    [tempDict setValue:[tempArray objectAtIndex:1] forKey:[tempArray objectAtIndex:0]];
                }
            }
            NSString *mod = [tempDict getStringValueForKey:@"mod" defaultValue:@""];
            if ( [mod isEqualToString:@"company"] ) {
                // 公司主页
                NSString *cuid = [tempDict getStringValueForKey:@"cuid" defaultValue:@""];
                RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] initWithCorporateID:cuid];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ( [mod isEqualToString:@"forum"] ){
                // 文章或文献
                NSString *fid = [tempDict getStringValueForKey:@"fid" defaultValue:@""];
                NSString *tid = [tempDict getStringValueForKey:@"tid" defaultValue:@""];
                if ( [fid isEqualToString:@"137"] ) {
                    // 文献
                    RYLiteratureDetailsViewController *vc = [[RYLiteratureDetailsViewController alloc] initWithTid:tid];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else{
                    // 文章
                    RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:tid];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            else{
                RYWebViewController *webvc = [[RYWebViewController alloc] initWithUrl:requesturl];
                [self.navigationController pushViewController:webvc animated:YES];
            }
            return NO;
        }
    }
    else if (navigationType == UIWebViewNavigationTypeOther) {
        NSURL *url = request.URL;
        if ([[url scheme] isEqualToString:@"ready"]) {
            float contentHeight = [[url host] floatValue];
            NSLog(@"contentHeight:%f",contentHeight);
            return NO;
        }
    }
    return YES;
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
    NSLog(@"urlToSave ::: %@",urlToSave);
//    if ( urlToSave.length > 0 ) {
//        NSArray *urlSplitArr = [urlToSave componentsSeparatedByString:@"."];
//        NSString *lastObj = [urlSplitArr lastObject];
//        if ( [lastObj isEqualToString:@"mp4"] ) {
//            return;
//        }
//        else{
//            if ( self.imageSourceArray.count > 0 ) {
//                NSInteger index = [self.imageSourceArray indexOfObject:urlToSave];
//                [self.browser setInitialPageIndex:index];
//                [self presentViewController:self.browser animated:YES completion:^{
//                }];
//            }
//            else{
//                return;
//            }
//        }
//    }
//    else{
//        return;
//    }
}


- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}


- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,VIEW_HEIGHT)];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.delegate = self;
    }
    return _webView;
}

- (UILabel *)topTitleView
{
    if ( _topTitleView == nil ) {
        _topTitleView = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 30)];
        _topTitleView.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        _topTitleView.numberOfLines = 0;
        _topTitleView.font = [UIFont systemFontOfSize:16];
    }
    return _topTitleView;
}


@end
