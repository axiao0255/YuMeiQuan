//
//  RYMyHomeLeftTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyHomeLeftTableViewCell.h"

@implementation RYMyHomeLeftTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(id)initWithTopCellStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        
        self.backgroundColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
        
        self.headPortraitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 43, 220, 37)];
        self.headPortraitButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.headPortraitButton];
        
        self.headPortraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
        self.headPortraitImageView.backgroundColor = [UIColor clearColor];
        [self.headPortraitButton addSubview:self.headPortraitImageView];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headPortraitImageView.frame)+13,
                                                                      CGRectGetMinY(self.headPortraitImageView.frame),
                                                                      100,
                                                                       CGRectGetHeight(self.headPortraitImageView.bounds))];
        self.userNameLabel.font = [UIFont boldSystemFontOfSize:16];
        self.userNameLabel.textColor = [UIColor whiteColor];
        [self.headPortraitButton addSubview:self.userNameLabel];
    }
    return self;
}

#pragma mark -----------------------

-(id)initWithCommonStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        
        self.commonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 43)];
        self.commonImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.commonImageView];
        
//        self.separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 1)];
//        self.backgroundColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0];
//        [self.commonImageView addSubview:self.separateLine];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted)
    {
        self.commonImageView.image = self.highlightImage;
    }
    else
    {
        self.commonImageView.image = self.normalImage;
    }
}

#pragma mark -----------------------
-(id)initWithExitStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.backgroundColor = [UIColor clearColor];
        self.exitButton = [Utils getCustomLongButton:@"退出账号"];
        self.exitButton.frame = CGRectMake(20, 8, 180, 34);
        self.exitButton.backgroundColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0];
        [self.exitButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.contentView addSubview:self.exitButton];
    }
    return self;
}



@end
