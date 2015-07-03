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
//#import "ChatCacheFileUtil.h"
//#import "VoiceConverter.h"

@interface RYcommentDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate,FSVoiceBubbleDelegate,AVAudioRecorderDelegate>
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
}

@property (nonatomic , strong) RYArticleData       *articleData;
@property (nonatomic , strong) MJRefreshTableView  *tableView;
@property (nonatomic , strong) NSMutableArray      *listData;
@property (nonatomic , strong) NSDictionary        *topDict;
@property (nonatomic , strong) NSString            *tid;

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

-(id)initWithArticleTid:(NSString *) tid
{
    self = [super init];
    if ( self ) {
       self.listData = [NSMutableArray array];
        self.tid = tid;
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
    [self.tableView headerBeginRefreshing];
    
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
    if ( [ShowBox checkCurrentNetwork] ) {
        [NetRequestAPI getCommentListWithSessionId:[RYUserInfo sharedManager].session
                                               tid:self.tid
                                              page:currentPage
                                           success:^(id responseDic) {
                                               NSLog(@"评论列表 responseDic :%@",responseDic);
            
        } failure:^(id errorString) {
             NSLog(@"评论列表 errorString :%@",errorString);
        }];
    }
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [textView resignFirstResponder];
}

#pragma mark FSVoiceBubbleDelegate
- (void)voiceBubbleDidStartPlaying:(FSVoiceBubble *)voiceBubble
{
    _currentRow = voiceBubble.tag;
}

#pragma mark 聊天窗
-(void)createTalkView
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, SCREEN_WIDTH, 50)];
    containerView.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
    
    talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    talkBtn.frame = CGRectMake(15, 5, 36, 36);
    talkBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [talkBtn setImage:[UIImage imageNamed:@"ic_shuru.png"] forState:UIControlStateNormal];
    [talkBtn setImage:[UIImage imageNamed:@"ic_voice.png"] forState:UIControlStateSelected];
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
    
    
    recordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recordBtn.frame = textView.frame;
    recordBtn.backgroundColor = [UIColor lightGrayColor];
    [recordBtn setTitle:@"按住  说话" forState:UIControlStateNormal];
    [recordBtn setTitle:@"松开  结束" forState:UIControlEventTouchDown];
    [recordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [recordBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [recordBtn setTitleShadowOffset:CGSizeMake(1, 1)];
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
    
    talkBtn.selected = YES;
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    
    talkBtn.selected = NO;
}

#pragma mark 录音功能

-(void)recordStart:(UIButton *)sender
{
    if(recording)
        return;
    RYcommentTableViewCell *cell = (RYcommentTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentRow inSection:1]];
    [cell.bubble pause];
    recording=YES;
    /*
    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:8000],AVSampleRateKey,
                            [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                            [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                            nil];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
//    NSString *fileName = [NSString stringWithFormat:@"rec_%@_%@.wav",MY_USER_ID,[dateFormater stringFromDate:now]];
//    NSString *fullPath = [[[ChatCacheFileUtil sharedInstance] userDocPath] stringByAppendingPathComponent:fileName];
//    NSURL *url = [NSURL fileURLWithPath:fullPath];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"recordTest.caf"];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    pathURL = url;
    NSError *error;
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:pathURL settings:settings error:&error];
    audioRecorder.delegate = self;

    peakTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updatePeak:) userInfo:nil repeats:YES];
    [peakTimer fire];
     */
    
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
    
//    NSDate *now = [NSDate date];
//    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
//    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    //    NSString *fileName = [NSString stringWithFormat:@"rec_%@_%@.wav",MY_USER_ID,[dateFormater stringFromDate:now]];
    //    NSString *fullPath = [[[ChatCacheFileUtil sharedInstance] userDocPath] stringByAppendingPathComponent:fileName];
    //    NSURL *url = [NSURL fileURLWithPath:fullPath];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"recordTest.caf"];
    
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
