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
#import "RYCommentData.h"
#import "CafToMp3.h"
#import "recordListeningView.h"

@interface RYcommentDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate,FSVoiceBubbleDelegate,AVAudioRecorderDelegate,RYcommentTableViewCellDelegate,RYShareSheetDelegate,UIAlertViewDelegate,recordListeningViewDelegate>
{
    UIView            *containerView;
    HPGrowingTextView *textView;
    UIButton          *talkBtn;
    
    BOOL            recording;
    NSURL           *pathURL;
    NSTimer         *peakTimer;
    AVAudioRecorder *audioRecorder;
    NSTimeInterval  _timeLen;
    
    AVAudioPlayer   *audioPlayer;
    UIButton        *recordBtn;              // 录音按钮
    
    NSString        *textContent;            // 输入框的内容
    NSString        *textViewPlaceholder;    //
    NSString        *praisesName;            // 点赞者的名字
    
}

@property (nonatomic , strong) RYArticleData       *articleData;
@property (nonatomic , strong) MJRefreshTableView  *tableView;
@property (nonatomic , strong) NSMutableArray      *listData;
@property (nonatomic , strong) NSDictionary        *topDict;
@property (nonatomic , strong) NSString            *tid;
@property (nonatomic , strong) NSMutableArray      *commentList;
@property (nonatomic , strong) RYShareSheet       *shareSheet;      // 分享

@property (assign , nonatomic) NSInteger           currentRow;
@property (nonatomic , assign) BOOL                isCanComment;    // 是否有权限评论
@property (nonatomic , strong) RYCommentData      *commentData;     // 需要提交的 评论数据
@property (nonatomic , assign) NSInteger          replyIndex;       // 当前回复评论第几条回复。      当对文字进行评论时 为 －1
@property (nonatomic , assign) BOOL               keyboardShow;     // 用于判断 textView是否是编辑
@property (nonatomic , assign) BOOL               myzanmessage;     // 是否点赞过

@property (nonatomic , strong) recordListeningView *listeningView;  // 录音完成 试听界面

@property (nonatomic , assign) BOOL               notStretch;

@end

@implementation RYcommentDetailsViewController

-(id)initWithArticleTid:(NSString *) tid
{
    self = [super init];
    if ( self ) {
       self.listData = [NSMutableArray array];
        self.tid = tid;
//#warning 测试 tid  需要删除
//        self.tid = @"1016634";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    self.currentRow = -1;
    self.replyIndex = -1;
    self.keyboardShow = NO;
    
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
        _shareSheet.viewController = self;
    }
    return _shareSheet;
}

- (RYCommentData *)commentData
{
    if ( _commentData == nil ) {
        _commentData = [[RYCommentData alloc] init];
    }
    return _commentData;
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

- (recordListeningView *)listeningView
{
    if ( _listeningView == nil ) {
        _listeningView = [[recordListeningView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _listeningView.delegate = self;
    }
    return _listeningView;
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
                                               [wSelf tableViewRefreshEndWithIsHead:isHeaderReresh];
                                               [wSelf analysisDataWithDict:responseDic isHeadRefresh:isHeaderReresh];
            
        } failure:^(id errorString) {
             NSLog(@"评论列表 errorString :%@",errorString);
            [wSelf tableViewRefreshEndWithIsHead:isHeaderReresh];
            if ( wSelf.commentList.count == 0 ) {
                [wSelf showErrorView:self.tableView];
            }
        }];
    }
    else{
        [self tableViewRefreshEndWithIsHead:isHeaderReresh];
        if ( self.commentList.count == 0 ) {
            [self showErrorView:self.tableView];
        }
    }
}

// 列表获取数据之后， 回到原来的位置  ，如果不是上下拉刷新，则不需要调用 endRefreshing方法，会引起显示错误
- (void)tableViewRefreshEndWithIsHead:(BOOL)isHead
{
    if ( !self.notStretch ) {
        if ( isHead ) {
            [self.tableView headerFinishRefreshing];
        }
        else{
            [self.tableView footerFinishRereshing];
        }
    }
    else{
        self.notStretch = NO;
    }
}


- (void)analysisDataWithDict:(NSDictionary *)responseDic isHeadRefresh:(BOOL) isHead
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        int  login = [meta getIntValueForKey:@"login" defaultValue:0];
        if ( login == 2 ) {  // login == 2 表示用户已过期 需要重新登录
            __weak typeof(self) wSelf = self;
            [RYUserInfo automateLoginWithLoginSuccess:^(BOOL isSucceed) {
                // 自动登录一次
                if ( isSucceed ) { // 自动登录成功 刷新数据，
                    wSelf.notStretch = YES;
                    wSelf.tableView.currentPage = 0;
                    [wSelf getDataWithIsHeaderReresh:YES andCurrentPage:0];
                }
                else{// 登录失败 打开登录界面 手动登录
                    [wSelf openLoginVC];
                }
            } failure:^(id errorString) {
                [wSelf openLoginVC];
            }]; 
        }
        else{
            if ( self.commentList.count == 0 ) {
                [self showErrorView:self.tableView];
            }
        }
        return;
    }
    [self removeErroeView];
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    // 取会员信息
    NSDictionary *usermassage = [info getDicValueForKey:@"usermassage" defaultValue:nil];
    if ( usermassage ) {
        [[RYUserInfo sharedManager] refreshUserInfoDataWithDict:usermassage];
    }
    
    // 取文章信息
    NSDictionary *threadmessage = [info getDicValueForKey:@"threadmessage" defaultValue:nil];
    self.isCanComment = [threadmessage getBoolValueForKey:@"cancommentmessage" defaultValue:NO];
    self.myzanmessage = [threadmessage getBoolValueForKey:@"myzanmessage" defaultValue:NO];
    praisesName = [threadmessage getStringValueForKey:@"zanmessage" defaultValue:@""];
    if ( threadmessage ) {
        NSDictionary *articleDict = [threadmessage getDicValueForKey:@"threadmessage" defaultValue:nil];
        if ( articleDict ) {
            [self setArticleWithDict:articleDict];
        }
    }
    
    self.tableView.totlePage = [info getIntValueForKey:@"total" defaultValue:1];
    if ( isHead ) {
        [self.commentList removeAllObjects];
    }
    NSArray *commentlistmessage = [info getArrayValueForKey:@"commentlistmessage" defaultValue:nil];
    if (commentlistmessage.count) {
        [self.commentList addObjectsFromArray:commentlistmessage];
    }
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
    [tempDict setValue:praisesName forKey:@"praise"];
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
        height = height + 20 + 28 + 10;
        
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
        [cell.replyBtn addTarget:self action:@selector(replyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if ( self.myzanmessage ) {
            [cell.praiseBtn setEnabled:NO];
            cell.praiseBtn.backgroundColor = [Utils getRGBColor:0x00 g:0x91 b:0xea a:1.0];
        }
        else{
            [cell.praiseBtn setEnabled:YES];
            cell.praiseBtn.backgroundColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        }
        return cell;
    }
    else{
        static NSString *voice_cell = @"voice_cell";
        RYcommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:voice_cell];
        if ( !cell ) {
            cell = [[RYcommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voice_cell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if ( self.commentList.count ) {
            NSDictionary *tempDict = [self.commentList objectAtIndex:indexPath.row];
            cell.bubble.tag = indexPath.row;
            cell.bubble.delegate = self;
            if ( _currentRow == indexPath.row && cell.bubble.playing ) {
                [cell.bubble startAnimating];
            }
            else{
                [cell.bubble stopAnimating];
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
    [self dismissTextView];
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
//    NSLog(@"cellTag : %ld , btnTage: %ld",(long)cellTag,(long)btnTage);
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
            [self dismissTextView];
            [self shareWithDict:dict];
        }
            break;
        case 1: // 回复
        {
            if ( self.keyboardShow ) {
                [self dismissTextView];
                return;
            }
            self.replyIndex = cellTag;
            textViewPlaceholder = [NSString stringWithFormat:@"回复%@",[dict getStringValueForKey:@"author" defaultValue:@""]];
            textView.placeholder = textViewPlaceholder;
            containerView.top = self.view.frame.size.height - 50;
            [textView becomeFirstResponder];
        }
            break;
        case 2: // 删除
        {
            
            [self dismissTextView];
 
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
    if ( alertView.tag == 1010 ) {
        if ( buttonIndex == 1 ) {
            [self submitComment];
        }
        return;
    }
    
    if ( buttonIndex == 1 ) {
        NSDictionary *dict = [self.commentList objectAtIndex:alertView.tag];
        [self deleteCommentWithDict:dict];
        // 当删除某条评论的时候，需要同时删除本地缓存的录音
        // 取网络 音频文件 后缀名
        NSString *voice = [dict getStringValueForKey:@"voice" defaultValue:nil];
        if ( ![ShowBox isEmptyString:voice] ) {
            NSString *voicePath = [self getLastStrWithVoicePath:voice];
            // 取本地录音 文件
            NSString *documentViocePath = [Utils getDocumnetsVoicePath];
            NSFileManager *manage=[NSFileManager defaultManager];
            NSArray  *voiceArray = [manage subpathsAtPath:documentViocePath];
            // 判断 网络音频在本地是否存在
            if ( [voiceArray indexOfObject:voicePath] != NSNotFound ) {
                NSString *voiceStr = [NSString stringWithFormat:@"%@",[documentViocePath stringByAppendingPathComponent:voicePath]];
                BOOL blDele= [manage removeItemAtPath:voiceStr error:nil];
                if (blDele) {
                    NSLog(@"dele success");
                }else {
                    NSLog(@"dele fail");
                }
            }
        }
    }
}

- (NSString *)getLastStrWithVoicePath:(NSString *)str
{
    if ( str == nil ) {
        return nil;
    }
    NSArray *arr = [str componentsSeparatedByString:NSLocalizedString(@"/", nil)];
    return [arr lastObject];
}


#pragma  mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissTextView];
}

#pragma mark FSVoiceBubbleDelegate
- (void)voiceBubbleDidStartPlaying:(FSVoiceBubble *)voiceBubble
{
    _currentRow = voiceBubble.tag;
    [self dismissTextView];
}

#pragma mark 聊天窗
-(void)createTalkView
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, 50)];
    containerView.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
    [containerView addSubview:line];
    
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
    recordBtn.backgroundColor = [UIColor whiteColor];
    recordBtn.frame = textView.frame;
    [recordBtn setBackgroundImage:[UIImage imageNamed:@"ic_recordBtn_normal.png"] forState:UIControlStateNormal];
    recordBtn.layer.cornerRadius = 5;
    recordBtn.layer.masksToBounds = YES;
    recordBtn.layer.borderWidth = 0.5;
    recordBtn.layer.borderColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0].CGColor;
    [recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [recordBtn setTitleColor:[Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0] forState:UIControlStateNormal];
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(recordButtonLongPressed:)];
    // you can control how many seconds before the gesture is recognized
    gesture.minimumPressDuration =0;
    [recordBtn addGestureRecognizer:gesture];
    
    [containerView addSubview:recordBtn];
}

- (void)recordButtonLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Touch down");
        
        [recordBtn setBackgroundImage:[UIImage imageNamed:@"ic_recordBtn_Highlight.png"] forState:UIControlStateNormal];
        [recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
        [self recordStart:nil];
        
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        NSLog(@"Long press Ended");
        [recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [recordBtn setBackgroundImage:[UIImage imageNamed:@"ic_recordBtn_normal.png"] forState:UIControlStateNormal];
        [self recordStop:nil];
        [self recordCancel:nil];
    }
}


/**
 * 语音和文字输入 切换
 */
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

#pragma  mark HPGrowingTextView 代理
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
    self.keyboardShow = YES;
    if (textContent.length) {
        textView.text = textContent;
    }
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    self.keyboardShow = NO;
    talkBtn.selected = NO;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    if ( growingTextView.text.length == 0 ) {
        [self dismissTextView];
        return YES;
    }
    if ( self.replyIndex != -1 ) {
        NSDictionary *dict = [self.commentList objectAtIndex:self.replyIndex];
        NSString *pid = [dict getStringValueForKey:@"pid" defaultValue:nil];
        self.commentData.tid = self.tid;
        self.commentData.voiceURL = nil;
        self.commentData.pid = pid;
        self.commentData.authorId = [dict getStringValueForKey:@"authorid" defaultValue:nil];
        self.commentData.word = growingTextView.text;
        [self submitComment];
    }
    else{
        self.commentData.tid = self.tid;
        self.commentData.voiceURL = nil;
        self.commentData.pid = nil;
        self.commentData.authorId = nil;
        self.commentData.word = growingTextView.text;
        [self submitComment];
    }
    return YES;
}

#pragma mark 提交评论
-(void)submitComment
{
    if ([ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [SVProgressHUD showWithStatus:@"正在发送..." maskType:SVProgressHUDMaskTypeBlack];
        [NetRequestAPI submitCommentWithSessionId:[RYUserInfo sharedManager].session
                                              tid:self.commentData.tid
                                              pid:self.commentData.pid
                                         authorId:self.commentData.authorId
                                             word:self.commentData.word
                                            voice:self.commentData.voiceURL
                                          success:^(id responseDic) {
                                              [SVProgressHUD dismiss];
                                              NSLog(@"上传录音 responseDic： %@",responseDic);
                                              NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                              BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                              if ( !success ) {
                                                  [wSelf submitCommentFailureShowAlert];
                                                  return ;
                                              }
                                              wSelf.replyIndex = -1;
                                              [wSelf submitCommentsuccess];
                                              [wSelf.tableView headerBeginRefreshing];
                                              
                                          } failure:^(id errorString) {
                                              NSLog(@"上传录音 errorString： %@",errorString);
                                              [SVProgressHUD dismiss];
                                              [wSelf submitCommentFailureShowAlert];
                                          }];
    }
}
/**
 *上传评论 失败  弹出提示框
 */
- (void)submitCommentFailureShowAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败，是否重新发送！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1010;
    [alertView show];
}

/**
 *上传评论成功
 */
- (void)submitCommentsuccess
{    pathURL = nil;
    [self dismissTextView];
}


/**
 * 隐藏键盘
 */
-(void) dismissTextView
{
    [textView resignFirstResponder];
    textView.text = nil;
    textContent = nil;
    [UIView animateWithDuration:0.25 animations:^{
        containerView.top = self.view.frame.size.height;
    }];
}


#pragma mark 文字点赞

-(void)praiseBtnClick:(id)sender
{
    NSLog(@"点赞");
    if ( !self.isCanComment ) {
        [ShowBox showError:@"您没有点赞权限，如需开通此功能，请与客服联系！"];
        return;
    }
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI praisesCommentWithSessionId:[RYUserInfo sharedManager].session
                                               tid:self.tid
                                           success:^(id responseDic) {
                                               NSLog(@"点赞 responseDic: %@",responseDic);
                                               NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                               BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                               if ( !success ) {
                                                   [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"操作失败，请稍候重试！"]];
                                                   return ;
                                               }
                                               [wSelf.tableView headerBeginRefreshing];
            
        } failure:^(id errorString) {
            [ShowBox showError:@"操作失败，请稍候重试！"];
             NSLog(@"点赞 errorString: %@",errorString);
        }];
    }
}

#pragma mark 评论文章
-(void)replyBtnClick:(id)sender
{
    NSLog(@"评论文章");
    if ( !self.isCanComment ) {
        [ShowBox showError:@"您没有回复权限，如需开通此功能，请与客服联系！"];
        return;
    }
    if ( self.keyboardShow ) {
        [self dismissTextView];
        return;
    }
    self.replyIndex = -1;
    textViewPlaceholder = @"我也说一句";
    textView.placeholder = textViewPlaceholder;
    textView.text = nil;
    containerView.top = self.view.frame.size.height - 50;
    [textView becomeFirstResponder];
}


#pragma mark 录音功能

-(void)recordStart:(UIButton *)sender
{
    // 检查麦克风是否打开
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            // 用户同意获取数据
            if(recording)
                return;
            if (_currentRow>=0) {
                RYcommentTableViewCell *cell = (RYcommentTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentRow inSection:1]];
                [cell.bubble stop];
                [cell.bubble stopAnimating];
            }
            
            recording=YES;
            
//            NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
//                                    [NSNumber numberWithFloat:44100.0],AVSampleRateKey,
//                                    [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
//                                    [NSNumber numberWithInt:12800],AVEncoderBitRateKey,
//                                    [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
//                                    [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
//                                    nil];
            NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
            //录音格式 无法使用
            [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
            //采样率
            [settings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
            //通道数
            [settings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
            //音频质量,采样质量
            [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];

            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryRecord error: nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            
            NSString *docsDir = [Utils getDocumnetsVoicePath];
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

        } else {
            // 可以显示一个提示框告诉用户这个app没有得到允许？
            [[[UIAlertView alloc] initWithTitle:@"麦克风被禁用"
                                         message:@"\n请启用麦克风-设置/隐私/麦克风"
                                        delegate:nil
                               cancelButtonTitle:@"关闭"
                               otherButtonTitles:nil] show];
        }
    }];
    
}

- (void)updatePeak:(NSTimer*)timer
{
    _timeLen = audioRecorder.currentTime;
    if(_timeLen>=60)
        [self recordStop:nil];
}

-(void)recordStop:(UIButton *)sender
{
    if (!recording ) {
        return;
    }
    _timeLen = audioRecorder.currentTime;
    [peakTimer invalidate];
    peakTimer = nil;
    [audioRecorder stop];
    recording = NO;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    if ( _timeLen <= 2 ) {
        [self removeCafFile];
        return;
    }
    
    NSString *docsDir = [Utils getDocumnetsVoicePath];
    docsDir = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[RYUserInfo sharedManager].uid]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *mp3FilePath = [docsDir stringByAppendingFormat:@"%@.mp3",str];
    
    __weak typeof(self) wSelf = self;
    // caf 转 mp3
    [CafToMp3 cafToMp3:pathURL.path toMp3Path:mp3FilePath complete:^(BOOL success, NSString *mp3Path) {
        [wSelf removeCafFile];
        if ( !success ) {
            [ShowBox showError:@"录音失败，请重新录音"];
        }
        else{
            NSURL *mp3URL = [NSURL fileURLWithPath:mp3Path];
            if ( wSelf.replyIndex != -1 ) {
                NSDictionary *dict = [wSelf.commentList objectAtIndex:wSelf.replyIndex];
                NSString *pid = [dict getStringValueForKey:@"pid" defaultValue:nil];
                wSelf.commentData.tid = wSelf.tid;
                wSelf.commentData.voiceURL = mp3URL;
                wSelf.commentData.pid = pid;
                wSelf.commentData.authorId = [dict getStringValueForKey:@"authorid" defaultValue:nil];
                wSelf.commentData.word = nil;
            }
            else{
                wSelf.commentData.tid = wSelf.tid;
                wSelf.commentData.voiceURL = mp3URL;
                wSelf.commentData.pid = nil;
                wSelf.commentData.authorId = nil;
                wSelf.commentData.word = nil;
            }
            [wSelf dismissTextView];
            [wSelf.listeningView showListeningViewWithRecordData:wSelf.commentData];
        }
    }];
    

//    if ( self.replyIndex != -1 ) {
//        NSDictionary *dict = [self.commentList objectAtIndex:self.replyIndex];
//        NSString *pid = [dict getStringValueForKey:@"pid" defaultValue:nil];
//        self.commentData.tid = self.tid;
//        self.commentData.voiceURL = pathURL;
//        self.commentData.pid = pid;
//        self.commentData.authorId = [dict getStringValueForKey:@"authorid" defaultValue:nil];
//        self.commentData.word = nil;
//    }
//    else{
//        self.commentData.tid = self.tid;
//        self.commentData.voiceURL = pathURL;
//        self.commentData.pid = nil;
//        self.commentData.authorId = nil;
//        self.commentData.word = nil;
//    }
//    [self dismissTextView];
//    [self.listeningView showListeningViewWithRecordData:self.commentData];
}

// 删除本地的caf录音文件
- (void)removeCafFile
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blDele= [fileManager removeItemAtURL:pathURL error:nil];
    pathURL = nil;
    if (blDele) {
        NSLog(@"dele success");
    }else {
        NSLog(@"dele fail");
    }
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


#pragma mark recordListeningViewDelegate
-(void)recordSendSuccess
{
    self.replyIndex = -1;
    [self submitCommentsuccess];
    [self.tableView headerBeginRefreshing];
}

#pragma  mark 如果自动登录不上则 需要打开登录界面手动登录
-(void)openLoginVC
{
    __weak typeof(self) wSelf = self;
    RYLoginViewController *nextVC = [[RYLoginViewController alloc] initWithFinishBlock:^(BOOL isLogin, NSError *error) {
        if ( isLogin ) {
            wSelf.notStretch = YES;
            wSelf.tableView.currentPage = 0;
            [wSelf getDataWithIsHeaderReresh:YES andCurrentPage:0];
        }
    }];
    [self.navigationController pushViewController:nextVC animated:YES];
}


@end
