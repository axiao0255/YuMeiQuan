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
        _playView.height = 120;
        _playView.image = [UIImage imageNamed:@"ic_Listening_background.png"];
        [_playView setUserInteractionEnabled:YES];
        _playView.top = SCREEN_HEIGHT;
    }
    return _playView;
}

- (void)showListeningViewWithSoundURL:(NSURL *)soundURL
{
    if ( soundURL == nil ) {
        return;
    }
    __weak AppDelegate *_appDelegate;
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [_appDelegate.window addSubview:self];
    [self.playBtn setSelected:NO];
    self.soundURL = soundURL;
    [self setAudioPlayer];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.playView.top = SCREEN_HEIGHT - 120;
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
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 120 - 53 - 13, 53, 53)];
        [_cancelBtn setImage:[UIImage imageNamed:@"ic_listenView_cancelBtn.png"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sendBtn
{
    if (_sendBtn == nil) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 53 - 15, 120 - 53 - 13, 53, 53)];
        [_sendBtn setImage:[UIImage imageNamed:@"ic_listenView_sendBtn.png"] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UIButton *)playBtn
{
    if ( _playBtn == nil ) {
        _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 4, 60, 60)];
        [_playBtn setImage:[UIImage imageNamed:@"ic_listenView_startPlay.png"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"ic_listenView_stopPlay.png"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UILabel *)timeLabel
{
    if ( _timeLabel == nil ) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 25, 70, 50, 20)];
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
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
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
}

- (void)sendBtnClick
{
    NSLog(@"发送");
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
    NSString *tiemStr = [NSString stringWithFormat:@"%ld:%0.0f",minutes,seconds];
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
    NSLog(@"播放结束");
    [self.playBtn setSelected:NO];
    [self setTotalTime];
    [self.timer invalidate];
}


@end
