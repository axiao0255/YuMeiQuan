//
//  RYBillboardView.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RYBillboardViewDelegate <NSObject>

- (void)bottomBtnClickIsShow:(BOOL) isShow;

@end

@interface RYBillboardView : UIView

@property (nonatomic ,   weak) id <RYBillboardViewDelegate>delegate;
@property (nonatomic , strong) UIButton                    *bottomBtn;

- (id)initWithFrame:(CGRect)frame;

@end
