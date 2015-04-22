//
//  RYRegisterSpecialtyTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYRegisterSpecialtyTableViewCell.h"

@implementation RYRegisterSpecialtyTableViewCell

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
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 20 - 50, 40)];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.textColor = [Utils getRGBColor:70.0 g:70.0 b:70.0 a:1.0];
        [self.contentView addSubview:self.contentLabel];
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 25, 7, 25, 25)];
        self.arrowImageView.backgroundColor = [UIColor clearColor];
        self.arrowImageView.image = [UIImage imageNamed:@"arrow_add"];
        [self.contentView addSubview:self.arrowImageView];
        
        _partingLine = [Utils getCellPartingLine];
        _partingLine.frame = CGRectMake(20, 39.5, SCREEN_WIDTH, 0.5);
        [self.contentView addSubview:_partingLine];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
