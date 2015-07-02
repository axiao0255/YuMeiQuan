//
//  RYcommentTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/7/1.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVoiceBubble.h"
#import "replyView.h"

@interface RYcommentTableViewCell : UITableViewCell
@property (nonatomic , strong) UILabel        *nameLabel;
@property (nonatomic , strong) FSVoiceBubble  *bubble;
@property (nonatomic , strong) UILabel        *commentLabel;
@property (nonatomic , strong) UILabel        *timeLabel;
@property (nonatomic , strong) replyView      *replyMenu;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

/**
 * 评论界面 top 的cell
 */
@interface RYcommentTopCellTableViewCell : UITableViewCell

@property (nonatomic , strong) UILabel  *titleLabel;  // 标题
@property (nonatomic , strong) UILabel  *praiseLael;  // 点赞人名称
@property (nonatomic , strong) UIButton *praiseBtn;   // 点赞按钮

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setValueWithDict:(NSDictionary *)dict;

@end