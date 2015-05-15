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
        self.corporateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH - 30, 17)];
        self.corporateTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.corporateTitleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.corporateTitleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.corporateTitleLabel];
        
        self.corporateRecommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.corporateTitleLabel.bottom + 16, SCREEN_WIDTH - 30, 100)];
        self.corporateRecommendLabel.font = [UIFont systemFontOfSize:12];
        self.corporateRecommendLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        self.corporateRecommendLabel.numberOfLines = 0;
        [self.contentView addSubview:self.corporateRecommendLabel];
    }
    return self;
}

- (void)setValueWithModel:(RYCorporateModel *)model
{
    if ( !model ) {
        return;
    }
    
    self.corporateTitleLabel.text = model.corporateName;
    [self.corporateTitleLabel sizeToFit];
    
    self.corporateRecommendLabel.top = self.corporateTitleLabel.bottom + 16;
    self.corporateRecommendLabel.text = model.corporateRecommend;
    [self.corporateRecommendLabel sizeToFit];
}

@end
