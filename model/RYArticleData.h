//
//  RYArticleData.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYArticleData : NSObject

@property(nonatomic, strong)NSString *subject;
@property(nonatomic, strong)NSString *author;
@property(nonatomic, strong)NSString *dateline;
@property(nonatomic, strong)NSString *message;
@property(nonatomic, strong)NSString *subhead;
@property(nonatomic, strong)NSString *periodical;
@property(nonatomic, strong)NSString *DOI;
@property(nonatomic, strong)NSString *originalAddress;
@property(nonatomic, strong)NSString *password;
@property(nonatomic, assign)BOOL     isCompany; // 是否是企业 所发的文章
@property(nonatomic, assign)NSString *slogan;   // 标语
@property(nonatomic, strong)NSString *authorId; // 如果是企业所发的文章，则次id为企业id
@property(nonatomic, assign)BOOL     isInquire; // 是否查询过改文献，YES 查询过，NO 未查询过
@property(nonatomic, strong)NSString *comment;  //
@property(nonatomic, strong)NSString *check;    // 查看原文提示文字

#pragma mark 分享所用
@property(nonatomic, strong)NSString *shareId;         // 分享id
@property(nonatomic, strong)NSString *shareArticleUrl; // 分享url
@property(nonatomic, strong)NSString *sharePicUrl;     // 分享的图片


@end
