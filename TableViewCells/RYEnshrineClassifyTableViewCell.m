//
//  RYEnshrineClassifyTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/28.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYEnshrineClassifyTableViewCell.h"

@implementation RYEnshrineClassifyTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH - 30, 20)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [self.contentView addSubview:self.titleLabel];
        
        self.numLabel = [[UILabel alloc] initWithFrame: CGRectMake(CGRectGetMinX(self.titleLabel.frame), 28, SCREEN_WIDTH - 30, 20)];
        self.numLabel.backgroundColor = [UIColor clearColor];
        self.numLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        self.numLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.numLabel];
    }
    return self;
}

@end
