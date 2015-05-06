//
//  RYMyInformListTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/5.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYMyInformListTableViewCell : UITableViewCell

@property (nonatomic , strong) UILabel  *titleLabel;
@property (nonatomic , strong) UILabel  *contentLabel;
@property (nonatomic , strong) UILabel  *timeLabel;

-(void)setValueWithDict:(NSDictionary *)dic;

@end
