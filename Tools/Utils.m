//
//  Utils.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "Utils.h"

@implementation Utils

#pragma mark gbk32中文char转码成nsstring
+ (NSString *)charToNSString:(char *)charstr{
    NSString *str = [NSString stringWithUTF8String:charstr];
    str = [str stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    return str;
}

+ (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (NSString*)appIdentifier{
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)bundlePath:(NSString *)fileName {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+ (NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}


+ (NSString *)tempPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"temp"];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (UIColor*) getRGBColor : (float) r g : (float) g b : (float) b a:(float)a
{
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

+ (NSString*) imageToBase64 : (UIImage*) _image
{
    if (!_image) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"base64" message:@"图片为空" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return @"";
    }
    NSData *imageData = UIImageJPEGRepresentation(_image, 1.0f);
    NSString *str = [GTMBase64 stringByEncodingData:imageData];
    return str;
}

#pragma mark 打电话
+(void)makeTelephoneCall:(NSString *)telePhone{
    if ([telePhone isEqualToString:@""] || [telePhone isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        //NSString *str = [telePhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"-－ （）()商场电话            "];
        NSString *str = [[telePhone componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString:@""];
        NSLog(@"makeTelephoneCall:%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",str]]];
    }else{
        [ShowBox showError:@"您的设备不提供拨打电话的功能！"];
    }
}

+(UIButton *)getCustomLongButton:(NSString *)string{
//    UIImage *image = [UIImage imageNamed:@"button_up.png"];
//    UIButton *baseButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, image.size.width, image.size.height)];
    UIButton *baseButton = [[UIButton alloc] initWithFrame: CGRectMake(10, 0, SCREEN_WIDTH - 20, 44)];
    baseButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [baseButton setTitle:string forState:UIControlStateNormal];
    //    [baseButton setTitleColor:[Utils getMiddleColor] forState:UIControlStateNormal];
    [baseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [baseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    baseButton.backgroundColor = [Utils getRGBColor:0x04 g:0xcb b:0x3c a:1.0];
    baseButton.layer.cornerRadius = 4.0;
//    [baseButton setBackgroundImage:[UIImage imageNamed:@"button_up.png"] forState:UIControlStateNormal];
//    [baseButton setBackgroundImage:[UIImage imageNamed:@"button_up.png"] forState:UIControlStateHighlighted];
    [baseButton setExclusiveTouch:YES];
    return baseButton;
}

+(UITextField *)getCustomLongTextField:(NSString *)string{
    UIImage *image = [UIImage imageNamed:@"input_text_bk_long.png"];
    UITextField *baseTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [baseTextField setBackgroundColor:[UIColor clearColor]];
    [baseTextField setFont:[UIFont systemFontOfSize:14]];
//    [baseTextField setTextColor:[Utils getLightDarkColor]];
    [baseTextField setTextColor:[Utils getRGBColor:70.0 g:70.0 b:70.0 a:1.0]];
    [baseTextField setPlaceholder:string];
    baseTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [baseTextField setBorderStyle:UITextBorderStyleNone];
    baseTextField.background = image;
    [baseTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    baseTextField.leftView = paddingView;
    baseTextField.leftViewMode = UITextFieldViewModeAlways;
    baseTextField.returnKeyType = UIReturnKeyDone;
    
    return baseTextField;
}

+ (UIView *)getCellPartingLine
{
//    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,0.5)];
//    line.backgroundColor = [UIColor clearColor];
//    line.image = [UIImage imageNamed:@"cell_partingLine.png"];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 20, 0.5)];
    line.backgroundColor = [Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0];
    
    return line;
}








@end
