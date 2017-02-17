//
//  NetRequest.h
//  iSoccer
//
//  Created by pfg on 15/12/15.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetRequest : NSObject
//GET请求
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters atView:(UIView*)view andHUDMessage:(NSString*)message success:(void(^)(id resposeObject)) success failure:(void(^)(NSError *error)) failure;

//POST请求
+ (void)POST:(NSString *)url parameters:(NSMutableDictionary *)parameters atView:(UIView*)view  andHUDMessage:(NSString*)message success:(void(^)(id resposeObject)) success failure:(void(^)(NSError *error)) failure;

@end
