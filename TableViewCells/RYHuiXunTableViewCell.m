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
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,10, 95, 70)];
        self.leftImageView.layer.borderColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0].CGColor;
        self.leftImageView.layer.borderWidth = 0.5;
        [self.contentView addSubview:self.leftImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImageView.frame) + 5,
                                                                    8,
                                                                    SCREEN_WIDTH - 30 - 5 - self.leftImageView.width,
                                                                    39)];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        
        self.subheadLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                                                      CGRectGetMaxY(self.titleLabel.frame) + 5,
                                                                      self.titleLabel.width, 30)];
        self.subheadLabel.font = [UIFont systemFontOfSize:12];
        self.subheadLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        self.subheadLabel.numberOfLines = 2;
        [self.contentView addSubview:self.subheadLabel];
        
        self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(15,
                                                                  CGRectGetMaxY(self.leftImageView.frame) + 10,
                                                                  self.titleLabel.width,
                                                                   12)];
        self.timeLable.font = [UIFont systemFontOfSize:12];
        self.timeLable.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.timeLable];
        
        
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return;
    }
    NSString *pic = [dict getStringValueForKey:@"pic" defaultValue:@""];
    NSString *title = [dict getStringValueForKey:@"subject" defaultValue:@""];
    
    [self.leftImageView setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"ic_pic_default.png"]];
    if ( ![ShowBox isEmptyString:pic] ) {
        self.leftImageView.width = 95;
        self.titleLabel.left = self.leftImageView.right + 5;
        self.titleLabel.width = SCREEN_WIDTH - 30 - 5 - self.leftImageView.width;
        self.titleLabel.height = 39;
        self.subheadLabel.left = self.titleLabel.left;
        self.subheadLabel.width = self.titleLabel.width;
        self.subheadLabel.height = 30;
        self.subheadLabel.top = self.titleLabel.bottom + 5;
        self.timeLable.top = self.leftImageView.bottom + 10;
       
    }
    else{
        self.leftImageView.width = 0;
        self.titleLabel.left = 15;
        self.titleLabel.width = SCREEN_WIDTH - 30;
        
        NSDictionary *actualAttributes = @{NSFontAttributeName:self.titleLabel.font};
        CGRect actualRect = [title boundingRectWithSize:CGSizeMake(self.titleLabel.width, 39)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:actualAttributes
                                                context:nil];
        self.titleLabel.height = actualRect.size.height;

        
        self.subheadLabel.left = self.titleLabel.left;
        self.subheadLabel.width = self.titleLabel.width;
        
        NSDictionary *subheadAttributes = @{NSFontAttributeName:self.titleLabel.font};
        CGRect subheadRect = [title boundingRectWithSize:CGSizeMake(self.titleLabel.width, 30)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:subheadAttributes
                                                context:nil];
        self.subheadLabel.height = subheadRect.size.height;
        self.subheadLabel.top = self.titleLabel.bottom + 5;
        self.timeLable.top = self.subheadLabel.bottom + 10;
    }
    
    self.titleLabel.text = title;
    
    self.subheadLabel.text = [dict getStringValueForKey:@"organizer" defaultValue:@""];
    self.timeLable.text = [dict getStringValueForKey:@"time" defaultValue:@""];
    
}

@end
