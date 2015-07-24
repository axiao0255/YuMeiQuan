//
//  RYLiteratureQueryTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYLiteratureQueryTableViewCell.h"

@implementation RYLiteratureQueryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 26, 26)];
        [self.contentView addSubview:self.leftImgView];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftImgView.right + 8, 0, 200, 58)];
        self.titleLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return;
    }
    
    NSInteger state = [dict getIntValueForKey:@"result" defaultValue:0];  //doi 查询 结果 分类 result：1查询完成，2第三方查到，3留言，4失败
    if ( state == 1 ) {
        self.leftImgView.image = [UIImage imageNamed:@"ic_successful.png"];
        self.titleLabel.text = @"查询完成";
    }
    else if ( state == 2 || state == 3 ){
        self.leftImgView.image = [UIImage imageNamed:@"ic_query.png"];
        self.titleLabel.text = @"查询中";
    }
    else{
        self.leftImgView.image = [UIImage imageNamed:@"ic_query_failure.png"];
        self.titleLabel.text = @"查询失败";
    }
}

@end


@implementation RYLiteratureQuerySubjectTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 39)];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setValueWithString:(NSString *)string
{
    if ( [ShowBox isEmptyString:string] ) {
        return;
    }
    
//    CGSize size = [string sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
    NSDictionary *attributes = @{NSFontAttributeName:self.titleLabel.font};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributes
                                      context:nil];

    self.titleLabel.height = rect.size.height;
    self.titleLabel.text = string;
}


@end


@implementation RYLiteratureQueryOrdinaryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, 4, 16)];
        self.leftView.layer.cornerRadius = 1;
        self.leftView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.leftView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftView.right + 15, 5, 100, 16)];
        self.titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 5, SCREEN_WIDTH - 50, 50)];
        self.contentLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];

    }
    return self;
}

- (void)setValueWithString:(NSString *)string
{
    if ( [ShowBox isEmptyString:string] ) {
        self.titleLabel.height = 0;
        return;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:attributes
                                                              context:nil];
    self.contentLabel.height = rect.size.height;
    self.contentLabel.text = string;

    
//    CGSize size = [string sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
//    self.titleLabel.height = size.height;
//    [self.titleLabel setAttributedText:[Utils getAttributedString:string hightlightString:[string substringToIndex:3] hightlightColor:[Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0] andFont:self.titleLabel.font]];
}

@end

