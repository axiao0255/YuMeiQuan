//
//  imagesView.h
//  imagesview
//
//  Created by pipasese on 15/2/14.
//  Copyright (c) 2015年 PIPASESE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImagesCollectionViewController.h"
#import "UIImageView+WebCache.h"
#import "imagesLoader.h"
/*
 调用方法
 imagesView* a =[[imagesView alloc] initWithImages:[NSArray arrayWithObjects:@"http://avatar.csdn.net/4/B/A/1_koupoo.jpg", nil]];
 
 设置frame的y
 [a fixFrameH:40];
 
 可编辑模式，不设置则是默认浏览模式
 [a setMaxNum:4];                       //最大照片数量
 [a seteidtEnable:couldEdit];           //可编辑
 [a setMainVC:self];                    //设置所在viewcontroller
 [a setPickerType:AlbumCollectionType]; //设置照片获取方式
 
 设置好模式之后：
 [a show];
 */

static NSInteger baseetag = 100;
typedef enum{
    UIImagePickerControllerType,    //默认调用系统照片以及摄像头
    AlbumCollectionType             //使用alnumlists控件
}IMAGEPICKERTYPE;                   //照片调用方法类型

typedef enum{
    cannotEdit,                     //无法编辑
    couldEdit                       //能编辑（添加，删除）
} EDITENABLE;                       //是否能编辑，显示类型

@protocol imagesViewDelegate <NSObject>
@required
-(BOOL)imagesViewAddImages:(NSArray*)arr;
-(BOOL)imagesViewDeleteImageAtIndex:(NSInteger)index;
@end
@interface imagesView : UIView<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSArray*                        imgArray;                   //图片数组
    NSInteger                       maxNum;                     //最大个数限制
    NSInteger                       fixSpace;                   //间隙
    NSInteger                       numOline;                   //每行数目
    IMAGEPICKERTYPE                 pickertype;
    BOOL                            deleteConfirm;              //如为真，则删除时弹出确认
    EDITENABLE                      editEnable;
    UIViewController*               mainVC;
    UIImagePickerController*        imagepickerController;
    ImagesCollectionViewController* albumpicker;
    ALAssetsLibrary*                assetsLibrary;
    UIImage*                        defaultimage;
    UIActivityIndicatorView*        activity;
}
@property(nonatomic,assign) id<imagesViewDelegate> delegate;

/**
 *  重新设置照片数组
 *
 *  @param arr
 */
-(void)setImagesArray:(NSArray*)arr;
/**
 *  获取照片数组
 *
 *  @return
 */
-(NSArray*)getImgArray;

-(void)show;
/**
 *  设置取图方式类型
 *
 *  @param type
 */
-(void)setPickerType:(IMAGEPICKERTYPE)type;

/**
 *  设置删除是否提示
 *
 *  @param type
 */
-(void)setDeleteConfirm:(BOOL)type;
/**
 *  设置是否能编辑
 *
 *  @param type
 */
-(void)seteidtEnable:(EDITENABLE)type;
/**
 *  设置寄生页面
 *
 *  @param vc
 */
-(void)setMainVC:(UIViewController*)vc;
/**
 *  根据最大数目初始化
 *
 *  @param num
 *
 *  @return
 */
-(instancetype)initWithMaxNum:(NSInteger)num;
/**
 *  根据照片数组初始化
 *
 *  @param array
 *
 *  @return
 */
-(instancetype)initWithImages:(NSArray*)array;
/**
 *  设置照片上限
 *
 *  @param num
 */
-(void)setMaxNum:(NSInteger)num;
/**
 *  设置frame
 *
 *  @param h
 */
-(void)fixFrameH:(CGFloat)h;
/**
 *  设置每行数目
 *
 *  @param nm
 */
-(void)setnumOline:(NSInteger)nm;
@end
