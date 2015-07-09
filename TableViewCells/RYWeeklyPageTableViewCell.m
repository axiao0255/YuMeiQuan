//
//  RYWeeklyPageTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYWeeklyPageTableViewCell.h"

@interface RYWeeklyPageTableViewCell ()

@property (nonatomic , strong) UIView *view;

@end

@implementation RYWeeklyPageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.adverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30 , 160)];
        [self.contentView addSubview:self.adverImageView];
        
        self.transparencyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 120, self.adverImageView.width, 40)];
        [self.adverImageView addSubview:self.transparencyImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,self.transparencyImageView.width - 30, self.transparencyImageView.height)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.transparencyImageView addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 180, SCREEN_WIDTH - 30, 39)];
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        self.contentLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.contentLabel.numberOfLines = 2;
        [self.contentView addSubview:self.contentLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.contentLabel.bottom + 5, SCREEN_WIDTH - 30, 11)];
        self.timeLabel.font = [UIFont systemFontOfSize:11];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        [self.contentView addSubview:self.timeLabel];
        
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, self.timeLabel.bottom + 5, SCREEN_WIDTH, 15)];
        self.view.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = [Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0];
        [self.view addSubview:line];
        [self.contentView addSubview:self.view];
        
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return ;
    }
    
    [self.adverImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"ic_bigPic_defaule.png"]];
    self.transparencyImageView.image = [UIImage imageNamed:@"ic_transparency.png"];
    
    NSString *idStr = [dict getStringValueForKey:@"id" defaultValue:@"0"];
    self.titleLabel.text = [NSString stringWithFormat:@"第%@期",idStr];
    
    NSString *subject = [dict getStringValueForKey:@"subject" defaultValue:@""];
    NSDictionary *praiseAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGRect praiseRect = [subject boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:praiseAttributes
                                              context:nil];
    if ( praiseRect.size.height > 30 ) {
        self.contentLabel.height = 39;
    }
    else{
        self.contentLabel.height = 16;
    }
    
    self.contentLabel.text = subject;
    
    self.timeLabel.top = self.contentLabel.bottom + 5;
    self.timeLabel.text = [dict getStringValueForKey:@"time" defaultValue:@""];
    
    self.view.top = self.timeLabel.bottom + 5;
}

@end
