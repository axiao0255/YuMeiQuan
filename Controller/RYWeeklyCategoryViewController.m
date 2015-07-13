//
//  RYWeeklyCategoryViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/10.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYWeeklyCategoryViewController.h"

@interface RYWeeklyCategoryViewController ()<UITableViewDelegate,UITableViewDataSource,GridMenuViewDelegate>

@property (nonatomic , strong) UITableView     *tableView;
@property (nonatomic , strong) NSArray         *listData;
@property (nonatomic , assign) NSInteger       currentSelectIndex;      // 当前展开第几个分类

@end

@implementation RYWeeklyCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"分类";
    
    NSMutableArray *arr = [NSMutableArray array];
    for ( NSInteger i = 0; i < 3; i ++ ) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        NSMutableArray *second_list = [NSMutableArray array];
        for ( NSInteger j = 0 ; j < 6; j ++ ) {
            NSMutableDictionary *secondDict = [NSMutableDictionary dictionary];
            [secondDict setValue:@"整形外科" forKey:@"name"];
            [secondDict setValue:[NSNumber numberWithInteger:j] forKey:@"id"];
            [second_list addObject:secondDict];
        }
        if ( i == 0 ){
            [dict setValue:@"时讯报道" forKey:@"name"];
        }
        else if ( i == 1 ){
            [dict setValue:@"文献导读" forKey:@"name"];
        }
        else {
            [dict setValue:@"书籍推荐" forKey:@"name"];
        }
        [dict setValue:second_list forKey:@"second_list"];
        [arr addObject:dict];
    }
    
    self.listData = arr;
    
    self.currentSelectIndex = 0;
    [self.view addSubview:self.tableView];
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

- (NSArray *)listData
{
    if ( _listData == nil ) {
        _listData = [NSArray array];
    }
    return _listData;
}

- (UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
        [Utils setExtraCellLineHidden:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark  UITableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.currentSelectIndex == section ) {
        return 2;
    }
    else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 ) {
        return 45;
    }
    else{
        NSDictionary *resultDic = [self.listData objectAtIndex:indexPath.section];
        NSArray *secondList = [resultDic getArrayValueForKey:@"second_list" defaultValue:nil];
        return ceil(secondList.count/3.0)*40 + 20 + 4.5 * (ceil(secondList.count/3.0) - 1);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 ) {
        NSString *title_cell = @"title_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:title_cell];
        if ( !cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title_cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 45)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0]];
            [label setFont:[UIFont systemFontOfSize:16]];
            [label setTag:1001];
            [cell.contentView addSubview:label];
            
            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_WIDTH - 15 - 8, 17, 8, 10)];
            arrowView.backgroundColor = [UIColor clearColor];
            arrowView.tag = 1002;
            [cell.contentView addSubview:arrowView];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
            [cell.contentView addSubview:line];
            
        }
        if ( self.listData.count ) {
            NSDictionary *resultDic = [self.listData objectAtIndex:indexPath.section];
            NSString *nameStr = [resultDic getStringValueForKey:@"name" defaultValue:@""];
            UILabel *tempLabel = (UILabel *)[cell viewWithTag:1001];
            [tempLabel setText:nameStr];
            
            UIImageView *arrowView = (UIImageView *)[cell.contentView viewWithTag:1002];
            if ( self.currentSelectIndex == indexPath.section ) {
                arrowView.image = [UIImage imageNamed:@"arrows_up.png"];
            }else{
                arrowView.image = [UIImage imageNamed:@"arrows_down.png"];
            }
        }
       
        return cell;
    }
    else{
        NSString *menu_cell = @"menu_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menu_cell];
        if ( !cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:menu_cell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSDictionary *resultDic = [self.listData objectAtIndex:indexPath.section];
        NSArray *secondList = [resultDic getArrayValueForKey:@"second_list" defaultValue:nil];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (NSDictionary *tempDic in secondList)
        {
            NSString *tempStr = [tempDic getStringValueForKey:@"name" defaultValue:@""];
            [titleArray addObject:tempStr];
        }
        
        GridMenuView *categoryview = [[GridMenuView alloc] initWithFrame:CGRectMake(10, 10, 300, ceil(secondList.count/3.0)*40  + 4.5 *(ceil(secondList.count/3.0) - 1) )
                                                               imgUpName:@"mallbtn_up_ic_2.png"
                                                             imgDownName:@"mallbtn_up_ic_2.png"
                                                              titleArray:titleArray
                                                          titleDownColor:[Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0]
                                                            titleUpColor:[Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0]
                                                               perRowNum:3 andCanLinefeed:NO];
        categoryview.tag = indexPath.section + 500;
        [categoryview setDelegate:self];
        [cell.contentView addSubview:categoryview];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == self.currentSelectIndex ) {
        if ( indexPath.row == 0 ) {
            self.currentSelectIndex = -1;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }
    else if ( self.currentSelectIndex == -1 )
    {
        if ( indexPath.row == 0 ) {
            self.currentSelectIndex = indexPath.section;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }
    else{
        if ( indexPath.row == 0 ) {
            
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentSelectIndex];
            NSIndexPath *delIndexPath = [NSIndexPath indexPathForRow:1 inSection:self.currentSelectIndex];
            self.currentSelectIndex = indexPath.section;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath,reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView deleteRowsAtIndexPaths:@[delIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }
}

#pragma mark GridMenuViewDelegate
- (void)GridMenuViewButtonSelected:(NSInteger)btntag selfTag:(NSInteger)selftag
{
    
}


@end
