//
//  UIView(CJ_Extention).h
//  ClothesSeller
//
//  Created by mincj on 15-1-31.
//  Copyright (c) 2015年 mincj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(CJ_Extention)

@property(nonatomic, assign)CGFloat CJ_X;
@property(nonatomic, assign)CGFloat CJ_Y;


@property(nonatomic, assign)CGFloat CJ_MAX_X;
@property(nonatomic, assign)CGFloat CJ_MAX_Y;

@property(nonatomic, assign)CGFloat CJ_WIDTH;
@property(nonatomic,assign)CGFloat CJ_HEIGHT;

@property(nonatomic, readonly)CGPoint CJ_Center_Local;
@property(nonatomic, readonly)CGPoint CJ_Center_parent;
@end
