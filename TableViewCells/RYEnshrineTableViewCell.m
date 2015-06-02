//
//  RYEnshrineTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYEnshrineTableViewCell.h"

@implementation RYEnshrineTableViewCell

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
        
//        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 48, 100, 20)];
//        self.timeLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
//        self.timeLabel.font = [UIFont systemFontOfSize:10];
//        self.timeLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:self.timeLabel];
        
        UIImage *icoImage = [UIImage imageNamed:@"ico_default.png"];
        self.icoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 55, icoImage.size.width, icoImage.size.height)];
        self.icoImageView.backgroundColor = [UIColor clearColor];
        self.icoImageView.image = icoImage;
        [self.contentView addSubview:self.icoImageView];
        
        self.tallyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icoImageView.right + 5,  self.contentLabel.bottom + 8, 200, 12)];
        self.tallyLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
//        self.tallyLabel.textAlignment = NSTextAlignmentRight;
        self.tallyLabel.backgroundColor = [UIColor clearColor];
        self.tallyLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.tallyLabel];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( !dict ) {
        return;
    }
    
    self.contentLabel.text = [dict getStringValueForKey:@"title" defaultValue:@""];
    [self.contentLabel sizeToFit];
    
//    self.timeLabel.text = [dict getStringValueForKey:@"time" defaultValue:@""];
//    [self.timeLabel sizeToFit];
    
//    NSString *str = [dict getStringValueForKey:@"class" defaultValue:@""];
//    CGSize labelsize = [str sizeWithFont:self.tallyLabel.font];
//    self.tallyLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - labelsize.width,
//                                       CGRectGetMinY(self.tallyLabel.frame),
//                                       labelsize.width,
//                                       CGRectGetHeight(self.tallyLabel.frame));
//    self.tallyLabel.text = str;
//    [self.tallyLabel sizeToFit];
//    
//    CGRect icoRect = self.icoImageView.frame;
//    icoRect.origin.x = CGRectGetMinX(self.tallyLabel.frame) - 2 - CGRectGetWidth(self.icoImageView.bounds);
//    self.icoImageView.frame = icoRect;
    
    self.tallyLabel.text = [dict getStringValueForKey:@"class" defaultValue:@""];
}


@end
