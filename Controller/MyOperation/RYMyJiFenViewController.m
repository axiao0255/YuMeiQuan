//
//  RYMyJiFenViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/4.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyJiFenViewController.h"

@interface RYMyJiFenViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray        *imgsArray;
}
@end

@implementation RYMyJiFenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的积分";
    self.view.backgroundColor = [UIColor whiteColor];
    imgsArray = [NSArray arrayWithArray:[Utils getImageArrWithImgName:@"jifen_img" andMaxIndex:2]];
    [self initSubviews];
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

- (void)initSubviews
{
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(106, 24, 164, 164)];
    iconImageView.image = [UIImage imageNamed:@"ic_jifen_jewel.png"];
    [self.view addSubview:iconImageView];
    
    UILabel *jifenTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 140, 100, 12)];
    jifenTitleLabel.text = @"积分余额";
    jifenTitleLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
    jifenTitleLabel.font = [UIFont systemFontOfSize:10];
    [jifenTitleLabel sizeToFit];
    [self.view addSubview:jifenTitleLabel];
    
    // 显示积分
    UILabel *showJifenLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(jifenTitleLabel.frame) + 3 ,
                                                                        CGRectGetMinY(jifenTitleLabel.frame),
                                                                        140 - CGRectGetWidth(jifenTitleLabel.bounds) ,
                                                                       34)];
    showJifenLabel.backgroundColor = [UIColor clearColor];
    showJifenLabel.font = [UIFont systemFontOfSize:35];
    showJifenLabel.textColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
    showJifenLabel.textAlignment = NSTextAlignmentRight;
    showJifenLabel.text = @"99999";
    [self.view addSubview:showJifenLabel];
    
    // 提现按钮
    UIButton *withdrawDepositBtn = [Utils getCustomLongButton:@"提现（即将开通）"];
    withdrawDepositBtn.backgroundColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0];
    [withdrawDepositBtn setEnabled:NO];
    withdrawDepositBtn.frame = CGRectMake(90,
                                          CGRectGetMaxY(showJifenLabel.frame) + 8,
                                          140,
                                          34);
    [self.view addSubview:withdrawDepositBtn];
    
    // 赚积分
    UIView    *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(withdrawDepositBtn.frame) + (IS_IPHONE_5?33:20),
                                                                         SCREEN_WIDTH,
                                                                         VIEW_HEIGHT - CGRectGetMaxY(withdrawDepositBtn.frame) + (IS_IPHONE_5?33:20))];;
    backgroundView.backgroundColor = [UIColor redColor];
    [self.view addSubview:backgroundView];
    
    UIImageView *bulgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    bulgeImageView.image = [UIImage imageNamed:@"ic_bulge.png"];
    [backgroundView addSubview:bulgeImageView];
    
    UILabel  *gainJifenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    gainJifenLabel.backgroundColor = [UIColor clearColor];
    gainJifenLabel.font = [UIFont systemFontOfSize:14];
    gainJifenLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
    gainJifenLabel.textAlignment = NSTextAlignmentCenter;
    gainJifenLabel.text = @"赚积分";
    [bulgeImageView addSubview:gainJifenLabel];
    
    UITableView *theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH,
                                                                              CGRectGetHeight(backgroundView.bounds) - 48)];
    theTableView.backgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    theTableView.scrollEnabled = NO;
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [backgroundView addSubview:theTableView];
}

#pragma mark - UITableView 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return imgsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
        imgView.tag = 1010;
        [cell.contentView addSubview:imgView];
    }
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1010];
    NSString *imgName = [imgsArray objectAtIndex:indexPath.row];
    imgView.image = [UIImage imageNamed:imgName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld",(long)indexPath.row);
}

@end
