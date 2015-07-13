//
//  RYLiteratureCategoryViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/13.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

@protocol RYLiteratureCategoryViewControllerDelegate <NSObject>

-(void)selectLiteratureCategoryWithIndex:(NSInteger) index;

@end

#import "RYBaseViewController.h"

@interface RYLiteratureCategoryViewController : RYBaseViewController

@property (nonatomic,assign) id<RYLiteratureCategoryViewControllerDelegate> delegate;
@property (nonatomic,strong) NSArray          *categoryArray;


-(id)initWithCategoryArray:(NSArray *)categoryArray;



@end
