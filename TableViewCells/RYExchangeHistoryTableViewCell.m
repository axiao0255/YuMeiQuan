//
//  RYExchangeHistoryTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/15.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYExchangeHistoryTableViewCell.h"

@implementation RYExchangeHistoryTableViewCell

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
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 95, 70)];
        self.leftImgView.layer.borderWidth = 1.0;
        self.leftImgView.layer.borderColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0].CGColor;
        [self.contentView addSubview:self.leftImgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImgView.right + 5, 10, SCREEN_WIDTH - 30 - 5 - self.leftImgView.width, 16)];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.titleLabel];
        
        self.subheadLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImgView.right + 5, self.titleLabel.bottom + 5, self.titleLabel.width, 32)];
        self.subheadLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        self.subheadLabel.font = [UIFont systemFontOfSize:13];
        self.subheadLabel.numberOfLines = 2;
        [self.contentView addSubview:self.subheadLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImgView.right + 5, self.subheadLabel.bottom + 5, self.titleLabel.width, 12)];
        self.timeLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( !dict ) {
        return;
    }
    
    NSString *pic = [dict getStringValueForKey:@"pic" defaultValue:@""];
    [self.leftImgView setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"ic_pic_default.png"]];
    self.titleLabel.text = [dict getStringValueForKey:@"name" defaultValue:@""];
    self.subheadLabel.text = [dict getStringValueForKey:@"subject" defaultValue:@""];
    self.timeLabel.text = [NSString stringWithFormat:@"兑换日期：%@",[dict getStringValueForKey:@"time" defaultValue:@""]];
}

@end
