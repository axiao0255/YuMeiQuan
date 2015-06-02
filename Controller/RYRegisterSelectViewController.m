//
//  RYRegisterSelectViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYRegisterSelectViewController.h"
#import "RYRegisterViewController.h"

@interface RYRegisterSelectViewController ()
{
    UILabel             *aboutUs;                 // 企业说明 label
}
@end

@implementation RYRegisterSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    [self initSubviews];
}

- (void)initSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 个人用户
    UIImageView *personalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(106, 16, 164, 164)];
    personalImageView.image = [UIImage imageNamed:@"register_personal.png"];
    [self.view addSubview:personalImageView];
    
    UIButton *personalButton = [Utils getCustomLongButton:@"个人用户"];
    personalButton.frame = CGRectMake(90, 132, 140, 34);
    personalButton.tag = 100;
    [personalButton addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:personalButton];
    
    // 企业用户
    UIImageView *companyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(personalImageView.frame),
                                                                                 CGRectGetMaxY(personalButton.frame) + 16,
                                                                                  164, 164)];
    companyImageView.image = [UIImage imageNamed:@"register_company.png"];
    [self.view addSubview:companyImageView];
    UIButton *companyButton = [Utils getCustomLongButton:@"企业用户"];
    companyButton.frame = CGRectMake(CGRectGetMinX(personalButton.frame),
                                     298, 140, 34);
    companyButton.tag = 101;
    [companyButton addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:companyButton];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(companyButton.frame) + 16,
                                                                 SCREEN_WIDTH,
                                                                  VIEW_HEIGHT - CGRectGetMaxY(companyButton.frame) - 16)];
    bottomView.backgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
    [self.view addSubview:bottomView];
    
    // 公司介绍
    aboutUs = [[UILabel alloc] initWithFrame:CGRectMake(0,0,
                                                        SCREEN_WIDTH,
                                                        bottomView.height)];
    aboutUs.backgroundColor = [UIColor clearColor];
    aboutUs.font = [UIFont systemFontOfSize:14];
    aboutUs.textAlignment = NSTextAlignmentCenter;
    aboutUs.numberOfLines = 0;
    aboutUs.textColor = [Utils getRGBColor:0x00 g:0x91 b:0xea a:1.0f];
    // 调整字体行间距
   
    NSString *labelText = @"全球最大的医疗美容专业资讯中文网络媒体";
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:6.0];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, labelText.length)];
//    aboutUs.attributedText = attributedString;
    aboutUs.text = labelText;
    [bottomView addSubview:aboutUs];
//    [aboutUs sizeToFit];
}

- (void)nextBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    registerType type;
    if ( btn.tag - 100 == 0 ) {
        type = typePersonal;
    }
    else{
        type = typeCollective;
    }
    RYRegisterViewController *registerVC = [[RYRegisterViewController alloc] initWithRefisterType:type];
    [self.navigationController pushViewController:registerVC animated:YES];
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
