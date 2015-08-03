//
//  RYExchangeDetailsTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYExchangeDetailsTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView *imgView;
@property (nonatomic , strong) UIImageView *transparencyImageView;
@property (nonatomic , strong) UILabel     *titleLabel;

- (void)setValueWithDict:(NSDictionary *)dict;

@end


@interface RYExchangeTextFieldTableViewCell : UITableViewCell

@property (nonatomic , strong) UITextField   *textField;

@end


#pragma mark 兑换礼品数量选择
@protocol RYExchangeNumberSelectTableViewCellDelegate <NSObject>

-(void)currentSelectExchangeNumber:(NSInteger) num;

@end

@interface RYExchangeNumberSelectTableViewCell : UITableViewCell

@property (nonatomic , weak)id<RYExchangeNumberSelectTableViewCellDelegate>delegate;
@property (nonatomic , strong)UILabel           *titleLabel;
@property (nonatomic , strong)UIButton          *reduceBtn;
@property (nonatomic , strong)UIButton          *addBtn;
@property (nonatomic , strong)UILabel           *numberLabel;
@property (nonatomic , assign)NSInteger         number;
@property (nonatomic , strong)UILabel           *expendLabel;
@property (nonatomic , strong)UILabel           *jifenLabel;
@property (nonatomic , assign)NSInteger         canExchangeMaxNumber;
@property (nonatomic , strong)NSDictionary      *dict;


- (void)setValueWithDict:(NSDictionary *)dict;


@end