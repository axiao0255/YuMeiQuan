//
//  RYMyCollectViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyCollectViewController.h"
#import "RYCorporateHomePageViewController.h"

@interface RYMyCollectViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITableView       *theTableView;
    NSMutableArray    *dataArray;
    NSArray           *arrayOfCharacters;
}
@end

@implementation RYMyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的关注";
    [self initSubviews];
    
    [self getNetData];
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

-(void)getNetData
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getMyAttentionListWithSessionId:[RYUserInfo sharedManager].session
                                               success:^(id responseDic) {
                                                   NSLog(@"我的关注列表 responseDic :: %@",responseDic);
                                                   [wSelf analysisDataWithDict:responseDic];
            
        } failure:^(id errorString) {
            NSLog(@"我的关注列表 errorString :: %@",errorString);
            [ShowBox showError:@"数据出错"];
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
    if ( meta == nil ) {
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
    
    NSArray *friendmessage = [info getArrayValueForKey:@"friendmessage" defaultValue:nil];
    if ( friendmessage.count == 0 ) {
        [ShowBox showError:@"为找到所关注的企业"];
        return;
    }
    
    arrayOfCharacters = [Utils findSameKeyWithArray:friendmessage];
    [theTableView reloadData];
    
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
    if ( arrayOfCharacters.count ) {
        NSArray *subArray = [arrayOfCharacters objectAtIndex:section];
        return subArray.count;
    }
    else{
        return 0;
    }
   
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
    
    if ( arrayOfCharacters.count ) {
        NSArray *subArray = [arrayOfCharacters objectAtIndex:indexPath.section];
        NSDictionary *dict = [subArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [dict getStringValueForKey:@"username" defaultValue:@""];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = [arrayOfCharacters objectAtIndex:indexPath.section];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    NSString *uid = [dict getStringValueForKey:@"uid" defaultValue:@""];
    RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] initWithCorporateID:uid];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 设置section Header
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray   *charArray = [NSMutableArray array];
    for ( NSInteger i = 0 ; i < arrayOfCharacters.count; i ++ ) {
        NSArray *subArray = [arrayOfCharacters objectAtIndex:i];
        NSDictionary *dict = [subArray objectAtIndex:0];
        [charArray addObject:[dict getStringValueForKey:@"firstcharter" defaultValue:@""]];
    }
    return charArray;
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
        
        NSArray *subArray = [arrayOfCharacters objectAtIndex:section];
        NSDictionary *dict = [subArray objectAtIndex:0];
        titleLabel.text = [dict getStringValueForKey:@"firstcharter" defaultValue:nil];
    }
    
    return sectionView;
}
// 右边选择拦 点击选择
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    if ( arrayOfCharacters.count == 0 ) {
        count =  0;
    }
    else{
        for ( NSInteger i = 0; i < arrayOfCharacters.count ; i ++ ) {
            NSArray *subArray = [arrayOfCharacters objectAtIndex:i];
            NSDictionary *dict = [subArray objectAtIndex:0];
            NSString *character = [dict getStringValueForKey:@"firstcharter" defaultValue:@""];
            if([character isEqualToString:title])
            {
                return count;
            }
            count ++;
        }
    }
    return count;
}


@end
