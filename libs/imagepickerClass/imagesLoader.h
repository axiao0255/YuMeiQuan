//
//  imagesLoader.h
//  assetImagepicker
//
//  Created by 刚正面的斯温 on 15-2-12.
//  Copyright (c) 2015年 hyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface imagesLoader : NSObject
+(instancetype)sharedObject;
-(ALAssetsLibrary*)alassetsLibrary;
-(void)loadImageWithblock:(void (^)(NSArray*))block;
-(void)loadImageWithblock:(void (^)(NSArray *))block andpropertyName:(NSString*)propertyName;
@end
