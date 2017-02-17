//
//  ForgetViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/27.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "ForgetViewController.h"
#import "Global.h"
#import "NetConfig.h"
#import "NetRequest.h"
#import "ProgressHUD.h"

@interface ForgetViewController ()
{
    
    IBOutlet UITextField *phoneNumText;
    IBOutlet UITextField *codeText;
    
    IBOutlet UITextField *passwordText;
    IBOutlet UITextField *surePasswordText;
    __weak IBOutlet UIButton *securityCodeButton;
}

@end

@implementation ForgetViewController
//返回登陆;
- (IBAction)backLoginViewHandler:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)getCodeHandler:(id)sender {
    //获取验证码
    UIButton * button = sender;
    button.enabled = YES;
    if(phoneNumText.text.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入手机号"];
        return;
    }
    
    NSDictionary * post = @{@"mobile":phoneNumText.text};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:GET_FORGET_VERIFY_CODE parameters:postData atView:self.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
        
        [ProgressHUD showSuccess:@"获取成功"];
        [self startTime];
    } failure:^(NSError *error) {
        NSLog(@"错误");
    }];

    
}

-(void)startTime{
    __block int timeout= 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [securityCodeButton setTitle:@"重发送验证码" forState:UIControlStateNormal];
                securityCodeButton.userInteractionEnabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [securityCodeButton setTitle:[NSString stringWithFormat:@"%zd秒重新发送",timeout] forState:UIControlStateNormal];
                securityCodeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}


//确认修改;
- (IBAction)changeHandler:(id)sender {
    
    if([self judgeRegister] == NO)
    {
        return;
    }
    
    NSDictionary * post = @{
                            @"userName":phoneNumText.text,
                            @"password":passwordText.text,
                            @"mobile":phoneNumText.text,
                            @"verifycode":codeText.text                            };
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:FORGET_PASSWORD parameters:postData atView:self.view andHUDMessage:@"修改中.." success:^(id resposeObject) {
        
        [[NSUserDefaults standardUserDefaults] setObject:phoneNumText.text forKey:ACCOUNT_SAVE];
        
        [[NSUserDefaults standardUserDefaults] setObject:passwordText.text forKey:PASSWORD_SAVE];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (BOOL)judgeRegister{
    if(phoneNumText.text.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入手机号"];
        return NO;
    }
    if(codeText.text.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入验证码"];
        return NO;
    }
    if(passwordText.text.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入密码"];
        return NO;
    }
    
    if(surePasswordText.text.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入确认密码"];
        return NO;
    }
    
    if(surePasswordText.text.length < 6 || passwordText.text.length < 6)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入6位数以上密码"];
        return NO;
    }
    
    if([passwordText.text isEqualToString:surePasswordText.text] == NO)
    {
        [Global alertWithTitle:@"提示" msg:@"两次输入的密码不一致"];
        return NO;
    }
    
    return YES;
}

//回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [phoneNumText resignFirstResponder];
    [codeText resignFirstResponder];
    [passwordText resignFirstResponder];
    [surePasswordText resignFirstResponder];
}


@end
