//
//  albumlistTableViewCell.h
//  assetImagepicker
//
//  Created by 刚正面的斯温 on 15-2-12.
//  Copyright (c) 2015年 hyq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface albumlistTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView* postImgView;
@property (nonatomic,strong) UILabel* name;
@property (nonatomic,strong) UILabel* imgNum;

+(CGFloat)albumlistTableViewCellHeight;
@end
