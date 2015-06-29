//
//  RYTokenView.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/22.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFTokenField.h"


@interface RYTokenView : UIView


- (id)initWithTokenDict:(NSDictionary *)dict andArticleID:(NSString *)articleId;

- (void)showTokenView;
- (void)dismissTokenView;

@end
