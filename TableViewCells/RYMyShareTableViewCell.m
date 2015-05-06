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
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH - 30, 30)];
        self.contentLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.numberOfLines = 2;
        [self.contentView addSubview:self.contentLabel];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 49, 17, 9)];
        self.iconImageView.image = [UIImage imageNamed:@"ic_read_num.png"];
        [self.contentView addSubview:self.iconImageView];
        
        self.readNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 8,40,100,25)];
        self.readNumLabel.font = [UIFont systemFontOfSize:10];
        self.readNumLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.readNumLabel];

    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dic
{
    if (!dic) {
        return;
    }
    
    self.contentLabel.text = [dic getStringValueForKey:@"title" defaultValue:@""];
    [self.contentLabel sizeToFit];
    self.readNumLabel.text = [dic getStringValueForKey:@"num" defaultValue:@""];
}

@end
