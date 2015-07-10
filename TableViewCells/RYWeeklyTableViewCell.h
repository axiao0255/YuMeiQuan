//
//  RYWeeklyTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYWeeklyTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView      *leftImgView;
@property (nonatomic , strong) UILabel          *titleLabel;
@property (nonatomic , strong) UILabel          *timeLabel;

- (void)setValueWithDict:(NSDictionary *)dict;

@end
