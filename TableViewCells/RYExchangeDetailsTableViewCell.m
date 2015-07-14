//
//  RYExchangeDetailsTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYExchangeDetailsTableViewCell.h"

@implementation RYExchangeDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 180)];
        self.imgView.layer.borderWidth = 0.5;
        self.imgView.layer.borderColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0].CGColor;
        [self.contentView addSubview:self.imgView];
        self.transparencyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 140,  self.imgView.width, 40)];
        [self.imgView addSubview:self.transparencyImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.transparencyImageView.width - 20, self.transparencyImageView.height)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.numberOfLines = 2;
        [self.transparencyImageView addSubview:self.titleLabel];

    }
    return self;
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    if ( !dict ) {
        return;
    }
    [self.imgView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"ic_bigPic_defaule.png"]];
    
    NSString *title = [dict getStringValueForKey:@"name" defaultValue:@""];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGRect rect = [title boundingRectWithSize:CGSizeMake(self.titleLabel.width, 40)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes
                                        context:nil];
    
    self.transparencyImageView.height = rect.size.height + 10;
    self.transparencyImageView.top = 180 - self.transparencyImageView.height;
    self.titleLabel.height = self.transparencyImageView.height;
    self.transparencyImageView.image = [UIImage imageNamed:@"ic_transparency.png"];
    self.titleLabel.text = title;
    
}


@end

@implementation RYExchangeTextFieldTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 30, 44)];
        self.textField.layer.borderWidth = 1.0;
        self.textField.layer.borderColor = [Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0].CGColor;
        self.textField.layer.cornerRadius = 4;
        self.textField.layer.masksToBounds = YES;
        self.textField.font = [UIFont systemFontOfSize:16];
        self.textField.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

@end

