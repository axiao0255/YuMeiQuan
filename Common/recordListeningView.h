//
//  recordListeningView.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface recordListeningView : UIView

@property (nonatomic , strong) UIButton       *transparencyBtn;
@property (nonatomic , strong) UIImageView    *playView;


- (id)initWithFrame:(CGRect)frame;

- (void)showListeningViewWithSoundURL:(NSURL *)soundURL;
- (void)dismissListeningView;

@end
