//
//  RYEnshrineClassifyTableViewCell.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/28.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "SWTableViewCell.h"

@interface RYEnshrineClassifyTableViewCell : SWTableViewCell

@property (nonatomic , strong) UILabel     *titleLabel;
@property (nonatomic , strong) UILabel     *numLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
