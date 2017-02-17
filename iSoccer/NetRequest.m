//
//  NetRequest.m
//  iSoccer
//
//  Created by pfg on 15/12/15.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import "NetRequest.h"
#import "AFNetworking.h"
#import "Global.h"
#import "OpenUDID.h"
#import "MBProgressHUD.h"
#import "NetDataNameConfig.h"

@implementation NetRequest

+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters atView:(UIView*)view andHUDMessage:(NSString*)message success:(void(^)(id resposeObject)) success failure:(void(^)(NSError *error)) failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html", nil];
    
    [Global getInstance].HUD.labelText = message;
    [view addSubview:[Global getInstance].HUD];
    [[Global getInstance].HUD show:YES];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    [manager GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        [[Global getInstance].HUD hide:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [Global alertWithTitle:@"提示" msg:error.localizedDescription];
            failure(error);
        }
        [[Global getInstance].HUD hide:YES];
    }];
}

+ (void)POST:(NSString *)url parameters:(NSMutableDictionary *)parameters atView:(UIView*)view  andHUDMessage:(NSString*)message success:(void(^)(id resposeObject)) success failure:(void(^)(NSError *error)) failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html", nil];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    
    
    NSString *udid = [OpenUDID value];
    
   // NSString *udid = @"e0bbdbd23d4d23169ce8d2d2d5e31e8471928875";
    
    [parameters setValue:udid forKey:UUID];
    
    UserData * user = [Global getInstance].userData;
    
    [parameters setValue:user.userId forKey:USER_ID];
    
    if(view != nil)
    {
        [Global getInstance].HUD.labelText = message;
        [view addSubview:[Global getInstance].HUD];
        [[Global getInstance].HUD show:YES];
    }
    
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        if (success) {
            
            NSString *code = responseObject[@"code"];
            NSString *msg = responseObject[@"msg"];
            
            //NSLog(@"%@",msg);
            
            if(code.integerValue == 1)
            {
                success(responseObject);
            }else if(code.integerValue == 2)
            {
                //[Global alertWithTitle:@"提示" msg:msg];
                //处理弹出登陆界面;
                
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ACCOUNT_SAVE];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:PASSWORD_SAVE];
                success(responseObject);
            }else if(code.integerValue == 3)
            {
                success(responseObject);
            }
            else{
                [Global alertWithTitle:@"提示" msg:msg];
            }
        }
        [[Global getInstance].HUD hide:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            [Global alertWithTitle:@"提示" msg:error.localizedDescription];
            failure(error);
        }
        [[Global getInstance].HUD hide:YES];
    }];
}
@end