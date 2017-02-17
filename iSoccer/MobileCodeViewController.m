//
//  MobileCodeViewController.m
//  iSoccer
//
//  Created by pfg on 16/3/18.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "MobileCodeViewController.h"
#import "Global.h"
#import "NetConfig.h"
#import "NetRequest.h"

@interface MobileCodeViewController ()
{
    
    IBOutlet UILabel *phoneNumberText;
    IBOutlet UITextField *codeText;
}

@end

@implementation MobileCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * number = [Global getInstance].currentPhoneNumber;
    
    phoneNumberText.text = [NSString stringWithFormat:@"手机号码:%@",number];
}

//提交绑定;
- (IBAction)sureHandler:(id)sender {
    
    if(codeText.text.length < 1)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入正确的验证码"];
    }
    
    NSString * wxOpenId = [[NSUserDefaults standardUserDefaults] objectForKey:@"openId"];
    
    NSDictionary *post = @{@"code":codeText.text,@"openId":wxOpenId};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:BINDING_CODE parameters:postData atView:self.view andHUDMessage:@"验证中.." success:^(id resposeObject) {
        NSLog(@"绑定成功;");
        [Global getInstance].userData.phoneNumber = [Global getInstance].currentPhoneNumber;
        [Global alertWithTitle:@"提示" msg:@"绑定成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        NSLog(@"绑定失败");
    }];
    
}


@end
