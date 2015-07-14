//
//  RYExchangeDetailsTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYExchangeDetailsTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView *imgView;
@property (nonatomic , strong) UIImageView *transparencyImageView;
@property (nonatomic , strong) UILabel     *titleLabel;

- (void)setValueWithDict:(NSDictionary *)dict;

@end


@interface RYExchangeTextFieldTableViewCell : UITableViewCell

@property (nonatomic , strong) UITextField   *textField;

@end