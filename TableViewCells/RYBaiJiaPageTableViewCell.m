//
//  RYBaiJiaPageTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaiJiaPageTableViewCell.h"

@implementation RYBaiJiaPageTableViewCell

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
        self.leftImgView.layer.borderColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0].CGColor;
        self.leftImgView.layer.borderWidth = 0.5;
        [self.contentView addSubview:self.leftImgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame) + 5, 8, SCREEN_WIDTH - 30 - 5 - self.leftImgView.width, 58)];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.numberOfLines = 3;
        [self.contentView addSubview:self.titleLabel];
        
        self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 3, self.titleLabel.width, 12)];
        self.authorLabel.font = [UIFont systemFontOfSize:12];
        self.authorLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        [self.contentView addSubview:self.authorLabel];
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
    self.titleLabel.width = SCREEN_WIDTH - 130;
    self.titleLabel.height = 58;
    self.titleLabel.text = [dict getStringValueForKey:@"subject" defaultValue:@""];
    [self.titleLabel sizeToFit];
    
    self.authorLabel.text = [dict getStringValueForKey:@"author" defaultValue:@""];
}

@end
