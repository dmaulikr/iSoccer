//
//  LoginViewController.h
//  iSoccer
//
//  Created by pfg on 15/12/16.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WeiboSDK.h"


@interface LoginViewController : UIViewController<TencentSessionDelegate>
- (void)enterMainView;

@property (nonatomic, retain)TencentOAuth *oauth;
@end
