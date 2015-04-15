//
//  RYRegisterSelectViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYRegisterSelectViewController.h"
#import "RYRegisterViewController.h"
#import "NYSegmentedControl.h"

@interface RYRegisterSelectViewController ()
{
    UILabel             *illustrateLabel;         // 适用对象Label
    UIImageView         *registerImageView;       // 医生或企业图片
    UIButton            *nextButton;              // 下一个 按钮
    UIImageView         *lineView;                // 分割线
    UILabel             *aboutUs;                 // 企业说明 label
    
    NSArray             *illustrateArray;         // 个人和企业 适用 对象
    
    NSUInteger          currentIndex;             // 用于判断当前选择的用户类型
}
@end

@implementation RYRegisterSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    
    illustrateArray = [NSArray arrayWithObjects:@"适用对象：\n医生、企业人员、医疗机构经营管理人员及其他医疗美容业者个人",\
                       @"适用对象：\n医疗美容相关产品及服务厂商与供应商,医疗美容机构（医院、科室、门诊部、诊所等）相关专业、行业学协会组织" ,nil];
    [self initSubviews];
}

- (void)initSubviews
{
    UIImage *image = [UIImage imageNamed:@"register_slider.png"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0 - image.size.width/2.0, \
                                                            IS_IPHONE_5?50:30, \
                                                            image.size.width,\
                                                            image.size.height)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    UIImageView *sliderBGView = [[UIImageView alloc] initWithFrame:view.bounds];
    sliderBGView.backgroundColor = [UIColor clearColor];
    sliderBGView.image = image;
    [view addSubview:sliderBGView];
    
    // 分段选择器
    UIColor *sliderBgColor = [Utils getRGBColor:0x04 g:0x8c b:0xcb a:1.0];
    NYSegmentedControl *instagramSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"个人用户",@"企业用户"]];
    [instagramSegmentedControl addTarget:self action:@selector(segmentSelectedControl:) forControlEvents:UIControlEventValueChanged];
    instagramSegmentedControl.borderColor = sliderBgColor;// 边界的颜色
    instagramSegmentedControl.borderWidth = 0.8;
    instagramSegmentedControl.backgroundColor = [UIColor whiteColor]; // 底部的颜色
    instagramSegmentedControl.segmentIndicatorBackgroundColor = sliderBgColor; // 所选按钮颜色
    instagramSegmentedControl.segmentIndicatorInset = 0; // 按钮缩小
    instagramSegmentedControl.titleTextColor = [Utils getRGBColor:0xb9 g:0xb9 b:0xb9 a:1.0]; // 字体颜色
    instagramSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];  // 选择时的字体颜色
    instagramSegmentedControl.segmentIndicatorBorderColor = [UIColor whiteColor]; // 所选按钮的字体颜色
    instagramSegmentedControl.frame = CGRectMake(view.frame.size.width/2 - 100, 0, 200 , 40);
    [view addSubview:instagramSegmentedControl];
    
    //    UIImage *isolateImge = [UIImage imageNamed:@"slider_isolate.png"];
    //    UIImageView *isolateView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width/2.0 - isolateImge.size.width /2 , 1, isolateImge.size.width, 38)];
    //    isolateView.backgroundColor = [UIColor clearColor];
    //    isolateView.image = isolateImge;
    //    [view addSubview:isolateView];
    
    illustrateLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x, IS_IPHONE_5?100:80, view.frame.size.width, 100)];
    illustrateLabel.font = [UIFont systemFontOfSize:12];
    illustrateLabel.backgroundColor = [UIColor clearColor];
    illustrateLabel.textColor = [Utils getRGBColor:0xb9 g:0xb9 b:0xb9 a:1.0]; // 字体颜色
    illustrateLabel.numberOfLines = 0;
    [self.view addSubview:illustrateLabel];
    
    UIImage *doctorImage = [UIImage imageNamed:@"register_image_0.png"];
    registerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0 - doctorImage.size.width/2.0,\
                                                                      IS_IPHONE_5?175:150,\
                                                                      doctorImage.size.width,\
                                                                      doctorImage.size.height)];
    registerImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:registerImageView];
    
    // 下一步按钮
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.origin.x, \
                                                            registerImageView.frame.origin.y + registerImageView.frame.size.height + (IS_IPHONE_5?34:30),\
                                                            200, 44)];
    nextButton.backgroundColor = [Utils getRGBColor:0x04 g:0xcb b:0x3c a:1.0];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = 4.0;
    nextButton.layer.shadowColor = [UIColor blackColor].CGColor;
    nextButton.layer.shadowOffset = CGSizeMake(0, 0);
    nextButton.layer.shadowOpacity = 0.3;
    nextButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(5, 5, nextButton.bounds.size.width - 10, 40)].CGPath;
    [self.view addSubview:nextButton];
    
    UIImage *lineImage = [UIImage imageNamed:@"register_line.png"];
    lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0,\
                                                             nextButton.frame.origin.y + nextButton.frame.size.height + (IS_IPHONE_5?50:40),\
                                                             SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor clearColor];
    lineView.image = lineImage;
    [self.view addSubview:lineView];
    
    aboutUs = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0 - 235 / 2.0,\
                                                        lineView.frame.origin.y + lineView.frame.size.height, \
                                                        235, \
                                                        VIEW_HEIGHT - lineView.frame.origin.y - lineView.frame.size.height)];
    aboutUs.backgroundColor = [UIColor clearColor];
    aboutUs.font = [UIFont systemFontOfSize:12];
    aboutUs.numberOfLines = 0;
    aboutUs.textColor = [Utils getRGBColor:0x80 g:0x80 b:0x80 a:1.0f];
    // 调整字体行间距
    NSString *labelText = @"全球最大的医疗美容专业资讯中文网络媒体\n     医疗美容专业资讯与营销服务提供商";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6.0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, labelText.length)];
    aboutUs.attributedText = attributedString;
    [self.view addSubview:aboutUs];
    currentIndex = 0;
    [self setSubviewWithIndex:currentIndex];
}

- (void)setSubviewWithIndex:(NSInteger ) index
{
    illustrateLabel.text = [illustrateArray objectAtIndex:index];
    [illustrateLabel sizeToFit];
    
    NSString *doctorImageName = [NSString stringWithFormat:@"register_image_%ld.png",(long)index];
    UIImage  *doctorImage = [UIImage imageNamed:doctorImageName];
    registerImageView.image = doctorImage;
}

- (void)segmentSelectedControl:(NYSegmentedControl *)sender
{
    currentIndex = sender.selectedSegmentIndex;
    [self setSubviewWithIndex:currentIndex];
}

- (void)nextBtnClick:(id)sender
{
    registerType type;
    if ( currentIndex == 0 ) {
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
