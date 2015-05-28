//
//  RYLiteratureCategoryView.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYLiteratureCategoryView.h"
#import "GridMenuView.h"

@interface RYLiteratureCategoryView ()<GridMenuViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UIButton     *transparencyBtn;

@property (nonatomic , strong) UITableView  *tableView;

@end

@implementation RYLiteratureCategoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIButton *)transparencyBtn
{
    if ( _transparencyBtn == nil ) {
        _transparencyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.offSetY, SCREEN_WIDTH, VIEW_HEIGHT - self.offSetY)];
        _transparencyBtn.backgroundColor = [Utils getRGBColor:0 g:0 b:0 a:0.5];
        [_transparencyBtn addTarget:self action:@selector(dismissCategoryView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transparencyBtn;
}

- (UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}


- (void)setCategoryData:(NSArray *)categoryData
{
    if ( _categoryData != categoryData ) {
        _categoryData = categoryData;
        
        [self.tableView reloadData];
    }
}

- (void)dismissCategoryView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ( [self.delegate respondsToSelector:@selector(dismissCompletion)] ) {
            [self.delegate dismissCompletion];
        }
    }];
}

- (void)showCategoryView
{
    if ( self.superview == nil ) {
        return;
    }
    self.frame = CGRectMake(0, self.offSetY, SCREEN_WIDTH, VIEW_HEIGHT - self.offSetY);
    self.transparencyBtn.frame = self.bounds;
    [self addSubview:self.transparencyBtn];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    [self addSubview:self.tableView];
    float itemsnum = self.categoryData.count;
    NSInteger colm = 5;
    NSUInteger row = ceil(itemsnum / colm);

    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, row * 20);
    } completion:^(BOOL finished) {
        [self.superview addSubview:self];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.categoryData.count ) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.categoryData.count ) {
        float itemsnum = self.categoryData.count;
        NSInteger colm = 5;
        NSUInteger row = ceil(itemsnum / colm);

        return row * 20;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    GridMenuView *gridMenu = (GridMenuView *)[cell.contentView viewWithTag:300];
    [gridMenu removeFromSuperview];
    gridMenu = [[GridMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)
                                                       imgUpName:@"ic_grid_default.png"
                                                     imgDownName:@"ic_grid_highlighted.png"
                                                      titleArray:self.categoryData
                                                  titleDownColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0]
                                                    titleUpColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0]
                                                       perRowNum:5
                                             andCanshowHighlight:YES];
    gridMenu.tag = 300;
    gridMenu.delegate = self;
    [cell.contentView addSubview:gridMenu];

    return cell;
}

#pragma mark - GridMenuViewDelegate
-(void)GridMenuViewButtonSelected:(NSInteger)btntag selfTag:(NSInteger)selftag
{
    [self dismissCategoryView];
    if ( [self.delegate respondsToSelector:@selector(literatureCategorySelected:selfTag:)] ) {
        [self.delegate literatureCategorySelected:btntag selfTag:self.tag];
    }
}


@end
