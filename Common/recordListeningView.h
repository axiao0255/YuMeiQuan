//
//  recordListeningView.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYCommentData.h"

@protocol recordListeningViewDelegate <NSObject>

// 录音发送成功后 代理 的回调
- (void)recordSendSuccess;

@end

@interface recordListeningView : UIView

@property (nonatomic , strong) UIButton       *transparencyBtn;
@property (nonatomic , strong) UIImageView    *playView;
@property (nonatomic , strong) id <recordListeningViewDelegate>delegate;
@property (nonatomic , strong) RYCommentData  *recordData;


- (id)initWithFrame:(CGRect)frame;

- (void)showListeningViewWithRecordData:(RYCommentData *)recordData;

- (void)dismissListeningView;

@end
