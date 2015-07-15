//
//  RYExchangeHistoryDetailsTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/15.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYExchangeHistoryDetailsTableViewCell.h"

@implementation RYExchangeHistoryDetailsTableViewCell

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
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 49, 16)];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.right, 10, SCREEN_WIDTH - 40 - 45 - 5, 39)];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        self.contentLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

@end
