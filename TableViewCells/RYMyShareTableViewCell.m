//
//  RYMyShareTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/4.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyShareTableViewCell.h"

@implementation RYMyShareTableViewCell

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
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH - 30, 39)];
        self.contentLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        self.contentLabel.numberOfLines = 2;
        [self.contentView addSubview:self.contentLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.contentLabel.bottom + 8, 100, 12)];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.timeLabel];
        
        self.jifenLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100,self.timeLabel.top,100,12)];
        self.jifenLabel.font = [UIFont systemFontOfSize:12];
        self.jifenLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.jifenLabel];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.jifenLabel.left - 4 - 13, self.jifenLabel.top, 13, 10)];
        self.iconImageView.image = [UIImage imageNamed:@"ic_small_jifen.png"];
        [self.contentView addSubview:self.iconImageView];


    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dic
{
    if (!dic) {
        return;
    }
    
    self.contentLabel.text = [dic getStringValueForKey:@"title" defaultValue:@""];
//    [self.contentLabel sizeToFit];
    NSString *jifen = [dic getStringValueForKey:@"jifen" defaultValue:@""];
    CGSize size = [jifen sizeWithFont:self.jifenLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH, 12)];
    self.jifenLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - size.width, self.jifenLabel.top, size.width, 12);
    self.jifenLabel.text = jifen;
    self.iconImageView.left = self.jifenLabel.left - 4 - self.iconImageView.width;
    
    self.timeLabel.text = [dic getStringValueForKey:@"time" defaultValue:@""];
}

@end
