//
//  RYLiteratureQueryViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYLiteratureQueryViewController.h"
#import "RYArticleData.h"
#import "RYLiteratureQueryTableViewCell.h"
#import "RYCopyAddressView.h"

@interface RYLiteratureQueryViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) NSDictionary    *literatureDict;
@property (nonatomic , strong) UITableView     *tableView;
@property (nonatomic , strong) RYArticleData   *articleData;

@end

@implementation RYLiteratureQueryViewController

- (id)initWithLiteratureDict:(NSDictionary *)dict
{
    self = [super init];
    if ( self ) {
        
        self.literatureDict = dict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"文献查询";
    
    if ( self.literatureDict != nil ) {
        [self setdata];
    }
    
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

- (void)setdata
{
    self.articleData.author = @"阿肯积分卡时间发货";
    self.articleData.dateline = @"2015.5.5";
    self.articleData.message = @"adfaf";
    self.articleData.subject = @"低能量激光治疗低能量激光治疗低能量激光治疗低能量激光治疗";
    self.articleData.subhead = @"adsjkfhakjdhfasdkjfhsadjkhfsakjhdfkaadlfjhaskdhfdalsk";
    self.articleData.periodical = @"jshfghsjghsfjhgsdjghewowtywug";
    self.articleData.DOI = @"1233816875698423756";
    self.articleData.originalAddress = @"http://pan.baidu.com/s/1o6qUur4";
    self.articleData.password = @"3typ";

}

- (RYArticleData *)articleData
{
    if ( _articleData == nil ) {
        _articleData = [[RYArticleData alloc] init];
    }
    return _articleData;
}


- (UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor clearColor];
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

#pragma mark  UITableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 7;
    }
    else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            return 58;
        }
        else if ( indexPath.row == 1 ){
            // 设置标题
            if ( [ShowBox isEmptyString:self.articleData.subject] ) {
                return 0;
            }
            else{
                NSString *subject = self.articleData.subject;
                CGSize size =  [subject sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
                return size.height + 8 ;
            }
        }
        else if ( indexPath.row == 2 ){
            // 设置 标题
            if ( [ShowBox isEmptyString:self.articleData.subhead] ) {
                return 0;
            }
            else{
                NSString *subhead = [NSString stringWithFormat:@"标题：%@",self.articleData.subhead];
                CGSize size = [subhead sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
                return size.height + 8;
            }
        }
        else if ( indexPath.row == 3 ){
            // 设置作者
            if ( [ShowBox isEmptyString:self.articleData.author] ) {
                return 0;
            }
            else{
                NSString *author = [NSString stringWithFormat:@"作者：%@",self.articleData.author];
                CGSize size =  [author sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
                return size.height + 8;
            }
        }
        else if ( indexPath.row == 4 ){
            // 设置 期刊
            if ( [ShowBox isEmptyString:self.articleData.periodical] ) {
                return 0;
            }
            else{
                NSString *periodical = [NSString stringWithFormat:@"期刊：%@",self.articleData.periodical];
                CGSize size =  [periodical sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
                return size.height + 8;
            }
        }
        else if ( indexPath.row == 5 ){
            // 设置 日期
            if ( [ShowBox isEmptyString:self.articleData.dateline] ) {
                return 0;
            }
            else{
                NSString *dateline = [NSString stringWithFormat:@"日期：%@",self.articleData.dateline];
                CGSize size =  [dateline sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
                return size.height + 8;
            }
        }
        else if ( indexPath.row == 6 ){
            // 设置 DOI
            if ( [ShowBox isEmptyString:self.articleData.DOI] ) {
                return 0;
            }
            else{
                NSString *doi = [NSString stringWithFormat:@"DOI：%@",self.articleData.DOI];
                CGSize size =  [doi sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
                return size.height + 8;
            }
        }
        else{
            return 0;
        }
    }
    else{
        return 200;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            NSString *query_state = @"query_state";
            RYLiteratureQueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:query_state];
            if ( !cell ) {
                cell = [[RYLiteratureQueryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:query_state];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"1" forKey:@"state"];
            [cell setValueWithDict:dic];
            return cell;
        }
        else if ( indexPath.row == 1 )
        {
            // 设置标题
            if ( ![ShowBox isEmptyString:self.articleData.subject] ) {
                NSString *subject_cell = @"subject_cell";
                RYLiteratureQuerySubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subject_cell];
                if (!cell ) {
                    cell = [[RYLiteratureQuerySubjectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subject_cell];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [cell setValueWithString:self.articleData.subject];
                return cell;
            }
            else{
                return [UITableViewCell new];
            }
        }
        else{
            
            NSString *ordinary_cell = @"ordinary_cell";
            RYLiteratureQueryOrdinaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ordinary_cell];
            if ( !cell ) {
                cell = [[RYLiteratureQueryOrdinaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ordinary_cell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if ( indexPath.row == 2 ) {
                // 设置 标题
                NSString *subhead;
                if ( ![ShowBox isEmptyString:self.articleData.subhead] ) {
                    subhead = [NSString stringWithFormat:@"标题：%@",self.articleData.subhead];
                }
                [cell setValueWithString:subhead];
            }
            else if ( indexPath.row == 3 ){
                // 设置作者
                NSString *author;
                if ( ![ShowBox isEmptyString:self.articleData.author] ) {
                   author = [NSString stringWithFormat:@"作者：%@",self.articleData.author];
                }
                [cell setValueWithString:author];
            }
            else if ( indexPath.row == 4 ){
                // 设置 期刊
                NSString *periodical;
                if ( ![ShowBox isEmptyString:self.articleData.periodical] ) {
                     periodical = [NSString stringWithFormat:@"期刊：%@",self.articleData.periodical];
                }
                [cell setValueWithString:periodical];
            }
            else if ( indexPath.row == 5 ){
                // 设置 日期
                NSString *dateline;
                if ( ![ShowBox isEmptyString:self.articleData.dateline] ) {
                     dateline = [NSString stringWithFormat:@"日期：%@",self.articleData.dateline];
                }
                [cell setValueWithString:dateline];
            }
            else if ( indexPath.row == 6 ){
                // 设置 DOI
                NSString *doi;
                if ( ![ShowBox isEmptyString:self.articleData.DOI] ) {
                     doi = [NSString stringWithFormat:@"DOI：%@",self.articleData.DOI];
                }
                [cell setValueWithString:doi];
            }
            
            return cell;
        }
    }
    else{
        
        NSString *copy_cell = @"copy_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:copy_cell];
        if ( !cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:copy_cell];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            RYCopyAddressView *copyView = [[RYCopyAddressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) andArticleData:self.articleData];
            [cell.contentView addSubview:copyView];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end
