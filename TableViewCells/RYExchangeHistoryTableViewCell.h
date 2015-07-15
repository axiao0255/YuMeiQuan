//
//  RYExchangeHistoryTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/15.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYExchangeHistoryTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView  *leftImgView;
@property (nonatomic , strong) UILabel      *titleLabel;
@property (nonatomic , strong) UILabel      *subheadLabel;
@property (nonatomic , strong) UILabel      *timeLabel;

- (void)setValueWithDict:(NSDictionary *)dict;


@end
