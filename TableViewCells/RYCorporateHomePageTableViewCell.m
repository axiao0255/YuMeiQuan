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
        self.backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
        [self.backgroundView setImage:[UIImage imageNamed:@"ic_company_bj.png"]];
        [self.contentView addSubview:self.backgroundView];
        
        self.directBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 50, 50, 17)];
        [self.directBtn setBackgroundImage:[UIImage imageNamed:@"ic_direct.png"] forState:UIControlStateNormal];
        [self.directBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.directBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.directBtn setTitle:@"直达号" forState:UIControlStateNormal];
        [self.directBtn setAdjustsImageWhenDisabled:NO];
        [self.contentView addSubview:self.directBtn];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,72,SCREEN_WIDTH,16)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, self.titleLabel.bottom + 10, 60, 25)];
        [self.contentView addSubview:self.attentionBtn];
        
        self.declareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.attentionBtn.bottom + 10,SCREEN_WIDTH,14)];
        self.declareLabel.font = [UIFont systemFontOfSize:14];
        self.declareLabel.textColor = [UIColor whiteColor];
        self.declareLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.declareLabel];
        
        self.aboutCompanyBtn = [[UIButton alloc] initWithFrame:CGRectMake(285, 35, 24, 24)];
        [self.aboutCompanyBtn setImage:[UIImage imageNamed:@"ic_aboutCompant.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.aboutCompanyBtn];
        
//        self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 35, 24, 24)];
//        [self.backBtn setImage:[UIImage imageNamed:@"ic_company_back.png"] forState:UIControlStateNormal];
//        [self.contentView addSubview:self.backBtn];
    }
    return self;
}

- (void)setValueWithDic:(NSDictionary *)dic
{
    if ( !dic ) {
        return;
    }
    NSString *titleStr = [dic getStringValueForKey:@"username" defaultValue:@""];
    [self.titleLabel setText:titleStr];
    
    [self.declareLabel setText:[dic getStringValueForKey:@"slogan" defaultValue:@""]];
    
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
        self.titlePic = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 95, 70)];
        self.titlePic.layer.borderWidth = 1.0;
        self.titlePic.layer.borderColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0].CGColor;
        [self.contentView addSubview:self.titlePic];
        // 内容
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titlePic.frame) + 5,
                                                                      10, SCREEN_WIDTH - 30 - 5 - self.titlePic.width, 58)];
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        self.contentLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.contentLabel.numberOfLines = 3;
        [self.contentView addSubview:self.contentLabel];
        // 分类
        self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100, self.contentLabel.bottom + 8, 100, 12)];
        self.categoryLabel.font = [UIFont systemFontOfSize:12];
        self.categoryLabel.textAlignment = NSTextAlignmentRight;
        self.categoryLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.categoryLabel];
        
//        // 问答
//        self.answerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 17,self.categoryLabel.top - 2 , 17, 17)];
//        self.answerImgView.image = [UIImage imageNamed:@"ic_answer_pic.png"];
//        [self.contentView addSubview:self.answerImgView];
        // 积分
        self.integratorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.contentLabel.frame),
                                                                               self.categoryLabel.top, 14, 11)];
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
        self.titlePic.width = 95;
        self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.titlePic.frame) + 5, self.contentLabel.top, SCREEN_WIDTH - 30 - 5 - self.titlePic.width, 58);
        self.contentLabel.text = [dic getStringValueForKey:@"subject" defaultValue:@""];
         [self.contentLabel sizeToFit];
        self.categoryLabel.top = 68;
    }
    else{
        self.titlePic.width = 0;
        self.contentLabel.frame = CGRectMake(15, self.contentLabel.top, SCREEN_WIDTH - 30, 58);
        self.contentLabel.text = [dic getStringValueForKey:@"subject" defaultValue:@""];
        [self.contentLabel sizeToFit];
        self.categoryLabel.top = self.contentLabel.bottom + 10;
    }
    
    self.categoryLabel.text = [dic getStringValueForKey:@"name" defaultValue:@""];
    self.integratorImgView.left = self.contentLabel.left;
    self.integratorImgView.top = self.categoryLabel.top;
    
    BOOL questions = [dic getBoolValueForKey:@"questions" defaultValue:NO];
    BOOL spread = [dic getBoolValueForKey:@"spread" defaultValue:NO];
    if ( questions || spread ) {
        self.integratorImgView.hidden = NO;
    }
    else{
        self.integratorImgView.hidden = YES;
    }
}

@end






























