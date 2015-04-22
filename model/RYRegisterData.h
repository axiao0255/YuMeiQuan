//
//  RYRegisterData.h
//  YuMeiQuan
//
//  Created by Jason on 15/4/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYRegisterData : NSObject

// 个人用户 注册
@property (nonatomic , strong) NSString      *userPhone;             // 收手机号码
@property (nonatomic , strong) NSString      *userSecurityCode;      // 验证码
@property (nonatomic , strong) NSString      *userPassword;          // 密码
@property (nonatomic , strong) NSString      *userRepetPassword;     // 重复密码
@property (nonatomic , strong) NSString      *userRofessional;       // 医生专业
@property (nonatomic , strong) NSString      *userIdentity;          // 不是医生时      用户的专业
@property (nonatomic , strong) NSString      *userName;              // 姓名
@property (nonatomic , strong) NSString      *userPosition;          // 职位
@property (nonatomic , strong) NSString      *userOrdinaryPosition;  // 不是医生 用户的 职务
@property (nonatomic , strong) NSString      *userCompany;           // 单位

@property (nonatomic , strong) NSArray       *doctorSpecialtyArray;   // 医生 临床专业
@property (nonatomic , strong) NSArray       *ordinarySpecialtyArray; // 普通专业
@property (nonatomic , strong) NSArray       *doctorPositionArray;    // 医生职务数组
@property (nonatomic , strong) NSArray       *ordinaryPositionArray;  // 不是医生 职务数组

// 企业用户 注册
@property (nonatomic , strong) NSArray       *companyTypeArray;       // 企业类型 数组

@property (nonatomic , strong) NSString      *companyType;            // 选择的后的企业类型
@property (nonatomic , strong) NSString      *companyName;            // 企业名称
@property (nonatomic , strong) NSString      *companyContactPerson;   // 企业联系人
@property (nonatomic , strong) NSString      *companyPhone;           // 企业电话
@property (nonatomic , strong) NSString      *companyEmail;           // 企业邮箱

@end
