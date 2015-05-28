//
//  RYPastWeeklyTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYPastWeeklyTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView *leftImgView;
@property (nonatomic , strong) UILabel     *timeLabel;
@property (nonatomic , strong) UILabel     *titleLabel;

- (void)setValueWithDict:(NSDictionary *)dict;

@end
