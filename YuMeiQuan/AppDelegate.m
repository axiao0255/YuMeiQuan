//
//  AppDelegate.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/8.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "AppDelegate.h"
#import "RYNewsViewController.h"
#import "UINavigationBar+JSDropShadow.h"

#import "RYLoginViewController.h"
#import "RYMyHomeLeftViewController.h"
#import "SlideNavigationContorllerAnimatorSlide.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialSnsService.h"
#import "UMSocialData.h"

#import "BPush.h"

#import "RYMyInformListViewController.h"
#import "Harpy.h"


@interface AppDelegate ()<UINavigationControllerDelegate>
{
    NSString             *appNewVersionUrl;
    RYNewsViewController *newsVC;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImage *topbkimg= [UIImage imageNamed:@"navigationbar.png"];
    [[UINavigationBar appearance] setBackgroundImage:topbkimg forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor] , UITextAttributeFont : [UIFont boldSystemFontOfSize:18]}];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil]];
    
    [UINavigationBar appearance].shadowImage = [UIImage new];
    
    //注册友盟
    [self setupUM];
    
    // 设置导航
    newsVC = [[RYNewsViewController alloc] init];
    RYMyHomeLeftViewController *homeLeftVC = [[RYMyHomeLeftViewController alloc] init];

    self.slideNav = [[SlideNavigationController alloc] initWithRootViewController:newsVC];
    // 增加阴影
    [self.slideNav.navigationBar dropShadowWithOffset:CGSizeMake(0, 4) radius:1 color:[UIColor blackColor] opacity:0.1];
    // 设置侧边栏的宽度
    self.slideNav.portraitSlideOffset = 55;
    self.slideNav.leftMenu = homeLeftVC;
    self.slideNav.delegate = self;
    id <SlideNavigationContorllerAnimator> revealAnimator = [[SlideNavigationContorllerAnimatorSlide alloc] init];
    self.slideNav.menuRevealAnimator = revealAnimator;
    self.slideNav.menuRevealAnimationDuration = 0.19;
    self.slideNav.enableShadow = YES;
    self.slideNav.enableSwipeGesture = YES;
    [self.window setRootViewController:self.slideNav];
    [self.window makeKeyAndVisible];
    
   // 设置 百度推送
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
#warning 上线 AppStore 时需要修改 pushMode 需要修改Apikey为自己的Apikey
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"zfGGBEBjkj8C4LNoCNImSuaQ" pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
        [newsVC receivePushNoticeWithUserinfo:userInfo];
    }

    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    /*
     // 测试本地通知
     [self performSelector:@selector(testLocalNotifi) withObject:nil afterDelay:1.0];
     */
    
    // 检查版本
    [Harpy checkVersion];

    return YES;
}

#pragma mark 设置 云 推送
// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    [BPush registerDeviceToken:deviceToken]; // 必须
//    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        NSLog(@"推送 result :%@",result);
    }];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    
    [newsVC receivePushNoticeWithUserinfo:userInfo];
    
    NSLog(@"推送 userInfo ：%@",userInfo);
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UINavigationController 的代理方法
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIBarButtonItem *back=[[UIBarButtonItem alloc] init];
    
    back.title = @" ";
    UIImage *backbtn = [UIImage imageNamed:@"back_btn_icon.png"];
    [back setBackButtonBackgroundImage:backbtn forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [back setBackButtonBackgroundImage:[UIImage imageNamed:@"back_btn_icon.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [back setStyle:UIBarButtonItemStylePlain];
    
    viewController.navigationItem.backBarButtonItem = back;
}

#pragma  mark 设置 友盟
- (void)setupUM
{
    [UMSocialData setAppKey:UMAPPKEY];
    [MobClick startWithAppkey:UMAPPKEY];
//    [MobClick checkUpdate];
    [MobClick setBackgroundTaskEnabled:NO];
    [UMSocialWechatHandler setWXAppId:@"wxed55f1b1544af9d0" appSecret:@"34a68e0b156af2cc96dda2de53e03702" url:nil];
    [UMSocialQQHandler setQQWithAppId:@"1101846072" appKey:@"yNSk5taezBe4HUOB" url:nil];
    
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
    
    
    [UMSocialQQHandler setSupportWebView:YES];
    
    
    // 获取 本地 版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    NSLog(@"version :: %@",version);
//    [MobClick checkUpdateWithDelegate:self selector:@selector(update:)];
}


/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//     NSLog(@"url 2 %@ ", url);
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
//    NSLog(@"url 1 %@ ", url);
    return  [UMSocialSnsService handleOpenURL:url];
}


#pragma mark - 程序更新的处理
- (void)update:(NSDictionary *)info
{
    if (info == nil || ![info isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    BOOL isNeedUpdate = [info getBoolValueForKey:@"update" defaultValue:NO];
    if (isNeedUpdate)//需要跟新的情况
    {
        NSString *currentVersion = [info getStringValueForKey:@"current_version" defaultValue:@""];//当前的版本
        NSString *updateLog = [info getStringValueForKey:@"update_log" defaultValue:@""];//更新日志
        NSString *newVersion = [info getStringValueForKey:@"version" defaultValue:@""];//最新版本
        appNewVersionUrl = [info getStringValueForKey:@"path" defaultValue:@""];
        
        NSString *message = [NSString stringWithFormat:@"最新版本：%@\n当前版本：%@\n更新内容：%@",newVersion,currentVersion,updateLog];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本！" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更新", nil];
        [alertView setTag:1000];
        [alertView show];
    }
    else//
    {
        
    }
}
/**
 *  分享 时调用
 *  index        选择分享的类型  0 微信 ，1 微信好友圈，2 QQ，3 短信 ，4 新浪微博
 *  content      分享的文字内容
 *  picUrl       需要分享的图片地址
 *  _callbackId  分享成功后 如果此参数不为空 表示有奖分享， 需要把 次id 传给后台
 *  _shareUrl    分享的web地址
 *  _thid        分享文章的ID
 */
-(void)shareWithIndex:(NSUInteger) index shareContent:(NSString *)content sharePicUrl:(NSString *)picUrl callbackId:(NSString *)_callbackId shareUrl:(NSString *)_shareUrl thid:(NSString *)_thid andPresentController:(UIViewController *)viewController
{
    //设置微信好友或者朋友圈的分享url,下面是微信好友，微信朋友圈对应wechatTimelineData
    UMSocialUrlResource *source = nil ;
    NSString *snsType = UMShareToWechatSession;
    if (content.length > 40 ) {
        content = [content substringToIndex:40];
    }
    switch ( index ) {
        case 0:
        {
            snsType = UMShareToWechatSession;
            if ( ![ShowBox isEmptyString:picUrl] ) {
                source = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:picUrl];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareUrl;
            }
            else{
                content = [NSString stringWithFormat:@"%@ %@",content,_shareUrl];
            }
        }
            
            break;
        case 1:
        {
            snsType = UMShareToWechatTimeline;
            
            if ( ![ShowBox isEmptyString:picUrl] ) {
                source = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:picUrl];
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
            }
            else{
                content = [NSString stringWithFormat:@"%@ %@",content,_shareUrl];
            }
        }
            
            break;
        case 2:
        {
            snsType = UMShareToQQ;
            
            if ( ![ShowBox isEmptyString:picUrl] ) {
                source = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:picUrl];
                [UMSocialData defaultData].extConfig.qqData.url = _shareUrl;
            }
            else{
                content = [NSString stringWithFormat:@"%@ %@",content,_shareUrl];
            }
        }
            break;
            
        case 3:
        {
            snsType = UMShareToSms;
            content = [NSString stringWithFormat:@"%@ %@",content,_shareUrl];
        }
            break;
            
        case 4:
        {
            snsType = UMShareToSina;
            
            if ( ![ShowBox isEmptyString:picUrl] ) {
                source = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:picUrl];
            }
            content = [NSString stringWithFormat:@"%@ %@",content,_shareUrl];
        }
            
            break;
        default:
            break;
    }
    
    __weak typeof(self) wSelf = self;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[snsType]
                                                        content:content
                                                          image:nil
                                                       location:nil
                                                    urlResource:source
                                            presentedController:viewController
                                                     completion:^(UMSocialResponseEntity *response){
                                                         
        if (response.responseCode == UMSResponseCodeSuccess) {
            [ShowBox showSuccess:@"分享成功"];
            // 分享成功后 如果 是有奖分享 则调此接口告诉后台 分享成功
            if ( ![ShowBox isEmptyString:_callbackId] && ![ShowBox isEmptyString:_thid] && [ShowBox isLogin] ) {
                [wSelf shareSuccessCallBackWithCallBackId:_callbackId andThid:_thid];
            }
        }
        NSLog(@"response.responseCode : %d",response.responseCode);
    }];
}

-(void)shareSuccessCallBackWithCallBackId:(NSString *)_callBackId andThid:(NSString *)thid
{
    [NetRequestAPI postShareCallBackWithSessionId:[RYUserInfo sharedManager].session
                                             thid:thid
                                             spid:_callBackId
                                          success:^(id responseDic) {
                                              NSLog(@"分享成功回调 responseDic : %@",responseDic);
                                              NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                              NSLog(@"msg : %@",[meta objectForKey:@"msg"]);
        
    } failure:^(id errorString) {
         NSLog(@"分享成功回调 errorString : %@",errorString);
    }];
}

@end
