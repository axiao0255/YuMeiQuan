//
//  SelectLabelGroup.h
//  RongYi
//
//  Created by mac on 15-3-4.
//  Copyright (c) 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectLabelGroup : UIView

@property(assign)int lineItemCount;
@property(strong)NSArray* items;

@property(strong)UIFont* font;
@property(strong)UIColor* textColor;
@property(strong)UIImage* normalBkg;

@property(assign)BOOL multiSelect;
@property(assign)UIColor* selectColor;
@property(strong)UIImage* selectBkg;

@property(readonly)NSArray* selectItems;
@property(copy)void(^itemClick)(SelectLabelGroup*, int);
@end
