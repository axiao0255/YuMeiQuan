//
//  albumlistTableViewCell.m
//  assetImagepicker
//
//  Created by 刚正面的斯温 on 15-2-12.
//  Copyright (c) 2015年 hyq. All rights reserved.
//

#import "albumlistTableViewCell.h"

@implementation albumlistTableViewCell
@synthesize postImgView,name,imgNum;
const int  cellheight       = 50 ;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self                    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int fiximg          =3;
        postImgView         = [[UIImageView alloc] initWithFrame:CGRectMake(fiximg, fiximg, cellheight - 2*fiximg, cellheight - 2*fiximg)];
        [postImgView setImage:[UIImage imageNamed:@"xunger.jpg"]];
        [self.contentView addSubview:postImgView];
        
        name                = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(postImgView.frame)+5, CGRectGetMinY(postImgView.frame)+3, 100, 20)];
        name.textColor      = [UIColor blackColor];
        [self.contentView addSubview:name];
        
        imgNum              = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(postImgView.frame)+5, CGRectGetMaxY(postImgView.frame)-23, 100, 20)];
        imgNum.textColor    = [UIColor blackColor];
        [self.contentView addSubview:imgNum];
    }
    return self;
}

- (void)awakeFromNib {
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)albumlistTableViewCellHeight{
    return cellheight;
}
@end
