//
//  RYCorporateTableViewCell.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/13.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYCorporateTableViewCell.h"

@implementation RYCorporateTableViewCell

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
        self.corporateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH - 30, 18)];
        self.corporateTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.corporateTitleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.corporateTitleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.corporateTitleLabel];
        
        self.attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.corporateTitleLabel.bottom + 16, 77, 28)];
        self.attentionBtn.hidden = YES;
        [self.contentView addSubview:self.attentionBtn];
        
        self.corporateRecommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.attentionBtn.bottom + 16, SCREEN_WIDTH - 30, 100)];
        self.corporateRecommendLabel.font = [UIFont systemFontOfSize:16];
        self.corporateRecommendLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.corporateRecommendLabel.numberOfLines = 0;
        [self.contentView addSubview:self.corporateRecommendLabel];
    }
    return self;
}

- (void)setValueWithModel:(RYCorporateHomePageData *)model
{
    if ( !model ) {
        return;
    }
    
    self.corporateTitleLabel.text = [model.corporateBody getStringValueForKey:@"realname" defaultValue:@""];
    [self.corporateTitleLabel sizeToFit];
    
    if ( [ShowBox isLogin] ) {
        self.attentionBtn.hidden = NO;
        self.attentionBtn.height = 28;
        if (model.isAttention) {
            [self.attentionBtn setImage:[UIImage imageNamed:@"ic_no_attention.png"] forState:UIControlStateNormal];
        }else{
            [self.attentionBtn setImage:[UIImage imageNamed:@"ic_attention.png"] forState:UIControlStateNormal];
        }
    }
    else{
        self.attentionBtn.hidden = YES;
        self.attentionBtn.height = 0;
    }
    
    self.attentionBtn.top = self.corporateTitleLabel.bottom + 16;
    
    self.corporateRecommendLabel.top = self.attentionBtn.bottom + 16;
    self.corporateRecommendLabel.text = [model.corporateBody getStringValueForKey:@"desc" defaultValue:@""];
    [self.corporateRecommendLabel sizeToFit];
}

@end
