//
//  RYEnshrineTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYEnshrineTableViewCell : UITableViewCell

@property (nonatomic , strong) UILabel     *contentLabel;
@property (nonatomic , strong) UIImageView *icoImageView;
@property (nonatomic , strong) UILabel     *tallyLabel;
@property (nonatomic , strong) UIButton    *editBtn;


- (void)setValueWithDict:(NSDictionary *)dict;

@end
