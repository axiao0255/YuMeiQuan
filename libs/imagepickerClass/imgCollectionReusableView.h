//
//  imgCollectionReusableView.h
//  assetImagepicker
//
//  Created by 刚正面的斯温 on 15-2-13.
//  Copyright (c) 2015年 hyq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imgCollectionReusableView : UICollectionReusableView{
    UILabel * titleLb;
    CALayer * folklayer;
}

-(void)settitle:(NSString*)title;
-(void)updatefolk:(BOOL)isfolk;
+(CGSize)imgCollectionReusableViewHeaderSectionSize;
@end
