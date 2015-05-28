//
//  RYBaseViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/8.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"
#import "IQKeyboardManager.h"

@interface RYBaseViewController ()

@end

@implementation RYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 去掉键盘的 toolbar
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[self class]];
    
//    self.view.backgroundColor = [UIColor colorWithRed:232/255.0f green:235/255.0f blue:240/255.0f alpha:1];
    self.view.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
    if([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
        ////        self.extendedLayoutIncludesOpaqueBars = NO;
        ////        self.modalPresentationCapturesStatusBarAppearance = NO;
        //        self.automaticallyAdjustsScrollViewInsets = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%@ dealloc", [self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    //  return UIInterfaceOrientationMaskAll &
    //         (~UIInterfaceOrientationMaskPortraitUpsideDown);
    return UIInterfaceOrientationMaskPortrait;//UIInterfaceOrientationMaskLandscape;
}


@end
