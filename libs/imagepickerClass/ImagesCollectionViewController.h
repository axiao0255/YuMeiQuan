//
//  ImagesCollectionViewController.h
//  assetImagepicker
//
//  Created by 刚正面的斯温 on 15-2-12.
//  Copyright (c) 2015年 hyq. All rights reserved.
//
/*
 使用方法：通过present弹出
 
 ImagesCollectionViewController* al = [[ImagesCollectionViewController alloc] initWithCompleteBlock:^(NSArray *array, imagestype type) { 
 
 }];
 UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:al];
 [self presentViewController:nav animated:YES completion:nil];
 
 */
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, imagestype) {
    imagestypeAlassets,         //alassets对象
    imagestypeUimage            //uiimagecontrollpicker返回的对象
};
typedef void(^completeBlock)(NSArray* array,imagestype type);
@interface ImagesCollectionViewController : UIViewController
-(instancetype)initWithCompleteBlock:(completeBlock)block;
@property (nonatomic,strong,setter=imgArray:) NSArray* imgArray;
@property (nonatomic,strong,setter=titleArray:) NSArray* titleArray;
-(void)setMaxNum:(NSInteger)num;        //设置最大选择数量
-(void)refreshSelectedArray;            //移除所有选择照片
@end
