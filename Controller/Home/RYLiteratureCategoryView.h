//
//  RYLiteratureCategoryView.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RYLiteratureCategoryViewDelegate <NSObject>

- (void)literatureCategorySelected:(NSInteger)btntag selfTag:(NSInteger)selftag;
- (void)dismissCompletion;

@end

@interface RYLiteratureCategoryView : UIView


@property (assign , nonatomic) id<RYLiteratureCategoryViewDelegate>delegate;

@property (strong , nonatomic) NSArray        *categoryData;

@property (assign , nonatomic) CGFloat        offSetY;


- (void)showCategoryView;
- (void)dismissCategoryView;
@end
