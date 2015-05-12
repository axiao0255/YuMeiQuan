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


@interface AppDelegate ()<UINavigationControllerDelegate>
{
    NSString         *appNewVersionUrl;
//    TencentOAuth     *_tencentOAuth;
//    NSMutableArray   *_permissions;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImage *topbkimg= [UIImage imageNamed:@"navigationbar.png"];
    [[UINavigationBar appearance] setBackgroundImage:topbkimg forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor] , UITextAttributeFont : [UIFont boldSystemFontOfSize:18]}];
    [UINavigationBar appearance].shadowImage = [UIImage new];
    
    //注册友盟
    [self setupUM];
    
    RYNewsViewController *newsVC = [[RYNewsViewController alloc] init];
    RYMyHomeLeftViewController *homeLeftVC = [[RYMyHomeLeftViewController alloc] init];

    self.slideNav = [[SlideNavigationController alloc] initWithRootViewController:newsVC];
    // 增加阴影
    [self.slideNav.navigationBar dropShadowWithOffset:CGSizeMake(0, 4) radius:1 color:[UIColor blackColor] opacity:0.1];
    // 设置侧边栏的宽度
    self.slideNav.portraitSlideOffset = 100;
    self.slideNav.leftMenu = homeLeftVC;
    self.slideNav.delegate = self;
    id <SlideNavigationContorllerAnimator> revealAnimator = [[SlideNavigationContorllerAnimatorSlide alloc] init];
    self.slideNav.menuRevealAnimator = revealAnimator;
    self.slideNav.menuRevealAnimationDuration = 0.19;
    self.slideNav.enableShadow = YES;
    self.slideNav.enableSwipeGesture = YES;
    [self.window setRootViewController:self.slideNav];
    
    [self.window makeKeyAndVisible];
    return YES;
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

- (void)setupUM
{
    [UMSocialData setAppKey:UMAPPKEY];
    [MobClick startWithAppkey:UMAPPKEY];
//    [MobClick checkUpdate];
//    [MobClick checkUpdateWithDelegate:self selector:@selector(update:)];
    [MobClick setBackgroundTaskEnabled:NO];
    [UMSocialWechatHandler setWXAppId:@"wxed55f1b1544af9d0" appSecret:@"34a68e0b156af2cc96dda2de53e03702" url:nil];
    [UMSocialQQHandler setQQWithAppId:@"1101846072" appKey:@"yNSk5taezBe4HUOB" url:nil];
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
    [UMSocialQQHandler setSupportWebView:YES];
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
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


@end
