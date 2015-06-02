//
//  RYEnshrineClassifyViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/28.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYEnshrineClassifyViewController.h"
#import "NYSegmentedControl.h"
#import "RYEnshrineClassifyTableViewCell.h"
#import "RYEditClassifyViewController.h"
#import "RYEnshrineSubClassifyViewController.h"

typedef enum : NSUInteger {
    type_one,        // 分类
    type_two,        // 标签
} TypeClassify;

@interface RYEnshrineClassifyViewController ()<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>
{
    UITableView         *theTableView;
    TypeClassify        selectType;
    
    NSMutableArray      *dataArray;
    
}
@end

@implementation RYEnshrineClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    selectType = type_one;
    dataArray = [[self initdata]mutableCopy];
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubviews
{
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
    theTableView.backgroundColor = [UIColor clearColor];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [Utils setExtraCellLineHidden:theTableView];
    [self.view addSubview:theTableView];
}

- (NSArray *)initdata
{
    NSMutableArray *arr = [NSMutableArray array];
    for ( int i = 0 ; i < 10 ; i ++ ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"新闻" forKey:@"title"];
        [dic setValue:@"1" forKey:@"num"];
        [arr addObject:dic];
    }
    return arr;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[Utils getRGBColor:0xff g:0xb4 b:0x00 a:1.0]
                                                 icon:[UIImage imageNamed:@"ic_edit.png"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[Utils getRGBColor:0xd8 g:0xd8 b:0xd8 a:1.0]
                                                 icon:[UIImage imageNamed:@"ic_wasteBasket.png"]];
    
    return rightUtilityButtons;
}

#pragma mark - UITableView 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIdentifier = @"Cell";
    RYEnshrineClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( !cell ) {
        cell = [[RYEnshrineClassifyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
//    if ( selectType == type_two ) {
        cell.rightUtilityButtons = [self rightButtons];
//    }
//    else{
//        cell.rightUtilityButtons = @[];
//    }

    if ( dataArray.count ) {
        NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = [dic getStringValueForKey:@"title" defaultValue:@""];
        [dic getIntValueForKey:@"num" defaultValue:0];
        cell.numLabel.text = [NSString stringWithFormat:@"%d篇文章",[dic getIntValueForKey:@"num" defaultValue:0]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RYEnshrineSubClassifyViewController *vc = [[RYEnshrineSubClassifyViewController alloc] initWithDataArray:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
    switch (index) {
        case 0:
        {
            [cell hideUtilityButtonsAnimated:YES];
            RYEditClassifyViewController *vc = [[RYEditClassifyViewController alloc] initWithDict:[dataArray objectAtIndex:index]];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [theTableView indexPathForCell:cell];
            [dataArray removeObjectAtIndex:index];
            [theTableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}


//// head 的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 35;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
//    headView.backgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
//    
//    // 分段选择器
//    NYSegmentedControl *instagramSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"分类",@"标签"]];
//    [instagramSegmentedControl addTarget:self action:@selector(segmentSelectedControl:) forControlEvents:UIControlEventValueChanged];
//    instagramSegmentedControl.borderColor = [UIColor whiteColor];// 边界的颜色
//    instagramSegmentedControl.borderWidth = 0.8;
//    instagramSegmentedControl.backgroundColor = [UIColor whiteColor]; // 底部的颜色
//    instagramSegmentedControl.segmentIndicatorBackgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0]; // 所选按钮颜色
//    instagramSegmentedControl.segmentIndicatorInset = 0; // 按钮缩小
//    instagramSegmentedControl.titleFont = [UIFont systemFontOfSize:14];
//    instagramSegmentedControl.titleTextColor = [Utils getRGBColor:0x00 g:0x91 b:0xea a:1.0]; // 字体颜色
//    instagramSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];  // 选择时的字体颜色
//    instagramSegmentedControl.segmentIndicatorBorderColor = [UIColor whiteColor]; // 所选按钮的字体颜色
//    instagramSegmentedControl.frame = CGRectMake(15, 4 , 290, 28);
//    [instagramSegmentedControl setSelectedSegmentIndex:selectType];
//
//    [headView addSubview:instagramSegmentedControl];
//    return headView;
//}
//
//- (void)segmentSelectedControl:(NYSegmentedControl *)sender
//{
//    NSLog(@"%lu",(unsigned long)sender.selectedSegmentIndex);
//    switch ( sender.selectedSegmentIndex ) {
//        case 0:
//            selectType = type_one;
//            break;
//        case 1:
//            selectType = type_two;
//            break;
//            
//        default:
//            break;
//    }
//    [theTableView reloadData];
//}
@end
