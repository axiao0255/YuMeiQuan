//
//  RYcommentDetailsViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/1.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"
#import "RYArticleData.h"
#import "JSCustomChatKeyboard.h"
#import "HPGrowingTextView.h"

@interface RYcommentDetailsViewController : RYBaseViewController<HPGrowingTextViewDelegate>

-(id)initWithArticleData:(RYArticleData *)articleData;

@end
