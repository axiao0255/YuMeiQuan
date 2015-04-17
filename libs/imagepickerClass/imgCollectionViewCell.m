//
//  imgCollectionViewCell.m
//  assetImagepicker
//
//  Created by 刚正面的斯温 on 15-2-13.
//  Copyright (c) 2015年 hyq. All rights reserved.
//

#import "imgCollectionViewCell.h"

@implementation imgCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    secView                     = [CALayer new];
    int fixH                    = 25;
    CGRect SRECT                = self.contentView.bounds;
    secView.frame               = CGRectMake(CGRectGetWidth(SRECT) - fixH, CGRectGetWidth(SRECT) - fixH, fixH-2, fixH-2);
    mainView                    = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, CGRectGetHeight(self.bounds)-4, CGRectGetHeight(self.bounds)-4)];
    [self.contentView addSubview:mainView];
    [mainView.layer addSublayer:secView];
}
 
-(void)updateWithAlsset:(ALAsset*)alasset{
    __weak imgCollectionViewCell* wself = self;
    [self setimage:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGImageRef cef                  = alasset.aspectRatioThumbnail;
        UIImage* img                    = [UIImage imageWithCGImage:cef];
        dispatch_async(dispatch_get_main_queue(), ^{
                [wself setimage:img];
        });
    });

}

-(void)setimage:(UIImage *)img{
    [mainView setImage:img];
}

-(void)cellselected:(BOOL)isselected{
    [UIView beginAnimations:nil context:nil]; 
    secView.contents            = isselected?(__bridge UIImage*)[[UIImage imageNamed:@"selectedImg"] CGImage]:nil;
    [UIView commitAnimations];
}

-(void)cellTakePhoto{
    [self cellselected:NO];
    [self setimage:[UIImage imageNamed:@"imgtakephoto"]];
}

+(CGSize)imgcollecionsize{
    return CGSizeMake(78, 78);
}
@end
