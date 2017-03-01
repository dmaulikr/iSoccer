//
//  AppDelegate.m
//  iSoccer
//
//  Created by pfg on 15/10/27.
//  Copyright © 2015年 iSoccer. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MenuTableViewController.h"
#import "REFrostedViewController.h"
#import "Global.h"
#import "NetConfig.h"
#import "NetRequest.h"
#import "MainViewController.h"
#import "Reachability.h"
#import "NetRequest.h"
#import "OpenUDID.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UMessage.h"
#import <TencentOpenAPI/TencentOAuth.h>

#define kAppKey @"1324390234"
#define kAppSecret          @"36a1ef0873fe3574b5268753bd38e8c9"
#define kRedirectURI @"http://www.sina.com"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@interface AppDelegate ()
{
    MainViewController * mainNavigationVC;
    MenuTableViewController * menuVC;
}

@end

@implementation AppDelegate


@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [NSThread sleepForTimeInterval:3.0];
    
    [WeiboSDK registerApp:kAppKey];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setOpaque:1.0];
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    mainNavigationVC = [[MainViewController alloc]init];
    
    [Global getInstance].mainVC = mainNavigationVC;
    
    menuVC = [[MenuTableViewController alloc]initWithStyle:UITableViewStylePlain];
    
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:mainNavigationVC menuViewController:menuVC];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    
    // Make it a root controller
    //
    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    
    
    //判断是否由远程消息通知触发应用程序启动
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil) {
        //获取应用程序消息通知标记数（即小红圈中的数字）
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge>0) {
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            badge = 0;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        }

    }
    
    
#ifdef __IPHONE_8_0
    //ios8注册推送
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound
        |UIRemoteNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#else
    //register to receive notifications
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    
    
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            [Global alertWithTitle:@"提示" msg:@"未检测到网络连接!"];
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            break;
    }
    
    [WXApi registerApp:@"wx72d476f91da4162f"];
    
    
    [UMessage startWithAppkey:@"56f0b28b67e58e3bfa000094" launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];

    [UMessage setLogEnabled:YES];
    
    
    return YES;
}



- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
   
        NSString * uid = response.userInfo[@"uid"];
        NSString * accessToken = response.userInfo[@"access_token"];
        
        if(uid != nil && accessToken != nil)
        {
            NSString *udid = [OpenUDID value];
            NSString * deviceNumber = [Global getInstance].diviceToken;
            
            LoginViewController * loginVC = [Global getInstance].loginView;
            
            NSString * GET_URL = [NSString stringWithFormat:@"%@?access_token=%@&uid=%@&uuid=%@&deviceNumber=%@",WEIBO_LOGIN,accessToken,uid,udid,deviceNumber];
            
            [NetRequest GET:GET_URL parameters:nil atView:loginVC.view andHUDMessage:@"登录中.." success:^(id resposeObject) {
                NSLog(@"haha ");
                [Global getInstance].isUpdate = YES;
                [Global getInstance].isLogin = YES;//设置已经登陆;
                [[Global getInstance] setGameDataByDictionary:resposeObject[@"data"]];
                
                
                NSString *openId = resposeObject[@"openId"];
                
                [[NSUserDefaults standardUserDefaults] setObject:openId forKey:@"openId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [Global getInstance].userData = [Global setUserDataByDictionary:resposeObject[@"user"]];
                
                [loginVC enterMainView];
                
            } failure:^(NSError *error) {
                NSLog(@"登陆失败");
            }];
        }
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        NSString *title = NSLocalizedString(@"支付结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if([response isKindOfClass:WBSDKAppRecommendResponse.class])
    {
        NSString *title = NSLocalizedString(@"邀请结果", nil);
        NSString *message = [NSString stringWithFormat:@"accesstoken:\n%@\nresponse.StatusCode: %d\n响应UserInfo数据:%@\n原请求UserInfo数据:%@",[(WBSDKAppRecommendResponse *)response accessToken],(int)response.statusCode,response.userInfo,response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }else if([response isKindOfClass:WBShareMessageToContactResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBShareMessageToContactResponse* shareMessageToContactResponse = (WBShareMessageToContactResponse*)response;
        NSString* accessToken = [shareMessageToContactResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [shareMessageToContactResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        [alert show];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#ifdef __IPHONE_8_0
//ios8需要调用内容
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

#endif


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    //获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
    NSString *pushToken = [[[[token description]
                             
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           
                           stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    
    NSLog(@"My token is:%@", pushToken);
    
    [Global getInstance].diviceToken = pushToken;
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    NSLog(@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
//    //以警告框的方式来显示推送消息
//    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"经过推送发送过来的消息"
//                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
//                                                       delegate:self
//                                              cancelButtonTitle:@"关闭"
//                                              otherButtonTitles:@"处理",nil];
//        [alert show];
//    }
    
    [Global getInstance].userData.messageCount += 1;
    [mainNavigationVC updateMessageCount];
    
    [menuVC updateMessageCount];
    
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    BOOL result = NO;
    result = [WXApi handleOpenURL:url delegate:self];
    if(result)
    {
        return result;
    }
    
    result = [TencentOAuth HandleOpenURL:url];
    if(result)
    {
        return result;
    }
    
    result = [WeiboSDK handleOpenURL:url delegate:self];
    
    if(result)
    {
        return result;
    }
    
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    BOOL result = NO;
    result = [WXApi handleOpenURL:url delegate:self];
    if(result)
    {
        return result;
    }
    
    result = [TencentOAuth HandleOpenURL:url];
    if(result)
    {
        return result;
    }
    
    result = [WeiboSDK handleOpenURL:url delegate:self];
    if(result)
    {
        return result;
    }
    
    return result;
}





-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];

    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%zu bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"提示"];
        
        NSString *strMsg;
        if(resp.errCode == 0)
        {
            strMsg = @"发送邀请成功!";
        }else{
            strMsg = @"发送邀请失败!";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        if(resp.errCode == 0)
        {
            NSLog(@"登陆成功");
            
            NSString *udid = [OpenUDID value];
            
            LoginViewController * loginVC = [Global getInstance].loginView;
            
            SendAuthResp * sendAuth= (SendAuthResp*)resp;
            
            
            NSString * GET_URL = [NSString stringWithFormat:@"%@%@&uuid=%@",WX_LOGIN,sendAuth.code,udid];
            
            [NetRequest GET:GET_URL parameters:nil atView:loginVC.view andHUDMessage:@"登录中.." success:^(id resposeObject) {
                NSLog(@"haha ");
                [Global getInstance].isUpdate = YES;
                [Global getInstance].isLogin = YES;//设置已经登陆;
                [[Global getInstance] setGameDataByDictionary:resposeObject[@"data"]];
                
                
                NSString *wxOpenId = resposeObject[@"openId"];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:wxOpenId forKey:@"openId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [Global getInstance].userData = [Global setUserDataByDictionary:resposeObject[@"user"]];
                
                [loginVC enterMainView];
                
            } failure:^(NSError *error) {
                NSLog(@"登陆失败");
            }];
            
        }else{
            NSLog(@"登陆失败");
        }
    }
    
    if([resp isKindOfClass:[PayResp class]])
    {
        NSLog(@"支付信息");
        if(resp.errCode == 0)
        {
            NSLog(@"支付成功");
            
            if([Global getInstance].isRecharge)
            {
                [[Global getInstance].rechargeVC WeixinPaySuccess];
            }else{
                [[Global getInstance].payFastVC WinxinPaySuccess];
            }
            
        }else{
            NSLog(@"支付失败");
        }
    }
}



// 是否wifi
+ (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}


@end
