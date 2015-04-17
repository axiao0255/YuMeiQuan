//
//  imgCollectionViewCell.h
//  assetImagepicker
//
//  Created by 刚正面的斯温 on 15-2-13.
//  Copyright (c) 2015年 hyq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface imgCollectionViewCell : UICollectionViewCell{
    CALayer* secView;
    UIImageView* mainView;
}
-(void)cellselected:(BOOL)isselected;
-(void)updateWithAlsset:(ALAsset*)alasset;
-(void)setimage:(UIImage*)img;
-(void)cellTakePhoto;
+(CGSize)imgcollecionsize;
@end
