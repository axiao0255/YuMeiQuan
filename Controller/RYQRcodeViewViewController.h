//
//  RYQRcodeViewViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"
#import "ZBarSDK.h"
#import <AVFoundation/AVFoundation.h>

@interface RYQRcodeViewViewController : RYBaseViewController<UIAlertViewDelegate,ZBarReaderDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    NSString                 *urlstr;
    NSArray                  *QRarray;
//    ZBarReaderViewController *reader;
//    ZBarReaderView           *readerView;
//    BOOL                     firstin;
    
    int                       num;
    BOOL                      upOrdown;
    NSTimer                   *timer;
}

@property (strong,nonatomic)AVCaptureDevice            * device;
@property (strong,nonatomic)AVCaptureDeviceInput       * input;
@property (strong,nonatomic)AVCaptureMetadataOutput    * output;
@property (strong,nonatomic)AVCaptureSession           * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic,retain)UIImageView                * line;

@end
