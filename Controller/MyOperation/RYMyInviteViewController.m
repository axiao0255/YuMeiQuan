//
//  RYMyInviteViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/6.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyInviteViewController.h"


@interface RYMyInviteViewController ()<GridMenuViewDelegate,UMSocialUIDelegate>
{
    NSArray  *ic_invite_array;
}
@end

@implementation RYMyInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请注册";
    self.view.backgroundColor = [Utils  getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
    ic_invite_array = [self setIcons];
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 获取 邀请 icon
- (NSArray *)setIcons
{
    NSArray  *icons = [Utils getImageArrWithImgName:@"ic_invite_share" andMaxIndex:4];
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    [tmpArr addObject:[icons subarrayWithRange:NSMakeRange(0, 3)]];
    [tmpArr addObject:[icons subarrayWithRange:NSMakeRange(3, 2)]];
    return tmpArr;
}

- (void)initSubviews
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 380)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(106, 24, 164, 164)];
    iconImageView.image = [UIImage imageNamed:@"ic_Invite.png"];
    [view addSubview:iconImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(55, 166, SCREEN_WIDTH - 110, 13)];
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [Utils getRGBColor:0x00 g:0x91 b:0xea a:1.0];
    label.text = @"邀请同行注册，邀请成功可获得50积分";
    [view addSubview:label];
    
    GridMenuView *invite_View1 = [[GridMenuView alloc] initWithFrame:CGRectMake(62, CGRectGetMaxY(label.frame) + 32, SCREEN_WIDTH - 124, 60)
                                                          imgUpArray:[ic_invite_array objectAtIndex:0]
                                                        imgDownArray:[ic_invite_array objectAtIndex:0]
                                                           perRowNum:3];
    invite_View1.tag = 100;
    invite_View1.delegate = self;
    invite_View1.backgroundColor = [UIColor clearColor];
    [view addSubview:invite_View1];
    
    GridMenuView *invite_View2 = [[GridMenuView alloc] initWithFrame:CGRectMake(62, CGRectGetMaxY(invite_View1.frame) + 8, SCREEN_WIDTH - 124, 60)
                                                          imgUpArray:[ic_invite_array objectAtIndex:1]
                                                        imgDownArray:[ic_invite_array objectAtIndex:1]
                                                           perRowNum:2];
    invite_View2.tag = 200;
    invite_View2.delegate = self;
    invite_View2.backgroundColor = [UIColor clearColor];
    [view addSubview:invite_View2];
}

#pragma mark - GridMenuViewDelegate
-(void)GridMenuViewButtonSelected:(int)btntag selfTag:(int)selftag
{
     NSUInteger index;
    if ( selftag == 100 ) {
        index = btntag;
    }
    else {
        if ( btntag == 0 ) {
            index = 3;
        }
        else{
            index = 4;
        }
    }
    [self shareWithIndex:index];
}

-(void)shareWithIndex:(NSUInteger) index
{    
    //设置微信好友或者朋友圈的分享url,下面是微信好友，微信朋友圈对应wechatTimelineData
    NSString *snsType = UMShareToWechatSession;
    switch ( index ) {
        case 0:
            snsType = UMShareToWechatSession;
            break;
        case 1:
            snsType = UMShareToWechatTimeline;
            break;
        case 2:
            snsType = UMShareToQQ;
            break;

        case 3:
            snsType = UMShareToSms;
            break;

        case 4:
            snsType = UMShareToSina;
            break;
        default:
            break;
    }
//    NSString *contentText = [NSString stringWithFormat:@" %@ %@ （医美圈·医学美容时讯）",self.bodyModel.subject,shareUrl];
    NSString *contentText = @"分享哈哈哈";
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[snsType] content:contentText image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [ShowBox showSuccess:@"分享成功"];
        }
    }];
}



@end
