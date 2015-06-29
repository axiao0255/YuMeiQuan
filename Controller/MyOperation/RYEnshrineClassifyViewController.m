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
//    TypeClassify        selectType;
    
    NSMutableArray      *dataArray;
}
@end

@implementation RYEnshrineClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的标签";
//    selectType = type_one;
    [self initSubviews];
    [self getNetData];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tallyChangeUpdate:) name:@"tallyChangeUpdate" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

-(void)tallyChangeUpdate:(NSNotification *)notic
{
     [self getNetData];
}

- (void)getNetData
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getMyJSTLListWithSessionId:[RYUserInfo sharedManager].session
                                          success:^(id responseDic) {
                                              NSLog(@" 我的标签 responseDic : %@",responseDic);
                                              [wSelf analysisDataWithDict:responseDic];
            
        } failure:^(id errorString) {
            NSLog(@"  我的标签  errorString : %@",errorString);
            
        }];
    }
}

- (void)analysisDataWithDict:(NSDictionary *)responseDic
{
    if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
        [ShowBox showError:@"数据出错，请稍候重试"];
        return;
    }
    
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    if ( !meta ) {
        [ShowBox showError:@"数据出错，请稍候重试"];
        return;
    }
    
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"数据出错，请稍候重试"]];
        return;
    }
    
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    if ( info == nil ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"数据出错，请稍候重试"]];
        return;
    }
    
    // 取标签列表
    NSArray *favoritecatmessage = [info getArrayValueForKey:@"favoritecatmessage" defaultValue:nil];
    if ( favoritecatmessage.count ) {
        dataArray = favoritecatmessage.mutableCopy;
        [theTableView reloadData];
    }
    
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

    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    
    NSString *idStr = [dic getStringValueForKey:@"id" defaultValue:@"0"];
    if ( ![idStr isEqualToString:@"0"] ) {
        cell.rightUtilityButtons = [self rightButtons];
    }
    else{
        // id 为 0 的时候 说明时未定义的标签， 不可修改和删除
        cell.rightUtilityButtons = @[];
    }
    
    if ( dataArray.count ) {
        
        cell.titleLabel.text = [dic getStringValueForKey:@"name" defaultValue:@""];
        [dic getIntValueForKey:@"num" defaultValue:0];
        cell.numLabel.text = [NSString stringWithFormat:@"%d篇文章",[dic getIntValueForKey:@"num" defaultValue:0]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RYEnshrineSubClassifyViewController *vc = [[RYEnshrineSubClassifyViewController alloc] initWithDataDict:[dataArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [theTableView indexPathForCell:cell];
    switch (index) {
        case 0:
        {
            [cell hideUtilityButtonsAnimated:YES];
            RYEditClassifyViewController *vc = [[RYEditClassifyViewController alloc] initWithDict:[dataArray objectAtIndex:indexPath.row]];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            [self deteleTallyWithIndex:indexPath.row];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for ( NSInteger i = 0; i < dataArray.count; i ++ ) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        RYEnshrineClassifyTableViewCell *cell = (RYEnshrineClassifyTableViewCell *)[theTableView cellForRowAtIndexPath:indexPath];
        [cell hideUtilityButtonsAnimated:YES];
    }
}

// 删除标签
- (void)deteleTallyWithIndex:(NSInteger)index
{
    if ( [ShowBox checkCurrentNetwork] ) {
        NSDictionary *dict = [dataArray objectAtIndex:index];
        __weak typeof(self) wSelf = self;
        [SVProgressHUD showWithStatus:@"提交中中..." maskType:SVProgressHUDMaskTypeGradient];
        [NetRequestAPI deleteTallyWithSessionId:[RYUserInfo sharedManager].session
                                        JSTL_ID:[dict objectForKey:@"id"]
                                        success:^(id responseDic) {
                                            [SVProgressHUD dismiss];
                                            [wSelf verifyResultWithDict:responseDic withIndex:index];
            
        } failure:^(id errorString) {
            [SVProgressHUD dismiss];
            [ShowBox showError:@"删除标签失败，请稍候重试"];
        }];
    }
    
}

- (void)verifyResultWithDict:(NSDictionary *)responseDic withIndex:(NSInteger)index
{
    if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
        [ShowBox showError:@"删除标签失败，请稍候重试"];
        return;
    }
    
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    if ( meta == nil ) {
        [ShowBox showError:@"删除标签失败，请稍候重试"];
        return;
    }
    
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"删除标签失败，请稍候重试"]];
        return;
    }
   [dataArray removeObjectAtIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
   [theTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

   [[NSNotificationCenter defaultCenter] postNotificationName:@"tallyChangeUpdate" object:nil];
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
