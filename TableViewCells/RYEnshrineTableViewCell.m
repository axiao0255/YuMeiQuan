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
        
        UIImage *icoImage = [UIImage imageNamed:@"ico_default.png"];
        self.icoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 60, icoImage.size.width, icoImage.size.height)];
        self.icoImageView.backgroundColor = [UIColor clearColor];
        self.icoImageView.image = icoImage;
        [self.contentView addSubview:self.icoImageView];
        
        self.tallyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icoImageView.right + 5,  self.icoImageView.top, 190, 12)];
        self.tallyLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        self.tallyLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.tallyLabel];
        
        
        self.editBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 75, 50, 75, 30)];
        self.editBtn.layer.cornerRadius = 4;
        self.editBtn.layer.masksToBounds = YES;
        self.editBtn.layer.borderWidth = 1.0;
        self.editBtn.layer.borderColor = [Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0].CGColor;
        [self.editBtn setTitle:@"编辑标签" forState:UIControlStateNormal];
        [self.editBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.editBtn setTitleColor:[Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0] forState:UIControlStateNormal];
        [self.contentView addSubview:self.editBtn];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( !dict ) {
        return;
    }
    
    self.contentLabel.text = [dict getStringValueForKey:@"subject" defaultValue:@""];
    [self.contentLabel sizeToFit];
    self.tallyLabel.text = [dict getStringValueForKey:@"name" defaultValue:@""];
}


@end
