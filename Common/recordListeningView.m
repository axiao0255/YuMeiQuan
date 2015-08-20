//
//  recordListeningView.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "recordListeningView.h"
#import <AVFoundation/AVFoundation.h>

@interface recordListeningView ()<AVAudioPlayerDelegate>

@property (nonatomic , strong) NSURL         *soundURL;
@property (nonatomic , strong) UIButton      *cancelBtn;
@property (nonatomic , strong) UIButton      *sendBtn;
@property (nonatomic , strong) UIButton      *playBtn;
@property (nonatomic , strong) AVAudioPlayer *audioPlayer;
@property (nonatomic , strong) UILabel       *timeLabel;
@property (nonatomic , strong) NSTimer       *timer;

@end

@implementation recordListeningView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.transparencyBtn];
        [self addSubview:self.playView];
        [self.playView addSubview:self.cancelBtn];
        [self.playView addSubview:self.sendBtn];
        [self.playView addSubview:self.playBtn];
        [self.playView addSubview:self.timeLabel];
    }
    return self;
}

-(UIButton *)transparencyBtn
{
    if ( _transparencyBtn == nil ) {
        _transparencyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _transparencyBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _transparencyBtn.left = 0;
        _transparencyBtn.top = 0;
        _transparencyBtn.width = SCREEN_WIDTH;
        _transparencyBtn.height = SCREEN_HEIGHT;
        _transparencyBtn.hidden = YES;
//       [_transparencyBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transparencyBtn;
}

- (UIImageView *)playView
{
    if ( _playView == nil ) {
        _playView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _playView.left = 0;
        _playView.width = SCREEN_WIDTH;
        
        if ( IS_IPHONE_6P ) {
            _playView.height = 134;
            _playView.image = [UIImage imageNamed:@"ic_Listening_background_6p.png"];
        }
        else{
            _playView.height = 120;
            if ( IS_IPHONE_6 ) {
                _playView.image = [UIImage imageNamed:@"ic_Listening_background_6.png"];
            }
            else{
                _playView.image = [UIImage imageNamed:@"ic_Listening_background.png"];
            }
        }
        [_playView setUserInteractionEnabled:YES];
        _playView.top = SCREEN_HEIGHT;
    }
    return _playView;
}

- (void)showListeningViewWithRecordData:(RYCommentData *)recordData
{
    if ( recordData == nil ) {
        return;
    }
    __weak AppDelegate *_appDelegate;
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [_appDelegate.window addSubview:self];
    [self.playBtn setSelected:NO];
    
    self.recordData = recordData;
    self.soundURL = self.recordData.voiceURL;
    [self setAudioPlayer];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.playView.top = SCREEN_HEIGHT - self.playView.height;
    } completion:^(BOOL finished) {
        self.transparencyBtn.hidden = NO;
    }];
}

- (void)dismissListeningView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.playView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        self.transparencyBtn.hidden = YES;
        [self removeFromSuperview];
    }];
}

- (UIButton *)cancelBtn
{
    if ( _cancelBtn == nil ) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        if ( IS_IPHONE_6P ) {
            _cancelBtn.left = 16;
            _cancelBtn.top = self.playView.height - 64 - 16;
            _cancelBtn.height = 64;
            _cancelBtn.width = 64;
        }
        else{
            _cancelBtn.left = 15;
            _cancelBtn.top = self.playView.height - 53 - (IS_IPHONE_6?15:13);
            _cancelBtn.height = 53;
            _cancelBtn.width = 53;
        }
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"ic_listenView_cancelBtn.png"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sendBtn
{
    if (_sendBtn == nil) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        if ( IS_IPHONE_6P ) {
            _sendBtn.left = SCREEN_WIDTH-16-64;
            _sendBtn.top = self.playView.height - 64 - 16;
            _sendBtn.height = 64;
            _sendBtn.width = 64;
            
        }
        else{
            _sendBtn.left = SCREEN_WIDTH-15-53;
            _sendBtn.top = self.playView.height - 53 - (IS_IPHONE_6?15:13);
            _sendBtn.height = 53;
            _sendBtn.width = 53;
        }
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"ic_listenView_sendBtn.png"] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UIButton *)playBtn
{
    if ( _playBtn == nil ) {
        _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-(IS_IPHONE_6P?33:30), IS_IPHONE_6P?5:4, IS_IPHONE_6P?66:60, IS_IPHONE_6P?66:60)];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"ic_listenView_startPlay.png"] forState:UIControlStateNormal];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"ic_listenView_stopPlay.png"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UILabel *)timeLabel
{
    if ( _timeLabel == nil ) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 25, IS_IPHONE_6P?75:70, 50, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:18];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setAudioPlayer
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
    NSError *error;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.soundURL error:&error];
    audioPlayer.numberOfLoops = 0;
    
    self.audioPlayer = audioPlayer;
    self.audioPlayer.delegate = self;
    
    // 设置总时间
    [self setTotalTime];
 }

// 文件的总时长
- (void)setTotalTime
{
    float minutes = floor(self.audioPlayer.duration/60);
    float seconds = self.audioPlayer.duration - (minutes * 60);
    
    NSString *tiemStr = [NSString stringWithFormat:@"%0.0f:%0.0f",minutes,seconds];
    [self.timeLabel setText:tiemStr];
}


- (void)cancelBtnClick
{
    [self dismissListeningView];
    [self stopPlaying];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blDele= [fileManager removeItemAtURL:self.soundURL error:nil];
    if (blDele) {
        NSLog(@"dele success");
    }else {
        NSLog(@"dele fail");
    }
}

- (void)sendBtnClick
{
//    NSLog(@"发送");
    if ([ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [SVProgressHUD showWithStatus:@"正在发送..." maskType:SVProgressHUDMaskTypeBlack];
        [NetRequestAPI submitCommentWithSessionId:[RYUserInfo sharedManager].session
                                              tid:self.recordData.tid
                                              pid:self.recordData.pid
                                         authorId:self.recordData.authorId
                                             word:self.recordData.word
                                            voice:self.soundURL
                                          success:^(id responseDic) {
                                              [SVProgressHUD dismiss];
                                              NSLog(@"上传录音 responseDic： %@",responseDic);
                                              NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                              BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                              if ( !success ) {
                                                  [wSelf submitCommentFailureShowAlert];
                                                  return ;
                                              }
                                              if ( [wSelf.delegate respondsToSelector:@selector(recordSendSuccess)] ) {
                                                  [wSelf.delegate recordSendSuccess];
                                              }
                                              [wSelf dismissListeningView];
                                              
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
    alertView.tag = 1000;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == 1000 ) {
        // 发送失败 从新发送
        if ( buttonIndex == 1 ) {
            [self sendBtnClick];
        }
        return;
    }
}


-(void)playBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        [self stopPlaying];
    }
    else{
        [self startPlaying];
    }
}

-(void)startPlaying
{
    [self.audioPlayer play];
    [self.playBtn setSelected:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimeValue) userInfo:nil repeats:YES];
}
// 播放的同时更新时间
- (void)updateTimeValue
{
    // 剩余时间
    CGFloat residueTime =  (self.audioPlayer.duration - self.audioPlayer.currentTime);
    NSInteger minutes = (NSInteger)residueTime/60;
    CGFloat seconds = residueTime - (minutes*60);
    NSString *tiemStr = [NSString stringWithFormat:@"%ld:%0.0f",(long)minutes,seconds];
    [self.timeLabel setText:tiemStr];
}
-(void)stopPlaying
{
    [self.audioPlayer stop];
    [self.playBtn setSelected:NO];
    [self setTotalTime];
    [self.timer invalidate];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
//    NSLog(@"播放结束");
    [self.playBtn setSelected:NO];
    [self setTotalTime];
    [self.timer invalidate];
}


@end
