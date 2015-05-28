//
//  GridMenuView.m
//  RongYi
//
//  Created by udspj on 13-11-1.
//  Copyright (c) 2013年 bluemobi. All rights reserved.
//

#import "GridMenuView.h"

@implementation GridMenuView

@synthesize delegate;

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame imgUpArray:(NSArray *)imguparray imgDownArray:(NSArray *)imgdownarray perRowNum:(int)perrownum
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canshowdownimg = YES;
        btnuparray = imguparray;
        btndownarray = imgdownarray;
        
        float itemsnum = [imguparray count];
        itemViewsArray = [[NSMutableArray alloc] initWithCapacity:itemsnum];
        int colm = perrownum;
        int row = ceil(itemsnum / colm);
        
        UIImage *img = [UIImage imageNamed:[imguparray objectAtIndex:0]];
        float imgwidth = img.size.width;
        float imgheight = img.size.height;
        //float imgdis = imgdistance + imgwidth;
        float imgdis_w;
        if (perrownum <= 1) {
            imgdis_w = 0;
        }else{
            imgdis_w = (self.frame.size.width + (self.frame.size.width - imgwidth*perrownum)/(perrownum-1))/perrownum;
        }
        float imgdis_h;
        if (row <= 1) {
            imgdis_h = 0;
        }else{
            imgdis_h = (self.frame.size.height + (self.frame.size.height - imgheight*row)/(row-1))/row;
        }
        
        for (int i = 0; i < itemsnum; i++) {
            UIButton *itemView = [[UIButton alloc] init];
            itemView.frame = CGRectMake(i%colm*imgdis_w, i/colm*imgdis_h, imgwidth, imgheight);
            itemView.adjustsImageWhenHighlighted = NO;
            itemView.tag = i;
            [itemView setBackgroundImage:[UIImage imageNamed:[imguparray objectAtIndex:i]] forState:UIControlStateNormal];
            [itemView setBackgroundImage:[UIImage imageNamed:[imgdownarray objectAtIndex:i]] forState:UIControlStateHighlighted];
            [itemView addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
            [itemView setExclusiveTouch:YES];
            [itemViewsArray addObject:itemView];
            [self addSubview:itemView];
        }
        self.selectedbtnnum = 0;
        //        [[itemViewsArray objectAtIndex:self.selectedbtnnum] setBackgroundImage:[UIImage imageNamed:[imgdownarray objectAtIndex:self.selectedbtnnum]] forState:UIControlStateNormal];
    }
    return self;
}

/**
 * 根据图片大小创建按钮大小，titlearray 为图片对应的按钮名称
 */
- (id)initWithFrame:(CGRect)frame imgUpArray:(NSArray *)imguparray imgDownArray:(NSArray *)imgdownarray perRowNum:(int)perrownum titleArray:(NSArray *)titlearray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canshowdownimg = YES;
        btnuparray = imguparray;
        btndownarray = imgdownarray;
        
        float itemsnum = [imguparray count];
        itemViewsArray = [[NSMutableArray alloc] initWithCapacity:itemsnum];
        int colm = perrownum;
        int row = ceil(itemsnum / colm);
        
        UIImage *img = [UIImage imageNamed:[imguparray objectAtIndex:0]];
        float imgwidth = img.size.width;
        float imgheight = img.size.height;
        //float imgdis = imgdistance + imgwidth;
        float imgdis_w;
        if (perrownum <= 1) {
            imgdis_w = 0;
        }else{
            imgdis_w = (self.frame.size.width + (self.frame.size.width - imgwidth*perrownum)/(perrownum-1))/perrownum;
        }
        float imgdis_h;
        if (row <= 1) {
            imgdis_h = 0;
        }else{
            imgdis_h = (self.frame.size.height + (self.frame.size.height - imgheight*row)/(row-1))/row;
        }
        
        for (int i = 0; i < itemsnum; i++) {
            UIButton *itemView = [[UIButton alloc] init];
            itemView.frame = CGRectMake(i%colm*imgdis_w, i/colm*imgdis_h, imgwidth, imgheight);
            itemView.adjustsImageWhenHighlighted = NO;
            itemView.tag = i;
            [itemView setBackgroundImage:[UIImage imageNamed:[imguparray objectAtIndex:i]] forState:UIControlStateNormal];
            [itemView setBackgroundImage:[UIImage imageNamed:[imgdownarray objectAtIndex:i]] forState:UIControlStateHighlighted];
            [itemView addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
            [itemView setExclusiveTouch:YES];
            [itemViewsArray addObject:itemView];
            [self addSubview:itemView];
            UILabel *itemLabel = [[UILabel alloc] init];
            itemLabel.frame = CGRectMake(itemView.frame.origin.x, itemView.frame.origin.y + itemView.frame.size.height, itemView.frame.size.width, 30);
            itemLabel.font = [UIFont systemFontOfSize:14];
            itemLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:0x33];
            itemLabel.textAlignment = NSTextAlignmentCenter;
            itemLabel.text = [titlearray objectAtIndex:i];
            [self addSubview:itemLabel];
        }
        self.selectedbtnnum = 0;
        //        [[itemViewsArray objectAtIndex:self.selectedbtnnum] setBackgroundImage:[UIImage imageNamed:[imgdownarray objectAtIndex:self.selectedbtnnum]] forState:UIControlStateNormal];
    }
    return self;
}


- (void)itemPressed:(UIButton *)sender{
    [[itemViewsArray objectAtIndex:self.selectedbtnnum] setBackgroundImage:[UIImage imageNamed:[btnuparray objectAtIndex:self.selectedbtnnum]] forState:UIControlStateNormal];

    self.selectedbtnnum = [sender tag];
    if (self.canshowdownimg) {
        [[itemViewsArray objectAtIndex:self.selectedbtnnum] setBackgroundImage:[UIImage imageNamed:[btndownarray objectAtIndex:self.selectedbtnnum]] forState:UIControlStateNormal];
    }
    
    [delegate GridMenuViewButtonSelected:sender.tag selfTag:self.tag];
}



- (id)initWithFrame:(CGRect)frame imgUpName:(NSString *)imgupname imgDownName:(NSString *)imgdownname titleArray:(NSArray *)titlearray titleDownColor:(UIColor *)titledowncolor titleUpColor:(UIColor *)titleupcolor perRowNum:(int)perrownum
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canshowdownimg = NO;
        
        float itemsnum = [titlearray count];
        itemViewsArray = [[NSMutableArray alloc] initWithCapacity:itemsnum];
        int colm = perrownum;
        int row = ceil(itemsnum / colm);
        
        UIImage *img = [UIImage imageNamed:imgdownname];
        float imgwidth = img.size.width;
        float imgheight = img.size.height;
        //imgdis = imgdistance + imgwidth;
        float imgdis_w;
        if (perrownum <= 1) {
            imgdis_w = 0;
        }else{
            imgdis_w = (self.frame.size.width + (self.frame.size.width - imgwidth*perrownum)/(perrownum-1))/perrownum;
        }
        float imgdis_h;
        if (row <= 1) {
            imgdis_h = 0;
        }else{
            imgdis_h = (self.frame.size.height + (self.frame.size.height - imgheight*row)/(row-1))/row;
        }
        
//        posx = self.frame.size.width/2 - (colm*imgwidth+(colm-1)*(imgdis_w + imgwidth))/2 - imgwidth/2;
//        posy = -imgheight/2;
        
        for (int i = 0; i < itemsnum; i++) {
            UIButton *itemView = [[UIButton alloc] init];
            itemView.frame = CGRectMake(i%colm*imgdis_w, i/colm*imgdis_h, imgwidth, imgheight);
            itemView.adjustsImageWhenHighlighted = NO;
            itemView.tag = i;
            [itemView setBackgroundImage:[UIImage imageNamed:imgupname] forState:UIControlStateNormal];
            [itemView setBackgroundImage:[UIImage imageNamed:imgdownname] forState:UIControlStateHighlighted];
            itemView.titleLabel.font = [UIFont systemFontOfSize:14];
            [itemView setTitle:[titlearray objectAtIndex:i] forState:UIControlStateNormal];
            [itemView setTitleColor:titleupcolor forState:UIControlStateNormal];
            [itemView setTitleColor:titledowncolor forState:UIControlStateHighlighted];
            [itemView addTarget:self action:@selector(itemPressedDelegate:) forControlEvents:UIControlEventTouchUpInside];
            [itemView setExclusiveTouch:YES];
            [itemViewsArray addObject:itemView];
            [self addSubview:itemView];
            
            
        }
        myTitledowncolor = titledowncolor;
        myTitleupcolor = titleupcolor;
        self.selectedbtnnum = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame imgUpName:(NSString *)imgupname imgDownName:(NSString *)imgdownname titleArray:(NSArray *)titlearray titleDownColor:(UIColor *)titledowncolor titleUpColor:(UIColor *)titleupcolor perRowNum:(int)perrownum andCanshowHighlight:(BOOL)showhight
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.canshowdownimg = showhight;
        
        float itemsnum = [titlearray count];
        itemViewsArray = [[NSMutableArray alloc] initWithCapacity:itemsnum];
        int colm = perrownum;
        int row = ceil(itemsnum / colm);
        
        UIImage *img = [UIImage imageNamed:imgdownname];
        float imgwidth = img.size.width;
        float imgheight = img.size.height;
        //imgdis = imgdistance + imgwidth;
        float imgdis_w;
        if (perrownum <= 1) {
            imgdis_w = 0;
        }else{
            imgdis_w = (self.frame.size.width + (self.frame.size.width - imgwidth*perrownum)/(perrownum-1))/perrownum;
        }
        float imgdis_h;
        if (row <= 1) {
            imgdis_h = 0;
        }else{
            imgdis_h = (self.frame.size.height + (self.frame.size.height - imgheight*row)/(row-1))/row;
        }
        
        //        posx = self.frame.size.width/2 - (colm*imgwidth+(colm-1)*(imgdis_w + imgwidth))/2 - imgwidth/2;
        //        posy = -imgheight/2;
        
        for (int i = 0; i < itemsnum; i++) {
            
            
            UIButton *itemView = [[UIButton alloc] init];
            itemView.frame = CGRectMake(i%colm*imgdis_w, i/colm*imgdis_h, imgdis_w, imgheight);
            itemView.adjustsImageWhenHighlighted = NO;
            itemView.tag = i;
            [itemView setBackgroundImage:[UIImage imageNamed:imgupname] forState:UIControlStateNormal];
            [itemView setBackgroundImage:[UIImage imageNamed:imgdownname] forState:UIControlStateHighlighted];
            [itemView setBackgroundImage:[UIImage imageNamed:imgdownname] forState:UIControlStateSelected];
            itemView.titleLabel.font = [UIFont systemFontOfSize:12];
            [itemView setTitle:[titlearray objectAtIndex:i] forState:UIControlStateNormal];
            [itemView setTitleColor:titleupcolor forState:UIControlStateNormal];
            [itemView setTitleColor:titledowncolor forState:UIControlStateHighlighted];
            [itemView addTarget:self action:@selector(itemPressedDelegate:) forControlEvents:UIControlEventTouchUpInside];
            [itemView setExclusiveTouch:YES];
            [itemViewsArray addObject:itemView];
            [self addSubview:itemView];
//            
//            if (i == 0)
//            {
//                UIView *spliteView = [[UIView alloc] initWithFrame:CGRectMake(0+1, 5, 1, 13)];
//                [self addSubview:spliteView];
//                [spliteView setBackgroundColor:[UIColor grayColor]];
//            }
//            else
//            {
//                UIView *spliteView = [[UIView alloc] initWithFrame:CGRectMake(i%colm*imgdis_w, 5, 1, 13)];
//                [self addSubview:spliteView];
//                [spliteView setBackgroundColor:[UIColor grayColor]];
//            }
//            
//            if (i == itemsnum - 1)
//            {
//                int k = (int)itemsnum;
//                UIView *spliteView = [[UIView alloc] initWithFrame:CGRectMake(k*imgdis_w - 1, 5, 1, 13)];
//                [self addSubview:spliteView];
//                [spliteView setBackgroundColor:[UIColor grayColor]];
//            }
            
        }
        myTitledowncolor = titledowncolor;
        myTitleupcolor = titleupcolor;
        self.selectedbtnnum = 0;
        
        
        if (self.canshowdownimg)
        {
            [[itemViewsArray objectAtIndex:self.selectedbtnnum] setTitleColor:myTitledowncolor forState:UIControlStateNormal];
        }
    }
    return self;
}

- (void)itemPressedDelegate:(UIButton *)sender{
    [[itemViewsArray objectAtIndex:self.selectedbtnnum] setTitleColor:myTitleupcolor forState:UIControlStateNormal];
    self.selectedbtnnum = [sender tag];
    if (self.canshowdownimg) {
        for ( UIButton *btn in itemViewsArray) {
            [btn setSelected:NO];
        }
        [sender setSelected:YES];
        [[itemViewsArray objectAtIndex:self.selectedbtnnum] setTitleColor:myTitledowncolor forState:UIControlStateNormal];
    }
    [delegate GridMenuViewButtonSelected:sender.tag selfTag:self.tag];
}


- (id)initWithFrame:(CGRect)frame imgURLArray:(NSArray *)imgurlarray imgSize:(CGSize)imgsize imgDefault:(NSString *)imgdefault perRowNum:(int)perrownum{
    self = [super initWithFrame:frame];
    if (self) {
        self.canshowdownimg = YES;
        
        float itemsnum = [imgurlarray count];
        itemViewsArray = [[NSMutableArray alloc] initWithCapacity:itemsnum];
        int colm = perrownum;
        int row = ceil(itemsnum / colm);
        
        float imgwidth = imgsize.width;
        float imgheight = imgsize.height;
        
        float imgdis_w;
        if (perrownum <= 1) {
            imgdis_w = 0;
        }else{
            imgdis_w = (self.frame.size.width + (self.frame.size.width - imgwidth*perrownum)/(perrownum-1))/perrownum;
        }
        float imgdis_h;
        if (row <= 1) {
            imgdis_h = 0;
        }else{
            imgdis_h = (self.frame.size.height + (self.frame.size.height - imgheight*row)/(row-1))/row;
        }
        
        for (int i = 0; i < itemsnum; i++) {
            UIImageView *itemimgview = [[UIImageView alloc] initWithFrame:CGRectMake(i%colm*imgdis_w, i/colm*imgdis_h, imgwidth, imgheight)];
            if (![ShowBox isEmptyString:[imgurlarray objectAtIndex:i]]) {
                [itemimgview setImageWithURL:[NSURL URLWithString:[imgurlarray objectAtIndex:i]]
                            placeholderImage:[UIImage imageNamed:imgdefault]];
            }else{
                itemimgview.image = [UIImage imageNamed:imgdefault];
            }
            [self addSubview:itemimgview];

            UIButton *itemView = [[UIButton alloc] init];
            itemView.frame = CGRectMake(i%colm*imgdis_w, i/colm*imgdis_h, imgwidth, imgheight);
            itemView.adjustsImageWhenHighlighted = NO;
            itemView.tag = i;
            [itemView addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
            [itemView setExclusiveTouch:YES];
            [itemViewsArray addObject:itemView];
            [self addSubview:itemView];
        }
        self.selectedbtnnum = 0;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end