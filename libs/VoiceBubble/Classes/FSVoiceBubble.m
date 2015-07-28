//
//  FSVoiceBubble.m
//  Pods
//
//  Created by Wenchao Ding on 3/25/15.
//
//

#import "FSVoiceBubble.h"
#import "UIImage+FSExtension.h"
#import <AVFoundation/AVFoundation.h>


#define kFSVoiceBubbleShouldStopNotification @"FSVoiceBubbleShouldStopNotification"
#define UIImageNamed(imageName) [[UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]] imageWithRenderingMode:UIImageRenderingModeAutomatic]

@interface FSVoiceBubble () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *player;
@property (nonatomic ,strong) AVPlayerItem  *playerItem;
@property (strong, nonatomic) AVURLAsset    *asset;
@property (strong, nonatomic) NSArray       *animationImages;
@property (weak  , nonatomic) UIButton      *contentButton;

- (void)initialize;
- (void)voiceClicked:(id)sender;
- (void)bubbleShouldStop:(NSNotification *)notification;

@end

@implementation FSVoiceBubble

@dynamic bubbleImage, textColor;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImageNamed(@"fs_icon_wave_2") imageWithOverlayColor:self.waveColor]  forState:UIControlStateNormal];
    [button setBackgroundImage:UIImageNamed(@"fs_chat_bubble") forState:UIControlStateNormal];
    [button setTitle:@"0\"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(voiceClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor                = [UIColor clearColor];
    button.titleLabel.font                = [UIFont systemFontOfSize:12];
    button.adjustsImageWhenHighlighted    = YES;
    button.imageView.animationDuration    = 2.0;
    button.imageView.animationRepeatCount = 30;
    button.imageView.clipsToBounds        = NO;
    button.imageView.contentMode          = UIViewContentModeCenter;
    button.contentHorizontalAlignment     = UIControlContentHorizontalAlignmentRight;
    [self addSubview:button];
    self.contentButton = button;
    
    self.waveColor = [UIColor colorWithRed:0/255.0 green:102/255.0 blue:51/255.0 alpha:1.0];
    self.textColor = [UIColor grayColor];
    
    _animatingWaveColor = [UIColor whiteColor];
    _exclusive = YES;
    _durationInsideBubble = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bubbleShouldStop:) name:kFSVoiceBubbleShouldStopNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFSVoiceBubbleShouldStopNotification object:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _contentButton.frame = self.bounds;

    NSString *title = [_contentButton titleForState:UIControlStateNormal];
    if (title && title.length) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[_contentButton titleForState:UIControlStateNormal] attributes:attributes];
        _contentButton.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                          -self.bounds.size.width + 50 + _waveInset,
                                                          0,
                                                          self.bounds.size.width - 50 + 25 - attributedString.size.width - _waveInset);
        NSInteger textPadding = _invert ? 2 : 4;
        if (_durationInsideBubble) {
            _contentButton.titleEdgeInsets = UIEdgeInsetsMake(1, -8-_textInset, 0, 8+_textInset);
        } else {
            _contentButton.titleEdgeInsets = UIEdgeInsetsMake(self.bounds.size.height - attributedString.size.height,
                                                    attributedString.size.width + textPadding,
                                                    0,
                                                    -attributedString.size.width - textPadding);
        }
        self.layer.transform = _invert ? CATransform3DMakeRotation(M_PI, 0, 1.0, 0) : CATransform3DIdentity;
        _contentButton.titleLabel.layer.transform = _invert ? CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0) : CATransform3DIdentity;
        
    }
}

# pragma mark - Setter & Getter

- (void)setWaveColor:(UIColor *)waveColor
{
    if (![_waveColor isEqual:waveColor]) {
        _waveColor = waveColor;
        [_contentButton setImage:[UIImageNamed(@"fs_icon_wave_2") imageWithOverlayColor:waveColor]  forState:UIControlStateNormal];
    }
}

- (void)setInvert:(BOOL)invert
{
    if (_invert != invert) {
        _invert = invert;
        [self setNeedsLayout];
    }
}

- (void)setBubbleImage:(UIImage *)bubbleImage
{
    [_contentButton setBackgroundImage:bubbleImage forState:UIControlStateNormal];
}

- (void)setTextColor:(UIColor *)textColor
{
    [_contentButton setTitleColor:textColor forState:UIControlStateNormal];
}

- (UIColor *)textColor
{
    return [_contentButton titleColorForState:UIControlStateNormal];
}

- (UIImage *)bubbleImage
{
    return [_contentButton backgroundImageForState:UIControlStateNormal];
}

- (void)setWaveInset:(CGFloat)waveInset
{
    if (_waveInset != waveInset) {
        _waveInset = waveInset;
        [self setNeedsLayout];
    }
}

- (void)setTextInset:(CGFloat)textInset
{
    if (_textInset != textInset) {
        _textInset = textInset;
        [self setNeedsLayout];
    }
}

- (void)setContentURL:(NSURL *)contentURL
{
    if (![_contentURL isEqual:contentURL]) {
        _contentURL = contentURL;
        if (self.isPlaying) {
            [self stop];
        }
        
        // 取本地录音 文件
        NSString *documentViocePath = [Utils getDocumnetsVoicePath];
        NSFileManager *manage=[NSFileManager defaultManager];
        NSArray  *voiceArray = [manage subpathsAtPath:documentViocePath];
        // 取网络 音频文件 后缀名
        NSString *voicePath = [self getLastStrWithVoicePath:[_contentURL absoluteString]];
        // 判断 网络音频在本地是否存在
        if ( [voiceArray indexOfObject:voicePath] != NSNotFound ) {
            //如果存在则播放本地音频文件
            _contentButton.enabled = YES;
            _contentURL = [NSURL URLWithString:[documentViocePath stringByAppendingPathComponent:voicePath]];
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setCategory:AVAudioSessionCategorySoloAmbient error:nil];
            NSError *error;
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_contentURL error:&error];
             _player.delegate = self;
            [_player prepareToPlay];
            
            float seconds = _player.duration;
            NSString *tiemStr = [NSString stringWithFormat:@"%0.0f\"",seconds];
            [_contentButton setTitle:tiemStr forState:UIControlStateNormal];
             [self setNeedsLayout];
        }else{
            _contentButton.enabled = NO;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                
                _asset = [[AVURLAsset alloc] initWithURL:contentURL options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @YES}];
                CMTime duration = _asset.duration;
                NSInteger seconds = CMTimeGetSeconds(duration);
                NSString *title = [NSString stringWithFormat:@"%@\"",@(seconds)];
                [_contentButton setTitle:title forState:UIControlStateNormal];
                
                NSString *savePath = [documentViocePath stringByAppendingPathComponent:voicePath];
                NSData *data = [NSData dataWithContentsOfURL:_contentURL];
                [data writeToFile:savePath atomically:YES];
                NSError *error=nil;
                _player = [[AVAudioPlayer alloc] initWithData:data error:&error];
                _player.delegate = self;
                [_player prepareToPlay];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _contentButton.enabled = YES;
                    [self setNeedsLayout];
                });

            });
        }

        
//        _contentButton.enabled = NO;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            _asset = [[AVURLAsset alloc] initWithURL:contentURL options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @YES}];
//            CMTime duration = _asset.duration;
//            NSInteger seconds = CMTimeGetSeconds(duration);
//            if (seconds > 60) {
//                NSLog(@"A voice audio should't last longer than 60 seconds");
//                _contentURL = nil;
//                _asset = nil;
//                return;
//            }
//            
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_playerPath]];
//            NSError *error=nil;
//            _player = [[AVAudioPlayer alloc] initWithData:data error:&error];
////            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_playerPath] error:&error];
//
//            _player.delegate = self;
//            [_player prepareToPlay];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *title = [NSString stringWithFormat:@"%@\"",@(seconds)];
//                [_contentButton setTitle:title forState:UIControlStateNormal];
//                _contentButton.enabled = YES;
//                [self setNeedsLayout];
//            });
//        });
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

- (BOOL)isPlaying
{
    return _player.isPlaying;
}

#pragma mark - AVAudioPlayer Delegate

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [self pause];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    [self play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopAnimating];
}

#pragma mark - Nofication

- (void)bubbleShouldStop:(NSNotification *)notification
{
    if (_player.isPlaying) {
        [self stop];
    }
}

#pragma mark - Target Action

- (void)voiceClicked:(id)sender
{
    if (_player.playing && _contentButton.imageView.isAnimating) {
        [self stop];
    } else {
        if (_exclusive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kFSVoiceBubbleShouldStopNotification object:nil];
        }
        [self play];
        if (_delegate && [_delegate respondsToSelector:@selector(voiceBubbleDidStartPlaying:)]) {
            [_delegate voiceBubbleDidStartPlaying:self];
        }
    }
}

#pragma mark - Public

- (void)startAnimating
{
    if (!_contentButton.imageView.isAnimating) {
        UIImage *image0 = [UIImageNamed(@"fs_icon_wave_0") imageWithOverlayColor:_animatingWaveColor];
        UIImage *image1 = [UIImageNamed(@"fs_icon_wave_1") imageWithOverlayColor:_animatingWaveColor];
        UIImage *image2 = [UIImageNamed(@"fs_icon_wave_2") imageWithOverlayColor:_animatingWaveColor];
        _contentButton.imageView.animationImages = @[image0, image1, image2];
        [_contentButton.imageView startAnimating];
    }
}

- (void)stopAnimating
{
    if (_contentButton.imageView.isAnimating) {
        [_contentButton.imageView stopAnimating];
    }
}

- (void)play
{
    if (!_contentURL) {
        NSLog(@"ContentURL of voice bubble was not set");
        return;
    }
    if (!_player.playing) {
        [_player play];
        [self startAnimating];
    }
}

- (void)pause
{
    if (_player.playing) {
        [_player pause];
        [self stopAnimating];
    }
}

- (void)stop
{
    if (_player.playing) {
        [_player stop];
        _player.currentTime = 0;
        [self stopAnimating];
    }
}

@end
