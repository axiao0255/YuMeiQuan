//
//  NetRequestAPI.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/28.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "NetRequestAPI.h"

@implementation NetRequestAPI

// 拼接 参数
+ (NSString *)getParamWithParamDic:(NSDictionary *)parmDic
{
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [parmDic keyEnumerator])
    {
        if (!([[parmDic valueForKey:key] isKindOfClass:[NSString class]]))
        {
            continue;
        }
        
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@",[Utils getEncodingWithUTF8:key], [Utils getEncodingWithUTF8:[parmDic objectForKey:key]]]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}


#pragma mark - 用户登录
+(void)userLoginWithUserName:(NSString *)username
                    password:(NSString *)password
                     success:(void(^)(id responseDic))success
                     failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"logging" forKey:@"mod"];
    [parDic setValue:@"login" forKey:@"action"];
    [parDic setValue:username?username:@"" forKey:@"username"];
    [parDic setValue:password?password:@"" forKey:@"password"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php?%@",DEBUGADDRESS,[self getParamWithParamDic:parDic]];
    
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:nil success:success fail:failure];
    
//    [NetManager JSONDataWithUrl:url parameters:nil success:success fail:failure];
}

#pragma mark - 退出登录
+(void)userLogoutWithSessionId:(NSString *)session
                       success:(void(^)(id responseDic))success
                       failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"logging" forKey:@"mod"];
    [parDic setValue:@"logout" forKey:@"action"];
    [parDic setValue:session forKey:@"sid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
    
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
    
}

#pragma mark - 首页的新闻 列表
+(void)getHomePageNewsListWithSessionId:(NSString *)session
                                    fid:(NSString *)_fid
                                   page:(NSInteger)_page
                                success:(void(^)(id responseDic))success
                                failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"forumlist" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_fid forKey:@"fid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 播客 列表
+(void)getPodcastListWithSessionId:(NSString *)session
                             tagid:(NSString *)_tagid
                              page:(NSInteger )_page
                           success:(void(^)(id responseDic))success
                           failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"forumlist" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    [parDic setValue:_tagid forKey:@"tagid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 首页列表
+(void)getHomePageWithSessionId:(NSString *)session
                        success:(void(^)(id responseDic))success
                        failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"portal" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    NSLog(@"parDic :::     %@",parDic);
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}


#pragma mark - 首页的文献 列表
+(void)getHomeLiteratureListWithSessionId:(NSString *)session
                                      fid:(NSString *)_fid
                                    tagid:(NSString *)_tagid
                                     page:(NSInteger)_page
                                  success:(void(^)(id responseDic))success
                                  failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"forumlist" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_fid forKey:@"fid"];
    [parDic setValue:_tagid forKey:@"tagid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 文章详细页
+(void)getArticleDetailWithSessionId:(NSString *)session
                                 tid:(NSString *)_tid
                             success:(void(^)(id responseDic))success
                             failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"forum" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_tid forKey:@"tid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 首页 百家列表
+(void)getHomeBaijiaListWithSessionId:(NSString *)session
                                 page:(NSInteger)_page
                              success:(void(^)(id responseDic))success
                              failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"writerindex" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 文章 取消收藏
+(void)cancelCollectWithSessionId:(NSString *)session
                             thid:(NSString *)_thid
                          success:(void(^)(id responseDic))success
                          failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"favoriteaction" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_thid forKey:@"thid"];
    [parDic setValue:@"del" forKey:@"ac"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 文章 添加收藏
+(void)additionCollectWithSessionId:(NSString *)session
                               thid:(NSString *)_thid
                               tags:(NSArray *)_tags
                            success:(void(^)(id responseDic))success
                            failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"favoriteaction" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_thid forKey:@"thid"];
    [parDic setValue:@"add" forKey:@"ac"];
    
    NSString *tagStr;
    if ( _tags.count ) {
        for (int i = 0; i < _tags.count; i ++ ) {
            NSString *str = [_tags objectAtIndex:i];
            if ( tagStr.length == 0 ) {
                tagStr = [NSString stringWithFormat:@"%@",str];
            }
            else{
                tagStr = [NSString stringWithFormat:@"%@,%@",tagStr,str];
            }
        }
    }
    
    if ( ![ShowBox isEmptyString:tagStr] ) {
        [parDic setValue:tagStr forKey:@"favcat"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];

}

#pragma mark - 回答问题
+(void)answerTheQuestionWithSessionId:(NSString *)session
                                 thid:(NSString *)_thid
                                 qtid:(NSString *)_qtid
                              success:(void(^)(id responseDic))success
                              failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"answer" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_thid forKey:@"thid"];
    [parDic setValue:_qtid forKey:@"qtid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 取作者 对应的 文章
+(void)getAuthorArticleWithSessionId:(NSString *)session
                                wuid:(NSString *)_wuid
                             success:(void(^)(id responseDic))success
                             failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"writer" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_wuid forKey:@"wuid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];

}

#pragma mark - 取搜索 直达号 匹配的公司
+(void)getAllCompanyNonstopWithSessionId:(NSString *)session
                                 success:(void(^)(id responseDic))success
                                 failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"search" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 获取企业主页
+(void)getCompanyHomePageWithSessionId:(NSString *)session
                                  cuid:(NSString *)_cuid
                                   fid:(NSString *)_fid   // 企业 所发帖子的 分类。 获取全部的时候 为 0
                                  page:(NSInteger)_page
                               success:(void(^)(id responseDic))success
                               failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"company" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_cuid forKey:@"cuid"]; // 企业id
    [parDic setValue:_fid forKey:@"fid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 我的收藏列表
+(void)getMyCollectListWithSessionId:(NSString *)session
                                fcid:(NSString *)_fcid
                                page:(NSInteger)_page
                            keywords:(NSString *)_keywords
                             success:(void(^)(id responseDic))success
                             failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"favorite" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    [parDic setValue:_fcid forKey:@"fcid"];
    [parDic setValue:_keywords forKey:@"keywords"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 我的标签列表
+(void)getMyJSTLListWithSessionId:(NSString *)session
                          success:(void(^)(id responseDic))success
                          failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"favoritecat" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 关注企业
+(void)addFriendactionWithSessionId:(NSString *)session
                             foruid:(NSString *)_foruid
                            success:(void(^)(id responseDic))success
                            failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"friendaction" forKey:@"mod"];
    [parDic setValue:@"add" forKey:@"ac"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_foruid forKey:@"foruid"];
   
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];

    
}

#pragma mark - 取消关注企业
+(void)delFriendactionWithSessionId:(NSString *)session
                             foruid:(NSString *)_foruid
                            success:(void(^)(id responseDic))success
                            failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"friendaction" forKey:@"mod"];
    [parDic setValue:@"del" forKey:@"ac"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_foruid forKey:@"foruid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 修改标签
+(void)amendTallyWithSessionId:(NSString *)session
                       JSTL_ID:(NSString *)_JSTL_ID // 标签id
                          name:(NSString *)_name
                       success:(void(^)(id responseDic))success
                       failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"favoritecataction" forKey:@"mod"];
    [parDic setValue:@"edit" forKey:@"ac"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_JSTL_ID forKey:@"id"];
    [parDic setValue:_name forKey:@"name"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 删除标签
+(void)deleteTallyWithSessionId:(NSString *)session
                        JSTL_ID:(NSString *)_JSTL_ID // 标签id
                        success:(void(^)(id responseDic))success
                        failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"favoritecataction" forKey:@"mod"];
    [parDic setValue:@"del" forKey:@"ac"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_JSTL_ID forKey:@"id"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];

}

#pragma mark - 往期周报列表
+(void)getPastweeklylistWithSessionId:(NSString *)session
                                 page:(NSInteger)_page
                              success:(void(^)(id responseDic))success
                              failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"weeklylist" forKey:@"mod"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    [parDic setValue:session forKey:@"sid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];

}

#pragma mark - 取第几期周报内容
+(void)getSelectWeeklyDataWithSessionId:(NSString *)session
                               weeklyId:(NSString *)_weeklyId
                                 cateid:(NSString *)_cateid
                                success:(void(^)(id responseDic))success
                                failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"weekly" forKey:@"mod"];
    [parDic setValue:_cateid forKey:@"cateid"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_weeklyId forKey:@"id"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];

}

#pragma mark - 我的关注列表
+(void)getMyAttentionListWithSessionId:(NSString *)session
                               success:(void(^)(id responseDic))success
                               failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"friend" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 我的积分
+(void)getMyCreditsWithSessionId:(NSString *)session
                         success:(void(^)(id responseDic))success
                         failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"credit" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 我的文献查询 列表
+ (void)getMyLiteratureListWithSessionId:(NSString *)session
                                    page:(NSInteger )_page
                                 success:(void(^)(id responseDic))success
                                 failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"mydoi" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 文献查询 接口
+ (void)postSeekLiteratureWithSessionId:(NSString *)session
                                    doi:(NSString *)_doi
                                success:(void(^)(id responseDic))success
                                failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"doi" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_doi forKey:@"doi"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];

}

#pragma mark - 问答记录接口
+(void)getMyAnswersListWithSessionId:(NSString *)session
                                page:(NSInteger )_page
                             success:(void(^)(id responseDic))success
                             failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"questionlog" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
    
}

#pragma mark - 我的通知 首页
+(void)getMyNoticeHomePageListWithSessionId:(NSString *)session
                                    success:(void(^)(id responseDic))success
                                    failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"noticeindex" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 邀请注册
+(void)getMyInviteRegisterWithSessionId:(NSString *)session
                                success:(void(^)(id responseDic))success
                                failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"invite" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
    
}

#pragma mark - 有奖分享成功后的回调
+(void)postShareCallBackWithSessionId:(NSString *)session
                                 thid:(NSString *)_thid
                                 spid:(NSString *)_spid
                              success:(void(^)(id responseDic))success
                              failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"spreadlog" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_spid forKey:@"spid"];
    [parDic setValue:_thid forKey:@"thid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
    
}

#pragma mark - 我的有奖分享记录列表
+(void)getMyAwardShareListWithSessionId:(NSString *)session
                                   page:(NSInteger )_page
                                success:(void(^)(id responseDic))success
                                failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"myspread" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];

}

#pragma mark - 获取 系统消息和有奖活动 通知列表
/**
 * _type   系统消息传 system  有奖活动 传 spread
 */
+(void)getSystemAndAwardNoticeListWithSessionId:(NSString *)session
                                           type:(NSString *)_type
                                           page:(NSInteger)_page
                                        success:(void(^)(id responseDic))success
                                        failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"noticelist" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    [parDic setValue:_type forKey:@"type"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [NetManager JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}


#pragma mark - 个人注册提交信息接口
/**
 * username       手机号码
 * _code          验证码
 * _password      密码
 * _doctor        是否是医生，YES 医生，NO 非医生
 * _professional  专业
 * _realname      姓名
 * _position      职务
 * _company       单位名称
 * _occupation    医生职称
 * _image         证件照
 *
 */
+(void)submitRegisterDataWithUserName:(NSString *)username
                                 code:(NSString *)_code
                             password:(NSString *)_password
                               doctor:(BOOL)      _doctor
                         professional:(NSString *)_professional
                             realname:(NSString *)_realname
                             position:(NSString *)_position
                              company:(NSString *)_company
                           occupation:(NSString *)_occupation
                                image:(UIImage *)_image
                              success:(void(^)(id responseDic))success
                              failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"register" forKey:@"mod"];
    [parDic setValue:username forKey:@"username"];
    [parDic setValue:_password forKey:@"password"];
    [parDic setValue:_code forKey:@"code"];
    [parDic setValue:[NSNumber numberWithBool:_doctor] forKey:@"doctor"];
    [parDic setValue:_professional forKey:@"professional"];
    [parDic setValue:_realname forKey:@"realname"];
    [parDic setValue:_position forKey:@"position"];
    [parDic setValue:_company forKey:@"company"];
    [parDic setValue:_occupation forKey:@"occupation"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
//    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
     [[NetManager sharedManager] uploadImageWithUrl:url image:_image parameters:parDic success:success fail:failure];
}

#pragma mark - 获取短信验证码
+(void)getSMS_codeWithPhoneNumber:(NSString *)phone
                          success:(void(^)(id responseDic))success
                          failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"duanxin" forKey:@"mod"];
    [parDic setValue:phone forKey:@"username"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];

}

#pragma mark - 上传图片
+(void)uploadImageWithImage:(UIImage *)image
                        uid:(NSString*)_uid
                    success:(void(^)(id responseDic))success
                    failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"files" forKey:@"mod"];
    [dict setValue:_uid forKey:@"uid"];

     NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    [[NetManager sharedManager] uploadImageWithUrl:url image:image parameters:dict success:success fail:failure];
}

#pragma mark - 转发文章赚积分
+(void)getspreadlistWithSessionId:(NSString *)session
                             page:(NSInteger )_page
                          success:(void(^)(id responseDic))success
                          failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"spreadlist" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 参与调研赚积分
+(void)getquestionlistWithSessionId:(NSString *)session
                               page:(NSInteger )_page
                            success:(void(^)(id responseDic))success
                            failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"questionlist" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 企业注册提交
+(void)submitCompanyRegisterWithType:(NSString *)_type
                             company:(NSString *)_company
                                name:(NSString *)_name
                                 tel:(NSString *)_tel
                               email:(NSString *)_email
                             success:(void(^)(id responseDic))success
                             failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"companyreg" forKey:@"mod"];
    [parDic setValue:_type forKey:@"type"];
    [parDic setValue:_company forKey:@"company"];
    [parDic setValue:_name forKey:@"linkman"];
    [parDic setValue:_tel forKey:@"phone"];
    [parDic setValue:_email forKey:@"email"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 文献详细页 获取文献原文
+(void)getShowDoiWithSessionId:(NSString *)session
                           tid:(NSString *)_tid
                       success:(void(^)(id responseDic))success
                       failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"showdoi" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_tid forKey:@"tid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 获取评论 列表
+(void)getCommentListWithSessionId:(NSString *)session
                               tid:(NSString *)_tid
                              page:(NSInteger )_page
                           success:(void(^)(id responseDic))success
                           failure:(void(^)(id errorString))failure
{
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"commentlist" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_tid forKey:@"tid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];

}

#pragma mark - 提交评论
/**
 *
 *_tid  文章 id
 *_pid  回复第几楼
 *_authorId  被回复者id
 *_word 评论的 文字
 *_voiceUrl 音频文件
 */
#pragma mark - 提交评论
+(void)submitCommentWithSessionId:(NSString *)session
                              tid:(NSString *)_tid
                              pid:(NSString *)_pid
                         authorId:(NSString *)_authorId
                             word:(NSString *)_word
                            voice:(NSURL *)_voiceUrl
                          success:(void(^)(id responseDic))success
                          failure:(void(^)(id errorString))failure
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"commentaction" forKey:@"mod"];
    [dict setValue:@"add" forKey:@"ac"];
    [dict setValue:session forKey:@"sid"];
    [dict setValue:_tid forKey:@"tid"];
    [dict setValue:_pid forKey:@"pid"];
    [dict setValue:_authorId forKey:@"beauthorid"];
    [dict setValue:_word forKey:@"word"];
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
    [[NetManager sharedManager] uploadFileWithUrl:url filePath:_voiceUrl parameters:dict success:success fail:failure];
    
}

#pragma mark - 删除评论
+(void)deleteCommentWithSessionId:(NSString *)session
                              tid:(NSString *)_tid
                              pid:(NSString *)_pid
                          success:(void(^)(id responseDic))success
                          failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"commentaction" forKey:@"mod"];
    [parDic setValue:@"del" forKey:@"ac"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_tid forKey:@"tid"];
    [parDic setValue:_pid forKey:@"pid"];
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
    
}

#pragma mark - 点赞
+(void)praisesCommentWithSessionId:(NSString *)session
                               tid:(NSString *)_tid
                           success:(void(^)(id responseDic))success
                           failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"commentaction" forKey:@"mod"];
    [parDic setValue:@"zan" forKey:@"ac"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_tid forKey:@"tid"];
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
    
}


#pragma mark -获取编辑标签的数据
+(void)getEditTallyWithSessionId:(NSString *)session
                             tid:(NSString *)_tid
                         success:(void(^)(id responseDic))success
                         failure:(void(^)(id errorString))failure
{
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"favoriteaction" forKey:@"mod"];
    [parDic setValue:@"index" forKey:@"ac"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_tid forKey:@"thid"];
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark -兑换列表
+(void)getExchangeListWithSessionId:(NSString *)session
                               page:(NSInteger )_page
                            success:(void(^)(id responseDic))success
                            failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"exchange" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark -提交兑换数据
+(void)submitExchangeDataWithSessionId:(NSString *)session
                                   eid:(NSString *)_eid
                                   num:(NSInteger)_num
                                  name:(NSString *)_name
                               address:(NSString *)_address
                                mobile:(NSString *)_mobile
                               success:(void(^)(id responseDic))success
                               failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"exchangeaction" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:_eid forKey:@"eid"];
    [parDic setValue:[NSNumber numberWithInteger:_num] forKey:@"num"];
    [parDic setValue:_name forKey:@"name"];
    [parDic setValue:_address forKey:@"address"];
    [parDic setValue:_mobile forKey:@"mobile"];
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark -兑换历史列表
+(void)getExchangeHistoryListWithSessionId:(NSString *)session
                                      page:(NSInteger )_page
                                   success:(void(^)(id responseDic))success
                                   failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"exchangelog" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark -检查版本更新
+(void)getVersionWithSuccess:(void(^)(id responseDic))success
                     failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"version" forKey:@"mod"];
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark -获取编辑数据
+(void)getEditInformationWithSessionId:(NSString *)session
                               success:(void(^)(id responseDic))success
                               failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"profile" forKey:@"mod"];
    [parDic setValue:session forKey:@"sid"];
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    [[NetManager sharedManager] JSONDataWithUrl:url parameters:parDic success:success fail:failure];
}

#pragma mark - 提交编辑资料数据
/**
 * _doctor        是否是医生，YES 医生，NO 非医生
 * _professional  专业
 * _realname      姓名
 * _position      职务
 * _company       单位名称
 * _occupation    医生职称
 * _image         证件照
 *
 */

+(void)submitEditInformationWithSessionId:(NSString *)session
                                   doctor:(BOOL      )_doctor
                             professional:(NSString *)_professional
                                 realname:(NSString *)_realname
                                 position:(NSString *)_position
                                  company:(NSString *)_company
                               occupation:(NSString *)_occupation
                                    image:(UIImage *)_image
                                  success:(void(^)(id responseDic))success
                                  failure:(void(^)(id errorString))failure
{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:session forKey:@"sid"];
    [parDic setValue:@"profile" forKey:@"mod"];
    [parDic setValue:@"update" forKey:@"ac"];
    [parDic setValue:[NSNumber numberWithBool:_doctor] forKey:@"doctor"];
    [parDic setValue:_professional forKey:@"professional"];
    [parDic setValue:_realname forKey:@"realname"];
    [parDic setValue:_position forKey:@"position"];
    [parDic setValue:_company forKey:@"company"];
    [parDic setValue:_occupation forKey:@"occupation"];
    if ( _image == nil ) {
        [parDic setValue:@"noimage" forKey:@"image"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
    
    [[NetManager sharedManager] uploadImageWithUrl:url image:_image parameters:parDic success:success fail:failure];
}



@end
