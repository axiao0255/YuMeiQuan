//
//  RYWeeklyPageTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYWeeklyPageTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView *adverImageView;
@property (nonatomic , strong) UIImageView *transparencyImageView;
@property (nonatomic , strong) UILabel     *titleLabel;
@property (nonatomic , strong) UILabel     *contentLabel;
@property (nonatomic , strong) UILabel     *timeLabel;

- (void)setValueWithDict:(NSDictionary *)dict;

@end
