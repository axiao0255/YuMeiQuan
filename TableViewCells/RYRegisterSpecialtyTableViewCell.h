//
//  RYRegisterSpecialtyTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYRegisterSpecialtyTableViewCell : UITableViewCell

@property (nonatomic , strong) UILabel     *contentLabel;
@property (nonatomic , strong) UIImageView *arrowImageView;
@property (nonatomic , strong) UIView      *partingLine;

@property (nonatomic , strong) UIImage     *highlightImage;
@property (nonatomic , strong) UIImage     *normalImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
