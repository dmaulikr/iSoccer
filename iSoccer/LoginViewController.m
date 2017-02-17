//
//  LoginViewController.m
//  iSoccer
//
//  Created by pfg on 15/12/16.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import "LoginViewController.h"
#import "NetConfig.h"
#import "NetRequest.h"
#import "Global.h"
#import "WXApi.h"

#import "sdkDef.h"
#import "OpenUDID.h"
#define QQ_APPID @"1105853276"

#define kRedirectURI @"http://www.sina.com"

@interface LoginViewController ()
{
    
    IBOutlet UITextField *accountText;
    IBOutlet UITextField *passwordText;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *wxLoginButton;
    __weak IBOutlet UIButton *qqLoginButton;
    __weak IBOutlet UIButton *wbLoginButton;
    __weak IBOutlet UIButton *forgetPasswordButton;
    __weak IBOutlet UIButton *registerButton;
    __weak IBOutlet UILabel *otherLoginLabel;
}

@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated{
    NSString * account = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_SAVE];
    
    NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_SAVE];
    
    
    if(account != nil)
    {
        accountText.text = account;
    }
    if(password != nil)
    {
        passwordText.text = password;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    accountText.placeholder = @"请输入账号";
    [accountText setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];//设置placeholder颜色代码；

    
    passwordText.placeholder = @"请输入密码";
    [passwordText setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];

    [loginButton addTarget:self action:@selector(tapLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if([WXApi isWXAppInstalled] == NO){
        wxLoginButton.hidden = YES;
    }
    if([TencentOAuth iphoneQQInstalled] == NO)
    {
        qqLoginButton.hidden = YES;
    }
    
    if([WeiboSDK isWeiboAppInstalled] == NO)
    {
        wbLoginButton.hidden = YES;
    }
    if(wxLoginButton.hidden == YES && qqLoginButton.hidden == YES && wbLoginButton.hidden == YES)
    {
        otherLoginLabel.hidden = YES;
    }

    
    [Global addTextBottomLineAtButton:forgetPasswordButton andText:forgetPasswordButton.titleLabel.text andTextColor:forgetPasswordButton.titleLabel.textColor];
    
    [Global addTextBottomLineAtButton:registerButton andText:registerButton.titleLabel.text andTextColor:registerButton.titleLabel.textColor];
}



- (IBAction)wbLoginHandler:(id)sender {
    //微信登录;
    
    [Global getInstance].isOtherLogin = YES;
    
    [Global getInstance].otherType = @"wb";
    
    [self WeiBoLogin];
}
//QQ登录
- (IBAction)qqLoginHandler:(id)sender {
    [Global getInstance].isOtherLogin = YES;
    
    [Global getInstance].otherType = @"qq";
    
    [self QQlogin];
}
//微信登陆;
- (IBAction)wxLoginHandler:(id)sender {
    [Global getInstance].isOtherLogin = YES;
    
    [Global getInstance].otherType = @"wx";
    
    [self sendAuthRequest];
}

-(void)sendAuthRequest
{
    //[WXApi ]
    if([WXApi isWXAppInstalled] == NO)
    {
        [Global alertWithTitle:@"提示" msg:@"您未安装微信!"];
        return;
    }
    
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    
}

//微博登录
- (void)WeiBoLogin
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;

    request.scope = @"all";
    request.userInfo = @{};
    [WeiboSDK sendRequest:request];
}

//QQ登录
- (void)QQlogin
{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            nil];
    
    _oauth = [[TencentOAuth alloc]initWithAppId:QQ_APPID andDelegate:self];

    [_oauth authorize:permissions inSafari:NO];
}

- (void)tapLoginButton:(UIButton*)sender{
    //NSLog(@"登陆");
    [Global getInstance].isOtherLogin = NO;
    
    if(accountText.text.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入账号!"];
        return;
    }
    if(passwordText.text.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入密码!"];
        return;
    }
    
    
    NSDictionary * post = @{
                            @"userName": accountText.text,
                            @"password": passwordText.text,
                            };
    
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:LOGIN_URL parameters:postData atView:self.view andHUDMessage:@"正在登录.." success:^(id resposeObject) {
        
        [Global getInstance].isUpdate = YES;
        [Global getInstance].isLogin = YES;//设置已经登陆;
        [Global getInstance].isFirstLogin = YES;
        [[Global getInstance] setGameDataByDictionary:resposeObject[@"data"]];
        
        [Global getInstance].isOtherLogin = NO;
        
        [Global getInstance].userData = [Global setUserDataByDictionary:resposeObject[@"user"]];

        [[NSUserDefaults standardUserDefaults] setObject:accountText.text forKey:ACCOUNT_SAVE];
            
        [[NSUserDefaults standardUserDefaults] setObject:passwordText.text forKey:PASSWORD_SAVE];
        [[NSUserDefaults standardUserDefaults] synchronize];
            
        [self enterMainView];
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [[Global getInstance].mainVC showLoginView:YES];

    }];
}


- (void)enterMainView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //模拟器没有diviceToken
    if([Global getInstance].diviceToken != nil)
    {
        NSDictionary * post = @{@"deviceToken":[Global getInstance].diviceToken};
        
        NSMutableDictionary * postData = [post mutableCopy];
        
        [NetRequest POST:SEND_DIVICE_TOKEN parameters:postData atView:nil andHUDMessage:nil success:^(id resposeObject) {
            NSLog(@"上传成功;");
        } failure:^(NSError *error) {
            
        }];

    }
}

/**
 *  关闭键盘
 *
 *  @param touches
 *  @param event
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [passwordText resignFirstResponder];
    [accountText resignFirstResponder];
}

//QQ回调
- (void)tencentDidLogin
{
    NSString * deviceNumber = [Global getInstance].diviceToken;
    NSString *udid = [OpenUDID value];
    
    NSString * GET_URL = [NSString stringWithFormat:@"%@?accessToken=%@&appid=%@&openId=%@&uuid=%@&deviceNumber=%@",QQ_LOGIN,_oauth.accessToken,QQ_APPID,_oauth.openId,udid,deviceNumber];
    
    [NetRequest GET:GET_URL parameters:nil atView:self.view andHUDMessage:@"登录中.." success:^(id resposeObject) {
        [Global getInstance].isUpdate = YES;
        [Global getInstance].isLogin = YES;//设置已经登陆;
        [[Global getInstance] setGameDataByDictionary:resposeObject[@"data"]];
        
        
        NSString *openId = resposeObject[@"openId"];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:openId forKey:@"openId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [Global getInstance].userData = [Global setUserDataByDictionary:resposeObject[@"user"]];
        
        [self enterMainView];
        
    } failure:^(NSError *error) {
        NSLog(@"登陆失败");
    }];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"登录失败");
}

- (void)tencentDidNotNetWork
{
    NSLog(@"网络失败");
}

- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams
{
    return nil;
}


@end
