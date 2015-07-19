//
//  RYQRcodeViewViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"
#import "ZBarSDK.h"

@interface RYQRcodeViewViewController : RYBaseViewController<UIAlertViewDelegate,ZBarReaderDelegate>
{
    NSString *urlstr;
    BOOL hasqrcode;
    NSArray *QRarray;
    ZBarReaderViewController *reader;
    BOOL firstin;
}
@end
