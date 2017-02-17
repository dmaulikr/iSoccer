//
//  UserData.h
//  iSoccer
//
//  Created by pfg on 16/1/4.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (nonatomic,strong)NSString *userId;

@property (nonatomic,strong)NSString *userName;

@property (nonatomic,strong)NSString *age;

@property (nonatomic,strong)NSString *sex;

@property (nonatomic,strong)NSString *nationality;

@property (nonatomic,strong)NSString *phoneNumber;

@property (nonatomic,strong)NSString *weight;

@property (nonatomic,strong)NSString *height;

@property (nonatomic,strong)NSString *remark;

@property (nonatomic,strong)NSString *avatarUrl;

@property (nonatomic,strong)NSString *email;

@property (nonatomic,strong)NSString *position;

@property (nonatomic,strong)NSString *deviceNumber;

@property (nonatomic,assign)NSInteger messageCount;

@property (nonatomic,strong)NSString *bindingMobile;

@end
