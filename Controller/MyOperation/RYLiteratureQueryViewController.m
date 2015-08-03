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
    
    [self setdataWithDict:self.literatureDict];
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

- (void)setdataWithDict:(NSDictionary *)dict
{    
    self.articleData.author = [dict getStringValueForKey:@"doiauthor" defaultValue:@""];
    self.articleData.dateline = [dict getStringValueForKey:@"doidate" defaultValue:@""];
    self.articleData.message = [dict getStringValueForKey:@"message" defaultValue:@""];
    self.articleData.subject = [dict getStringValueForKey:@"subject" defaultValue:@""];
    self.articleData.subhead = [dict getStringValueForKey:@"doititle" defaultValue:@""];
    self.articleData.periodical = [dict getStringValueForKey:@"doijournal" defaultValue:@""];
    self.articleData.DOI = [dict getStringValueForKey:@"doiresult" defaultValue:@""];
    self.articleData.originalAddress = [dict getStringValueForKey:@"doiurl" defaultValue:@""];
    self.articleData.password = [dict getStringValueForKey:@"doipassword" defaultValue:@""];


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
        NSInteger state = [self.literatureDict getIntValueForKey:@"result" defaultValue:0];  //doi 查询 结果 分类 result：1查询完成，2第三方查到，3留言，4失败
        
        if ( state == 1 ) {
            return 1;
        }
        else{
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if ( indexPath.section == 0 ) {
        
        if ( indexPath.row == 0 ) {
            return 58;
        }
        else{
            NSString *content;
            if ( indexPath.row == 1 ){
                content = self.articleData.subject;
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
                CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil];
                return rect.size.height + 10;
            }
            else if ( indexPath.row == 2 ){
                // 设置 标题
                content = self.articleData.subhead;
            }
            else if ( indexPath.row == 3 ){
                // 设置作者
                content = self.articleData.author;
            }
            else if ( indexPath.row == 4 ){
                // 设置 期刊
                content = self.articleData.periodical;
            }
            else if ( indexPath.row == 5 ){
                // 设置 日期
                content = self.articleData.dateline;
            }
            else{
                // 设置 DOI
                content = self.articleData.DOI;
            }
            
            if ( [ShowBox isEmptyString:content] ) {
                return 0;
            }
            else{
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
                CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:attributes
                                                   context:nil];
                return rect.size.height + 31;

            }
        }
    }
    else{
        return 220;
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
            [cell setValueWithDict:self.literatureDict];
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
                if ( ![ShowBox isEmptyString:self.articleData.subhead] ) {
                    cell.leftView.backgroundColor = [Utils getRGBColor:0x00 g:0x91 b:0xea a:1.0];
                    cell.titleLabel.text = @"标题";
                    [cell setValueWithString:self.articleData.subhead];
                }
            }
            else if ( indexPath.row == 3 ){
                
                // 设置作者
                if ( ![ShowBox isEmptyString:self.articleData.author] ) {
                    cell.leftView.backgroundColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
                    cell.titleLabel.text = @"作者";
                    [cell setValueWithString:self.articleData.author];
                }
            }
            else if ( indexPath.row == 4 ){
               
                // 设置 期刊
                if ( ![ShowBox isEmptyString:self.articleData.periodical] ) {
                     cell.leftView.backgroundColor = [Utils getRGBColor:0xea g:0x73 b:0xc5 a:1.0];
                    cell.titleLabel.text = @"期刊";
                    [cell setValueWithString:self.articleData.periodical];
                }
            }
            else if ( indexPath.row == 5 ){
                
                // 设置 日期
                if ( ![ShowBox isEmptyString:self.articleData.dateline] ) {
                    cell.leftView.backgroundColor = [Utils getRGBColor:0x0b g:0xcd b:0xd3 a:1.0];
                    cell.titleLabel.text = @"日期";
                    [cell setValueWithString:self.articleData.dateline];
                }
            }
            else if ( indexPath.row == 6 ){
                
                // 设置 DOI
                if ( ![ShowBox isEmptyString:self.articleData.DOI] ) {
                    cell.leftView.backgroundColor = [Utils getRGBColor:0xee g:0x18 b:0x18 a:1.0];
                    cell.titleLabel.text = @"DOI";
                    [cell setValueWithString:self.articleData.DOI];
                }
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
            RYCopyAddressView *copyView = [[RYCopyAddressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220) andArticleData:self.articleData];
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
