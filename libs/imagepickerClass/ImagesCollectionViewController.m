//
//  ImagesCollectionViewController.m
//  assetImagepicker
//
//  Created by 刚正面的斯温 on 15-2-12.
//  Copyright (c) 2015年 hyq. All rights reserved.
//

#import "ImagesCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "imgCollectionReusableView.h"
#import "imgCollectionViewCell.h"
#import "imagesLoader.h"
@interface ImagesCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSInteger folkSection;
    BOOL isfolk;
    completeBlock comBlock;
    UIImagePickerController* takephotoPickerl;
    NSInteger maxNum;
    CGPoint fixY;
}
@property   (nonatomic,strong,getter=collectionView)  UICollectionView*  collectionView;
@property   (nonatomic,strong,getter=imageloader)           imagesLoader*       imgloader;
@property   (nonatomic,strong)                          NSMutableArray*        selectedArray;
@end

@implementation ImagesCollectionViewController
 static NSString* cellid                    = @"imagescedddllid";
 static NSString* headerid                  = @"headerid";

-(instancetype)initWithCompleteBlock:(completeBlock)block{
    self = [super init];
    if (self) {
        comBlock = block;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor               = [UIColor whiteColor];
    _selectedArray                          = [NSMutableArray array];
    [self initNaviButton];
    [self refreshButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.imgloader loadImageWithblock:^(NSArray *array) {
        self.titleArray                     = array;
    }];
}

-(void)initNaviButton{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(handleComplete) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    UIButton* backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 60, 30);
    [backbtn setTitle:@"返回" forState:UIControlStateNormal];
    [backbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(handlebackComplete) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
}

-(void)handlebackComplete{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)refreshButton{
    if (self.navigationItem.rightBarButtonItem) {
        UIBarButtonItem *item = self.navigationItem.rightBarButtonItem;
        UIButton* btn = (UIButton*)item.customView;
        NSInteger num = _selectedArray.count;
        NSString* str = num==0?@"完成":[NSString stringWithFormat:@"完成(%ld)",(long)num];
        [btn setTitle:str forState:UIControlStateNormal];
//        [btn setEnabled:num>0];
//        if (num == 0) {
//            [btn setBackgroundColor:[UIColor grayColor]];
//        }else{
//            [btn setBackgroundColor:[UIColor redColor]];
//        }
    }
    
}

-(void)refreshSelectedArray{
    [_selectedArray removeAllObjects];
}

-(void)setMaxNum:(NSInteger)num{
    maxNum = num;
}

-(UICollectionView*)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *clayout = [[UICollectionViewFlowLayout alloc] init];
        clayout.minimumInteritemSpacing     = 2;
        clayout.minimumLineSpacing          = 2;
        _collectionView                     = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:clayout];
        [_collectionView registerClass:[imgCollectionViewCell class] forCellWithReuseIdentifier:cellid];
        [_collectionView registerClass:[imgCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerid];
        _collectionView.delegate            = self;
        _collectionView.dataSource          = self;
        _collectionView.backgroundColor     = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(void)imgArray:(NSArray *)imgArray{
    _imgArray                               = [NSArray arrayWithArray:imgArray];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _titleArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [imgCollectionReusableView imgCollectionReusableViewHeaderSectionSize];
}
 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (isfolk && section == folkSection) {
         return self.imgArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    imgCollectionViewCell* cell             = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell cellTakePhoto];
    }else   if (isfolk && indexPath.section == folkSection && indexPath.row>0) {
        ALAsset *asset                      = [self.imgArray objectAtIndex:indexPath.row];
        [cell cellselected:[self isselected:asset]];
        [cell updateWithAlsset:asset];
    }

    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [imgCollectionViewCell imgcollecionsize];
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        imgCollectionReusableView * header  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerid forIndexPath:indexPath];
        ALAssetsGroup* group                = [_titleArray objectAtIndex:indexPath.section];
        [header settitle:[group valueForProperty:ALAssetsGroupPropertyName]];
        if (![header gestureRecognizers]) {
            UITapGestureRecognizer * tap    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhedie:)];
            tap.numberOfTapsRequired        = 1;
            tap.numberOfTouchesRequired     = 1;
            [header removeGestureRecognizer:tap];
            [header addGestureRecognizer:tap];
        } 
        [header setTag:indexPath.section+1000];
        [header updatefolk:NO];
        if (isfolk && (folkSection == indexPath.section)) {
            [header updatefolk:YES];
        } 
        return header;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [(imgCollectionViewCell*)cell setimage:nil];
    [(imgCollectionViewCell*)cell cellselected:NO];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>0) {
        imgCollectionViewCell* cell             = (imgCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        BOOL isselected;
        ALAsset* al                             = [_imgArray objectAtIndex:indexPath.row];
        if ([self isselected:al] ) {
            isselected                          = NO;
            [self removeAsset:al];
        }else{
            if (_selectedArray.count+1 > maxNum && maxNum>0  ) {
                UIAlertView* al = [[UIAlertView alloc] initWithTitle:@"不能添加更多照片了" message:@"" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [al show];
                return;
            }
            isselected                          = YES;
            [self addAsset:al];
        }
        [cell cellselected:isselected];
    }else{
        //照相
        [self takePhoto];
    }
    [self refreshButton];
}

-(void)takePhoto{
    if (![self isCameraValible]) {
        UIAlertView* al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有可用的摄像头" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [al show];
        return;
    }else{
        [self presentViewController:[self takephtot] animated:YES completion:nil];
    }
}

-(BOOL)isCameraValible{
    BOOL rt = NO ;
    if ([self useCamera] == UIImagePickerControllerCameraDeviceRear|| [self useCamera] ==UIImagePickerControllerCameraDeviceFront) {
        rt =  YES;
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
    if (!takephotoPickerl) {
        takephotoPickerl = [[UIImagePickerController alloc] init];
        takephotoPickerl.delegate = self;
        takephotoPickerl.sourceType = UIImagePickerControllerSourceTypeCamera;
        takephotoPickerl.cameraDevice = [self useCamera];
    }
    return takephotoPickerl;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:NO completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
        UIImage* img = [info valueForKey:UIImagePickerControllerOriginalImage];
        [[self.imgloader alassetsLibrary] writeImageToSavedPhotosAlbum:img.CGImage orientation:(ALAssetOrientation)img.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
            [[self.imgloader alassetsLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                comBlock([NSArray arrayWithObject:asset],imagestypeAlassets);
            } failureBlock:^(NSError *error) {
            }];
        }];
    }];
}
/**
 *  处理手势
 *
 *  @param tap
 */
-(void)zhedie:(UITapGestureRecognizer*)tap{ 
    imgCollectionReusableView * imgView     = (imgCollectionReusableView *)tap.view;
    NSInteger num                                 = imgView.tag - 1000;
    [imgView updatefolk:isfolk];
    if (!isfolk) {                                              //未展开的情况，展开
        [self open:num];
    }else{                                                      //展开的情况
        if (folkSection == num) {                               //相同，折叠
            [self close:num];
        }else{                                                  //不相同，先折叠，再展开
            [self close:num];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self open:num];
            });
        }

    }
}

/**
 *  折叠
 *
 *  @param num
 */
-(void)close:(NSInteger)num{
    isfolk                                  = NO;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:folkSection]];
}

/**
 *  展开
 *
 *  @param num
 */
-(void)open:(NSInteger)num{
    isfolk                              = YES;
    folkSection                         = num;
    ALAssetsGroup* group                = _titleArray[num];
    folkSection                         = [_titleArray indexOfObject:group];
    _imgArray                           = [self getImagesFromAssetGroup:group];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:folkSection]];
}

/**
 *  set方法，存放相册组
 *
 *  @param titleArray
 */
-(void)titleArray:(NSArray *)titleArray{
    _titleArray = [NSArray arrayWithArray:titleArray];
    if (_titleArray.count>0) {
        ALAssetsGroup* group            = [_titleArray lastObject];
        folkSection                     = [_titleArray indexOfObject:group];
        isfolk                          = YES;
        _imgArray                       = [self getImagesFromAssetGroup:group];
        [self.collectionView reloadData];
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.collectionView.numberOfSections-1] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        CGPoint tmppo;
        if (fixY.y == 0) {
            CGPoint po = [self.collectionView contentOffset];
            po.y-=[imgCollectionReusableView imgCollectionReusableViewHeaderSectionSize].height;
            fixY = po;
            tmppo = po;
        }else{
            tmppo.y = fixY.y - 64;
        }
        [self.collectionView setContentOffset:tmppo animated:NO];
    }
}

/**
 *  alassetlibrary实例
 *
 *  @return
 */
-(imagesLoader*)imageloader{
    if (!_imgloader) {
        _imgloader                      = [imagesLoader sharedObject];
    }
    return _imgloader;
}

/**
 *  是否已经选择，ALAsset的相似性
 *
 *  @param asset
 *
 *  @return
 */
- (ALAsset *)assetSimilarTo:(ALAsset *)asset {
    ALAsset *similarAsset               = nil;
    NSURL *assetURL                     = [asset defaultRepresentation].url;
    for (ALAsset *a in _selectedArray) {
        NSURL *aURL                     = [a defaultRepresentation].url;
        if ([assetURL isEqual:aURL]) {
            similarAsset                = a;
            break;
        }
    }
    return similarAsset;
}

/**
 *  判断照片是否选择了
 *
 *  @param asset 、
 *
 *  @return 、
 */
-(BOOL)isselected:(ALAsset *)asset{
    return ([self assetSimilarTo:asset]!=nil);
}

/**
 *  新增照片
 *
 *  @param asset
 */
- (void)addAsset:(ALAsset *)asset {
    if (![self isselected:asset]) [_selectedArray addObject:asset];
}

/**
 *  移除照片
 *
 *  @param asset
 */
- (void)removeAsset:(ALAsset *)asset {
    ALAsset *assetToRemove              = [self assetSimilarTo:asset];
    if (assetToRemove)
        [_selectedArray removeObject:assetToRemove];
}

/**
 *  通过group获取组里的照片
 *
 *  @param group
 *
 *  @return
 */
-(NSArray *)getImagesFromAssetGroup:(ALAssetsGroup*)group{
    __block NSMutableArray *arr         = [NSMutableArray array];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [arr addObject:result];
        }
    }];
    NSString* photo                     = @"photo";
    [arr insertObject:photo atIndex:0];
    return [NSArray arrayWithArray:arr];
}

/**
 *  选择完成
 */
-(void)handleComplete{
    if (comBlock) {
        [self dismissViewControllerAnimated:YES completion:nil];
        comBlock(_selectedArray,imagestypeAlassets);
    }
}

@end
