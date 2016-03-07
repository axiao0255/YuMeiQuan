//
//  RYCorporateProductCategoryViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYCorporateProductCategoryViewController.h"

@interface RYCorporateProductCategoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView  *tableView;
@property (nonatomic , strong) RYCorporateHomePageData  *dataModel;

@end

@implementation RYCorporateProductCategoryViewController

-(id)initWithCategoryData:(RYCorporateHomePageData *)data
{
    self = [super init];
    if ( self ) {
        self.dataModel = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
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
- (void)setup
{
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}
#pragma mark  UITableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataModel.categoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *category_cell = @"category_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:category_cell];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:category_cell];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 43)];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        label.tag = 121;
        [cell.contentView addSubview:label];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 9, 15 , 9, 14)];
        arrow.image = [UIImage imageNamed:@"ic_small_arrow.png"];
        [cell.contentView addSubview:arrow];
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:121];
    if ( self.dataModel.categoryArray.count ) {
        NSDictionary *dict = [self.dataModel.categoryArray objectAtIndex:indexPath.row];
        label.text = [dict getStringValueForKey:@"name" defaultValue:@""];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( self.dataModel.categoryArray.count ) {
        NSDictionary *dict = [self.dataModel.categoryArray objectAtIndex:indexPath.row];
        NSString *fid = [dict getStringValueForKey:@"fid" defaultValue:@"0"];
        if ( [self.delegate respondsToSelector:@selector(categorySelectDidWithFid:)] ) {
            [self.delegate categorySelectDidWithFid:fid];
        }
      
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
