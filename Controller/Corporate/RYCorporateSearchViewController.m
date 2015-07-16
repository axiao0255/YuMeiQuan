//
//  RYCorporateSearchViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/6/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYCorporateSearchViewController.h"
#import "RYCorporateHomePageViewController.h"

@interface RYCorporateSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)  NSString      *placeholder;
@property (nonatomic , strong)  UISearchBar   *searchBar;

@property (nonatomic , strong)  NSArray       *dataList;

@property (nonatomic , strong)  UITableView   *tableView;
@property (nonatomic , strong)  NSArray       *findArray;

@end

@implementation RYCorporateSearchViewController

- (id) initWithSearchBarPlaceholder:(NSString *)placeholder
{
    self = [super init];
    if ( self ) {
        if ( [ShowBox isEmptyString:placeholder] ) {
            placeholder = @"输入企业直达号";
        }
        self.placeholder = placeholder;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"allCompany.plist"];
    self.dataList = [NSArray arrayWithContentsOfFile:path];
    
    [self.view addSubview:self.tableView];
    
    [self setnavBar];
    [self getAllCompanyData];
    
}

- (void)getAllCompanyData
{
    __weak typeof(self) wSelf = self;
    [NetRequestAPI getAllCompanyNonstopWithSessionId:[RYUserInfo sharedManager].session
                                             success:^(id responseDic) {
                                                 NSLog(@"搜索公司 ：%@",responseDic);
                                                 [wSelf analysisDataWithDict:responseDic];
        
    } failure:^(id errorString) {
        NSLog(@"errorString :: %@",errorString);
    }];
}

- (void)analysisDataWithDict:(NSDictionary *)responseDic
{
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    
    if ( info == nil ) {
        return;
    }
    
    NSArray *searchmessage = [info getArrayValueForKey:@"searchmessage" defaultValue:nil];
    
    if ( searchmessage.count ) {
        self.dataList = searchmessage;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *testPath = [documentsDirectory stringByAppendingPathComponent:@"allCompany.plist"];
        [self.dataList writeToFile:testPath atomically:YES];
    }
}

- (void)setnavBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 8, SCREEN_WIDTH - 40, 28)];
    searchBar.layer.cornerRadius = 5.0f;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = self.placeholder;
    searchBar.delegate = self;
    searchBar.backgroundImage = [UIImage new];
    [searchBar setShowsCancelButton:YES];
    
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.font = [UIFont systemFontOfSize:14];
    searchField.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
    searchField.enablesReturnKeyAutomatically = NO;
    searchField.returnKeyType = UIReturnKeySearch;
    
    UIButton *cancelBnt = [self cancelButtonWithSearchBar:searchBar];
    [cancelBnt setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    self.searchBar = searchBar;
    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = searchBar;
}

- (UIButton *)cancelButtonWithSearchBar:(UISearchBar *)searchBar
{
    UIButton *cancelBtn = nil;
    if([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        for (UIView *subView in searchBar.subviews){
            for (UIView *ndLeveSubView in subView.subviews){
                if ([ndLeveSubView isKindOfClass:[UIButton class]]){
                    cancelBtn = (UIButton *)ndLeveSubView;
                    break;
                }
            }
        }
    }
    return cancelBtn;
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    NSLog(@"点击搜索框");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"取消");
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"searchText : %@",searchText);
    
    NSString *searchStr;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        searchStr = searchText;
    }
    else{ // 英文下 转小写字母
        searchStr = searchText.lowercaseString;
    }
    
    self.findArray = [self findExistCompanyWithOriginalCompanyList:self.dataList andSearchKey:searchStr];
    [self.tableView reloadData];
}

- (NSArray *)findExistCompanyWithOriginalCompanyList:(NSArray *)originalArray andSearchKey:(NSString *)searchKey
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for ( NSInteger i = 0; i < originalArray.count; i ++ ) {
        NSDictionary *dict = [originalArray objectAtIndex:i];
        NSString *keywords = [dict getStringValueForKey:@"keywords" defaultValue:@""];
        
        if ( [keywords rangeOfString:searchKey].location != NSNotFound ) {
            [tempArray addObject:dict];
        }
    }
    return tempArray;
}

- (UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

//- (void)keyboardWillShow:(NSNotification*)notification //键盘出现
//{
//    CGRect _keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
////    NSLog(@"%f-%f",_keyboardRect.origin.y,_keyboardRect.size.height);
//    self.tableView.height = VIEW_HEIGHT - _keyboardRect.size.height;
//}
//
//- (void)keyboardWillHide:(NSNotification*)notification //键盘下落
//{
//    self.tableView.height = VIEW_HEIGHT;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.findArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *find_cell = @"find_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:find_cell];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:find_cell];
    }
    if ( self.findArray.count ) {
        NSDictionary *dict = [self.findArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [dict getStringValueForKey:@"username" defaultValue:@""];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
    
    NSDictionary *dict = [self.findArray objectAtIndex:indexPath.row];
    NSString *companyID = [dict getStringValueForKey:@"uid" defaultValue:@""];
    if (  ![ShowBox isEmptyString:companyID] ) {
        RYCorporateHomePageViewController *vc = [[RYCorporateHomePageViewController alloc] initWithCorporateID:companyID];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

@end
