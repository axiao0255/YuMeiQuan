//
//  RYQRcodeViewViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYQRcodeViewViewController.h"

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
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    
    UIImageView *qroverimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"13-touming.png"]];
    qroverimg.frame = CGRectMake(0, 0, qroverimg.frame.size.width, qroverimg.frame.size.height);
    [reader.view addSubview:qroverimg];
    
    UILabel *loadinglabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, VIEW_WIDTH, 30)];
    loadinglabel.textAlignment = NSTextAlignmentCenter;
    loadinglabel.text = @"初始化二维码控件";
    loadinglabel.textColor = [UIColor redColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loadinglabel];
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
    NSLog(@"info:: %@",info);
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    urlstr = symbol.data;
    NSLog(@"urlstr::%@",urlstr);
    if ([predicate evaluateWithObject:urlstr]) {
        NSLog(@"%@",urlstr);
        NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",@"www.rongyi.com"];
        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",@"test.rongyi.com"];
        QRarray = [urlstr componentsSeparatedByString:@"/"];
        NSPredicate *type = [NSPredicate predicateWithFormat: @"SELF IN { 'malls', 'shops', 'activities', 'groupon' }"];
        if (([p evaluateWithObject:urlstr] || [p2 evaluateWithObject:urlstr]) && [QRarray count]==5 && [type evaluateWithObject:[QRarray objectAtIndex:3]]) {
            NSLog(@"%@",QRarray);
            //打印出来的信息
            //            "http:",
            //            "",
            //            "www.rongyi.com",
            //            malls,
            //            5236ae116038b5c93f000001
            [reader dismissViewControllerAnimated:NO completion:nil];
            firstin = YES;
            //[self.navigationController popViewControllerAnimated:NO];
//            [self gotoDetailPageQianDao];
        }else{
            NSString *title;
//            if ([urlstr rangeOfString:TextNeedMallLifeLogin options:NSCaseInsensitiveSearch].location != NSNotFound && ![ShowBox isLogin:YES]) {
//                NSLog(@"aaa");
//                title = @"需要容易网账号登录，要打开以下二维码网址吗？";
//            } else {
//                NSLog(@"bbb");
//                title = @"要打开以下二维码网址吗？";
//            }
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title
                                                            message:urlstr
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认", nil];
            alert.delegate = self;
            [alert show];
        }
    }else{
        [ShowBox showError:@"无法识别的二维码"];
        return;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
