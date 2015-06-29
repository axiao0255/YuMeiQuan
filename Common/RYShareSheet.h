//
//  RYShareSheet.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RYShareSheetDelegate <NSObject>


@end

@interface RYShareSheet : UIView

@property (nonatomic ,weak  ) id <RYShareSheetDelegate>delegate;

// 分享数据
@property (nonatomic ,strong) NSDictionary             *shareDataDict;


- (void)showShareView;
- (void)dismissShareView;
@end
