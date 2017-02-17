//
//  ZFBViewController.m
//  iSoccer
//
//  Created by pfg on 16/2/2.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "ZFBViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Global.h"
#import "NetConfig.h"
#import "PaySuccessViewController.h"
@interface ZFBViewController ()<UIWebViewDelegate>
{
    
    IBOutlet UIWebView *payWebView;
}

@end



@implementation ZFBViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    if([Global getInstance].isPaySuccessed == YES)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    payWebView.hidden = YES;
    
}

- (void)rechargetWithMoney:(NSString*)money
{
    NSString * userId = [Global getInstance].userData.userId;
    
    NSString * accountId = [Global getInstance].currentAccountId;
    
    NSString * getUrl = [NSString stringWithFormat:@"%@?userId=%@&money=%@&accountId=%@",RECHARGE_MONEY,userId,money,accountId];
    
    [self loadWithUrlStr:getUrl];
}

- (void)loadWithUrlStr:(NSString*)urlStr
{
    
    if (urlStr.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                        cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                    timeoutInterval:30];
            [payWebView loadRequest:webRequest];
        });
    }
}

- (void)payWithUrlOrder:(NSString*)urlOrder
{
    if (urlOrder.length > 0) {
        //__weak ZFBViewController* wself = self;
        [[AlipaySDK defaultService]payUrlOrder:urlOrder fromScheme:@"isoccer" callback:^(NSDictionary* result) {
            // 处理支付结果
            NSLog(@"%@", result);
            // isProcessUrlPay 代表 支付宝已经处理该URL
            if ([result[@"isProcessUrlPay"] boolValue]) {
                // returnUrl 代表 第三方App需要跳转的成功页URL
                //NSString* urlStr = result[@"returnUrl"];
                //[wself loadWithUrlStr:urlStr];
                
                NSString * code = result[@"resultCode"];
                if(code.integerValue == 9000)
                {
                    PaySuccessViewController * successVC = [[UIStoryboard storyboardWithName:@"PayAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"success"];
                    
                    [self.navigationController pushViewController:successVC animated:YES];
                    
                    [Global getInstance].isPaySuccessed = YES;
                }else{
                    NSLog(@"支付失败");
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
}


#pragma mark -- UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* orderInfo = [[AlipaySDK defaultService]fetchOrderInfoFromH5PayUrl:[request.URL absoluteString]];
    if (orderInfo.length > 0) {
        [self payWithUrlOrder:orderInfo];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    //显示WebView;
    payWebView.hidden = NO;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{

}


@end
