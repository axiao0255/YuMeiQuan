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

@interface AppDelegate ()<UINavigationControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImage *topbkimg= [UIImage imageNamed:@"navigationbar.png"];
    [[UINavigationBar appearance] setBackgroundImage:topbkimg forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor] , UITextAttributeFont : [UIFont boldSystemFontOfSize:18]}];
    [UINavigationBar appearance].shadowImage = [UIImage new];
    
    
    RYNewsViewController *newsVC = [[RYNewsViewController alloc] init];
//    RYlalViewController *laVC = [[RYlalViewController alloc] init];
//    RYLoginViewController *loginVC = [[RYLoginViewController alloc] init];
//    self.nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    
   
  
     self.nav = [[UINavigationController alloc] initWithRootViewController:newsVC];
    
    
    

    // 增加阴影
    [self.nav.navigationBar dropShadowWithOffset:CGSizeMake(0, 4) radius:1 color:[UIColor blackColor] opacity:0.1];
    self.nav.delegate = self;
    
    [self.window setRootViewController:self.nav];
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

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
//
//- (BOOL)prefersStatusBarHidden
//
//{
//    
//    return YES;
//    
//}


@end
