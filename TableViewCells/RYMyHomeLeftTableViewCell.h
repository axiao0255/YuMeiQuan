//
//  RYMyHomeLeftTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYMyHomeLeftTableViewCell : UITableViewCell

// top 黄色 cell
@property (nonatomic , strong) UIButton      *headPortraitButton;
@property (nonatomic , strong) UIImageView   *headPortraitImageView;
@property (nonatomic , strong) UILabel       *userNameLabel;

-(id)initWithTopCellStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

//
@property (nonatomic , strong) UIImageView   *commonImageView;
@property (nonatomic , strong) UIImage       *highlightImage;
@property (nonatomic , strong) UIImage       *normalImage;
//@property (nonatomic , strong) UIView        *separateLine;       // 分割线

-(id)initWithCommonStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

// 退出按钮的cell
@property (nonatomic , strong) UIButton      *exitButton;          // 退出登录按钮
-(id)initWithExitStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
