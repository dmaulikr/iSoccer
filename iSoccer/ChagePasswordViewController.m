//
//  ChagePasswordViewController.m
//  iSoccer
//
//  Created by pfg on 16/2/14.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "ChagePasswordViewController.h"
#import "NetConfig.h"
#import "NetRequest.h"
#import "Global.h"
#import "ProgressHUD.h"

@interface ChagePasswordViewController ()
{
    IBOutlet UITextField *oldPasswordText;
    IBOutlet UITextField *newPasswordOnceText;
    IBOutlet UITextField *newPasswordTwiceText;
}

@end

@implementation ChagePasswordViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.title = @"修改密码";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
- (IBAction)changePasswordHandler:(id)sender {
    //确认修改密码
    
    if([self checkPassword] == NO)
    {
        return;
    }
    
    NSDictionary * post = @{@"oldPassword":oldPasswordText.text,@"newPassword":newPasswordTwiceText.text};
    
    NSMutableDictionary * postData = [post mutableCopy];
    [NetRequest POST:CHANGE_PASSWORD parameters:postData atView:self.view andHUDMessage:@"修改中.." success:^(id resposeObject) {
        [ProgressHUD showSuccess:@"修改成功"];
        
        [[NSUserDefaults standardUserDefaults] setObject:newPasswordOnceText.text forKey:PASSWORD_SAVE];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"错误");
    }];
    
}

- (BOOL)checkPassword{
    if(newPasswordTwiceText.text.length < 6 || newPasswordOnceText.text.length < 6)
    {
        [Global alertWithTitle:@"提示" msg:@"密码长度不能小于6位"];
        return NO;
    }
    
    if([newPasswordOnceText.text compare:newPasswordTwiceText.text] != 0)
    {
        [Global alertWithTitle:@"提示" msg:@"两次密码输入不一致"];
        return NO;
    }
    
    return YES;
}

@end
