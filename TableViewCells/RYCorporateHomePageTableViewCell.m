//
//  RYCorporateHomePageTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/13.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYCorporateHomePageTableViewCell.h"

@implementation RYCorporateHomePageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ---------------------------------------------
//     企业微主页  头部第一行cell
- (id)initWithTopCellStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.logoImageView.left = 15;
        self.logoImageView.top = 16;
        self.logoImageView.height = 37;
        self.logoImageView.width = 37;
        self.logoImageView.layer.cornerRadius = 18.5;
        self.logoImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.logoImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 15,
                                                                    18,
                                                                    250,
                                                                    16)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [self.contentView addSubview:self.titleLabel];
        
        self.declareLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                                                      CGRectGetMaxY(self.titleLabel.frame) + 8,
                                                                      250,
                                                                      14)];
        self.declareLabel.font = [UIFont systemFontOfSize:14];
        self.declareLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [self.contentView addSubview:self.declareLabel];
        
        self.rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 17, 26, 17, 16)];
        self.rightArrow.image = [UIImage imageNamed:@"ic_arrow_right.png"];
        [self.contentView addSubview:self.rightArrow];
        
        self.directImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 20, 38, 12)];
        self.directImgView.image = [UIImage imageNamed:@"ic_direct.png"];
        [self.contentView addSubview:self.directImgView];
    }
    return self;
}

- (void)setValueWithDic:(NSDictionary *)dic
{
    if ( !dic ) {
        return;
    }
    [self.logoImageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"ic_logo_default.png"]];
    [self.titleLabel setText:[dic getStringValueForKey:@"name" defaultValue:@""]];
    [self.declareLabel setText:[dic getStringValueForKey:@"declare" defaultValue:@""]];
    [self.titleLabel sizeToFit];
    self.directImgView.left = self.titleLabel.right;
}

@end


#pragma mark ---------------------------------------------

@implementation RYCorporateAttentionTableViewCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


//    企业微主页 关注
- (id)initWithAttentionStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
//        self.attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 8, 77, 28)];
//        self.attentionButton.layer.masksToBounds = YES;
//        self.attentionButton.layer.borderColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0].CGColor;
//        self.attentionButton.layer.borderWidth = 1;
//        self.attentionButton.layer.cornerRadius = 5;
//        self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
//        [self.attentionButton setTitleColor:[Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0] forState:UIControlStateNormal];
//        [self.contentView addSubview:self.attentionButton];
        
        self.attentionButton = [Utils getCustomLongButton:@"关注"];
        self.attentionButton.frame = CGRectMake(15, 8, SCREEN_WIDTH - 30, 40);
        [self.contentView addSubview:self.attentionButton];
    }
    return self;
}



@end

#pragma mark ---------------------------------------------

@implementation RYCorporatePublishedArticlesTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


//    企业微主页 发布的文章列表 cell
- (id)initWithPublishedArticlesStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        // 题图
        self.titlePic = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 58, 58)];
        [self.contentView addSubview:self.titlePic];
        // 内容
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titlePic.frame) + 8,
                                                                      8, SCREEN_WIDTH - 30 - 58, 39)];
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        self.contentLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.contentLabel.numberOfLines = 2;
        [self.contentView addSubview:self.contentLabel];
        // 分类
        self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentLabel.left, self.contentLabel.bottom + 8, 50, 12)];
        self.categoryLabel.font = [UIFont systemFontOfSize:12];
        self.categoryLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.categoryLabel];
        
        // 问答
        self.answerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 17,self.categoryLabel.top - 2 , 17, 17)];
        self.answerImgView.image = [UIImage imageNamed:@"ic_answer_pic.png"];
        [self.contentView addSubview:self.answerImgView];
        // 积分
        self.integratorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.answerImgView.frame)-17 - 4,
                                                                               self.answerImgView.top, 17, 17)];
        self.integratorImgView.image = [UIImage imageNamed:@"ic_integrator_pic.png"];
        [self.contentView addSubview:self.integratorImgView];

    }
    return self;
}

- (void)setValueWithPublishedArticlesDic:(NSDictionary *)dic
{
    if ( !dic ) {
        return;
    }
    NSString *pic = [dic getStringValueForKey:@"pic" defaultValue:@""];
    [self.titlePic setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"ic_pic_default.png"]];
    if ( ![ShowBox isEmptyString:pic] ) {
        self.titlePic.width = 58;
        self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.titlePic.frame) + 8, self.contentLabel.top, SCREEN_WIDTH - 30 - 58 - 8, 39);
    }
    else{
        self.titlePic.width = 0;
        self.contentLabel.frame = CGRectMake(15, self.contentLabel.top, SCREEN_WIDTH - 30, 39);
    }
    self.contentLabel.text = [dic getStringValueForKey:@"content" defaultValue:@""];
    self.categoryLabel.left = self.contentLabel.left;
    self.categoryLabel.text = @"新闻";
}

@end






























