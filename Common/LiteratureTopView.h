//
//  LiteratureTopView.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/22.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYArticleData.h"

@interface LiteratureTopView : UIView

@property (nonatomic , strong)RYArticleData *articleData;

- (CGFloat)getLiteratureTopViewHeight;

@end
