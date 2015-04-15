//
//  TextFieldWithLabel.m
//  RyMmBusiness
//
//  Created by rongyi on 15-1-7.
//  Copyright (c) 2015年 rongyi. All rights reserved.
//

#import "TextFieldWithLabel.h"

@implementation UITextField(TextFieldWithLabel)

-(void)label:(NSString*)l withWidth:(unsigned int)w{
    NSString* _label = l;

    if(_label.length <= 0) return;
    
    UILabel* lControl = [[UILabel alloc]initWithFrame: \
                         CGRectMake(0, 0, w, CGRectGetHeight(self.bounds))];
//    lControl.layer.borderColor = [UIColor redColor].CGColor;
//    lControl.layer.borderWidth = 1.0;
    [lControl setText:_label];
    [lControl setFont:[UIFont systemFontOfSize:14]];
    [self setFont:[UIFont systemFontOfSize:14]];
    self.leftView = lControl;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

-(void)seperatorWidth:(unsigned int)w{
    UILabel* lControl = [[UILabel alloc]initWithFrame: \
                         CGRectMake(0, 0, w, CGRectGetHeight(self.bounds))];
    self.leftView = lControl;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self setFont:[UIFont systemFontOfSize:14]];
}
@end
