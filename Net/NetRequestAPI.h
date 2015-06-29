//
//  NetRequestAPI.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/28.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetRequestAPI : NSObject


#pragma mark - 用户登录
+(void)userLoginWithUserName:(NSString *)username
                    password:(NSString *)password
                     success:(void(^)(id responseDic))success
                     failure:(void(^)(id errorString))failure;

#pragma mark - 退出登录
+(void)userLogoutWithSessionId:(NSString *)session
                       success:(void(^)(id responseDic))success
                       failure:(void(^)(id errorString))failure;

#pragma mark - 首页的新闻、会讯 列表
+(void)getHomePageNewsListWithSessionId:(NSString *)session
                                    fid:(NSString *)_fid
                                   page:(NSInteger)_page
                                success:(void(^)(id responseDic))success
                                failure:(void(^)(id errorString))failure;
#pragma mark - 播客 列表
+(void)getPodcastListWithSessionId:(NSString *)session
                             tagid:(NSString *)_tagid
                              page:(NSInteger )_page
                           success:(void(^)(id responseDic))success
                           failure:(void(^)(id errorString))failure;

#pragma mark - 首页列表
+(void)getHomePageWithSessionId:(NSString *)session
                        success:(void(^)(id responseDic))success
                        failure:(void(^)(id errorString))failure;


#pragma mark - 首页的文献 列表
+(void)getHomeLiteratureListWithSessionId:(NSString *)session
                                      fid:(NSString *)_fid
                                    tagid:(NSString *)_tagid
                                     page:(NSInteger)_page
                                  success:(void(^)(id responseDic))success
                                  failure:(void(^)(id errorString))failure;

#pragma mark - 文章详细页
+(void)getArticleDetailWithSessionId:(NSString *)session
                                 tid:(NSString *)_tid
                             success:(void(^)(id responseDic))success
                             failure:(void(^)(id errorString))failure;

#pragma mark - 首页 百家列表
+(void)getHomeBaijiaListWithSessionId:(NSString *)session
                                 page:(NSInteger)_page
                              success:(void(^)(id responseDic))success
                              failure:(void(^)(id errorString))failure;

#pragma mark - 文章 取消收藏
+(void)cancelCollectWithSessionId:(NSString *)session
                             thid:(NSString *)_thid
                          success:(void(^)(id responseDic))success
                          failure:(void(^)(id errorString))failure;

#pragma mark - 文章 添加收藏
+(void)additionCollectWithSessionId:(NSString *)session
                               thid:(NSString *)_thid
                               tags:(NSArray *)_tags
                            success:(void(^)(id responseDic))success
                            failure:(void(^)(id errorString))failure;

#pragma mark - 回答问题
+(void)answerTheQuestionWithSessionId:(NSString *)session
                                 thid:(NSString *)_thid
                                 qtid:(NSString *)_qtid
                              success:(void(^)(id responseDic))success
                              failure:(void(^)(id errorString))failure;

#pragma mark - 取作者 对应的 文章
+(void)getAuthorArticleWithSessionId:(NSString *)session
                                wuid:(NSString *)_wuid
                             success:(void(^)(id responseDic))success
                             failure:(void(^)(id errorString))failure;

#pragma mark - 取搜索 直达号 匹配的公司
+(void)getAllCompanyNonstopWithSessionId:(NSString *)session
                                 success:(void(^)(id responseDic))success
                                 failure:(void(^)(id errorString))failure;

#pragma mark - 获取企业主页 
+(void)getCompanyHomePageWithSessionId:(NSString *)session
                                  cuid:(NSString *)_cuid
                                   fid:(NSString *)_fid
                                  page:(NSInteger)_page
                               success:(void(^)(id responseDic))success
                               failure:(void(^)(id errorString))failure;


#pragma mark - 我的收藏列表
+(void)getMyCollectListWithSessionId:(NSString *)session
                                fcid:(NSString *)_fcid
                                page:(NSInteger)_page
                            keywords:(NSString *)_keywords
                             success:(void(^)(id responseDic))success
                             failure:(void(^)(id errorString))failure;

#pragma mark - 我的标签列表
+(void)getMyJSTLListWithSessionId:(NSString *)session
                          success:(void(^)(id responseDic))success
                          failure:(void(^)(id errorString))failure;

#pragma mark - 关注企业
+(void)addFriendactionWithSessionId:(NSString *)session
                             foruid:(NSString *)_foruid // 企业id
                            success:(void(^)(id responseDic))success
                            failure:(void(^)(id errorString))failure;

#pragma mark - 取消关注企业
+(void)delFriendactionWithSessionId:(NSString *)session
                             foruid:(NSString *)_foruid  // 企业id
                            success:(void(^)(id responseDic))success
                            failure:(void(^)(id errorString))failure;

#pragma mark - 修改标签
+(void)amendTallyWithSessionId:(NSString *)session
                       JSTL_ID:(NSString *)_JSTL_ID // 标签id
                          name:(NSString *)_name
                       success:(void(^)(id responseDic))success
                       failure:(void(^)(id errorString))failure;

#pragma mark - 删除标签
+(void)deleteTallyWithSessionId:(NSString *)session
                        JSTL_ID:(NSString *)_JSTL_ID // 标签id
                        success:(void(^)(id responseDic))success
                        failure:(void(^)(id errorString))failure;

#pragma mark - 往期周报列表
+(void)getPastweeklylistWithSessionId:(NSString *)session
                                 page:(NSInteger)_page
                              success:(void(^)(id responseDic))success
                              failure:(void(^)(id errorString))failure;

#pragma mark - 取第几期周报内容
+(void)getSelectWeeklyDataWithSessionId:(NSString *)session
                               weeklyId:(NSString *)_weeklyId
                                success:(void(^)(id responseDic))success
                                failure:(void(^)(id errorString))failure;

#pragma mark - 我的关注列表
+(void)getMyAttentionListWithSessionId:(NSString *)session
                               success:(void(^)(id responseDic))success
                               failure:(void(^)(id errorString))failure;

#pragma mark - 我的积分
+(void)getMyCreditsWithSessionId:(NSString *)session
                         success:(void(^)(id responseDic))success
                         failure:(void(^)(id errorString))failure;

#pragma mark - 我的文献查询 列表
+ (void)getMyLiteratureListWithSessionId:(NSString *)session
                                    page:(NSInteger )_page
                                 success:(void(^)(id responseDic))success
                                 failure:(void(^)(id errorString))failure;

#pragma mark - 文献查询 接口
+ (void)postSeekLiteratureWithSessionId:(NSString *)session
                                    doi:(NSString *)_doi
                                success:(void(^)(id responseDic))success
                                failure:(void(^)(id errorString))failure;

#pragma mark - 问答记录接口
+(void)getMyAnswersListWithSessionId:(NSString *)session
                                page:(NSInteger )_page
                             success:(void(^)(id responseDic))success
                             failure:(void(^)(id errorString))failure;

#pragma mark - 我的通知 首页
+(void)getMyNoticeHomePageListWithSessionId:(NSString *)session
                                    success:(void(^)(id responseDic))success
                                    failure:(void(^)(id errorString))failure;

#pragma mark - 邀请注册
+(void)getMyInviteRegisterWithSessionId:(NSString *)session
                                success:(void(^)(id responseDic))success
                                failure:(void(^)(id errorString))failure;


#pragma mark - 有奖分享成功后的回调
+(void)postShareCallBackWithSessionId:(NSString *)session
                                 thid:(NSString *)_thid
                                 spid:(NSString *)_spid
                              success:(void(^)(id responseDic))success
                              failure:(void(^)(id errorString))failure;

#pragma mark - 我的有奖分享纪录列表
+(void)getMyAwardShareListWithSessionId:(NSString *)session
                                   page:(NSInteger )_page
                                success:(void(^)(id responseDic))success
                                failure:(void(^)(id errorString))failure;

#pragma mark - 获取 系统消息和有奖活动 通知列表
+(void)getSystemAndAwardNoticeListWithSessionId:(NSString *)session
                                           type:(NSString *)_type
                                           page:(NSInteger)_page
                                        success:(void(^)(id responseDic))success
                                        failure:(void(^)(id errorString))failure;

#pragma mark - 个人注册提交信息接口
+(void)submitRegisterDataWithUserName:(NSString *)username
                                 code:(NSString *)_code
                             password:(NSString *)_password
                               doctor:(BOOL)      _doctor
                         professional:(NSString *)_professional
                             realname:(NSString *)_realname
                             position:(NSString *)_position
                              company:(NSString *)_company
                              success:(void(^)(id responseDic))success
                              failure:(void(^)(id errorString))failure;

#pragma mark - 获取短信验证码
+(void)getSMS_codeWithPhoneNumber:(NSString *)phone
                          success:(void(^)(id responseDic))success
                          failure:(void(^)(id errorString))failure;

#pragma mark - 上传图片
+(void)uploadImageWithImage:(UIImage *)image
                    success:(void(^)(id responseDic))success
                    failure:(void(^)(id errorString))failure;



@end
