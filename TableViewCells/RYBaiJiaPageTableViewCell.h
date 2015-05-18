//
//  RYBaiJiaPageTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYBaiJiaPageTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView      *leftImgView;
@property (nonatomic , strong) UILabel          *titleLabel;

- (void)setValueWithDict:(NSDictionary *)dict;

@end
