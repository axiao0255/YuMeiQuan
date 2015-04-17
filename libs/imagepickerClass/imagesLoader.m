//
//  imagesLoader.m
//  assetImagepicker
//
//  Created by 刚正面的斯温 on 15-2-12.
//  Copyright (c) 2015年 hyq. All rights reserved.
//

#import "imagesLoader.h"

@implementation imagesLoader{
    ALAssetsLibrary* assetsLibrary;
}

+ (instancetype)sharedObject {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return self;
}
-(void)loadImageWithblock:(void (^)(NSArray *))block{
    __block NSMutableArray* array           = [NSMutableArray array];
    __block NSArray* tmparr                 = [NSArray array];
    __block BOOL isend                      = NO;
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [array addObject:group];
            tmparr                          = [NSArray arrayWithArray:array];
        }else{
            isend = YES;
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
    while (!isend) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
         
                                 beforeDate: [NSDate distantFuture]];
    }
    block(tmparr);
}

-(void)loadImageWithblock:(void (^)(NSArray *))block andpropertyName:(NSString*)propertyName{
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:propertyName]) {
                __block NSMutableArray* array = [NSMutableArray array];
                
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result) {
                        [array addObject:result];
                    } 
                }];
                NSArray* tmparr               = [NSArray arrayWithArray:array];
                block(tmparr);
            }
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

-(ALAssetsLibrary*)alassetsLibrary{
    if (!assetsLibrary) {
        assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return assetsLibrary;
}
@end
