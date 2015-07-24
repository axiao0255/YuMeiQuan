//
//  SelectLabelGroup.m
//  RongYi
//
//  Created by mac on 15-3-4.
//  Copyright (c) 2015年 bluemobi. All rights reserved.
//

#import "SelectLabelGroup.h"

@interface SelectItem : NSObject
+(instancetype)itemWithBtn:(UIButton*)btn;
@property(strong)UIButton* btn;
@property(assign)BOOL bSelect;
@end

@implementation SelectItem

+(instancetype)itemWithBtn:(UIButton*)btn{
    SelectItem* item = [[SelectItem alloc]init];
    item.btn = btn;
    return item;
}

@end

@implementation SelectLabelGroup{
    NSMutableArray* _btns;
    BOOL _bGen;
}
@synthesize items = _items;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.font = [UIFont systemFontOfSize:28/2.0];
    
    _btns = [[NSMutableArray alloc]init];
    return self;
}
-(void)layoutSubviews{
    if(!_bGen){
        [self selfGen];
    }
    
    int count = 0;
    int row = 0;
    float offset = 5;
    for (SelectItem* item in _btns) {
        if(count == 0){
            item.btn.frame = item.btn.bounds;
        }else{
            SelectItem* lastItem = [_btns objectAtIndex:(count - 1)];
            if(lastItem.btn.CJ_MAX_X + offset + item.btn.CJ_WIDTH > self.CJ_WIDTH){
                //change line
                row++;
                item.btn.center = CGPointMake(item.btn.CJ_WIDTH/2.0, \
                                              (10 + item.btn.CJ_HEIGHT) * row + item.btn.CJ_HEIGHT/2.0);
            }else{
                item.btn.center = CGPointMake(lastItem.btn.CJ_MAX_X + item.btn.CJ_WIDTH/2.0 + offset, \
                                              (10 + item.btn.CJ_HEIGHT) * row + item.btn.CJ_HEIGHT/2.0);
            }
        }
        count++;
    }
}

-(void)selfGen{
    if(!_items || [_items count] == 0) return;
    
    for (NSString* item in _items) {
        CGSize sz = [self btnSizeWithItem:item];
        UIButton* btn = [[UIButton alloc]initWithFrame:\
                         CGRectMake(0, 0, sz.width, sz.height)];
        
        [btn setTitle:item forState:UIControlStateNormal];
        btn.titleLabel.font = self.font;
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:self.normalBkg forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.layer.borderWidth = 0.5;
//        btn.layer.borderColor = COLOR_MACRO(0xd2, 0xd2, 0xd2).CGColor;
        btn.layer.borderColor = [Utils getRGBColor:0xd2 g:0xd2 b:0xd2 a:1.0].CGColor;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [btn setTitleColor:self.textColor forState:UIControlStateNormal];
        [_btns addObject:[SelectItem itemWithBtn:btn]];
        
        _bGen = YES;
    }
}

-(CGSize)btnSizeWithItem:(NSString*)item{
    CGSize sz = [item sizeWithFont:self.font];
    
    if(self.lineItemCount > 0){
        float width = self.CJ_WIDTH / self.lineItemCount;
        sz.width = width;
    }else{
        sz.width += 20;
    }
        sz.height += 12;
    return sz;
}
-(void)itemClick:(id)sender{
    SelectItem* item = nil;
    int i = 0;
    for (SelectItem* var in _btns) {
        if(var.btn == sender){
            item = var;
            item.bSelect = !item.bSelect;
            
            if(self.itemClick){
                self.itemClick(self, i);
            }
        }else if(!self.multiSelect){
            var.bSelect = !var.bSelect;
        }
        
        if(var.bSelect){
            [var.btn setBackgroundImage:self.selectBkg forState:UIControlStateNormal];
        }else{
            [var.btn setBackgroundImage:self.normalBkg forState:UIControlStateNormal];
        }
        
        i++;
    }
    [self setNeedsDisplay];
}

-(NSArray*)selectItems{
    NSMutableArray* ret = [[NSMutableArray alloc]init];
    int i = 0;
    for (SelectItem* item in _btns) {
        if(item.bSelect){
            [ret addObject:[NSNumber numberWithInt:i]];
        }
        i++;
    }
    return ret;
}

-(void)setItems:(NSArray *)items{
    if(!items || [items count] <= 0) return;
    _items = items;
    _bGen = NO;

    for (SelectItem* bt in _btns) {
        if(bt){
            bt.btn.hidden = YES;
            [bt.btn removeFromSuperview];
        }
    }
    [_btns removeAllObjects];
}

-(NSArray*)items{
    return _items;
}
@end

