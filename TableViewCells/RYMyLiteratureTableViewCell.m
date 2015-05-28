//
//  RYMyLiteratureTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyLiteratureTableViewCell.h"

@implementation RYMyLiteratureTableViewCell

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
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 26, 26)];
        [self.contentView addSubview:self.leftImgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 8, SCREEN_WIDTH - 68 - 15, 36)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 48, SCREEN_WIDTH - 68 - 15, 10)];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return;
    }
    
    BOOL state = [dict getBoolValueForKey:@"state" defaultValue:NO];
    if ( state ) {
        self.leftImgView.image = [UIImage imageNamed:@"ic_successful.png"];
    }
    else{
        self.leftImgView.image = [UIImage imageNamed:@"ic_query.png"];
    }
    
    self.titleLabel.text = [dict getStringValueForKey:@"title" defaultValue:@""];
    self.timeLabel.text = [dict getStringValueForKey:@"time" defaultValue:@""];
    
}
@end
