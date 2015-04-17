//
//  albumListsViewController.m
//  assetImagepicker
//
//  Created by 刚正面的斯温 on 15-2-12.
//  Copyright (c) 2015年 hyq. All rights reserved.
//

#import "albumListsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "albumlistTableViewCell.h"
#import "imagesLoader.h"
#import "ImagesCollectionViewController.h"
@interface albumListsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
}
@property  (nonatomic,strong,setter=setAlbumlists:) NSArray*            albumLists;
@property  (nonatomic,strong)                       UITableView*        tableView;
@property  (nonatomic,strong,getter=imageloader)    imagesLoader*       imgloader;
@end

@implementation albumListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView                              = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate                     = self;
    _tableView.dataSource                   = self;
    [self.view addSubview:_tableView];
    
    UIButton* btn                           = [[UIButton alloc] initWithFrame:CGRectMake(200, 50, 50, 15)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(retturn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    // Do any additional setup after loading the view.
}

-(void)retturn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.imgloader loadImageWithblock:^(NSArray *array) {
        self.albumLists = array;
    }];
}

-(void)setAlbumlists:(NSArray *)albumLists{
    _albumLists = [NSArray arrayWithArray:albumLists];
    [self.tableView reloadData];
}
-(imagesLoader*)imageloader{
    if (!_imgloader) {
        _imgloader = [imagesLoader new];
    }
    return _imgloader;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _albumLists.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [albumlistTableViewCell albumlistTableViewCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellid = @"cell";
    albumlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[albumlistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    ALAssetsGroup* group = [_albumLists objectAtIndex:indexPath.row];
    [cell.name setText:[NSString stringWithFormat:@"%@",[group valueForProperty:ALAssetsGroupPropertyName]]];
    [cell.imgNum setText:[NSString stringWithFormat:@"%d张图片",group.numberOfAssets]];
    __weak albumListsViewController *wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGImageRef cg = [group posterImage];
        UIImage *img = [UIImage imageWithCGImage:cg];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[wself.tableView indexPathsForVisibleRows] containsObject:indexPath]) {
                id celldi = [wself.tableView cellForRowAtIndexPath:indexPath];
                [[(albumlistTableViewCell*)celldi postImgView] setImage:img];
            }
        });
    });
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ALAssetsGroup* group = [_albumLists objectAtIndex:indexPath.row];
    [self.imageloader loadImageWithblock:^(NSArray *array) {
        ImagesCollectionViewController* cvc = [[ImagesCollectionViewController alloc] init];
        cvc.titleArray = _albumLists;
        cvc.imgArray = array;
        [self.navigationController pushViewController:cvc animated:YES];
    } andpropertyName:[group valueForProperty:ALAssetsGroupPropertyName]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
