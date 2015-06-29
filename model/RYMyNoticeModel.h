//
//  RYMyNoticeModel.h
//  YuMeiQuan
//
//  Created by Jason on 15/6/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYMyNoticeModel : NSObject

@property (nonatomic , strong) NSArray      *systemNoticeArray;         // 系统消息
@property (nonatomic , strong) NSArray      *prizeNoticeArray;          // 有奖活动
@property (nonatomic , strong) NSArray      *companyNoticeArray;        // 企业通知

@end
