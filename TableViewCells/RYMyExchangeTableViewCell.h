//
//  RYMyExchangeTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYMyExchangeTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView  *leftImgView;
@property (nonatomic , strong) UILabel      *titleLabel;
@property (nonatomic , strong) UILabel      *jifenLabel;
@property (nonatomic , strong) UIButton     *exchangeBtn;

- (void)setValueWithDict:(NSDictionary *)dict;

@end
