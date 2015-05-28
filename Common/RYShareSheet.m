//
//  RYShareSheet.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYShareSheet.h"

@interface RYShareSheet ()<UITableViewDelegate,UITableViewDataSource,GridMenuViewDelegate>

@property (nonatomic,strong)UITableView   *tableView;
@property (nonatomic,strong)UIButton      *cancelButton;
@property (nonatomic,strong)UIButton      *transparencyBtn;
@property (nonatomic,strong)NSArray       *shareIconArray;

@end


@implementation RYShareSheet

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
    self = [super init];
    if ( self ) {
         self.shareIconArray = [self setIcons];
    }
   
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.shareIconArray = [self setIcons];
    }
    
    return self;
}

- (NSArray *)setIcons
{
    NSArray  *icons = [Utils getImageArrWithImgName:@"ic_invite_share" andMaxIndex:4];
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    [tmpArr addObject:[icons subarrayWithRange:NSMakeRange(0, 3)]];
    [tmpArr addObject:[icons subarrayWithRange:NSMakeRange(3, 2)]];
    return tmpArr;
}

- (UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (UIButton *)transparencyBtn
{
    if ( _transparencyBtn == nil ) {
        _transparencyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _transparencyBtn.backgroundColor = [Utils getRGBColor:0 g:0 b:0 a:0.5];
        [_transparencyBtn addTarget:self action:@selector(dismissShareView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transparencyBtn;
}

- (void)dismissShareView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)showShareView
{
    __weak AppDelegate *_appDelegate;
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [_appDelegate.window.rootViewController.view addSubview:self];
    self.frame = _appDelegate.window.bounds;
    self.transparencyBtn.frame = self.bounds;
    [self addSubview:self.transparencyBtn];
    [self addSubview:self.tableView];
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT-227, SCREEN_WIDTH, 227);
    } completion:^(BOOL finished) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 ) {
        return 160;
    }
    else{
        return 67;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 ) {
        NSString *cellIdentifier = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if ( !cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        GridMenuView *share_View1 = [[GridMenuView alloc] initWithFrame:CGRectMake(62, 32, SCREEN_WIDTH - 124, 60)
                                                              imgUpArray:[self.shareIconArray objectAtIndex:0]
                                                            imgDownArray:[self.shareIconArray objectAtIndex:0]
                                                               perRowNum:3];
        share_View1.tag = 100;
        share_View1.delegate = self;
        share_View1.backgroundColor = [UIColor clearColor];
        [cell addSubview:share_View1];
        
        GridMenuView *share_View2 = [[GridMenuView alloc] initWithFrame:CGRectMake(62, CGRectGetMaxY(share_View1.frame) + 8, SCREEN_WIDTH - 124, 60)
                                                              imgUpArray:[self.shareIconArray objectAtIndex:1]
                                                            imgDownArray:[self.shareIconArray objectAtIndex:1]
                                                               perRowNum:2];
        share_View2.tag = 200;
        share_View2.delegate = self;
        share_View2.backgroundColor = [UIColor clearColor];
        [cell addSubview:share_View2];

        
        return cell;
    }
    else{
        
        NSString *cell_cancel = @"cell_cancel";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_cancel];
        if ( !cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_cancel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.cancelButton = [Utils getCustomLongButton:@"取消"];
            self.cancelButton.frame = CGRectMake(40, 16, SCREEN_WIDTH - 80, 35);
            self.cancelButton.backgroundColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0];
            [self.cancelButton addTarget:self action:@selector(dismissShareView) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:self.cancelButton];
        }
        return cell;
    }
 }

#pragma mark - GridMenuViewDelegate
-(void)GridMenuViewButtonSelected:(NSInteger)btntag selfTag:(NSInteger)selftag
{
    NSUInteger index;
    if ( selftag == 100 ) {
        index = btntag;
    }
    else {
        if ( btntag == 0 ) {
            index = 3;
        }
        else{
            index = 4;
        }
    }
    
    __weak AppDelegate *_appDelegate;
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [_appDelegate shareWithIndex:index];
}



@end
