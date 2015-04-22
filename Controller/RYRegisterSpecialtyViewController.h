//
//  RYRegisterSpecialtyViewController.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

@protocol RYRegisterSpecialtyDelegate <NSObject>

@required
- (void)selectSpecialtyTypeWithTag:(NSUInteger)tag didStr:(NSString *)str;

@end

#import "RYBaseViewController.h"

@interface RYRegisterSpecialtyViewController : RYBaseViewController

@property (nonatomic,weak) id <RYRegisterSpecialtyDelegate>delegate;

- (id)initWIthSpecialtyArray:(NSArray *)array isFillout:(BOOL)fillout andTitle:(NSString *)title;

@end
