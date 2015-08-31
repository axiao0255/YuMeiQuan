//
//  replyView.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/2.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "replyView.h"

@interface replyView ()

@property (nonatomic,assign) MenuType menuType;

@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *replyBtn;
@property (nonatomic,strong) UIButton *deleBtn;

@end

@implementation replyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, MENU_VIEW_WIDTH, MENU_VIEW_HEIGHT)];
    if (self) {
       
    }
    return self;
}
-(void)menuType:(MenuType)type
{
    self.menuType = type;
    if ( self.menuType == shareAndReply ) {
        self.shareBtn.left = 0;
        [self addSubview:self.shareBtn];
        self.replyBtn.right = MENU_VIEW_WIDTH;
        [self addSubview:self.replyBtn];
        
        self.replyBtn.hidden = NO;
        self.deleBtn.hidden = YES;
    }
    else{
        self.shareBtn.left = 0;
        [self addSubview:self.shareBtn];
        self.deleBtn.right = MENU_VIEW_WIDTH;
        [self addSubview:self.deleBtn];
        
        self.replyBtn.hidden = YES;
        self.deleBtn.hidden = NO;
    }
}

-(UIButton *)shareBtn
{
    if ( !_shareBtn ) {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _shareBtn.tag = 0;
        [_shareBtn setImage:[UIImage imageNamed:@"ic_comment_share"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

-(UIButton *)replyBtn
{
    if ( !_replyBtn ) {
        _replyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _replyBtn.tag = 1;
        [_replyBtn setImage:[UIImage imageNamed:@"ic_comment_reply"] forState:UIControlStateNormal];
        [_replyBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyBtn;
}

-(UIButton *)deleBtn
{
    if ( !_deleBtn ) {
        _deleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _deleBtn.tag = 2;
        [_deleBtn setImage:[UIImage imageNamed:@"ic_comment_dele"] forState:UIControlStateNormal];
        [_deleBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleBtn;
}

-(void)menuBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ( [self.delegate respondsToSelector:@selector(didSelectButtonWithIndex:)]) {
        [self.delegate didSelectButtonWithIndex:btn.tag];
    }
}

@end
