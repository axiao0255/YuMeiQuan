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
        self.nameLabel.text = @"习近平";
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
        [self.contentView addSubview:self.commentLabel];
        
        // 分享评论框
        self.replyMenu = [[replyView alloc]init];
        self.replyMenu.right = SCREEN_WIDTH - 15;
        self.replyMenu.top = self.commentLabel.bottom + 10;
        [self.replyMenu menuType:shareAndReply];
        [self.contentView addSubview:self.replyMenu];
        
    }
    return self;
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
        
        self.praiseBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        self.praiseBtn.width = 48;
        self.praiseBtn.height = 24;
        self.praiseBtn.right = SCREEN_WIDTH - 15;
        [self.praiseBtn setImage:[UIImage imageNamed:@"ic_praise_nm.png"] forState:UIControlStateNormal];
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"ic_praise_bk.png"] forState:UIControlStateNormal];
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
    
    self.praiseLael.top = self.titleLabel.bottom + 20;
    NSString *praise = [dict getStringValueForKey:@"praise" defaultValue:@""];
    self.praiseLael.text = praise;
    [self.praiseLael sizeToFit];
    
    if ( [ShowBox isEmptyString:praise] ) {
        self.praiseBtn.top = self.titleLabel.bottom + 20;
    }
    else{
        self.praiseBtn.top = self.praiseLael.bottom + 10;
    }
}

@end