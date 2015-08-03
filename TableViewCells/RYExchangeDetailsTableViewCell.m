//
//  RYExchangeDetailsTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYExchangeDetailsTableViewCell.h"

@implementation RYExchangeDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 180)];
        self.imgView.layer.borderWidth = 0.5;
        self.imgView.layer.borderColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0].CGColor;
        [self.contentView addSubview:self.imgView];
        self.transparencyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 140,  self.imgView.width, 40)];
        [self.imgView addSubview:self.transparencyImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.transparencyImageView.width - 20, self.transparencyImageView.height)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.numberOfLines = 2;
        [self.transparencyImageView addSubview:self.titleLabel];

    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( !dict ) {
        return;
    }
    [self.imgView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"ic_bigPic_defaule.png"]];
    
    NSString *title = [dict getStringValueForKey:@"subject" defaultValue:@""];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGRect rect = [title boundingRectWithSize:CGSizeMake(self.titleLabel.width, 40)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes
                                        context:nil];
    
    self.transparencyImageView.height = rect.size.height + 10;
    self.transparencyImageView.top = 180 - self.transparencyImageView.height;
    self.titleLabel.height = self.transparencyImageView.height;
    self.transparencyImageView.image = [UIImage imageNamed:@"ic_transparency.png"];
    self.titleLabel.text = title;
    
}


@end

@implementation RYExchangeTextFieldTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 30, 44)];
        self.textField.layer.borderWidth = 1.0;
        self.textField.layer.borderColor = [Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0].CGColor;
        self.textField.layer.cornerRadius = 4;
        self.textField.layer.masksToBounds = YES;
        [self.textField seperatorWidth:10];
        self.textField.font = [UIFont systemFontOfSize:16];
        self.textField.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

@end



#pragma mark 兑换礼品数量选择

@implementation RYExchangeNumberSelectTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 35, 26)];
        self.titleLabel.text = @"数量";
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [self.contentView addSubview:self.titleLabel];
        
        self.reduceBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.titleLabel.right + 5, 0, 26, 26)];
        [self.reduceBtn setImage:[UIImage imageNamed:@"ic_reduce_normal.png"] forState:UIControlStateNormal];
        [self.reduceBtn setImage:[UIImage imageNamed:@"ic_reduce_disabled.png"] forState:UIControlStateHighlighted];
        [self.reduceBtn setImage:[UIImage imageNamed:@"ic_reduce_disabled.png"] forState:UIControlStateDisabled];
        [self.reduceBtn addTarget:self action:@selector(reduceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.reduceBtn setEnabled:NO];
        [self.contentView addSubview:self.reduceBtn];
        
        
        self.number = 1;
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.reduceBtn.right + 5, 5, 16, 16)];
        self.numberLabel.layer.borderWidth = 1.0;
        self.numberLabel.layer.borderColor = [Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0].CGColor;
        self.numberLabel.layer.cornerRadius = 4;
        self.numberLabel.layer.masksToBounds = YES;
        self.numberLabel.font = [UIFont systemFontOfSize:12];
        self.numberLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.numberLabel.text = [NSString stringWithFormat:@"%ld",self.number];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.numberLabel];
        
        self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.numberLabel.right + 5, 0, 26, 26)];
        [self.addBtn setImage:[UIImage imageNamed:@"ic_add_normal.png"] forState:UIControlStateNormal];
        [self.addBtn setImage:[UIImage imageNamed:@"ic_add_disabled.png"] forState:UIControlStateHighlighted];
        [self.addBtn setImage:[UIImage imageNamed:@"ic_add_disabled.png"] forState:UIControlStateDisabled];
        [self.addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.addBtn];
        
        self.expendLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.expendLabel.left = 200;
        self.expendLabel.width = 80;
        self.expendLabel.top = 0;
        self.expendLabel.height = 26;
        self.expendLabel.font = [UIFont systemFontOfSize:16];
        self.expendLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.expendLabel.text = @"消耗积分：";
        [self.contentView addSubview:self.expendLabel];
        
        self.jifenLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 40, 0, 40, 26)];
        self.jifenLabel.font = [UIFont systemFontOfSize:16];
        self.jifenLabel.textColor = [Utils getRGBColor:0xcd g:0x24 b:0x2b a:1.0];
        self.jifenLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.jifenLabel];
        
    }
    return self;
}

-(void)reduceBtnClick:(id)sender
{
    if ( self.number > 1 ) {
        [self.reduceBtn setEnabled:YES];
        self.number --;
        self.numberLabel.text = [NSString stringWithFormat:@"%ld",self.number];
    }
    
    if ( self.number <= 1 ) {
        [self.reduceBtn setEnabled:NO];
    }
    
    if ( self.number < self.canExchangeMaxNumber ) {
        [self.addBtn setEnabled:YES];
    }
    //每个礼品所需要的积分
    NSInteger singleJifen = [self.dict getIntValueForKey:@"needcredit" defaultValue:0];
    NSString *jifenStr = [NSString stringWithFormat:@"%ld",singleJifen*self.number];
    [self adjustSiteWithString:jifenStr];
    
    if ( [self.delegate respondsToSelector:@selector(currentSelectExchangeNumber:)] ) {
        [self.delegate currentSelectExchangeNumber:self.number];
    }
}

-(void)addBtnClick:(id)sender
{
    self.number ++;
    if ( self.number > 1 ) {
         [self.reduceBtn setEnabled:YES];
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",self.number];
    if ( self.number >= self.canExchangeMaxNumber ) {
        [self.addBtn setEnabled:NO];
    }
    
    //每个礼品所需要的积分
    NSInteger singleJifen = [self.dict getIntValueForKey:@"needcredit" defaultValue:0];
    NSString *jifenStr = [NSString stringWithFormat:@"%ld",singleJifen*self.number];
    [self adjustSiteWithString:jifenStr];
    
    if ( [self.delegate respondsToSelector:@selector(currentSelectExchangeNumber:)] ) {
        [self.delegate currentSelectExchangeNumber:self.number];
    }
}

- (void)setDelegate:(id<RYExchangeNumberSelectTableViewCellDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        
        if ( [_delegate respondsToSelector:@selector(currentSelectExchangeNumber:)] ) {
            [_delegate currentSelectExchangeNumber:self.number];
        }
    }
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return;
    }
    self.dict = dict;
    
    // 活动状态
    NSInteger status = [dict getIntValueForKey:@"status" defaultValue:0];
    if ( status == 0 ) {
        self.canExchangeMaxNumber = 0;
    }
    else{
        // 剩余总数
        NSInteger totalNum = [dict getIntValueForKey:@"totalrest" defaultValue:0];
        if ( totalNum == 0 ) {
            self.canExchangeMaxNumber = 0;
        }
        else{
            // 能兑换的数量上限
            NSInteger canExchangeNum = [dict getIntValueForKey:@"everyrest" defaultValue:0];
            if ( canExchangeNum == 0 ) {
                self.canExchangeMaxNumber = 0;
            }
            else{
                //每个礼品所需要的积分
                NSInteger singleJifen = [dict getIntValueForKey:@"needcredit" defaultValue:0];
                if ( singleJifen == 0 ) {
                    self.canExchangeMaxNumber = totalNum>canExchangeNum?canExchangeNum:totalNum;
                }else{
                    //我当前的总积分
                    NSInteger myJifen = [[RYUserInfo sharedManager].credits integerValue];
                    //我的总积分能换多少个礼品
                    NSInteger myMaxNum = myJifen / singleJifen;
                    myMaxNum = myMaxNum>totalNum?totalNum:myMaxNum;
                    myMaxNum = myMaxNum>canExchangeNum?canExchangeNum:myMaxNum;
                    self.canExchangeMaxNumber = myMaxNum;
                }
            }
        }
    }
    if ( self.canExchangeMaxNumber <= 1 ) {
        [self.reduceBtn setEnabled:NO];
        [self.addBtn setEnabled:NO];
    }
    //每个礼品所需要的积分
    NSInteger singleJifen = [dict getIntValueForKey:@"needcredit" defaultValue:0];
    NSString *jifenStr = [NSString stringWithFormat:@"%ld",singleJifen*self.number];
    [self adjustSiteWithString:jifenStr];
}

- (void)adjustSiteWithString:(NSString *)string
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 16)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];
    self.jifenLabel.width = rect.size.width;
    self.jifenLabel.left = SCREEN_WIDTH - 15 - self.jifenLabel.width;
    self.jifenLabel.text = string;
    
    self.expendLabel.left = SCREEN_WIDTH - 15 - 80 - self.jifenLabel.width;
}


@end

