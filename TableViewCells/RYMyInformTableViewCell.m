//
//  RYMyInformTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/5.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyInformTableViewCell.h"

@implementation RYMyInformTableViewCell

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
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 265, 48)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [self.contentView addSubview:self.titleLabel];
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 20, 14, 20, 20)];
        self.numLabel.backgroundColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
        self.numLabel.font = [UIFont systemFontOfSize:10];
        self.numLabel.textColor = [UIColor whiteColor];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.layer.cornerRadius = 10;
        self.numLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:self.numLabel];
    }
    return self;
}

@end
