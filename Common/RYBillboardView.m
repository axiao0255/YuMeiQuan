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
        _bottomBtn.backgroundColor = [UIColor redColor];
        _bottomBtn.width = 160;
        _bottomBtn.top = 332;
        _bottomBtn.height = 40;
        _bottomBtn.left = 80;
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_bottomBtn setTitleColor:[Utils getRGBColor:0x5c g:0x12 b:0x12 a:1.0] forState:UIControlStateNormal];
    }
    return _bottomBtn;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.bottomBtn];
        [self.bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


-(void)bottomBtnClick:(id)sender
{
    NSLog(@"kkkkkk");
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    if ( [self.delegate respondsToSelector:@selector(bottomBtnClickIsShow:)] ) {
        [self.delegate bottomBtnClickIsShow:btn.selected];
    }
    
}

@end
