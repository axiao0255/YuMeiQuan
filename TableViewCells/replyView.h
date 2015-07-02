//
//  replyView.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/2.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MENU_VIEW_WIDTH 68
#define MENU_VIEW_HEIGHT 24

typedef enum : NSUInteger {
    shareAndDel,       // 分享和删除
    shareAndReply,     // 分享和回复
} MenuType;

@protocol replyViewDelegate <NSObject>

/**
 * 按钮点击之后 代理的回调。 
 * index 0 分享，1 回复。2 删除
 */
-(void)didSelectButtonWithIndex:(NSInteger) index;

@end

@interface replyView : UIView

@property (nonatomic ,weak) id<replyViewDelegate>delegate;

-(void)menuType:(MenuType)type;

-(id)init;

@end
