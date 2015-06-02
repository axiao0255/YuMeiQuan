//
//  RYCopyAddressView.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYCopyAddressView.h"
#import "HTCopyableLabel.h"

@interface RYCopyAddressView ()<HTCopyableLabelDelegate>

@property (nonatomic , strong) RYArticleData *articleData;

@end

@implementation RYCopyAddressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame andArticleData:(RYArticleData *)articleData
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.articleData = articleData;
        [self setup];
    }
    return self;
}


- (void)setup
{
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 8, SCREEN_WIDTH - 80, 12)];
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
    addressLabel.text = @"原文地址";
    [self addSubview:addressLabel];
    
    HTCopyableLabel *showAddressLabel = [[HTCopyableLabel alloc] initWithFrame:CGRectMake(40, addressLabel.bottom + 8, SCREEN_WIDTH - 80, 40)];
    showAddressLabel.copyableLabelDelegate = self;
    showAddressLabel.backgroundColor = [UIColor whiteColor];
    showAddressLabel.font = [UIFont systemFontOfSize:14];
    showAddressLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
    showAddressLabel.layer.cornerRadius = 5;
    showAddressLabel.layer.masksToBounds = YES;
    showAddressLabel.tag = 1000;
    showAddressLabel.text = [NSString stringWithFormat:@"   %@",self.articleData.originalAddress];
    [self addSubview:showAddressLabel];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, showAddressLabel.bottom + 8, SCREEN_WIDTH - 80, 12)];
    passwordLabel.font = [UIFont systemFontOfSize:12];
    passwordLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
    passwordLabel.text = @"密码";
    [self addSubview:passwordLabel];

    HTCopyableLabel *showPasswordLabel = [[HTCopyableLabel alloc] initWithFrame:CGRectMake(40, passwordLabel.bottom + 8, SCREEN_WIDTH - 80, 40)];
    showPasswordLabel.copyableLabelDelegate = self;
    showPasswordLabel.backgroundColor = [UIColor whiteColor];
    showPasswordLabel.font = [UIFont systemFontOfSize:14];
    showPasswordLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
    showPasswordLabel.layer.cornerRadius = 5;
    showPasswordLabel.layer.masksToBounds = YES;
    showPasswordLabel.tag = 1001;
    showPasswordLabel.text = [NSString stringWithFormat:@"   %@",self.articleData.password];
    [self addSubview:showPasswordLabel];

    HTCopyableLabel *copyAddressAndPassword = [[HTCopyableLabel alloc] initWithFrame:CGRectMake(40, showPasswordLabel.bottom + 8, SCREEN_WIDTH - 80, 40)];
    copyAddressAndPassword.copyableLabelDelegate = self;
    copyAddressAndPassword.backgroundColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
    copyAddressAndPassword.textAlignment = NSTextAlignmentCenter;
    copyAddressAndPassword.font = [UIFont boldSystemFontOfSize:18];
    copyAddressAndPassword.textColor = [UIColor whiteColor];
    copyAddressAndPassword.text = @"复制地址和密码";
    copyAddressAndPassword.layer.cornerRadius = 5;
    copyAddressAndPassword.layer.masksToBounds = YES;
    copyAddressAndPassword.tag = 1002;
    [self addSubview:copyAddressAndPassword];
    
     UILabel *suggestLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, copyAddressAndPassword.bottom + 8, SCREEN_WIDTH - 80, 12)];
    suggestLabel.font = [UIFont systemFontOfSize:12];
    suggestLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
    suggestLabel.text = @"建议使用电脑设备浏览";
    suggestLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:suggestLabel];
}

#pragma mark - HTCopyableLabelDelegate

- (NSString *)stringToCopyForCopyableLabel:(HTCopyableLabel *)copyableLabel
{
    NSString *stringToCopy = @"";
    NSInteger index = copyableLabel.tag - 1000;
    if ( index == 0 ) {
        stringToCopy = self.articleData.originalAddress;
    }
    else if ( index == 1 ){
        stringToCopy = self.articleData.password;
    }
    else if ( index == 2 ){
        stringToCopy = [NSString stringWithFormat:@"%@ %@",self.articleData.originalAddress,self.articleData.password];
    }
    return stringToCopy;
}

//- (CGRect)copyMenuTargetRectInCopyableLabelCoordinates:(HTCopyableLabel *)copyableLabel
//{
//
//}



@end
