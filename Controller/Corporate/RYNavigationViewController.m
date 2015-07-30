//
//  RYNavigationViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/30.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYNavigationViewController.h"

@interface RYNavigationViewController ()

@end

@implementation RYNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    //  return UIInterfaceOrientationMaskAll &
    //         (~UIInterfaceOrientationMaskPortraitUpsideDown);
    return UIInterfaceOrientationMaskPortrait;//UIInterfaceOrientationMaskLandscape;
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
