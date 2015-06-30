//
//  RYCompanyRegisterSuccessViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/6/30.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYCompanyRegisterSuccessViewController.h"

@interface RYCompanyRegisterSuccessViewController ()

@property (nonatomic , strong) NSDictionary *info;
@property (nonatomic , strong) UIView       *subView;

@end

@implementation RYCompanyRegisterSuccessViewController

-(id)initWithDict:(NSDictionary *)info
{
    self = [super init];
    if ( self ) {
        self.info = info;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"VIEW_HEIGHT :%f",VIEW_HEIGHT);
    NSLog(@"VIEW_HEIGHT / 2: %f",VIEW_HEIGHT / 2);
    NSLog(@"a : %f",(VIEW_HEIGHT - self.subView.height));
    NSLog(@"b : %f",(VIEW_HEIGHT - self.subView.height)/2);
    self.subView.top = (VIEW_HEIGHT - self.subView.height)/2;
    [self.view addSubview:self.subView];
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

-(UIView *)subView
{
    if ( _subView == nil ) {
        _subView = [[UIView alloc] initWithFrame:CGRectZero];
        _subView.backgroundColor = [UIColor clearColor];
        _subView.width = SCREEN_WIDTH;
        _subView.height = 262;
        UIImageView *successImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 25, 0, 50, 50)];
        successImgView.image = [UIImage imageNamed:@"ic_register_success.png"];
        [_subView addSubview:successImgView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, successImgView.bottom + 10, SCREEN_WIDTH, 18)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"信息提交成功";
        [_subView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, titleLabel.bottom + 20, SCREEN_WIDTH - 60, 39)];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        contentLabel.numberOfLines = 2;
        contentLabel.text = [self.info getStringValueForKey:@"chenggong" defaultValue:@""];
        [_subView addSubview:contentLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, contentLabel.bottom + 20, SCREEN_WIDTH - 40, 0.5)];
        line.backgroundColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        [_subView addSubview:line];
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, line.bottom + 20, SCREEN_WIDTH, 14)];
        phoneLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        phoneLabel.textAlignment = NSTextAlignmentCenter;
        phoneLabel.font = [UIFont systemFontOfSize:14];
        phoneLabel.text = [NSString stringWithFormat:@"您也可以拨打%@咨询",[self.info getStringValueForKey:@"kefu" defaultValue:@""]];
        [_subView addSubview:phoneLabel];
        
        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(successImgView.left, phoneLabel.bottom + 20, 50, 50)];
        [phoneBtn setImage:[UIImage imageNamed:@"ic_register_phone.png"] forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_subView addSubview:phoneBtn];
    }
    
    return _subView;
}

-(void)phoneBtnClick:(id)sender
{
    NSString *tempStr = [self.info getStringValueForKey:@"kefu" defaultValue:@""];
    [Utils makeTelephoneCall:tempStr];
}

@end
