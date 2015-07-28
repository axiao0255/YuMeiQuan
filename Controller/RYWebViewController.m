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
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [webView setDelegate:self];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
