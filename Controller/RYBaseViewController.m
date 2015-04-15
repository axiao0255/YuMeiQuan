//
//  RYBaseViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/8.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYBaseViewController.h"

@interface RYBaseViewController ()

@end

@implementation RYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor colorWithRed:232/255.0f green:235/255.0f blue:240/255.0f alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
