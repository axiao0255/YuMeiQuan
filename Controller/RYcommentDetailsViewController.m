//
//  RYcommentDetailsViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/1.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYcommentDetailsViewController.h"
#import "MJRefreshTableView.h"
#import "RYcommentTableViewCell.h"

@interface RYcommentDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate,FSVoiceBubbleDelegate>
{
    UIView *containerView;
    HPGrowingTextView *textView;
    UIButton *talkBtn;
}

@property (nonatomic , strong) RYArticleData       *articleData;
@property (nonatomic , strong) MJRefreshTableView  *tableView;
@property (nonatomic , strong) NSMutableArray      *listData;
@property (nonatomic , strong) NSDictionary        *topDict;

@property (assign, nonatomic) NSInteger currentRow;

@end

@implementation RYcommentDetailsViewController

-(id)initWithArticleData:(RYArticleData *)articleData
{
    self = [super init];
    if ( self ) {
        self.articleData = articleData;
        self.listData = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    self.currentRow = -1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.articleData.subject forKey:@"subject"];
    NSString *str = @"张三，李四，王五，赵六，张三，李四，王五，赵六，张三，李四，王五，赵六，张三，李四，王五，赵六等点赞";
    [dict setValue:str forKey:@"praise"];
    self.topDict = dict;
    
    [self.view addSubview:self.tableView];
//    [self.tableView headerBeginRefreshing];
//    [[JSCustomChatKeyboard customKeyboard]textViewShowView:self customKeyboardDelegate:self];
    
    [self createTalkView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MJRefreshTableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[MJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delegateRefersh = self;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

-(void)getDataWithIsHeaderReresh:(BOOL)isHeaderReresh andCurrentPage:(NSInteger)currentPage
{
    
}

#pragma mark - UITableView 代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.listData.count;
    if ( section == 0 ) {
        NSString *subject = [self.topDict getStringValueForKey:@"subject" defaultValue:@""];
        if ( [ShowBox isEmptyString:subject] ) {
            return 0;
        }
        return 1;
    }
    else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        
        CGFloat height = 0;
        NSString *subject = [self.topDict getStringValueForKey:@"subject" defaultValue:@""];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20]};
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [subject boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        height = 16+rect.size.height;
        
        NSString *praise = [self.topDict getStringValueForKey:@"praise" defaultValue:@""];
        if ( ![ShowBox isEmptyString:praise] ) {
            
            NSDictionary *praiseAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
            CGRect praiseRect = [praise boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:praiseAttributes
                                                     context:nil];
            height = height + praiseRect.size.height + 10;
        }
        height = height + 20 + 24 + 10;
        
        return height;
    }
    else{
        return 200;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        NSString *top_cell = @"top_cell";
        RYcommentTopCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:top_cell];
        if ( !cell ) {
            cell = [[RYcommentTopCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:top_cell];
        }
        [cell setValueWithDict:self.topDict];
        return cell;
    }
    else{
        NSString *voice_cell = @"voice_cell";
        RYcommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:voice_cell];
        if ( !cell ) {
            cell = [[RYcommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voice_cell];
        }
        cell.bubble.tag = indexPath.row;
        cell.bubble.contentURL = [NSURL URLWithString:@"http://music.baidutt.com/up/kwcawswc/yuydsw.mp3"];
        cell.bubble.delegate = self;
        
        if ( _currentRow == indexPath.row && cell.bubble.playing ) {
            [cell.bubble startAnimating];
        }
        else{
            [cell.bubble stopAnimating];
        }

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 30;
    }
    else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( section == 0 ) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        [view addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, SCREEN_WIDTH - 30, 16)];
        label.textColor = [Utils getRGBColor:0xf6 g:0x31 b:0x56 a:1.0];
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"精彩评论";
        [view addSubview:label];
        
        return view;
    }
    return nil;
}
#pragma FSVoiceBubbleDelegate
- (void)voiceBubbleDidStartPlaying:(FSVoiceBubble *)voiceBubble
{
    _currentRow = voiceBubble.tag;
}

#pragma 聊天窗
-(void)createTalkView
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, SCREEN_WIDTH, 50)];
    containerView.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
    
    talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    talkBtn.frame = CGRectMake(15, 5, 36, 36);
    talkBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [talkBtn setImage:[UIImage imageNamed:@"ic_voice.png"] forState:UIControlStateNormal];
    [talkBtn setImage:[UIImage imageNamed:@"ic_shuru.png"] forState:UIControlStateSelected];
    [talkBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    talkBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    [talkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [talkBtn addTarget:self action:@selector(talkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:talkBtn];

    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(65, 5, SCREEN_WIDTH - 80, 40)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    textView.returnKeyType = UIReturnKeyGo; //just as an example
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"Type to see the textView grow!";
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    textView.delegate = self;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0].CGColor;
    // textView.text = @"test\n\ntest";
    // textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:containerView];
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:textView];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

-(void)talkBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if ( btn.selected ) {
        [textView becomeFirstResponder];
    }
    else{
        [textView resignFirstResponder];
    }
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    talkBtn.selected = NO;
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    talkBtn.selected = YES;
}

@end
