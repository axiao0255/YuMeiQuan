//
//  RYAnswerSheet.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RYAnswerSheetDelegate <NSObject>

-(void)submitAnawerDidFinish;

@end

@interface RYAnswerSheet : UIView

@property (nonatomic ,strong) NSDictionary *dataDict;
@property (nonatomic ,strong) NSString     *thid;          // 文章的id
@property (nonatomic ,weak) id <RYAnswerSheetDelegate> delegate;

- (CGFloat)getAnswerSheetHeight;

- (id)initWithDataSource:(NSDictionary *)dataSource;



@end
