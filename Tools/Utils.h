//
//  Utils.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import "GTMBase64.h"
#import "ShowBox.h"

@interface Utils : NSObject

#pragma mark gbk32中文char转码成nsstring
+ (NSString *)charToNSString:(char *)charstr;

#pragma mark md5加密
+ (NSString *)md5:(NSString *)str;

#pragma mark base64
+ (NSString*)base64forData:(NSData*)theData;

#pragma mark 获取app bundle id
+ (NSString*)appIdentifier;

#pragma mark 获取bundle目录
+ (NSString *)bundlePath:(NSString *)fileName;

#pragma mark 获取document目录
+ (NSString *)documentsPath:(NSString *)fileName;

#pragma mark 获取临时目录
+ (NSString *)tempPath:(NSString *)fileName;

#pragma mark 获取UIColor
+ (UIColor *) getRGBColor : (float) r g : (float) g b : (float) b a : (float) a;

#pragma mark 图片转base64
+ (NSString *) imageToBase64 : (UIImage*) _image;

#pragma mark 打电话
+(void)makeTelephoneCall:(NSString *)telePhone;

#pragma mark 定制长的按钮
+(UIButton *)getCustomLongButton:(NSString *)string;

#pragma mark 定制长的输入框
+(UITextField *)getCustomLongTextField:(NSString *)string;

#pragma mark cell 分割线
+(UIView *)getCellPartingLine;

#pragma mark textField 输入长度 计算
+(NSInteger)getTextFieldActualLengthWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

#pragma mark  隐藏 UITableViewCell 多余部分的 分割线
+(void)setExtraCellLineHidden: (UITableView *)tableView;

#pragma mark 连续的获取本地图片数组
+(NSArray *)getImageArrWithImgName:(NSString *)imgName andMaxIndex:(NSUInteger )index;

#pragma mark - 定制数字高亮的attributedString
+ (NSAttributedString *)getAttributedString:(NSString *)sourceStr andHightlightString:(NSString *)hightStr;

#pragma mark - 定制特殊 状态的 高亮字段
+ (NSAttributedString *)getAttributedString:(NSString *)sourceStr hightlightString:(NSString *)hightStr hightlightColor:(UIColor *)color andFont:(UIFont*)font;

#pragma mark 获取中文字符串转码utf8
+ (NSString*) getEncodingWithUTF8:(NSString *)_str;




@end
