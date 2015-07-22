//
//  RYBillboardView.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBillboardView.h"

@interface RYBillboardView ()

@property (nonatomic , strong) UIImageView   *backgroundView;
@property (nonatomic , strong) UILabel       *topLabel;
@property (nonatomic , strong) UILabel       *awardLabel;            // 奖励 label
@property (nonatomic , strong) UILabel       *explainLabel;          // 补充说明label
@property (nonatomic , strong) UILabel       *zanzhuLabel;           // 提供者 label
@property (nonatomic , strong) UILabel       *companySloganLabel;    // 企业标语
@property (nonatomic , strong) UIButton      *shareBtn;              // 立即转发按钮

@end

@implementation RYBillboardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIImageView *)backgroundView
{
    if ( _backgroundView == nil ) {
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundView.image = [UIImage imageNamed:@"ic_billboard_background.png"];
    }
    return _backgroundView;
}

- (UIButton *)bottomBtn
{
    if ( _bottomBtn == nil ) {
        _bottomBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _bottomBtn.width = 160;
        _bottomBtn.top = 332;
        _bottomBtn.height = 40;
        _bottomBtn.left = 80;
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_bottomBtn setTitleEdgeInsets:UIEdgeInsetsMake(-2, -20, 0, 0)];
        [_bottomBtn setTitleColor:[Utils getRGBColor:0x5c g:0x12 b:0x12 a:1.0] forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

-(UILabel *)topLabel
{
    if ( _topLabel == nil ) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 30, SCREEN_WIDTH - 50, 18)];
        _topLabel.textColor = [Utils getRGBColor:0xfe g:0xbf b:0x10 a:1.0];
        _topLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    }
    return _topLabel;
    
}

-(UILabel *)awardLabel
{
    if ( _awardLabel == nil ) {
        _awardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 36)];
        _awardLabel.textColor = [Utils getRGBColor:0xfe g:0xbf b:0x10 a:1.0];
        _awardLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:36];
        _awardLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _awardLabel;
}

- (UILabel *)explainLabel
{
    if ( _explainLabel == nil ) {
        _explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, 12)];
        _explainLabel.textColor = [Utils getRGBColor:0xfe g:0xbf b:0x10 a:1.0];
        _explainLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        _explainLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _explainLabel;
}

- (UILabel *)zanzhuLabel
{
    if ( _zanzhuLabel == nil ) {
        _zanzhuLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 160, SCREEN_WIDTH-60, 35)];
        _zanzhuLabel.textColor = [UIColor whiteColor];
        _zanzhuLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        _zanzhuLabel.textAlignment = NSTextAlignmentCenter;
        _zanzhuLabel.numberOfLines = 2;
    }
    return _zanzhuLabel;
}

- (UILabel *)companySloganLabel
{
    if ( _companySloganLabel == nil ) {
        _companySloganLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 220, SCREEN_WIDTH-30, 35)];
        _companySloganLabel.textColor = [UIColor whiteColor];
        _companySloganLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        _companySloganLabel.textAlignment = NSTextAlignmentCenter;
        _companySloganLabel.numberOfLines = 2;
    }
    return _companySloganLabel;
}

- (UIButton *)shareBtn
{
    if ( _shareBtn == nil ) {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-123/2, 210, 123, 47)];
        [_shareBtn setImage:[UIImage imageNamed:@"ic_Billboard_share.png"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.bottomBtn];
        [self addSubview:self.topLabel];
        [self addSubview:self.awardLabel];
        [self addSubview:self.explainLabel];
        [self addSubview:self.zanzhuLabel];
        [self addSubview:self.companySloganLabel];
        [self addSubview:self.shareBtn];
    }
    return self;
}


-(void)bottomBtnClick:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    if ( [self.delegate respondsToSelector:@selector(bottomBtnClickIsShow:)] ) {
        [self.delegate bottomBtnClickIsShow:btn.selected];
    }
}

- (void)shareBtnClick:(id)sender
{
    if ( [self.delegate respondsToSelector:@selector(billboardViewShareBtnDidCilck:)] ) {
        [self.delegate billboardViewShareBtnDidCilck:sender];
    }

}

- (void)setDataDict:(NSDictionary *)dataDict
{
    if ( dataDict == nil ) {
        return;
    }
    
    self.topLabel.text = [dataDict getStringValueForKey:@"topTitle" defaultValue:@""];
    self.awardLabel.text = [dataDict getStringValueForKey:@"jiangli" defaultValue:@""];
    self.explainLabel.text = [dataDict getStringValueForKey:@"duihuan" defaultValue:@""];
    self.zanzhuLabel.text = [dataDict getStringValueForKey:@"zanzhu" defaultValue:@""];
    
    // 设置赞助商 名称
    NSString *zanzhu = [dataDict getStringValueForKey:@"zanzhu" defaultValue:@""];
    NSDictionary *zanzhuAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15]};
    CGRect zanzhuRect = [zanzhu boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, 35)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:zanzhuAttributes
                                                            context:nil];
    self.zanzhuLabel.left = SCREEN_WIDTH/2 - zanzhuRect.size.width/2;
    self.zanzhuLabel.width = zanzhuRect.size.width;
    self.zanzhuLabel.height = zanzhuRect.size.height;
    
    NSString *type = [dataDict getStringValueForKey:@"type" defaultValue:@""];
    if ( [type isEqualToString:@"answer"] ) {
        // 设置赞助商 标语
        NSString *slogan = [dataDict getStringValueForKey:@"slogan" defaultValue:@""];
        NSDictionary *sloganAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15]};
        CGRect sloganRect = [slogan boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, 35)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:sloganAttributes
                                                 context:nil];
        self.companySloganLabel.left = SCREEN_WIDTH/2 - sloganRect.size.width/2;
        self.companySloganLabel.width = sloganRect.size.width;
        self.companySloganLabel.height = sloganRect.size.height;
        self.companySloganLabel.text = slogan;
        self.companySloganLabel.hidden = NO;
        

        self.shareBtn.hidden = YES;
        [self.bottomBtn setTitle:@"有奖问答" forState:UIControlStateNormal];
    }
    else{
        self.companySloganLabel.hidden = YES;
        self.shareBtn.hidden = NO;
        [self.bottomBtn setTitle:@"有奖转发" forState:UIControlStateNormal];
    }
    
}

@end
