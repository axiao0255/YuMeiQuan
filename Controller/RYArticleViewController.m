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

#define BROWSER_TITLE_LBL_TAG 12731
@interface RYArticleViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate,CXPhotoBrowserDelegate,CXPhotoBrowserDataSource>
{
    CXBrowserNavBarView *navBarView;
    BOOL                showButtonView;    // 用于判断 点击下载pdf是的
}
@property (strong, nonatomic)  UIScrollView     *scrollView;
@property (strong, nonatomic)  UIWebView        *webView;
@property (strong, nonatomic)  UIImageView      *backgroundView;

@property (strong, nonatomic)  UILabel          *sourceLabel;
@property (strong, nonatomic)  UILabel          *dateLabel;
@property (strong, nonatomic)  UILabel          *bodeyTitleLabel;
@property (strong, nonatomic)  UIButton         *originalBtn;

@property (strong, nonatomic)  UIView           *buttomView;

@property (strong, nonatomic)  RYArticleData    *articleData;
@property (nonatomic, strong)  NSMutableArray   *photoDataSource;
@property (nonatomic, strong)  NSArray          *imageSourceArray;

@property (nonatomic, assign)  CGFloat          webViewHeight;

@property (nonatomic, strong)  CXPhotoBrowser   *browser;


@end

@implementation RYArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"文章";
    showButtonView = YES;
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
}

- (void)setupMainView
{
    [self addTapOnWebView];
    [self.view addSubview:self.backgroundView];
    self.webView.scrollView.scrollEnabled = NO;
    [self.scrollView addSubview:self.webView];
    [self.scrollView addSubview:self.sourceLabel];
    [self.scrollView addSubview:self.dateLabel];
    [self.scrollView addSubview:self.bodeyTitleLabel];
    [self.scrollView addSubview:self.originalBtn];
    [self.scrollView addSubview:self.buttomView];
    [self.view addSubview:self.scrollView];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)getBodyData
{
    NSString *url = @"http://yimeiquan.cn/forum.php?mod=viewthread&tid=1016575&page=1&mobile=2&yy=1";
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
    
    [self refreshMainView];
}

- (void)refreshMainView
{
    self.bodeyTitleLabel.text = self.articleData.subject;
    
    self.sourceLabel.text = self.articleData.author;
    self.dateLabel.text = [NSString stringWithFormat:@"发布于：%@",self.articleData.dateline];

    
    CGSize size =  [self.articleData.subject sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(300, MAXFLOAT)];
    self.bodeyTitleLabel.text = self.articleData.subject;
    self.bodeyTitleLabel.height = size.height;
    self.sourceLabel.top = self.bodeyTitleLabel.bottom + 10;
    self.dateLabel.top = self.sourceLabel.bottom + 10;
    self.originalBtn.top = self.sourceLabel.bottom;
    self.webView.top = self.originalBtn.bottom;
    self.webView.height -= self.webView.top;

    //
    NSMutableString *htmlString = [NSMutableString stringWithFormat:@"<div id='webHeight' style=\"padding-left:7px;padding-right:8px;line-height:24px;\">%@</div>", self.articleData.message ];
    //    NSString *webviewText = @"<style>body{margin:10;background-color:transparent;font:80px/18px Custom-Font-Name}</style>";
    //        NSString *htmlString = [webviewText stringByAppendingFormat:@"%@", self.bodyModel.message];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://yimeiquan.cn"]];
    UIEdgeInsets insets = self.webView.scrollView.contentInset;
    insets.top = self.originalBtn.bottom;
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
        _scrollView.backgroundColor = [UIColor clearColor];
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
        _webView.layer.borderWidth = 1;
        _webView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _webView;
}

- (UIImageView *)backgroundView
{
    if (_backgroundView == nil) {
        UIImage *image = [UIImage imageNamed:@"body_bg"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        _backgroundView = [[UIImageView alloc] initWithImage:image];
        _backgroundView.frame = self.view.bounds;
    }
    return _backgroundView;
}

- (UILabel *)sourceLabel
{
    if (_sourceLabel == nil) {
        _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sourceLabel.left = 10;
        _sourceLabel.height = 15;
        _sourceLabel.width = 200;
        _sourceLabel.backgroundColor = [UIColor grayColor];
        _sourceLabel.font = [UIFont systemFontOfSize:12];
        _sourceLabel.textColor = [UIColor lightGrayColor];
    }
    return _sourceLabel;
}

- (UILabel *)dateLabel
{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.left = 10;
        _dateLabel.height = 15;
        _dateLabel.width = 200;
        _dateLabel.backgroundColor = [UIColor blueColor];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = [UIColor lightGrayColor];
    }
    return _dateLabel;
}

- (UILabel *)bodeyTitleLabel
{
    if (_bodeyTitleLabel == nil) {
        UILabel *bodeyTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        bodeyTitleLabel.width = 300;
        bodeyTitleLabel.left = 10;
        bodeyTitleLabel.top = 10;
        bodeyTitleLabel.numberOfLines = 2;
        bodeyTitleLabel.backgroundColor = [UIColor yellowColor];
        bodeyTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        bodeyTitleLabel.textColor = [UIColor blackColor];
        _bodeyTitleLabel = bodeyTitleLabel;
    }
    return _bodeyTitleLabel;
}

- (UIButton *)originalBtn
{
    if (_originalBtn == nil) {
        _originalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _originalBtn.width = 80;
        _originalBtn.backgroundColor = [UIColor redColor];
        _originalBtn.height = 40;
        _originalBtn.right = self.view.width - 10;
        [_originalBtn setTitle:@"阅读原文>>" forState:UIControlStateNormal];
        _originalBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_originalBtn addTarget:self action:@selector(clickOriginalBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_originalBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return _originalBtn;
}

- (UIView *)buttomView
{
    if (_buttomView == nil) {
        _buttomView = [[UIView alloc]initWithFrame:CGRectZero];
        _buttomView.backgroundColor = [UIColor orangeColor];
        _buttomView.width = 300;
        _buttomView.left = 10;
        _buttomView.height = 200;
        _buttomView.top = CGRectGetHeight(self.view.bounds);
        _buttomView.hidden = YES;
    }
    return _buttomView;
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
    if ( showButtonView ) {
        self.buttomView.hidden = NO;
    }
    else{
        self.buttomView.hidden = YES;
    }
   
    self.buttomView.top = self.webViewHeight + self.originalBtn.bottom;
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    scrollViewContentSize.height = self.webViewHeight + self.originalBtn.bottom + self.buttomView.height;
    self.scrollView.contentSize = scrollViewContentSize ;
    self.webView.height = self.webViewHeight+self.buttomView.height + self.originalBtn.bottom;
     NSLog(@"%f",scrollViewContentSize.height);
    NSLog(@"%f",self.webView.height);
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
            showButtonView = NO;
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
            scrollViewContentSize.height = size.height + self.originalBtn.bottom;
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
        [doneButton setFrame:CGRectMake(size.width - 60, 10, 50, 30)];
        [doneButton addTarget:self action:@selector(photoBrowserDidTapDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton.layer setMasksToBounds:YES];
        [doneButton.layer setCornerRadius:4.0];
        [doneButton.layer setBorderWidth:1.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
        [doneButton.layer setBorderColor:colorref];
        doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [navBarView addSubview:doneButton];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFrame:CGRectMake((size.width - 100)/2, 10, 100, 40)];
        [titleLabel setCenter:navBarView.center];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:20.]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [titleLabel setTag:BROWSER_TITLE_LBL_TAG];
        [navBarView addSubview:titleLabel];
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






@end
