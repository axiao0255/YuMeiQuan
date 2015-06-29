//
//  RYNewsPageTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYNewsPageTableViewCell.h"

@implementation RYNewsPageTableViewCell

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
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 58, 58)];
        [self.contentView addSubview:self.leftImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImageView.frame) + 8,
                                                                    8, SCREEN_WIDTH - 30 - 58, 39)];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                                                   55, 100, 12)];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return;
    }
    
    [self.leftImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"ic_pic_default.png"]];
    self.titleLabel.text = [dict getStringValueForKey:@"subject" defaultValue:@""];
    self.timeLabel.text = [dict getStringValueForKey:@"time" defaultValue:@""];
}

@end

@implementation RYAdverTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.adverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
        [self.contentView addSubview:self.adverImageView];
        
        self.transparencyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, 40)];
        [self.adverImageView addSubview:self.transparencyImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, self.transparencyImageView.height)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.numberOfLines = 2;
        [self.transparencyImageView addSubview:self.titleLabel];
        
//        UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, 8)];
//        segmentView.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
//        [self.contentView addSubview:segmentView];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( !dict ) {
        return;
    }
    [self.adverImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"ic_bigPic_defaule.png"]];
    NSString *title = [dict getStringValueForKey:@"subject" defaultValue:@""];
    CGSize size = [title sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, 40)];
    self.transparencyImageView.height = size.height + 8;
    self.transparencyImageView.top = 180 - self.transparencyImageView.height;
    self.titleLabel.frame = CGRectMake(15, 0, SCREEN_WIDTH - 30, self.transparencyImageView.height);
    self.transparencyImageView.image = [UIImage imageNamed:@"ic_transparency.png"];
    self.titleLabel.text = title;//[dict getStringValueForKey:@"subject" defaultValue:@""];
    
}

@end
