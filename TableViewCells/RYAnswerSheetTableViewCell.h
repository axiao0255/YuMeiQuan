//
//  RYAnswerSheetTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/5/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYAnswerSheetTableViewCell : UITableViewCell

@property (strong , nonatomic) UIImageView     *leftImgView;
@property (strong , nonatomic) UILabel         *titleLabel;

-(void)setValueWithString:(NSString *)string;

-(void)changeSelectHighlighted:(BOOL)highlighted;

@end
