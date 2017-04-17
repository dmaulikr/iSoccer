//
//  AppDelegate.h
//  iSoccer
//
//  Created by pfg on 15/10/27.
//  Copyright © 2015年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WXApi.h"
#import "WeiboSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,WeiboSDKDelegate>
{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
}

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

@end

