//
//  RYPastWeeklyTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYPastWeeklyTableViewCell.h"

@implementation RYPastWeeklyTableViewCell

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
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 58, 58)];
        [self.contentView addSubview:self.leftImgView];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImgView.right + 8, 8, SCREEN_WIDTH - 30 - 8 - self.leftImgView.width, 12)];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        [self.contentView addSubview:self.timeLabel];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.timeLabel.left, self.timeLabel.bottom + 8, self.timeLabel.width, 39)];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return;
    }
    
    NSString *pic = [dict getStringValueForKey:@"pic" defaultValue:@""];
    [self.leftImgView setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"ic_pic_default.png"]];
    self.titleLabel.text = [dict getStringValueForKey:@"subject" defaultValue:@""];
    
    NSString *time = [dict getStringValueForKey:@"time" defaultValue:@""];
    NSString *idStr = [dict getStringValueForKey:@"id" defaultValue:@""];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 总第%@期",time,idStr];
}

@end
