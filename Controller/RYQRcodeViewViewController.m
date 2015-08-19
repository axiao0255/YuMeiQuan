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
{
    CGFloat  scanWidth;
    CGFloat  lineOrigin;
}

@end

@implementation RYQRcodeViewViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    if (firstin) {
//        //        [self presentModalViewController: reader animated: NO];
//        [self presentViewController:reader animated:NO completion:nil];
//    }
//    firstin = NO;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([Utils isCaptureAuthorizationed]) {
        
        if ( ![Utils DeviceIsSimulator] ) {
            [self setupCamera];
        }
        else{
            [ShowBox showError:@"模拟器找不到相机"];
        }
    }
    else{
        [ShowBox showError:@"无法访问您的摄像头！请在设置->隐私->相机 中允许医美圈访问摄像头。"];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //判断是否能使用摄像头，暂未做其他处理。
    if (![Utils isCaptureAuthorizationed] ) {
        return;
    }
//    
//    firstin = YES;
//    
//    reader = [ZBarReaderViewController new];
//    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
//    reader.showsZBarControls = NO;
//    reader.tracksSymbols = YES;
//    
//    ZBarImageScanner *scanner = reader.scanner;
//    
//    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
//    
//    UIImageView *qroverimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"13-touming.png"]];
//    qroverimg.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [reader.view addSubview:qroverimg];
//    
    self.title = @"扫描二维码";
    if ( IS_IPHONE_4_OR_LESS ) {
        scanWidth = 260;
        lineOrigin = 80;
    }
    else{
        scanWidth = 300;
        lineOrigin = 110;
    }
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IS_IPHONE_4_OR_LESS?78:108)];
    topView.backgroundColor = [Utils getRGBColor:0 g:0 b:0 a:0.5];
    [self.view addSubview:topView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom+scanWidth-16, SCREEN_WIDTH, VIEW_HEIGHT-(topView.bottom+scanWidth))];
    bottomView.backgroundColor = [Utils getRGBColor:0 g:0 b:0 a:0.5];
    [self.view addSubview:bottomView];

    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom, (SCREEN_WIDTH-scanWidth)/2+8, VIEW_HEIGHT-topView.height-bottomView.height-16)];
    leftView.backgroundColor = [Utils getRGBColor:0 g:0 b:0 a:0.5];
    [self.view addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(leftView.width+scanWidth-16, leftView.top, SCREEN_WIDTH-(leftView.width+scanWidth-16), leftView.height)];
    rightView.backgroundColor = [Utils getRGBColor:0 g:0 b:0 a:0.5];
    [self.view addSubview:rightView];
    
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT - 50, SCREEN_WIDTH, 50)];
    bar.backgroundColor = [UIColor blackColor];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 50, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:cancelBtn];
    [self.view addSubview:bar];

    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-scanWidth)/2, IS_IPHONE_4_OR_LESS?10:40, scanWidth, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.font = [UIFont systemFontOfSize:IS_IPHONE_4_OR_LESS?14:16];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别";
    [self.view addSubview:labIntroudction];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-scanWidth)/2, IS_IPHONE_4_OR_LESS?70:100, scanWidth, scanWidth)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-220)/2,lineOrigin, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}

-(void)animation1
{
    
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(_line.left, lineOrigin+2*num, 220, 2);
        if (2*num == scanWidth-20) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(_line.left, lineOrigin+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_output setRectOfInterest:CGRectMake((IS_IPHONE_4_OR_LESS?70:100 + 44)/SCREEN_HEIGHT,((SCREEN_WIDTH-scanWidth)/2)/SCREEN_WIDTH,scanWidth/SCREEN_HEIGHT,scanWidth/SCREEN_WIDTH)];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //    _preview.frame =CGRectMake(20,110,280,280);
    _preview.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    [timer invalidate];
    NSLog(@"%@",stringValue);
    urlstr = stringValue;
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    NSLog(@"urlstr::%@",urlstr);
    if ([predicate evaluateWithObject:urlstr]) {
        //        NSLog(@"%@",urlstr);
        
        NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",DOMAINNAME];
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
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstr]];
        }
        
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
        [ShowBox showError:@"无法识别的二维码"];
    }

}

//- (void) imagePickerController: (UIImagePickerController*)reader didFinishPickingMediaWithInfo: (NSDictionary*) info
//{
//    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        break;
//    //[reader dismissModalViewControllerAnimated: YES];
////    NSLog(@"info:: %@",info);
//    //判断是否包含 头'http:'
//    NSString *regex = @"http+:[^\\s]*";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    urlstr = symbol.data;
//    NSLog(@"urlstr::%@",urlstr);
//    if ([predicate evaluateWithObject:urlstr]) {
////        NSLog(@"%@",urlstr);
//        
//        NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",DOMAINNAME];
//        // 判断是否来自医美圈的域名
//        if ( [p evaluateWithObject:urlstr] ) {
//            NSArray *array = [urlstr componentsSeparatedByString:@"?"];
////            NSLog(@"array : %@",array);
//            NSString *QRString = [array lastObject];
//            QRarray = [QRString componentsSeparatedByString:@"&"];
////            NSLog(@"QRarray : %@",QRarray);
//            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
//            for ( NSInteger i = 0 ; i < QRarray.count; i ++ ) {
//                NSString *Qstr = [QRarray objectAtIndex:i];
//                NSArray *tempArray = [Qstr componentsSeparatedByString:@"="];
//                if ( tempArray.count >= 2) {
//                    [tempDict setValue:[tempArray objectAtIndex:1] forKey:[tempArray objectAtIndex:0]];
//                }
//            }
//           [self gotoDetailPageWithDict:tempDict];
////           NSLog(@"tempDict :: %@",tempDict);
//        }
//        else{
//            
//            [self.navigationController popToRootViewControllerAnimated:NO];
//            [reader dismissViewControllerAnimated:NO completion:nil];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstr]];
//        }
//        
//    }else{
//        [ShowBox showError:@"无法识别的二维码"];
//    }
//}
//
//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    [picker dismissViewControllerAnimated:NO completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//    [reader dismissViewControllerAnimated:NO completion:nil];
    [timer invalidate];
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
   
//    [reader dismissViewControllerAnimated:NO completion:nil];
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



@end
