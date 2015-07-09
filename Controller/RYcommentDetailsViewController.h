//
//  RYcommentDetailsViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/1.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RYArticleData.h"
#import "HPGrowingTextView.h"

@interface RYcommentDetailsViewController : RYBaseViewController<HPGrowingTextViewDelegate>


-(id)initWithArticleTid:(NSString *) tid;

@end
