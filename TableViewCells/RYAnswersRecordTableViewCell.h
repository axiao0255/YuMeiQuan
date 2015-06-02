//
//  RYAnswersRecordTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYAnswersRecordTableViewCell : UITableViewCell


@property (nonatomic , strong) UIImageView      *leftImgView;
@property (nonatomic , strong) UILabel          *titleLabel;
@property (nonatomic , strong) UIImageView      *jifenImageView;
@property (nonatomic , strong) UILabel          *jifenLabel;

- (void)setValueWithDict:(NSDictionary *)dict;


@end
