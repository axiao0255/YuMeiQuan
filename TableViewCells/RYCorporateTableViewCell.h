//
//  RYCorporateTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/13.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYCorporateHomePageData.h"

@interface RYCorporateTableViewCell : UITableViewCell

@property (nonatomic , strong) UILabel   *corporateTitleLabel;
@property (nonatomic , strong) UILabel   *corporateRecommendLabel;

@property (nonatomic , strong) UIButton  *attentionBtn;

- (void)setValueWithModel:(RYCorporateHomePageData *)model;

@end
