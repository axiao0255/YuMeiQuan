//
//  RYMyHomeLeftViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyHomeLeftViewController.h"
#import "RYMyHomeLeftTableViewCell.h"

@interface RYMyHomeLeftViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView      *theTableView;
    
    NSArray          *highlightedImgArrs;// 高亮图片组
    NSArray          *normalImageArrs;   // 普通图片组
}
@end

@implementation RYMyHomeLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setdatas];
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 获取图片数组
- (void)setdatas
{
    highlightedImgArrs = [NSArray arrayWithArray:[Utils getImageArrWithImgName:@"ic_highlighted_" andMaxIndex:7]];
    normalImageArrs = [NSArray arrayWithArray:[Utils getImageArrWithImgName:@"ic_normalImage_" andMaxIndex:7]];
}

- (void)initSubviews
{
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [theTableView setScrollEnabled:NO];
    [theTableView setDelegate:self];
    [theTableView setDataSource:self];
    theTableView.backgroundColor = [UIColor clearColor];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:theTableView];
}

#pragma mark - UITableView 代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 9;
    }
    else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            return 80;
        }
        else{
            return 43;
        }
    }else{
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            NSString *topCell = @"topCell";
            RYMyHomeLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topCell];
            if ( !cell ) {
                cell = [[RYMyHomeLeftTableViewCell alloc] initWithTopCellStyle:UITableViewCellStyleDefault reuseIdentifier:topCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.headPortraitImageView.image = [UIImage imageNamed:@"user_head_yes.png"];
            cell.userNameLabel.text = @"点击登录";
            [cell.headPortraitButton addTarget:self action:@selector(headButtonClick) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        else{
            NSString *commonCell = @"commonCell";
            RYMyHomeLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCell];
            if ( !cell ) {
                cell = [[RYMyHomeLeftTableViewCell alloc] initWithCommonStyle:UITableViewCellStyleDefault reuseIdentifier:commonCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            //高亮图片的名字
            NSString *highlightedImgName = [highlightedImgArrs objectAtIndex:indexPath.row-1];
            //normal图片的名字
            NSString *normalImageName = [normalImageArrs objectAtIndex:indexPath.row-1];
            cell.normalImage = [UIImage imageNamed:normalImageName];
            cell.highlightImage = [UIImage imageNamed:highlightedImgName];
            return cell;
        }
    }else{
        NSString *exitCell = @"exitCell";
        RYMyHomeLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:exitCell];
        if ( !cell ) {
            cell = [[RYMyHomeLeftTableViewCell alloc] initWithExitStyle:UITableViewCellStyleDefault reuseIdentifier:exitCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.exitButton addTarget:self action:@selector(exitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----- 按钮点击事件
- (void)headButtonClick
{
    NSLog(@"头像点击");
}

- (void)exitButtonClick
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要注销用户吗？" delegate:self cancelButtonTitle:@"不注销" otherButtonTitles:@"继续注销", nil];
    alert.tag = 110;
    [alert show];
}

#pragma mark ----- UIAlertView 代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        NSLog(@"注销");
    }
}


@end
