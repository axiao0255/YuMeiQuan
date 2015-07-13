//
//  RYLiteratureCategoryViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/13.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYLiteratureCategoryViewController.h"
#import "GridMenuView.h"

@interface RYLiteratureCategoryViewController ()<GridMenuViewDelegate>

@end

@implementation RYLiteratureCategoryViewController

-(id)initWithCategoryArray:(NSArray *)categoryArray
{
    self = [super init];
    if ( self ) {
        self.categoryArray = categoryArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类";
    
    NSMutableArray *titleArray = [NSMutableArray array];
    for ( NSInteger i = 0 ; i < self.categoryArray.count; i ++ ) {
        NSDictionary *dict = [self.categoryArray objectAtIndex:i];
        NSString *title = [dict getStringValueForKey:@"tagname" defaultValue:@""];
        [titleArray addObject:title];
    }
    int row = ceil((CGFloat)titleArray.count / 4);
    
    GridMenuView *gridMenu = [[GridMenuView alloc] initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH - 10,  (row-1)*10 + row*50)
                                                       imgUpName:@"ic_literatureCategory.png"
                                                     imgDownName:@"ic_literatureCategory.png"
                                                      titleArray:titleArray
                                                  titleDownColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0]
                                                    titleUpColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0]
                                                       perRowNum:4
                                                  andCanLinefeed:YES];
    gridMenu.delegate = self;
    
    [self.view addSubview:gridMenu];
    
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
- (void)GridMenuViewButtonSelected:(NSInteger)btntag selfTag:(NSInteger)selftag
{
//    NSLog(@"%ld,%ld",btntag,selftag);
    if ( [self.delegate respondsToSelector:@selector(selectLiteratureCategoryWithIndex:)] ) {
        [self.delegate selectLiteratureCategoryWithIndex:btntag];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
