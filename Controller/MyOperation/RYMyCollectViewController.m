//
//  RYMyCollectViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyCollectViewController.h"

@interface RYMyCollectViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITableView       *theTableView;
    NSMutableArray    *dataArray;
    NSMutableArray    *arrayOfCharacters;
}
@end

@implementation RYMyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的关注";
    arrayOfCharacters = [[self initheadArray] mutableCopy];
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
    theTableView.backgroundColor = [UIColor clearColor];
    [theTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [theTableView setSectionIndexColor:[Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0]];
    theTableView.delegate = self;
    theTableView.dataSource = self;
//    theTableView.tableHeaderView = [self tableViewHeadView];
    [Utils setExtraCellLineHidden:theTableView];
    [self.view addSubview:theTableView];
}

- (NSArray *)initheadArray
{
    NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
    for(char c = 'A';c <= 'Z';c++ )
        [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
    return toBeReturned;
}

// 搜索框
- (UIView *)tableViewHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    headView.backgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 4, 290, 28)];
    searchBar.layer.cornerRadius = 5.0f;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = @"搜索关注企业";
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.font = [UIFont systemFontOfSize:12];
    searchBar.delegate = self;
    searchBar.backgroundImage = [UIImage new];
    [headView addSubview:searchBar];
    return headView;
}

#pragma mark -UISearchBar 代理方法
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.text = @"";
    UITextField *searchBarTextField = nil;
    if([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        for (UIView *subView in searchBar.subviews){
            for (UIView *ndLeveSubView in subView.subviews){
                if ([ndLeveSubView isKindOfClass:[UITextField class]]){
                    searchBarTextField = (UITextField *)ndLeveSubView;
                    break;
                }
            }
        }
    }else{
        for (UIView *subView in searchBar.subviews){
            if ([subView isKindOfClass:[UITextField class]]){
                searchBarTextField = (UITextField *)subView;
                break;
            }
        }
    }
    searchBarTextField.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
    searchBarTextField.enablesReturnKeyAutomatically = NO;
    searchBarTextField.returnKeyType = UIReturnKeyDone;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}


#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrayOfCharacters.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier = @"indentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    cell.textLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = @"赛诺龙";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 设置section Header
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return arrayOfCharacters;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 21;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectZero];
    sectionView.backgroundColor = [Utils getRGBColor:242.0 g:242.0 b:242.0 a:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 21)];
    titleLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
    titleLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.backgroundColor = [UIColor clearColor];
    [sectionView addSubview:titleLabel];
    if ( [arrayOfCharacters count] == 0 ) {
        titleLabel.text = @"";
    }
    else{
        titleLabel.text = [arrayOfCharacters objectAtIndex:section];
    }
    
    return sectionView;
}
// 右边选择拦 点击选择
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *character in arrayOfCharacters)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return count;
}


@end
