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
        
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 14, 14)];

        [self.contentView addSubview:self.leftImgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImgView.right + 10, 0, 225, 44)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [self.contentView addSubview:self.titleLabel];
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 33, 14, 16, 16)];
        self.numLabel.backgroundColor = [UIColor redColor];//[Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
        self.numLabel.font = [UIFont boldSystemFontOfSize:10];
        self.numLabel.textColor = [UIColor whiteColor];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.layer.cornerRadius = 8;
        self.numLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:self.numLabel];
        
//        self.subheadLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImgView.right + 10, 45, 225, 14)];
//        self.subheadLabel.backgroundColor = [UIColor clearColor];
//        self.subheadLabel.font = [UIFont systemFontOfSize:14];
//        self.subheadLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
//        [self.contentView addSubview:self.subheadLabel];
    }
    return self;
}

@end


@implementation RYCompanyNoticeTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 260, 16)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [self.contentView addSubview:self.titleLabel];
        
        self.subheadLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 33, 260, 14)];
        self.subheadLabel.backgroundColor = [UIColor clearColor];
        self.subheadLabel.font = [UIFont systemFontOfSize:14];
        self.subheadLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.subheadLabel];
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 33, 22, 16, 16)];
        self.numLabel.backgroundColor = [UIColor redColor];
        self.numLabel.font = [UIFont boldSystemFontOfSize:10];
        self.numLabel.textColor = [UIColor whiteColor];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.layer.cornerRadius = 8;
        self.numLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:self.numLabel];
    }
    return self;
}

-(void)setValueWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return;
    }
    
    self.titleLabel.text = [dict getStringValueForKey:@"author" defaultValue:@""];
    self.subheadLabel.text = [dict getStringValueForKey:@"note" defaultValue:@""];
    
    NSInteger count = [dict getIntValueForKey:@"count" defaultValue:0];
    if (count > 0) {
        self.numLabel.hidden = NO;
        self.numLabel.text = [NSString stringWithFormat:@"%li",count];
    }
    else{
        self.numLabel.hidden = YES;
    }
}
@end
