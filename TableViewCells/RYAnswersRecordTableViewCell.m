//
//  RYAnswersRecordTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYAnswersRecordTableViewCell.h"

@implementation RYAnswersRecordTableViewCell

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
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame) + 8, 8, SCREEN_WIDTH - 30 - 58, 39)];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        
        self.jifenLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100, self.titleLabel.bottom + 8, 100, 12)];
        self.jifenLabel.font = [UIFont systemFontOfSize:12];
        self.jifenLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.jifenLabel];
        
        
        self.jifenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.jifenLabel.left-4-13, self.jifenLabel.top, 13, 10)];
        self.jifenImageView.image = [UIImage imageNamed:@"ic_small_jifen.png"];
        [self.contentView addSubview:self.jifenImageView];
        
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return;
    }
    NSString *pic = [dict getStringValueForKey:@"pic" defaultValue:@""];
    [self.leftImgView setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"ic_default_small.png"]];
    self.titleLabel.text = [dict getStringValueForKey:@"title" defaultValue:@""];
    
    NSString *jifen = [ dict getStringValueForKey:@"jifen" defaultValue:@""];
    CGSize size = [jifen sizeWithFont:self.jifenLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH, 12)];
    self.jifenLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - size.width, self.jifenLabel.top, size.width, 12);
    self.jifenLabel.text = jifen;
    
    self.jifenImageView.left = self.jifenLabel.left - 4 - self.jifenImageView.width;
}


@end
