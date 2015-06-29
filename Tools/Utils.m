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
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"-－ （）()联系方式            "];
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
    baseButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [baseButton setTitle:string forState:UIControlStateNormal];
    [baseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [baseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    baseButton.backgroundColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
    baseButton.layer.cornerRadius = 5.0;
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

+(NSInteger)getTextFieldActualLengthWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSInteger textLength = 0;
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        textLength = textField.text.length;
    }
    if (string.length > 0) {
        //输入状态
        if (textField.text.length > range.location) {       //候选词替换高亮拼音时
            NSString *newStr = [NSString stringWithFormat:@"%@%@",[textField.text substringToIndex:range.location],
                                string];
            textLength = newStr.length;
        }else {
            textLength += string.length;
        }
    }else {
        //删除状态
        if (textField.text.length > 0) {
            textLength = [[textField.text substringToIndex:range.location]length];
        }
    }
    
    return textLength;
    
}


+(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

+(NSArray *)getImageArrWithImgName:(NSString *)imgName andMaxIndex:(NSUInteger )index
{
    NSMutableArray * imgs = [NSMutableArray array];
    for ( NSUInteger i = 0 ; i <= index ; i ++ ) {
        NSString *imgStr = [NSString stringWithFormat:@"%@%lu.png",imgName,(unsigned long)i];
        [imgs addObject:imgStr];
    }
    return imgs;
}

#pragma mark - 定制数字高亮的attributedString
/**
 *  定制数字高亮的attributedString
 *  采用默认设置的颜色
 *  @param sourceStr 源文字
 *  @param hightStr  高亮文字
 *
 *  @return
 */
+ (NSAttributedString *)getAttributedString:(NSString *)sourceStr andHightlightString:(NSString *)hightStr
{
    NSMutableAttributedString *resultStr = [[NSMutableAttributedString alloc] initWithString:sourceStr];
    [resultStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, sourceStr.length)];
    
    NSRange range = [sourceStr rangeOfString:hightStr options:NSBackwardsSearch];
    
    if (range.location != NSNotFound)
    {
        [resultStr setAttributes:@{NSForegroundColorAttributeName:[Utils getRGBColor:0xff g:0x65 b:0x21 a:1.0]} range:range];
    }
    //设置字体
    
    
    return resultStr;
}

#pragma mark - 定制特殊 状态的 高亮字段
+ (NSAttributedString *)getAttributedString:(NSString *)sourceStr hightlightString:(NSString *)hightStr hightlightColor:(UIColor *)color andFont:(UIFont*)font
{
     NSMutableAttributedString *resultStr = [[NSMutableAttributedString alloc] initWithString:sourceStr];
    [resultStr setAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, sourceStr.length)];
    NSRange range = [sourceStr rangeOfString:hightStr options:NSBackwardsSearch];
    if (range.location != NSNotFound)
    {
        [resultStr setAttributes:@{NSForegroundColorAttributeName:color} range:range];
    }
    
    return resultStr;
}

#pragma mark 获取中文字符串转码utf8
+ (NSString*) getEncodingWithUTF8:(NSString *)_str
{
    return [_str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - 从NSString中 取出 数字
+ (NSInteger)findNumFormOriginalStr:(NSString *)originalStr
{
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:originalStr];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    while ( ![scanner isAtEnd] ) {
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [numberString appendString:tempStr];
        tempStr = @"";
    }
    
    NSInteger number = [numberString integerValue];
    
    return number;
}

#pragma mark - 从数组中取出 首字母相同key字典 归类
+ (NSArray *)findSameKeyWithArray:(NSArray *)originalArray
{
    // 1、对数组按firstcharter排序
    NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstcharter" ascending:YES]];
    NSArray *sortedArr = [originalArray sortedArrayUsingDescriptors:sortDesc];
//    NSLog(@"排序后的数组:%@",sortedArr);
    
    // 2、对数组进行分组，按firstcharter
    // 遍历,创建组数组,组数组中的每一个元素是一个模型数组
    NSMutableArray *_groupArr = [NSMutableArray array];
    NSMutableArray *currentArr = [NSMutableArray array];
//    NSLog(@"class--%@",[currentArr class]);
    // 因为肯定有一个字典返回,先添加一个
    [currentArr addObject:sortedArr[0]];
    [_groupArr addObject:currentArr];
    // 如果不止一个,才要动态添加
    if(sortedArr.count > 1){
        for (int i = 1; i < sortedArr.count; i++) {
            // 先取出组数组中  上一个模型数组的第一个字典模型的firstcharter
            NSMutableArray *preModelArr = [_groupArr objectAtIndex:_groupArr.count-1];
            NSString *preFirstchar = [[preModelArr objectAtIndex:0] objectForKey:@"firstcharter"];
            // 取出当前字典,根据firstcharter比较,如果相同则添加到同一个模型数组;如果不相同,说明不是同一个组的
            NSDictionary *currentDict = sortedArr[i];
            NSString *firstchar = [currentDict objectForKey:@"firstcharter"];
            if ( [firstchar isEqualToString:preFirstchar] ) {
                [currentArr addObject:currentDict];
            }else{
                // 如果不相同,说明 有新的一组,那么创建一个模型数组,并添加到组数组_groupArr
                currentArr = [NSMutableArray array];
                [currentArr addObject:currentDict];
                [_groupArr addObject:currentArr];
            }
        }
    }
//    NSLog(@"分组后的数组 %@",_groupArr);
    return _groupArr;
}



@end
