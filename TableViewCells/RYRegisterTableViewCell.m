//
//  RYRegisterTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/17.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYRegisterTableViewCell.h"

@implementation RYRegisterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithTopStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 设置top 蓝色 view
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 ,15, 250, 40)];
        topView.backgroundColor = [Utils getRGBColor:0x04 g:0x8c b:0xcb a:1.0];
        [self.contentView addSubview:topView];
        // 绘制圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds
                                                       byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                             cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = topView.bounds;
        maskLayer.path = maskPath.CGPath;
        topView.layer.mask = maskLayer;
        
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 ,0, 250, 35)];
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.textColor = [UIColor whiteColor];
        topLabel.font = [UIFont boldSystemFontOfSize:14];
        topLabel.tag = 1212;
        topLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:topLabel];
        
        UITextField *textField = [Utils getCustomLongTextField:@""];
        textField.frame = CGRectMake(topView.frame.origin.x, 50, topView.frame.size.width, 40);
        textField.tag = 101;
        [self.contentView addSubview:textField];
    }
    return self;
}

@end
