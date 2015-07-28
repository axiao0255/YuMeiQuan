//
//  RYQRcodeViewViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYQRcodeViewViewController.h"
#import "RYCorporateHomePageViewController.h"
#import "RYLiteratureDetailsViewController.h"
#import "RYArticleViewController.h"

@interface RYQRcodeViewViewController ()

@end

@implementation RYQRcodeViewViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (firstin) {
        //        [self presentModalViewController: reader animated: NO];
        [self presentViewController:reader animated:NO completion:nil];
    }
    firstin = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //判断是否能使用摄像头，暂未做其他处理。
    [Utils isCaptureAuthorizationed];
    
    hasqrcode = NO;
    firstin = YES;
    
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsZBarControls = NO;
//    reader.tracksSymbols = YES;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    
    UIImageView *qroverimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"13-touming.png"]];
    qroverimg.frame = CGRectMake(0, 0, qroverimg.frame.size.width, qroverimg.frame.size.height);
    [reader.view addSubview:qroverimg];
    
//    UILabel *loadinglabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, VIEW_WIDTH, 30)];
//    loadinglabel.textAlignment = NSTextAlignmentCenter;
//    loadinglabel.text = @"初始化二维码控件";
//    loadinglabel.textColor = [UIColor redColor];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:loadinglabel];
    
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    bar.backgroundColor = [UIColor blackColor];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 50, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:cancelBtn];
    [reader.view addSubview:bar];
}

- (void) imagePickerController: (UIImagePickerController*)reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    if (hasqrcode) {
        return;
    }
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    //[reader dismissModalViewControllerAnimated: YES];
//    NSLog(@"info:: %@",info);
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    urlstr = symbol.data;
    NSLog(@"urlstr::%@",urlstr);
    if ([predicate evaluateWithObject:urlstr]) {
//        NSLog(@"%@",urlstr);
        
        NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",@"121.40.151.63"];
        // 判断是否来自医美圈的域名
        if ( [p evaluateWithObject:urlstr] ) {
            NSArray *array = [urlstr componentsSeparatedByString:@"?"];
//            NSLog(@"array : %@",array);
            NSString *QRString = [array lastObject];
            QRarray = [QRString componentsSeparatedByString:@"&"];
//            NSLog(@"QRarray : %@",QRarray);
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            for ( NSInteger i = 0 ; i < QRarray.count; i ++ ) {
                NSString *Qstr = [QRarray objectAtIndex:i];
                NSArray *tempArray = [Qstr componentsSeparatedByString:@"="];
                if ( tempArray.count >= 2) {
                    [tempDict setValue:[tempArray objectAtIndex:1] forKey:[tempArray objectAtIndex:0]];
                }
            }
           [self gotoDetailPageWithDict:tempDict];
//           NSLog(@"tempDict :: %@",tempDict);
        }
        else{
            
            [self.navigationController popToRootViewControllerAnimated:NO];
            [reader dismissViewControllerAnimated:NO completion:nil];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstr]];
        }
        
    }else{
        [ShowBox showError:@"无法识别的二维码"];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [reader dismissViewControllerAnimated:NO completion:nil];
}

- (void)gotoDetailPageWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return;
    }
    NSString * strId = [dict getStringValueForKey:@"id" defaultValue:@""];
    NSString * strAc = [dict getStringValueForKey:@"ac" defaultValue:@""];
    NSString * strFid = [dict getStringValueForKey:@"fid" defaultValue:@""];
    NSString * strTid = [dict getStringValueForKey:@"tid" defaultValue:@""];
    NSString * strUid = [dict getStringValueForKey:@"uid" defaultValue:@""];
   
    [reader dismissViewControllerAnimated:NO completion:nil];
    UINavigationController *nav = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    if ( [strId isEqualToString:@"ymq_home"] && ![ShowBox isEmptyString:strUid] ) {
        // 进入公司 微主页
        RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] initWithCorporateID:strUid];
        [nav pushViewController:vc animated:YES];
    }
    else if ( [strId isEqualToString:@"ymq_home"] &&
             [strFid isEqualToString:@"137"] &&
             [strAc isEqualToString:@"viewnews"] &&
             ![ShowBox isEmptyString:strTid] ){
        // 进入 文献详细页
        RYLiteratureDetailsViewController *vc = [[RYLiteratureDetailsViewController alloc] initWithTid:strTid];
        [nav pushViewController:vc animated:YES];
    }
    else if ( [strId isEqualToString:@"ymq_home"] &&
             [strFid isEqualToString:@"136"] &&
             [strAc isEqualToString:@"viewnews"] &&
             ![ShowBox isEmptyString:strTid] ){
        // 进入 文章详细页
        RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:strTid];
        [nav pushViewController:vc animated:YES];
    }
    else{
        [ShowBox showError:@"无法识别的二维码"];
    }
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
