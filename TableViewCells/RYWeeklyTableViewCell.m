//
//  RYWeeklyTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYWeeklyTableViewCell.h"

@implementation RYWeeklyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.belongsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 44, 0, 44, 19)];
        self.belongsLabel.textAlignment = NSTextAlignmentCenter;
        self.belongsLabel.backgroundColor = [Utils getRGBColor:0xd8 g:0xd8 b:0xd8 a:1.0];
        self.belongsLabel.textColor = [Utils getRGBColor:0xff g:0xff b:0xff a:1.0];
        self.belongsLabel.font = [UIFont systemFontOfSize:10];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.belongsLabel.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.belongsLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        self.belongsLabel.layer.mask = maskLayer;
        [self.contentView addSubview:self.belongsLabel];
        
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.belongsLabel.bottom + 8, 58, 58)];
        [self.contentView addSubview:self.leftImgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImgView.right + 8, self.leftImgView.top, SCREEN_WIDTH - 30 - 8 - self.leftImgView.width, 39)];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 8, self.titleLabel.width, 10)];
        self.timeLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.timeLabel];
        
        self.subheadLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.timeLabel.left, self.timeLabel.bottom + 8 , self.timeLabel.width, 10)];
        self.subheadLabel.font = [UIFont systemFontOfSize:12];
        self.subheadLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        [self.contentView addSubview:self.subheadLabel];
        
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( !dict ) {
        return;
    }
    self.belongsLabel.text = [dict getStringValueForKey:@"belongs" defaultValue:@""];
    NSString *pic = [dict getStringValueForKey:@"pic" defaultValue:@""];
    [self.leftImgView setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"ic_pic_default.png"]];
    self.titleLabel.text = [dict getStringValueForKey:@"title" defaultValue:@""];
    self.timeLabel.text = [dict getStringValueForKey:@"time" defaultValue:@""];
    self.subheadLabel.text = [dict getStringValueForKey:@"subhead" defaultValue:@""];
   
}

@end
