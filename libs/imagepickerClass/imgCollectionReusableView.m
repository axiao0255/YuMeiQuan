//
//  imgCollectionReusableView.m
//  assetImagepicker
//
//  Created by 刚正面的斯温 on 15-2-13.
//  Copyright (c) 2015年 hyq. All rights reserved.
//

#import "imgCollectionReusableView.h"

@implementation imgCollectionReusableView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];        
    }
    return self;
}

-(void)setup{
    titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, CGRectGetWidth(self.frame) - 20, 14)];
    titleLb.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLb];
    folklayer = [CALayer new];
    folklayer.frame = CGRectMake(CGRectGetMaxX(titleLb.frame)+4, CGRectGetMinY(titleLb.frame)+(14-12.5)/2, 12.5, 12.5);
       folklayer.position = CGPointMake(CGRectGetMaxX(titleLb.frame)+10, CGRectGetMidY(titleLb.frame));
    folklayer.contents = (__bridge UIImage*)[[UIImage imageNamed:@"imgsectionright"] CGImage];
    [self.layer addSublayer:folklayer];
}

-(void)settitle:(NSString *)title{
    titleLb.frame = CGRectMake(10, 3, CGRectGetWidth(self.frame) - 20, 14);
    titleLb.text  = title;
    [titleLb sizeToFit];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    folklayer.frame = CGRectMake(CGRectGetMaxX(titleLb.frame)+10, CGRectGetMinY(titleLb.frame)+(14-12.5)/2, 12.5, 12.5);
    folklayer.position = CGPointMake(CGRectGetMaxX(titleLb.frame)+10, CGRectGetMidY(titleLb.frame));
    [CATransaction commit];
}

-(void)updatefolk:(BOOL)isfolk{
    UIImage *img = [UIImage imageNamed:isfolk?@"imgsectiondown":@"imgsectionright"];
    folklayer.contents = (__bridge UIImage*)[img CGImage];
}

+(CGSize)imgCollectionReusableViewHeaderSectionSize{
    return CGSizeMake(100, 30);
}
@end
