//
//  RYCorporateViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/13.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYCorporateViewController.h"
#import "RYCorporateTableViewCell.h"

@interface RYCorporateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView      *tableView;


@property (nonatomic , strong) RYCorporateHomePageData *dataModel;

@end

@implementation RYCorporateViewController

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

    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}



#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        NSString *realname = [self.dataModel.corporateBody getStringValueForKey:@"realname" defaultValue:@""];
//        CGSize nameSize = [realname sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        NSDictionary *nameAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
        CGRect nameRect = [realname boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 , MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:nameAttributes
                                          context:nil];
        
        NSString *desc = [self.dataModel.corporateBody getStringValueForKey:@"depict" defaultValue:@""];
//        CGSize  recommendSize = [desc sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        NSDictionary *descAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
        CGRect recommendRect = [desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 , MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:descAttributes
                                                 context:nil];

        
        CGFloat collectBntHeight;
        if ( [ShowBox isLogin] ) {
            collectBntHeight = 16 + 16 + 28;
        }
        else{
            collectBntHeight = 16;
        }

        return nameRect.size.height + recommendRect.size.height + 80 + collectBntHeight;
    }
    else{
         return 94;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"identifier";
    RYCorporateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell ) {
        cell = [[RYCorporateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setValueWithModel:self.dataModel];
    [cell.attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


- (void)attentionBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;

    if ( [ShowBox checkCurrentNetwork] ) {
        NSString *uid = [self.dataModel.corporateBody getStringValueForKey:@"uid" defaultValue:@""];
        [btn setEnabled:NO];
        __weak typeof(self) wSelf = self;
        if ( self.dataModel.isAttention ) {
            [NetRequestAPI delFriendactionWithSessionId:[RYUserInfo sharedManager].session
                                                 foruid:uid
                                                success:^(id responseDic) {
                                                    [btn setEnabled:YES];

                                                    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                                    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                                    if ( !success ) {
                                                        [ShowBox showError:@"取消收藏失败,请稍候重试"];
                                                    }
                                                    else{
                                                        wSelf.dataModel.isAttention = !wSelf.dataModel.isAttention;
                                                        [btn setImage:[UIImage imageNamed:@"ic_attention.png"] forState:UIControlStateNormal];
                                                        [wSelf.delegate statesChange];
                                                    }
                
            } failure:^(id errorString) {
                [ShowBox showError:@"取消收藏失败,请稍候重试"];
                 [btn setEnabled:YES];
            }];
        }
        else{
            [NetRequestAPI addFriendactionWithSessionId:[RYUserInfo sharedManager].session
                                                 foruid:uid
                                                success:^(id responseDic) {
                                                    [btn setEnabled:YES];
                                                    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                                    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                                    if ( !success ) {
                                                        [ShowBox showError:@"收藏失败,请稍候重试"];
                                                    }
                                                    else{
                                                        wSelf.dataModel.isAttention = !wSelf.dataModel.isAttention;
                                                        [btn setImage:[UIImage imageNamed:@"ic_no_attention.png"] forState:UIControlStateNormal];
                                                        [wSelf.delegate statesChange];
                                                    }
            } failure:^(id errorString) {
                [ShowBox showError:@"收藏失败，请稍候重试"];
                [btn setEnabled:YES];

            }];
        }
    }
}




@end
