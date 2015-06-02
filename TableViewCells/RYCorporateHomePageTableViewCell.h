//
//  RYCorporateHomePageTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/13.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark ---------------------------------------------
@interface RYCorporateHomePageTableViewCell : UITableViewCell

//     企业微主页  头部第一行cell
@property (nonatomic , strong) UIImageView   *logoImageView;
@property (nonatomic , strong) UILabel       *titleLabel;
@property (nonatomic , strong) UILabel       *declareLabel;
@property (nonatomic , strong) UIImageView   *rightArrow;
@property (nonatomic , strong) UIImageView   *directImgView;
- (id)initWithTopCellStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setValueWithDic:(NSDictionary *)dic;

@end

#pragma mark ---------------------------------------------
@interface RYCorporateAttentionTableViewCell : UITableViewCell

//    企业微主页 关注
@property (nonatomic , strong) UIButton      *attentionButton;
- (id)initWithAttentionStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end


#pragma mark ---------------------------------------------
@interface RYCorporatePublishedArticlesTableViewCell : UITableViewCell

//    企业微主页 发布的文章列表 cell
@property (nonatomic , strong) UIImageView   *titlePic;
@property (nonatomic , strong) UILabel       *contentLabel;
@property (nonatomic , strong) UIImageView   *answerImgView;       // 问答
@property (nonatomic , strong) UIImageView   *integratorImgView;   // 积分
@property (nonatomic , strong) UILabel       *categoryLabel;       // 分类
- (id)initWithPublishedArticlesStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setValueWithPublishedArticlesDic:(NSDictionary *)dic;

@end
