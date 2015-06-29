//
//  RYMyInformListTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/5.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyInformListTableViewCell.h"

@implementation RYMyInformListTableViewCell

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
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 30)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,
                                                                     CGRectGetMaxY(self.titleLabel.frame),SCREEN_WIDTH - 30,
                                                                     44)];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [UIFont systemFontOfSize:12];
        self.contentLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        self.contentLabel.numberOfLines = 3;
        [self.contentView addSubview:self.contentLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 74, SCREEN_WIDTH - 30 , 24)];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

-(void)setValueWithDict:(NSDictionary *)dic
{
    if ( !dic ) {
        return;
    }
    
    self.titleLabel.text = [dic getStringValueForKey:@"title" defaultValue:@""];
    self.contentLabel.text = [dic getStringValueForKey:@"note" defaultValue:@""];
    self.timeLabel.text = [dic getStringValueForKey:@"time" defaultValue:@""];
}

@end
