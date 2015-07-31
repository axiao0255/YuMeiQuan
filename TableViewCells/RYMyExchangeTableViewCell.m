//
//  RYMyExchangeTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyExchangeTableViewCell.h"

@implementation RYMyExchangeTableViewCell

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
//        self.leftImgView.layer.cornerRadius = 4;
//        self.leftImgView.layer.masksToBounds = YES;
        self.leftImgView.layer.borderWidth = 0.5;
        self.leftImgView.layer.borderColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0].CGColor;
        [self.contentView addSubview:self.leftImgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImgView.right + 5, 8, SCREEN_WIDTH - 30 - 5 - self.leftImgView.width, 58)];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        
        self.jifenLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImgView.right + 5, 64, 100, 16)];
        self.jifenLabel.font = [UIFont systemFontOfSize:16];
        self.jifenLabel.textColor = [Utils getRGBColor:0xed g:0x24 b:0x2b a:1.0];
        [self.contentView addSubview:self.jifenLabel];
        
        self.exchangeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 70, 50, 70, 30)];
        [self.exchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.exchangeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        self.exchangeBtn.layer.cornerRadius = 4;
        self.exchangeBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:self.exchangeBtn];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( !dict ) {
        return;
    }
    NSString *pic = [dict getStringValueForKey:@"pic" defaultValue:@""];
    [self.leftImgView setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"ic_pic_default.png"]];
    self.titleLabel.width = SCREEN_WIDTH - 130;
    self.titleLabel.height = 58;
    self.titleLabel.text = [dict getStringValueForKey:@"subject" defaultValue:@""];
    [self.titleLabel sizeToFit];
    
    self.jifenLabel.text = [dict getStringValueForKey:@"needcredit" defaultValue:@""];
    // 每个产品需要的积分
    NSInteger jifen = [dict getIntValueForKey:@"needcredit" defaultValue:0];
    // 我的剩余积分
    NSInteger myJifen = [[RYUserInfo sharedManager].credits integerValue];
    
    NSInteger status = [dict getIntValueForKey:@"status" defaultValue:0];
    [self.exchangeBtn setEnabled:NO];
    if ( status == 0  ) { // 活动已结束
        [self.exchangeBtn setBackgroundColor:[Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0]];
        [self.exchangeBtn setTitle:@"已结束" forState:UIControlStateNormal];
    }
    else{
         // 总数为0  已经兑换完
        NSInteger totalrest = [dict getIntValueForKey:@"totalrest" defaultValue:0];
        if ( totalrest == 0 ) {
            [self.exchangeBtn setBackgroundColor:[Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0]];
            [self.exchangeBtn setTitle:@"已兑完" forState:UIControlStateNormal];
        }
        else{
            // everyrest==0  兑换已达上限
            NSInteger everyrest = [dict getIntValueForKey:@"everyrest" defaultValue:0];
            if ( everyrest == 0 ) {
                [self.exchangeBtn setBackgroundColor:[Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0]];
                [self.exchangeBtn setTitle:@"已兑换" forState:UIControlStateNormal];
            }
            else{
                if ( myJifen >= jifen ) {
                    [self.exchangeBtn setBackgroundColor:[Utils getRGBColor:0x8c g:0xd2 b:0x32 a:1.0]];
                    [self.exchangeBtn setTitle:@"可以兑换" forState:UIControlStateNormal];
                }
                else{
                    [self.exchangeBtn setBackgroundColor:[Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0]];
                    [self.exchangeBtn setTitle:@"积分不足" forState:UIControlStateNormal];
                }
            }
        }
    }
}


@end
