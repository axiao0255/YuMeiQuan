//
//  RYcommentTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/1.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYcommentTableViewCell.h"

@implementation RYcommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 16)];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [self.contentView addSubview:self.nameLabel];
        
        // 设置语音框
        self.bubble =  [[FSVoiceBubble alloc] initWithFrame:CGRectMake(20, self.nameLabel.bottom + 5, 200, 40)];
        self.bubble.waveColor = [Utils getRGBColor:0x00 g:0x91 b:0xea a:1.0];
        self.bubble.animatingWaveColor = [Utils getRGBColor:0x00 g:0x91 b:0xea a:1.0];
        self.bubble.invert = NO;
        self.bubble.exclusive = YES;
        self.bubble.durationInsideBubble = YES;
        [self.bubble setBubbleImage:[UIImage imageNamed:@"fs_cap_bg_0"]];
        [self.contentView addSubview:self.bubble];
        
        // 回复文字 label
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.bubble.bottom + 5, SCREEN_WIDTH - 40, 50)];
        self.commentLabel.font = [UIFont systemFontOfSize:16];
        self.commentLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        self.commentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.commentLabel];
        
        // 设置时间
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.commentLabel.bottom + 15, 150, 14)];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        [self.contentView addSubview:self.timeLabel];
        
        // 分享评论框
        self.replyMenu = [[replyView alloc]init];
        self.replyMenu.right = SCREEN_WIDTH - 15;
        self.replyMenu.top = self.commentLabel.bottom + 10;
        self.replyMenu.delegate = self;
        [self.contentView addSubview:self.replyMenu];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return;
    }
    
    NSString *author = [dict getStringValueForKey:@"author" defaultValue:@""];
    NSString *beauthor = [dict getStringValueForKey:@"beauthor" defaultValue:nil];
    if ( [ShowBox isEmptyString:beauthor] ) {
        self.nameLabel.text = author;
    }
    else{
        self.nameLabel.text = [NSString stringWithFormat:@"%@回复%@",author,beauthor];
    }
    
    // 判断声音是否 空
    NSString *voice = [dict getStringValueForKey:@"voice" defaultValue:@""];
//    voice = @"http://music.baidutt.com/up/kwcawswc/yuydsw.mp3";
    if ( [ShowBox isEmptyString:voice] ) {
        self.bubble.hidden = YES;
        self.bubble.height = 0;
        self.commentLabel.top = self.bubble.bottom;
    }
    else{
        self.bubble.hidden = NO;
        self.bubble.height = 40;
        if ( ![self.voicePath isEqualToString:voice] ) {
            self.voicePath = voice;
            self.bubble.contentURL = [NSURL URLWithString:self.voicePath];
        }
       
        self.commentLabel.top = self.bubble.bottom + 5;
    }
    // 判断是否有文字
    NSString *word = [dict getStringValueForKey:@"word" defaultValue:@""];
    if ( [ShowBox isEmptyString:word] ) {
        self.commentLabel.height = 0;
        self.commentLabel.hidden = YES;
        self.timeLabel.top = self.bubble.bottom + 15;
        self.replyMenu.top = self.bubble.bottom + 10;
    }
    else{
        
        NSDictionary *praiseAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        CGRect rect = [word boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:praiseAttributes
                                               context:nil];
        self.commentLabel.height = rect.size.height;
        self.commentLabel.text = word;
        self.commentLabel.hidden = NO;
        self.timeLabel.top = self.commentLabel.bottom + 15;
        self.replyMenu.top = self.commentLabel.bottom + 10;
    }
    
    self.timeLabel.text = [dict getStringValueForKey:@"time" defaultValue:@""];
    // 取作者id  并 判断 是否 和本人uid 是否一致
    NSString *authorid = [dict getStringValueForKey:@"authorid" defaultValue:@""];
    if ( [[RYUserInfo sharedManager].uid isEqualToString:authorid] && ![ShowBox isEmptyString:authorid] ) {
        [self.replyMenu menuType:shareAndDel];
    }
    else{
        [self.replyMenu menuType:shareAndReply];
    }
}

#pragma mark replyViewDelegate
-(void)didSelectButtonWithIndex:(NSInteger) index
{
    if ( [self.delegate respondsToSelector:@selector(currentSelectCellTag:andSelectBtnTage:)] ) {
        [self.delegate currentSelectCellTag:self.tag andSelectBtnTage:index];
    }
}

@end


@implementation RYcommentTopCellTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.left = 15;
        self.titleLabel.top = 16;
        self.titleLabel.width = SCREEN_WIDTH - 30;
        [self.contentView addSubview:self.titleLabel];
        
        self.praiseLael = [[UILabel alloc] initWithFrame:CGRectZero];
        self.praiseLael.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        self.praiseLael.font = [UIFont systemFontOfSize:14];
        self.praiseLael.numberOfLines = 0;
        self.praiseLael.left = 15;
        self.praiseLael.width = SCREEN_WIDTH - 30;
        [self.contentView addSubview:self.praiseLael];
        
        self.replyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        self.replyBtn.width = 56;
        self.replyBtn.height = 28;
        self.replyBtn.right = SCREEN_WIDTH - 15;
        self.replyBtn.layer.cornerRadius = 15;
        self.replyBtn.layer.masksToBounds = YES;
        self.replyBtn.backgroundColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.replyBtn setTitle:@"评论" forState:UIControlStateNormal];
        self.replyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.replyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.replyBtn];
        
        self.praiseBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        self.praiseBtn.width = 56;
        self.praiseBtn.height = 28;
        self.praiseBtn.right = self.replyBtn.left - 10;
        self.praiseBtn.layer.cornerRadius = 15;
        self.praiseBtn.layer.masksToBounds = YES;
        self.praiseBtn.backgroundColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.praiseBtn setTitle:@"赞" forState:UIControlStateNormal];
        self.praiseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.praiseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.praiseBtn];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return;
    }
    
    self.titleLabel.text = [dict getStringValueForKey:@"subject" defaultValue:@""];
    [self.titleLabel sizeToFit];
    
    NSString *praise = [dict getStringValueForKey:@"praise" defaultValue:@""];
    NSDictionary *praiseAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect praiseRect = [praise boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:praiseAttributes
                                             context:nil];
    self.praiseLael.top = self.titleLabel.bottom + 20;
    self.praiseLael.height = praiseRect.size.height;
    self.praiseLael.text = praise;
    
    if ( [ShowBox isEmptyString:praise] ) {
        self.praiseBtn.top = self.titleLabel.bottom + 20;
        self.replyBtn.top = self.titleLabel.bottom + 20;
    }
    else{
        self.praiseBtn.top = self.praiseLael.bottom + 10;
        self.replyBtn.top = self.praiseLael.bottom + 10;
    }
}

@end