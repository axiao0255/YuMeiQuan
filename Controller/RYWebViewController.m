//
//  RYWebViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/28.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYWebViewController.h"

@interface RYWebViewController ()<UIWebViewDelegate>
{
    NSString *urlStr;
}
@end

@implementation RYWebViewController

-(id)initWithUrl:(NSString *)openUrl
{
    self = [super init];
    if ( self ) {
        urlStr = openUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    urlStr=@"http://alpworks.baijia.baidu.com/article/161495";
//    urlStr = @"http://view.inews.qq.com/q/WXN20150916011699051?plg_nld=1&plg_uin=1&plg_auth=1&plg_usr=1&plg_dev=1&plg_vkey=1&plg_nld=1&refer=mobileqq";
    urlStr = @"http://toutiao.com/group/6195543212709773570/?iid=3003891408&app=news_article&tt_from=mobile_qq&utm_source=mobile_qq&utm_medium=toutiao_ios&utm_campaign=client_share";
    
//    urlStr = @"http://vip.baidu.com/cps/show/goto?mallid=112&url=8c38nAKiCM8yQUwI2nyJstuL5v19TWJBxuwTy1IJb9%2FhmDAewxwDO18g%2BFyXBl%2BG0%2BI&statkey=&vip_frm=super_nav";
    
    [ShowBox checkCurrentNetwork];
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [webView setDelegate:self];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
   
    NSURL  *url = [NSURL URLWithString:urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    [NSURLConnection  sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //在这里将data数据转换为html数据,然后传给一个函数让其正则匹配
        NSLog(@"string  :: %@",string);
//        [self regexp:string];
        
        
        //设定起始标记
//        NSString *pageStart=@"<h1 class=\"fl\" id=\"subject_tpc\">";
//        NSString *pageEnd=@"<div id=\"w_tpc\" class=\"c\">";
//        int startOffset=[string rangeOfString:pageStart].location;
//        int endOffset=[string rangeOfString:pageEnd].location;
//        //截取substring
//        NSString *partialString=[string substringWithRange:NSMakeRange(startOffset, endOffset-startOffset)];
        //    //显示
//        [webView loadHTMLString:partialString baseURL:nil];
        
        
//        NSLog(@" html :::  = %@",partialString);

        
    }];
    
    
//    NSString *partialString =  [self urlstring:urlStr];
//    [webView loadHTMLString:partialString baseURL:nil];
 }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [self showErrorView:webView];
}

-(NSString*) urlstring:(NSString*)strurl{
//  NSURL *url = [NSURL URLWithString:strurl];
//  NSData *data = [NSData dataWithContentsOfURL:url];
    
//  NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//  NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    
    //GBK编码。如果是UTF8，用NSUTF8StringEncoding
    NSStringEncoding chineseEnc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *webString=[NSString stringWithContentsOfURL:[NSURL URLWithString:strurl] encoding:chineseEnc error:nil];
    //设定起始标记
    NSString *pageStart=@"<h1 class=\"fl\" id=\"subject_tpc\">";
    NSString *pageEnd=@"<div id=\"w_tpc\" class=\"c\">";
    NSInteger startOffset=[webString rangeOfString:pageStart].location;
    NSInteger endOffset=[webString rangeOfString:pageEnd].location;
    //截取substring
    NSString *partialString=[webString substringWithRange:NSMakeRange(startOffset, endOffset-startOffset)];
//    //显示
//    [webView loadHTMLString:partialString baseURL:nil];
 
    
    NSLog(@" html :::  = %@",partialString);
    
    return partialString;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
