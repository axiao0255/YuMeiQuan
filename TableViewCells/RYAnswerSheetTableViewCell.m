//
//  RYAnswerSheetTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYAnswerSheetTableViewCell.h"

@implementation RYAnswerSheetTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if ( selected ) {
//        self.leftImgView.image = [UIImage imageNamed:@"ic_answer_highlighted.png"];
//    }
//    else{
//        self.leftImgView.image = [UIImage imageNamed:@"ic_answer_normal.png"];
//    }
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 30, 30)];
        [self.contentView addSubview:self.leftImgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImgView.right + 15, 16, SCREEN_WIDTH - 75, 15)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setValueWithString:(NSString *)string
{
    if ( [ShowBox isEmptyString:string] ) {
        return;
    }
    CGSize size = [string sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH - 75, MAXFLOAT)];
    self.titleLabel.height = size.height;
    self.titleLabel.text = string;
    self.leftImgView.top = (size.height + 32)/2.0 - self.leftImgView.height/2.0;
}

-(void)changeSelectHighlighted:(BOOL)highlighted
{
    if ( highlighted ) {
        self.leftImgView.image = [UIImage imageNamed:@"ic_answer_highlighted.png"];
    }
    else{
        self.leftImgView.image = [UIImage imageNamed:@"ic_answer_normal.png"];
    }

}

@end
