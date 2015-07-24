//
//  RYAnswersRecordTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYAnswersRecordTableViewCell.h"

@implementation RYAnswersRecordTableViewCell

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
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 95, 70)];
        [self.contentView addSubview:self.leftImgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImgView.frame) + 5, 8,SCREEN_WIDTH - 30 - 5 - self.leftImgView.width, 58)];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.numberOfLines = 3;
        [self.contentView addSubview:self.titleLabel];
        
        self.jifenLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100, self.titleLabel.bottom + 5, 100, 12)];
        self.jifenLabel.font = [UIFont systemFontOfSize:12];
        self.jifenLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.jifenLabel];
        
        
        self.jifenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.jifenLabel.left-4-13, self.jifenLabel.top, 13, 10)];
        self.jifenImageView.image = [UIImage imageNamed:@"ic_small_jifen.png"];
        [self.contentView addSubview:self.jifenImageView];
        
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return;
    }
    NSString *pic = [dict getStringValueForKey:@"pic" defaultValue:@""];
    [self.leftImgView setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"ic_default_small.png"]];
    self.titleLabel.width = SCREEN_WIDTH - 130;
    self.titleLabel.height = 58;
    self.titleLabel.text = [dict getStringValueForKey:@"subject" defaultValue:@""];
    [self.titleLabel sizeToFit];
    
    NSString *jifen = [ dict getStringValueForKey:@"hdjifen" defaultValue:@""];
//    CGSize size = [jifen sizeWithFont:self.jifenLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH, 12)];
    NSDictionary *attributes = @{NSFontAttributeName:self.jifenLabel.font};
    CGRect rect = [jifen boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 12)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];
    self.jifenLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - rect.size.width, self.jifenLabel.top, rect.size.width, 12);
    self.jifenLabel.text = jifen;
    
    self.jifenImageView.left = self.jifenLabel.left - 4 - self.jifenImageView.width;
}


@end
