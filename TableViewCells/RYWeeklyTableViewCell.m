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
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 95, 70)];
        [self.contentView addSubview:self.leftImgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImgView.right + 5, 8, SCREEN_WIDTH - 30 - 5 - self.leftImgView.width, 58)];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.numberOfLines = 3;
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100, self.titleLabel.bottom + 3, 100, 12)];
        self.timeLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
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
    self.titleLabel.width = SCREEN_WIDTH - 130;
    self.titleLabel.height = 58;
    self.titleLabel.text = [dict getStringValueForKey:@"subject" defaultValue:@""];
    [self.titleLabel sizeToFit];
    self.timeLabel.text = [dict getStringValueForKey:@"time" defaultValue:@""];
}

@end
