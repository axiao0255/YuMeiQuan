//
//  RYMyShareTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/4.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYMyShareTableViewCell : UITableViewCell

@property (nonatomic , strong) UILabel        *contentLabel;        // 内容
@property (nonatomic , strong) UIImageView    *iconImageView;       // 图标
@property (nonatomic , strong) UILabel        *readNumLabel;        // 阅读次数


- (void)setValueWithDict:(NSDictionary *)dic;

@end
