//
//  RYHuiXunTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYHuiXunTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView    *leftImageView;
@property (nonatomic , strong) UILabel        *titleLabel;
@property (nonatomic , strong) UILabel        *timeLable;
@property (nonatomic , strong) UILabel        *subheadLabel;
@property (nonatomic , strong) UIImageView    *integratorImgView;

- (void)setValueWithDict:(NSDictionary *)dict;

@end
