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
@property (nonatomic , strong) UIImageView   *backgroundView;
@property (nonatomic , strong) UIButton      *directBtn;       // 直达号背景图
@property (nonatomic , strong) UILabel       *titleLabel;          // 企业直达号 标题
@property (nonatomic , strong) UILabel       *declareLabel;        // 副标题
@property (nonatomic , strong) UIButton      *backBtn;             // 返回按钮
@property (nonatomic , strong) UIButton      *aboutCompanyBtn;     // 更多公司信息
@property (nonatomic , strong) UIButton      *attentionBtn;        // 关注按钮

- (id)initWithTopCellStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setValueWithDic:(NSDictionary *)dic;

@end

#pragma mark ---------------------------------------------
@interface RYCorporatePublishedArticlesTableViewCell : UITableViewCell

//    企业微主页 发布的文章列表 cell
@property (nonatomic , strong) UIImageView   *titlePic;
@property (nonatomic , strong) UILabel       *contentLabel;
//@property (nonatomic , strong) UIImageView   *answerImgView;       // 问答
@property (nonatomic , strong) UIImageView   *integratorImgView;   // 积分
@property (nonatomic , strong) UILabel       *categoryLabel;       // 分类
- (id)initWithPublishedArticlesStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setValueWithPublishedArticlesDic:(NSDictionary *)dic;

@end
