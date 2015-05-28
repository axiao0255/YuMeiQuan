//
//  RYLiteratureQueryTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYLiteratureQueryTableViewCell : UITableViewCell

@property (strong , nonatomic)  UIImageView       *leftImgView;
@property (strong , nonatomic)  UILabel           *titleLabel;

- (void)setValueWithDict:(NSDictionary *)dict;

@end


@interface RYLiteratureQuerySubjectTableViewCell : UITableViewCell

@property (strong , nonatomic) UILabel            *titleLabel;

- (void)setValueWithString:(NSString *)string;

@end


@interface RYLiteratureQueryOrdinaryTableViewCell : UITableViewCell

@property (strong , nonatomic) UILabel            *titleLabel;

- (void)setValueWithString:(NSString *)string;


@end
