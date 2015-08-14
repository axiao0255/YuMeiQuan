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


//-(id)initWithTopCellStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if ( self ) {
//        
//        self.backgroundColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
//        
//        self.headPortraitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 43, 220, 37)];
//        self.headPortraitButton.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:self.headPortraitButton];
//        
//        self.headPortraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
//        self.headPortraitImageView.backgroundColor = [UIColor clearColor];
//        [self.headPortraitButton addSubview:self.headPortraitImageView];
//        
//        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headPortraitImageView.frame)+13,
//                                                                      CGRectGetMinY(self.headPortraitImageView.frame),
//                                                                      100,
//                                                                       CGRectGetHeight(self.headPortraitImageView.bounds))];
//        self.userNameLabel.font = [UIFont boldSystemFontOfSize:16];
//        self.userNameLabel.textColor = [UIColor whiteColor];
//        [self.headPortraitButton addSubview:self.userNameLabel];
//    }
//    return self;
//}
//
#pragma mark -----------------------

-(id)initWithCommonStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        
        self.commonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IS_IPHONE_4_OR_LESS?(SCREEN_WIDTH-10):(SCREEN_WIDTH-55), 40*SCREEN_WIDTH/320)];
        self.commonImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.commonImageView];
        
//        self.separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 1)];
//        self.backgroundColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0];
//        [self.commonImageView addSubview:self.separateLine];
        
//        self.noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 40, 43)];
//        self.noticeLabel.backgroundColor = [UIColor clearColor];
//        self.noticeLabel.textAlignment = NSTextAlignmentRight;
//        self.noticeLabel.font = [UIFont systemFontOfSize:16];
//        self.noticeLabel.textColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
//        [self.contentView addSubview:self.noticeLabel];
    
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



@end
