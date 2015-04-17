//
//  imagesView.m
//  imagesview
//
//  Created by pipasese on 15/2/14.
//  Copyright (c) 2015年 PIPASESE. All rights reserved.
//

#import "imagesView.h"
#define screenwidth [UIScreen mainScreen].bounds.size.width;
@implementation imagesView
-(instancetype)initWithMaxNum:(NSInteger)num{
    self = [super init];
    if (self) {
        imgArray                = [NSArray array];
        maxNum                  = num;
        fixSpace                = 10;
        numOline                = 4 ;
        self.frame = [self frameWithNum:numOline];
    }
    return self;
}

-(instancetype)initWithImages:(NSArray*)array{
    self                        = [super init];
    if (self) {
        imgArray                = [NSArray arrayWithArray:array];
        fixSpace                = 10;
        numOline                = 4 ;
        self.frame              = [self frameWithNum:array.count];
    }
    return self;
}

-(void)setImagesArray:(NSArray*)arr{
    imgArray                = [NSArray arrayWithArray:arr];
    self.frame              = [self frameWithNum:arr.count];
    [self refreshUI];
}
/**
 *  移除照片ui
 *
 *  @param index
 */
-(void)removeImageAtIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(imagesViewDeleteImageAtIndex:)]) {
        if (![self.delegate imagesViewDeleteImageAtIndex:index]) {
            return;
        }
    }
    NSMutableArray *array       = [NSMutableArray arrayWithArray:imgArray];
    [array removeObjectAtIndex:index];
    imgArray                    = [NSArray arrayWithArray:array];
    [self refreshUI];
}

-(void)show{
    [self refreshUI];
}
/**
 *  根据传来的h设置frame位置
 *
 *  @param h
 */
-(void)fixFrameH:(CGFloat)h{
    CGRect rect                 = self.frame;
    rect.origin.y               = h;
    self.layer.frame            = rect;
}

/**
 *  添加照片
 *
 *  @param img
 */
-(void)addImage:(id)img{
    if (maxNum>0 && maxNum == imgArray.count) {
        return;
    }
    NSMutableArray * arr        = [NSMutableArray arrayWithArray:imgArray];
    [arr addObject:img];
    imgArray                    = [NSArray arrayWithArray:arr];
    [self addUIwithImage:img AndNum:imgArray.count-1];
}

/**
 *  添加照片 ui
 *
 *  @param img ＝
 *  @param num
 */
-(void)addUIwithImage:(id)img AndNum:(NSInteger)num{
    UIImageView* imgV                   = [[UIImageView alloc] initWithFrame:[self itemFrameWithNum:num]];
    if (editEnable == couldEdit) {
        [imgV setTag:baseetag+num];
        [imgV setUserInteractionEnabled:YES];
        if (num == imgArray.count) {
            [imgV setImage:[UIImage imageNamed:@"imgtakephoto"]];
            [imgV setUserInteractionEnabled:YES];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callUIimage)];
            [tap setNumberOfTapsRequired:1];
            [tap setNumberOfTouchesRequired:1];
            [imgV addGestureRecognizer:tap];
        }else{
            CGFloat width = [self itemWidth];
            UIButton* deletebtn         = [[UIButton alloc] initWithFrame:CGRectMake(0.5*width, 0, 0.5*width, 0.5*width)];
            [deletebtn setTitle:@"X" forState:UIControlStateNormal];
            [deletebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            deletebtn.layer.masksToBounds = YES;
//            deletebtn.layer.cornerRadius = 0.25*width;
//            deletebtn.backgroundColor = [UIColor lightGrayColor];
            [deletebtn addTarget:self action:@selector(deleteimg:) forControlEvents:UIControlEventTouchUpInside];
            if ([img isKindOfClass:[NSString class]]) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:img]) {
                    [imgV setImage:[UIImage imageWithContentsOfFile:img]];
                }else{
                    [imgV setImageWithURL:[NSURL URLWithString:img] placeholderImage:[self defaultPlaceholderImage]];
                }
            }else if ([img isKindOfClass:[ALAsset class]]){
                CGImageRef iref         =     [(ALAsset*)img aspectRatioThumbnail];
                [imgV setImage:[UIImage imageWithCGImage:iref]];
            }
            [imgV addSubview:deletebtn];
        }
    }else{
        [imgV setImageWithURL:[NSURL URLWithString:img] placeholderImage:[self defaultPlaceholderImage]];
    }
    
    [self addSubview:imgV];
    self.frame                          = [self frameWithNum:num];
}

-(void)deleteimg:(UIButton*)btn{
    int num                             = btn.superview.tag - baseetag;
    [self removeImageAtIndex:num];
}

-(void)callUIimage{
    if (maxNum>0 && imgArray.count == maxNum) {
        UIAlertView* al                 = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"一共只能添加%d张图片",maxNum] message:@"" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [al show];
        return;
    }
    if (pickertype == UIImagePickerControllerType) {
        [self takePhoto];
    }else if (pickertype == AlbumCollectionType){
        [self takeAlbum];
    }
}

-(void)takeAlbum{
    UINavigationController* nav         = [[UINavigationController alloc] initWithRootViewController:[self albumpicker]];
    [mainVC dismissViewControllerAnimated:NO completion:nil];
    [mainVC presentViewController:nav animated:YES completion:nil];
}

-(ImagesCollectionViewController*)albumpicker{
    albumpicker                         = [[ImagesCollectionViewController alloc] initWithCompleteBlock:^(NSArray *array, imagestype type) {
        [self showActivity];
        [self addimagesWithArray:array];
    }];
    [albumpicker setMaxNum:maxNum - imgArray.count];
    return albumpicker;
}

-(void)takePhoto{
    if (![self isCameraValible]) {
        UIAlertView* al                 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有可用的摄像头" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [al show];
        return;
    }else{
        [mainVC presentViewController:[self takephtot] animated:YES completion:nil];
    }
}

-(BOOL)isCameraValible{
    BOOL rt                             = NO ;
    if ([self useCamera] == UIImagePickerControllerCameraDeviceRear|| [self useCamera] ==UIImagePickerControllerCameraDeviceFront) {
        rt                              =  YES;
    }
    return rt;
}

-(UIImagePickerControllerCameraDevice)useCamera{
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        return UIImagePickerControllerCameraDeviceRear;
    }else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        return UIImagePickerControllerCameraDeviceFront;
    }
    return -2;
}

-(UIImagePickerController*)takephtot{
    if (!imagepickerController) {
        imagepickerController                   = [[UIImagePickerController alloc] init];
        imagepickerController.delegate          = self;
        imagepickerController.sourceType        = UIImagePickerControllerSourceTypeCamera;
        imagepickerController.cameraDevice      = [self useCamera];
    }
    return imagepickerController;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self showActivity];
    UIImage* img                                = [info valueForKey:UIImagePickerControllerOriginalImage];
    [[self assetsLibrary] writeImageToSavedPhotosAlbum:img.CGImage orientation:(ALAssetOrientation)img.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        [[self assetsLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [self addimagesWithArray:[NSArray arrayWithObject:asset]];
        } failureBlock:^(NSError *error) {
            [self dismissActivity];
        }];
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)addimagesWithArray:(NSArray *)arrtmp{
    NSMutableArray* arr                         = [NSMutableArray arrayWithArray:imgArray];
    [arr addObjectsFromArray:arrtmp];
    if (maxNum>0 && arr.count>maxNum) {
        UIAlertView* al                         = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"一共只能添加%d张图片",maxNum] message:@"" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [al show];
        [self dismissActivity];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(imagesViewAddImages:)]) {
        if (![self.delegate imagesViewAddImages:arrtmp]) {
            return;
        };
    }
    imgArray                                    = [NSArray arrayWithArray:arr];
    [self refreshUI];
    [self dismissActivity];
}
/**
 *  刷新ui
 */
-(void)refreshUI{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i=0; i<imgArray.count; i++) {
        [self addUIwithImage:imgArray[i] AndNum:i];
    }
    if (editEnable == couldEdit && imgArray.count <maxNum) {
        [self addUIwithImage:nil AndNum:imgArray.count];
    }
}

/**
 *  根据数量返回frame
 *
 *  @param num
 *
 *  @return
 */
-(CGRect)frameWithNum:(NSInteger)num{
    CGSize size                                 = [self sizeWithNum:num];
    CGRect rect                                 = self.frame;
    rect.size                                   = size;
    return rect;
}

/**
 *  根据照片数量返回尺寸
 *
 *  @param num
 *
 *  @return
 */
-(CGSize)sizeWithNum:(NSInteger)num{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [self itemWidth]*(num/numOline+1) +fixSpace*(num/numOline+2) );
}

/**
 *  frame
 *
 *  @param num 第几个照片
 *
 *  @return
 */
-(CGRect)itemFrameWithNum:(NSInteger)num{
    CGRect rect;
    rect.origin.x                   = [self itemWidth]*(num%numOline)+fixSpace*((num%numOline)+1);
    rect.origin.y                   = [self itemWidth]*(num/numOline) +fixSpace*(num/numOline+1);
    rect.size.width                 = [self itemWidth];
    rect.size.height                = [self itemWidth];
    return rect;
}

/**
 *  照片宽度，根据 每行数目 以及 间隙 获得
 *
 *  @return
 */
-(CGFloat)itemWidth{
    CGFloat screenW                 = [UIScreen mainScreen].bounds.size.width;
    return (screenW-fixSpace*(numOline+1))/numOline;
}

-(void)setMaxNum:(NSInteger)num{
    maxNum                          = num;
}

-(void)setPickerType:(IMAGEPICKERTYPE)type{
    pickertype                      = type;
}

-(void)setDeleteConfirm:(BOOL)type{
    deleteConfirm                   = type;
}

-(void)seteidtEnable:(EDITENABLE)type{
    editEnable                      = type;
}

-(void)setMainVC:(UIViewController*)vc{
    mainVC                          = vc;
}

-(ALAssetsLibrary*)assetsLibrary{
    if (!assetsLibrary) {
        assetsLibrary               = [[imagesLoader sharedObject] alassetsLibrary];
    }
    return assetsLibrary;
}

-(UIImage*)defaultPlaceholderImage{
    if (!defaultimage) {
        defaultimage                = [UIImage imageNamed:@"defaulticon"];
    }
    return defaultimage;
}

-(UIActivityIndicatorView*)activity{
    if (!activity) {
        activity                    = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.center             = mainVC.view.center;
        UIView* vc                  = [[UIView alloc] initWithFrame:mainVC.view.bounds];
        vc.backgroundColor          = [UIColor colorWithWhite:0.5 alpha:0.5];
        [vc addSubview:activity];
        [mainVC.view addSubview:[[self activity] superview]];
        [[[[self activity] superview] layer] setHidden:YES];
    }
    return activity;
}
-(void)showActivity{
    if (![[self activity] isAnimating]) {
        [UIView beginAnimations:nil context:nil];
        [[[[self activity] superview] layer] setHidden:NO];
        [UIView commitAnimations];
        [[self activity] startAnimating];
    }
}

-(void)dismissActivity{
    if ([[self activity] isAnimating]) {
        [[self activity] stopAnimating];
        [UIView beginAnimations:nil context:nil];
        [[[[self activity] superview] layer] setHidden:YES];
        [UIView commitAnimations];
    }
}

-(void)setnumOline:(NSInteger)nm{
    numOline                        = nm;
}

-(NSArray*)getImgArray{
    return imgArray;
}
@end
