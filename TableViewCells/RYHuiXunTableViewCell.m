//
//  RYHuiXunTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYHuiXunTableViewCell.h"

@implementation RYHuiXunTableViewCell

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
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 50, 50)];
        [self.contentView addSubview:self.leftImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImageView.frame) + 8,
                                                                    8,
                                                                    SCREEN_WIDTH - 30 - 58,
                                                                    35)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                                                  CGRectGetMaxY(self.titleLabel.frame) + 8,
                                                                  self.titleLabel.width,
                                                                   11)];
        self.timeLable.font = [UIFont systemFontOfSize:10];
        self.timeLable.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.timeLable];
        
        self.subheadLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.timeLable.frame),
                                                                     CGRectGetMaxY(self.timeLable.frame) + 8,
                                                                      self.titleLabel.width, 11)];
        self.subheadLabel.font = [UIFont systemFontOfSize:10];
        self.subheadLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.subheadLabel];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return;
    }
    NSString *pic = [dict getStringValueForKey:@"pic" defaultValue:@""];
    if ( ![ShowBox isEmptyString:pic] ) {
        self.leftImageView.width = 50;
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.leftImageView.frame) + 8,
                                           CGRectGetMinY(self.titleLabel.frame),
                                           SCREEN_WIDTH - 30 - 58,
                                           CGRectGetHeight(self.titleLabel.bounds));
        
    }
    else{
        self.leftImageView.width = 0;
        self.titleLabel.frame = CGRectMake(15,
                                           CGRectGetMinY(self.titleLabel.frame),
                                           SCREEN_WIDTH - 30,
                                           CGRectGetHeight(self.titleLabel.bounds));
    }
    [self.leftImageView setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"ic_pic_default.png"]];
    
    NSString *title = [dict getStringValueForKey:@"title" defaultValue:@""];
    CGSize titleSize = [title sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(self.titleLabel.width, 35)];
    CGRect rect = self.titleLabel.frame;
    rect.size.height = titleSize.height;
    self.titleLabel.frame = rect;
    self.titleLabel.text = title;
    
    self.timeLable.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                       CGRectGetMaxY(self.titleLabel.frame) + 8,
                                       CGRectGetWidth(self.titleLabel.bounds),
                                       10);
    self.timeLable.text = [dict getStringValueForKey:@"time" defaultValue:@""];
    
    self.subheadLabel.frame = CGRectMake(CGRectGetMinX(self.timeLable.frame),
                                         CGRectGetMaxY(self.timeLable.frame)+ 8,
                                         CGRectGetWidth(self.timeLable.bounds),
                                         10);
    self.subheadLabel.text = [dict getStringValueForKey:@"subhead" defaultValue:@""];
    
}

@end
