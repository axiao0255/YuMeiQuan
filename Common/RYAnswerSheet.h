//
//  RYAnswerSheet.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYAnswerSheet : UIView


- (CGFloat)getAnswerSheetHeight;

- (id)initWithDataSource:(NSDictionary *)dataSource;

@end
