//
//  MobileViewController.m
//  iSoccer
//
//  Created by pfg on 16/3/18.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "MobileViewController.h"
#import "MobileCodeViewController.h"
#import "NetRequest.h"
#import "NetConfig.h"
#import "Global.h"

@interface MobileViewController ()
{
    
    IBOutlet UITextField *phoneNumber;
}

@end

@implementation MobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
    }
    return self;
}

//绑定事件
- (IBAction)sureHandler:(id)sender {
    
    if(phoneNumber.text.length != 11)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入正确手机号码"];
        return;
    }
    
    
    NSDictionary * post = @{@"mobile":phoneNumber.text};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:GET_CODE parameters:postData atView:self.view andHUDMessage:@"绑定中..." success:^(id resposeObject) {
        
        [Global getInstance].currentPhoneNumber = phoneNumber.text;
        
        MobileCodeViewController * codeVC = [[UIStoryboard storyboardWithName:@"Mobile" bundle:nil] instantiateViewControllerWithIdentifier:@"mobile_code"];
        [self.navigationController pushViewController:codeVC animated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"绑定失败");
    }];
}

-(void)backMainView:(UIBarButtonItem*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
