//
//  RYMyLiteratureTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYMyLiteratureTableViewCell : UITableViewCell

@property (strong , nonatomic) UIImageView     *leftImgView;
@property (strong , nonatomic) UILabel         *titleLabel;
@property (strong , nonatomic) UILabel         *timeLabel;


- (void)setValueWithDict:(NSDictionary *)dict;

@end
