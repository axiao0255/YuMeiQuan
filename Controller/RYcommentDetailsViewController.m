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
#import "RYShareSheet.h"
//#import "ChatCacheFileUtil.h"
//#import "VoiceConverter.h"

@interface RYcommentDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate,FSVoiceBubbleDelegate,AVAudioRecorderDelegate,RYcommentTableViewCellDelegate,RYShareSheetDelegate,UIAlertViewDelegate>
{
    UIView            *containerView;
    HPGrowingTextView *textView;
    UIButton          *talkBtn;
    
    BOOL            recording;
    NSURL           *pathURL;
    NSTimer         *peakTimer;
    AVAudioRecorder *audioRecorder;
    NSTimeInterval  _timeLen;
    NSString*       _lastRecordFile;
    CAShapeLayer    *shapeLayer;
    
    AVAudioPlayer   *audioPlayer;
    UIButton        *recordBtn;       // 录音按钮
    
    NSString        *textContent;     // 输入框的内容
    NSInteger       replyIndex;       // 当前回复评论第几条回复。      当对文字进行评论时 为 －1
    NSString        *textViewPlaceholder;    //
    
}

@property (nonatomic , strong) RYArticleData       *articleData;
@property (nonatomic , strong) MJRefreshTableView  *tableView;
@property (nonatomic , strong) NSMutableArray      *listData;
@property (nonatomic , strong) NSDictionary        *topDict;
@property (nonatomic , strong) NSString            *tid;
@property (nonatomic , strong) NSMutableArray      *commentList;
@property (nonatomic , strong) RYShareSheet       *shareSheet; // 分享

@property (assign , nonatomic) NSInteger           currentRow;
@property (nonatomic , assign) BOOL                isCanComment;    // 是否有权限评论

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

-(id)initWithArticleTid:(NSString *) tid
{
    self = [super init];
    if ( self ) {
       self.listData = [NSMutableArray array];
        self.tid = tid;
        self.tid = @"1016634";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    self.currentRow = -1;
    replyIndex = -1;
    
    [self.view addSubview:self.tableView];
    [self.tableView headerBeginRefreshing];
    
    [self createTalkView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)commentList
{
    if ( _commentList == nil ) {
        _commentList = [NSMutableArray array];
    }
    return _commentList;
}

- (RYShareSheet *)shareSheet
{
    if ( _shareSheet == nil ) {
        _shareSheet = [[RYShareSheet alloc] init];
    }
    return _shareSheet;
}

- (RYArticleData *)articleData
{
    if ( _articleData == nil ) {
        _articleData = [[RYArticleData alloc] init];
    }
    return _articleData;
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
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getCommentListWithSessionId:[RYUserInfo sharedManager].session
                                               tid:self.tid
                                              page:currentPage
                                           success:^(id responseDic) {
                                               NSLog(@"评论列表 responseDic :%@",responseDic);
                                               [wSelf.tableView endRefreshing];
                                               [wSelf analysisDataWithDict:responseDic isHeadRefresh:isHeaderReresh];
            
        } failure:^(id errorString) {
             NSLog(@"评论列表 errorString :%@",errorString);
            [wSelf.tableView endRefreshing];
            if ( wSelf.commentList.count == 0 ) {
                [ShowBox showError:@"数据出错"];
            }
        }];
    }
}

- (void)analysisDataWithDict:(NSDictionary *)responseDic isHeadRefresh:(BOOL) isHead
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"数据出错，请稍候重试！"]];
        return;
    }
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    if ( info == nil ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"数据出错，请稍候重试！"]];
        return;
    }
    // 取会员信息
    NSDictionary *usermassage = [info getDicValueForKey:@"usermassage" defaultValue:nil];
    if ( usermassage ) {
        [[RYUserInfo sharedManager] refreshUserInfoDataWithDict:usermassage];
    }
    
    // 取文章信息
    NSDictionary *threadmessage = [info getDicValueForKey:@"threadmessage" defaultValue:nil];
    self.isCanComment = [threadmessage getBoolValueForKey:@"cancommentmessage" defaultValue:NO];
    if ( threadmessage ) {
        NSDictionary *articleDict = [threadmessage getDicValueForKey:@"threadmessage" defaultValue:nil];
        if ( articleDict ) {
            [self setArticleWithDict:articleDict];
        }
    }
    
    self.tableView.totlePage = [info getIntValueForKey:@"total" defaultValue:1];
    
    NSArray *commentlistmessage = [info getArrayValueForKey:@"commentlistmessage" defaultValue:nil];
    if (commentlistmessage.count) {
        if ( isHead ) {
            [self.commentList removeAllObjects];
        }
        [self.commentList addObjectsFromArray:commentlistmessage];
    }
    
    // 判断是否有权评论，
//    if ( self.isCanComment ) {
//        self.tableView.height = VIEW_HEIGHT - 50;
//        containerView.hidden = NO;
//    }
//    else{
//        self.tableView.height = VIEW_HEIGHT;
//        containerView.hidden = YES;
//    }
    
    [self.tableView reloadData];
}

-(void)setArticleWithDict:(NSDictionary *)dict
{
    if ( !dict ) {
        return;
    }
    
    self.articleData.subject = [dict getStringValueForKey:@"subject" defaultValue:@""];
    
    self.articleData.shareArticleUrl = [dict getStringValueForKey:@"spreadurl" defaultValue:@""];
    self.articleData.shareId = [dict getStringValueForKey:@"spid" defaultValue:@""];
    self.articleData.sharePicUrl = [dict getStringValueForKey:@"pic" defaultValue:@""];
    
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    [tempDict setValue:self.articleData.subject forKey:@"subject"];
    NSString *str = @"张三，李四，王五，赵六，张三，李四，王五，赵六，张三，李四，王五，赵六，张三，李四，王五，赵六等点赞";
    [tempDict setValue:str forKey:@"praise"];
    self.topDict = tempDict;
}



#pragma mark - UITableView 代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSString *subject = self.articleData.subject;
    if ( [ShowBox isEmptyString:subject] ) {
        return 0;
    }
    else{
        return 2;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
//        NSString *subject = [self.topDict getStringValueForKey:@"subject" defaultValue:@""];
        NSString *subject = self.articleData.subject;
        if ( [ShowBox isEmptyString:subject] ) {
            return 0;
        }
        return 1;
    }
    else{
        return self.commentList.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        
        CGFloat height = 0;
        NSString *subject = self.articleData.subject;
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
        if ( self.commentList.count ) {
            NSDictionary *dict = [self.commentList objectAtIndex:indexPath.row];
//            NSMutableDictionary *dict = [[self.commentList objectAtIndex:indexPath.row] mutableCopy];
//            [dict setValue:@"http://music.baidutt.com/up/kwcawswc/yuydsw.mp3" forKey:@"voice"];
            NSString *voice = [dict getStringValueForKey:@"voice" defaultValue:nil];
            CGFloat height = 0;
            if ( ![ShowBox isEmptyString:voice] ) {
                height = 16 + 5 + 40 + 10;
            }
            else{
                height = 16 + 10;
            }
            NSString *word = [dict getStringValueForKey:@"word" defaultValue:nil];
            if ( ![ShowBox isEmptyString:word] ) {
                NSDictionary *praiseAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
                CGRect praiseRect = [word boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:praiseAttributes
                                                         context:nil];
                height = height + 5 + praiseRect.size.height;
            }
            return height + 10 + 24 + 6;
        }
        else{
            return 0;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        NSString *top_cell = @"top_cell";
        RYcommentTopCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:top_cell];
        if ( !cell ) {
            cell = [[RYcommentTopCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:top_cell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [cell setValueWithDict:self.topDict];
        return cell;
    }
    else{
        NSString *voice_cell = @"voice_cell";
        RYcommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:voice_cell];
        if ( !cell ) {
            cell = [[RYcommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voice_cell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if ( self.commentList.count ) {
            NSDictionary *tempDict = [self.commentList objectAtIndex:indexPath.row];
            NSString *voice = [tempDict getStringValueForKey:@"voice" defaultValue:nil];
//            voice = @"http://music.baidutt.com/up/kwcawswc/yuydsw.mp3";
            if ( ![ShowBox isEmptyString:voice] ) {
                cell.bubble.tag = indexPath.row;
                cell.bubble.contentURL = [NSURL URLWithString:voice];
                cell.bubble.delegate = self;
                
                if ( _currentRow == indexPath.row && cell.bubble.playing ) {
                    [cell.bubble startAnimating];
                }
                else{
                    [cell.bubble stopAnimating];
                }
            }
            
            [cell setValueWithDict:tempDict];
        }
        cell.delegate = self;
        cell.tag = indexPath.row;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        containerView.top = self.view.frame.size.height;
    }];
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
    if ( section == 0 && self.commentList.count ) {
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

#pragma mark RYcommentTableViewCellDelegate

-(void)currentSelectCellTag:(NSInteger)cellTag andSelectBtnTage:(NSInteger)btnTage
{
    NSLog(@"cellTag : %ld , btnTage: %ld",(long)cellTag,(long)btnTage);
    if ( !self.isCanComment && btnTage == 1 ) {
        [ShowBox showError:@"您没有回复权限，如需开通此功能，请与客服联系！"];
        return;
    }
    
    if ( cellTag >= self.commentList.count ) {
        return;
    }
    
    NSDictionary *dict = [self.commentList objectAtIndex:cellTag];
    switch ( btnTage ) {
        case 0:  // 分享
        {
            [textView resignFirstResponder];
            [UIView animateWithDuration:0.25 animations:^{
                containerView.top = self.view.frame.size.height;
            } completion:^(BOOL finished) {
                [self shareWithDict:dict];
            }];
            
        }
            break;
        case 1: // 回复
        {
            replyIndex = cellTag;
            textViewPlaceholder = [NSString stringWithFormat:@"回复%@",[dict getStringValueForKey:@"author" defaultValue:@""]];
            textView.placeholder = textViewPlaceholder;
            containerView.top = self.view.frame.size.height - 50;
            [textView becomeFirstResponder];
        }
            break;
        case 2: // 删除
        {
            
            [textView resignFirstResponder];
            [UIView animateWithDuration:0.25 animations:^{
                containerView.top = self.view.frame.size.height;
            } completion:^(BOOL finished) {
            }];
 
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = cellTag;
            [alertView show];
            
        }
            break;
        default:
            break;
    }
}

/**
 * 分享评论
 */
-(void)shareWithDict:(NSDictionary *)dict
{
    
    NSString *word = [dict getStringValueForKey:@"word" defaultValue:nil];
    NSString *beauthorid = [dict getStringValueForKey:@"beauthorid" defaultValue:nil];
    NSString *beauthor = [dict getStringValueForKey:@"beauthor" defaultValue:@""];
    NSString *author = [dict getStringValueForKey:@"author" defaultValue:@""];
    NSString *voice = [dict getStringValueForKey:@"voice" defaultValue:@""];
    NSString *subject = self.articleData.subject;
    NSString *shareContent;
    if ( ![ShowBox isEmptyString:word] ) {
        if ( word.length > 100 ) {
            word = [word substringToIndex:100];
        }
        if ( [ShowBox isEmptyString:beauthorid] ) {
            //文字评论
            shareContent = [NSString stringWithFormat:@"%@ 评论给",word];
        }
        else{
            //文字回复
            shareContent = [NSString stringWithFormat:@"%@ %@回复%@",word,author,beauthor];
        }
    }
    else{
        if ( [ShowBox isEmptyString:beauthorid] && ![ShowBox isEmptyString:voice] ) {
            // 语音 评论
            shareContent = [NSString stringWithFormat:@"%@语音评论了《%@》",author,subject];
        }
        else{
            // 语音回复
            shareContent = [NSString stringWithFormat:@"%@语音回复%@",author,beauthor];
        }
    }
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    [tempDict setValue:self.articleData.shareArticleUrl forKey:SHARE_URL];
    [tempDict setValue:shareContent forKey:SHARE_TEXT];
    [tempDict setValue:self.articleData.shareId forKey:SHARE_CALLBACK_DI];
    [tempDict setValue:self.articleData.sharePicUrl forKey:SHARE_PIC];
    [tempDict setValue:self.tid forKey:SHARE_TID];
    
    self.shareSheet.shareDataDict = tempDict;
    self.shareSheet.delegate = self;
    
    [self.shareSheet showShareView];
}

/**
 *删除评论
 */
-(void)deleteCommentWithDict:(NSDictionary *)dict
{
    if ( [ShowBox checkCurrentNetwork] ) {
        NSString *pid = [dict getStringValueForKey:@"pid" defaultValue:@""];
        __weak typeof(self) wSelf = self;
        [NetRequestAPI deleteCommentWithSessionId:[RYUserInfo sharedManager].session
                                              tid:self.tid
                                              pid:pid
                                          success:^(id responseDic) {
                                              NSLog(@"删除评论responseDic : %@",responseDic);
                                              NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                              BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                              if ( !success ) {
                                                  [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"网络出错，请稍候重试！"]];
                                              }
                                              
                                              [wSelf.tableView headerBeginRefreshing];
        } failure:^(id errorString) {
             NSLog(@"删除评论errorString : %@",errorString);
            [ShowBox showError:@"网络出错，请稍候重试!"];
        }];
    }
}

#pragma  mark UIAlertView 代理

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        NSDictionary *dict = [self.commentList objectAtIndex:alertView.tag];
        [self deleteCommentWithDict:dict];
    }
}

#pragma  mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        containerView.top = self.view.frame.size.height;
    }];
}

#pragma mark FSVoiceBubbleDelegate
- (void)voiceBubbleDidStartPlaying:(FSVoiceBubble *)voiceBubble
{
    _currentRow = voiceBubble.tag;
    [textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        containerView.top = self.view.frame.size.height;
    }];
}

#pragma mark 聊天窗
-(void)createTalkView
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, 50)];
    containerView.backgroundColor = [UIColor redColor];//[Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
    
    talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    talkBtn.frame = CGRectMake(15, 8, 36, 36);
    talkBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [talkBtn setImage:[UIImage imageNamed:@"ic_shuru.png"] forState:UIControlStateNormal];
    [talkBtn setImage:[UIImage imageNamed:@"ic_voice.png"] forState:UIControlStateSelected];
    [talkBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    talkBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    [talkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [talkBtn addTarget:self action:@selector(talkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:talkBtn];

    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(65, 8, SCREEN_WIDTH - 80, 40)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    textView.returnKeyType = UIReturnKeySend; //just as an example
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"我也说一句!";
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    textView.delegate = self;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0].CGColor;
//    textView.animateHeightChange = YES; //turns off animation
    
    [self.view addSubview:containerView];
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:textView];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    recordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recordBtn.frame = textView.frame;
    recordBtn.backgroundColor = [UIColor lightGrayColor];
    [recordBtn setTitle:@"按住  说话" forState:UIControlStateNormal];
    [recordBtn setTitle:@"松开  结束" forState:UIControlEventTouchDown];
    [recordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [recordBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [recordBtn setTitleShadowOffset:CGSizeMake(1, 1)];
    [recordBtn addTarget:self action:@selector(recordStart:) forControlEvents:UIControlEventTouchDown];
    [recordBtn addTarget:self action:@selector(recordStop:) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn addTarget:self action:@selector(recordCancel:) forControlEvents:UIControlEventTouchUpOutside];
    recordBtn.selected = NO;
    [containerView addSubview:recordBtn];
}

-(void)talkBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if ( btn.selected ) {
        recordBtn.hidden = NO;
        [textView resignFirstResponder];
        textContent = textView.text;
        textView.text = nil;
    }
    else{
        recordBtn.hidden = YES;
        [textView becomeFirstResponder];
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
    recordBtn.hidden = YES;
    talkBtn.selected = YES;
    if (textContent.length) {
        textView.text = textContent;
    }
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    
    talkBtn.selected = NO;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    NSLog(@"return");
    if ( growingTextView.text.length == 0 ) {
        return YES;
    }
    if ( replyIndex != -1 ) {
        NSDictionary *dict = [self.commentList objectAtIndex:replyIndex];
        NSString *pid = [dict getStringValueForKey:@"pid" defaultValue:nil];
        [self submitCommentWithPid:pid word:growingTextView.text voice:nil];
    }
    else{
        [self submitCommentWithPid:nil word:growingTextView.text voice:nil];
    }
    return YES;
}

#pragma mark 提交评论
-(void)submitCommentWithPid:(NSString *)_pid word:(NSString *)_word voice:(NSURL *)voiceURL
{
    if ([ShowBox checkCurrentNetwork] ) {
        [NetRequestAPI submitCommentWithSessionId:[RYUserInfo sharedManager].session
                                              tid:self.tid
                                              pid:_pid
                                             word:_word
                                            voice:pathURL
                                          success:^(id responseDic) {
                                              NSLog(@"上传录音 responseDic： %@",responseDic);
                                              
                                          } failure:^(id errorString) {
                                              NSLog(@"上传录音 errorString： %@",errorString);
                                          }];
 
    }
}


#pragma mark 录音功能

-(void)recordStart:(UIButton *)sender
{
    if(recording)
        return;
    if (_currentRow>=0) {
        RYcommentTableViewCell *cell = (RYcommentTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentRow inSection:1]];
        [cell.bubble pause];
    }
 
    recording=YES;
    
    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                            [NSNumber numberWithFloat:44100.0],AVSampleRateKey,
                            [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                            [NSNumber numberWithInt:12800],AVEncoderBitRateKey,
                            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                            [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                            nil];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    docsDir = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[RYUserInfo sharedManager].uid]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *soundFilePath = [docsDir stringByAppendingFormat:@"%@.caf",str];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    pathURL = url;
    NSError *error;
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:pathURL settings:settings error:&error];
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
    [audioRecorder record];
    peakTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updatePeak:) userInfo:nil repeats:YES];
    [peakTimer fire];
}

- (void)updatePeak:(NSTimer*)timer
{
    _timeLen = audioRecorder.currentTime;
    if(_timeLen>=60)
        [self recordStop:nil];
    
    /*    [audioRecorder updateMeters];
     const double alpha=0.5;
     double peakPowerForChannel=pow(10, (0.05)*[audioRecorder peakPowerForChannel:0]);
     lowPassResults=alpha*peakPowerForChannel+(1.0-alpha)*lowPassResults;
     
     for (int i=1; i<8; i++) {
     if (lowPassResults>1.0/7.0*i){
     [[talkView viewWithTag:i] setHidden:NO];
     }else{
     [[talkView viewWithTag:i] setHidden:YES];
     }
     }*/
}

-(void)recordStop:(UIButton *)sender
{
    if(!recording)
        return;
    [peakTimer invalidate];
    peakTimer = nil;
    
    //    [self offRecordBtns];
    
    _timeLen = audioRecorder.currentTime;
    [audioRecorder stop];
//    NSString *amrPath = [VoiceConverter wavToAmr:pathURL.path];
//    NSData *recordData = [NSData dataWithContentsOfFile:amrPath];
//    
//    [[ChatCacheFileUtil sharedInstance] deleteWithContentPath:pathURL.path];
//    [[ChatCacheFileUtil sharedInstance] deleteWithContentPath:amrPath];
//    _lastRecordFile = [[amrPath lastPathComponent] copy];
//    
//    NSLog(@"音频文件路径:%@\n%@",pathURL.path,amrPath);
//    //    if (_timeLen<1) {
//    //        [g_App showAlert:@"录的时间过短"];
//    //        return;
//    //    }
//    [self sendVoice:recordData];
//    audioRecorder = nil;
//    recording = NO;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];

    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    
    recording = NO;
    NSLog(@"playing");
    
    [NetRequestAPI submitCommentWithSessionId:[RYUserInfo sharedManager].session
                                          tid:self.tid
                                          pid:nil
                                         word:@"评论文章啦啊啦啦啦"
                                        voice:pathURL
                                      success:^(id responseDic) {
                                          NSLog(@"上传录音 responseDic： %@",responseDic);
        
    } failure:^(id errorString) {
         NSLog(@"上传录音 errorString： %@",errorString);
    }];
    
    

}

-(void)recordCancel:(UIButton *)sender
{
    if(!recording)
        return;
    [audioRecorder stop];
    audioRecorder = nil;
    [peakTimer invalidate];
    peakTimer = nil;
    recording = NO;
}
-(void)sendVoice:(NSData *)data
{
    // 发送声音
}


@end
