//
//  RYNewsPageTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYNewsPageTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView *leftImageView;
@property (nonatomic , strong) UILabel     *titleLabel;
@property (nonatomic , strong) UILabel     *timeLabel;

- (void)setValueWithDict:(NSDictionary *)dict;

@end

@interface RYAdverTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView *adverImageView;
@property (nonatomic , strong) UIImageView *transparencyImageView;
@property (nonatomic , strong) UILabel     *titleLabel;

- (void)setValueWithDict:(NSDictionary *)dict;


@end