//
//  UIView(CJ_Extention).m
//  ClothesSeller
//
//  Created by mincj on 15-1-31.
//  Copyright (c) 2015年 mincj. All rights reserved.
//

#import "UIView+CJ_Extention.h"

@implementation UIView(CJ_Extention)

-(CGFloat)CJ_X{
    return self.frame.origin.x;
}

-(CGFloat)CJ_Y{
    return CGRectGetMinY(self.frame);
}

-(CGFloat)CJ_MAX_X{
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)CJ_MAX_Y{
    return CGRectGetMaxY(self.frame);
}

-(void)setCJ_X:(CGFloat)CJ_X{
    CGRect frame = self.frame;
    frame.origin.x = CJ_X;
    self.frame = frame;
}

-(void)setCJ_Y:(CGFloat)CJ_Y{
    CGRect frame = self.frame;
    frame.origin.y = CJ_Y;
    self.frame = frame;
}

-(void)setCJ_MAX_X:(CGFloat)CJ_MAX_X{
    CGRect frame = self.frame;
    frame.size.width = (CJ_MAX_X - self.CJ_X);
    self.frame = frame;
}

-(void)setCJ_MAX_Y:(CGFloat)CJ_MAX_Y{
    CGRect frame = self.frame;
    frame.size.height = (CJ_MAX_Y - self.CJ_Y);
    self.frame = frame;
}

-(CGFloat)CJ_WIDTH{
    return CGRectGetWidth(self.frame);
}

-(CGFloat)CJ_HEIGHT{
    return CGRectGetHeight(self.frame);
}

-(void)setCJ_WIDTH:(CGFloat)CJ_WIDTH{
    CGRect frame = self.frame;
    frame.size.width = CJ_WIDTH;
    self.frame = frame;
}

-(void)setCJ_HEIGHT:(CGFloat)CJ_HEIGHT{
    CGRect frame = self.frame;
    frame.size.height = CJ_HEIGHT;
    self.frame = frame;
}
-(CGPoint)CJ_Center_Local{
    return CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
}
-(CGPoint)CJ_Center_parent{
    return CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
}
@end
