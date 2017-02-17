//
//  WithdrawViewController.m
//  iSoccer
//
//  Created by pfg on 16/2/3.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "WithdrawViewController.h"
#import "Global.h"
#import "MMPickerView.h"
#import "NetConfig.h"
#import "NetRequest.h"
#import "ProgressHUD.h"
@interface WithdrawViewController ()
{
    //可用余额;
    IBOutlet UILabel *canUseMoneyText;
    //开户行;
    IBOutlet UILabel *bankLabel;
    //持卡人姓名;
    IBOutlet UITextField *cardName;
    //卡号;
    IBOutlet UITextField *bankNumber;
    //电话号码
    IBOutlet UILabel *phoneNumber;
    //输入验证码;
    IBOutlet UITextField *safeCodeText;
    
    IBOutlet UITextField *withdrawMoney;
    NSString * canUseMoney;
    
}

@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * moibleNumber;
    if([Global getInstance].userData.phoneNumber.length < 11)
    {
        moibleNumber = [Global getInstance].userData.bindingMobile;
    }else{
        moibleNumber = [Global getInstance].userData.phoneNumber;
    }
    
    NSString * mobile = [NSMutableString stringWithString:moibleNumber];
    
    NSRange range = NSMakeRange(3, 4);
    
    NSString * newMobile = [mobile stringByReplacingCharactersInRange:range withString:@"****"];
    
    phoneNumber.text = newMobile;//填入电话号码;
    
    bankLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapBankLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBankLabel:)];
    
    [bankLabel addGestureRecognizer:tapBankLabel];
    
    canUseMoneyText.text = [NSString stringWithFormat:@"￥%@",canUseMoney];
}

- (void)tapBankLabel:(UITapGestureRecognizer*)gesture{
    NSLog(@"喃");
    NSArray *banks = @[@"中国银行",@"招商银行",@"建设银行",@"农业银行",@"工商银行",@"交通银行",
                       @"华夏银行",@"光大银行",@"成都银行",@"包商银行",@"民生银行",@"中信银行"];
    [MMPickerView showPickerViewInView:self.view withStrings:banks withOptions:nil completion:^(NSString *selectedString) {
        if([selectedString compare:bankLabel.text] != 0)
        {
            bankLabel.text = selectedString;
        }
    } hedden:^{
        NSLog(@"%@",bankLabel.text);
    }];
}

- (void)setHasMoney:(NSString*)money
{
    canUseMoney = money;
}

//获取验证码;
- (IBAction)getSafeCodeHandler:(id)sender {
    
    //提交验证;
    UIButton * button = (UIButton*)sender;
    
    button.enabled = NO;
    NSString *phone;
    if([Global getInstance].userData.phoneNumber.length < 11)
    {
        phone = [Global getInstance].userData.bindingMobile;
    }else{
        phone = [Global getInstance].userData.phoneNumber;
    }
    
    NSDictionary * post = @{@"mobile":phone};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:GET_WITHDRAW_SAFE_CODE parameters:postData atView:self.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
        [ProgressHUD showSuccess:@"获取成功"];
    } failure:^(NSError *error) {
        NSLog(@"获取失败");
    }];
    
}
//提现申请;
- (IBAction)withdrawHandler:(id)sender {
    
    if([self checkInput] == NO)
    {
        return;
    }
    NSString * accountId = [Global getInstance].currentAccountId;
    NSDictionary * post = @{@"cashAmount":withdrawMoney.text,
                            @"accountId":accountId,
                            @"cashBank":bankLabel.text,
                            @"cashName":cardName.text,
                            @"cardNumber":bankNumber.text,
                            @"verifycode":safeCodeText.text};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:WITHDRAW_MONEY parameters:postData atView:self.view andHUDMessage:@"提交中.." success:^(id resposeObject) {
        [Global alertWithTitle:@"提示" msg:@"申请成功,3个工作日之内到账!"];
        [Global getInstance].isWithdrawSuccessed = YES;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"错误");
    }];
}

- (BOOL)checkInput{
    
    if([bankLabel.text compare:@"选择开户行＞"] == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请选择开户行!"];
        return NO;
    }
    
    if(cardName.text.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入持卡人姓名!"];
        return NO;
    }
    
    if(bankNumber.text.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入银行卡卡号!"];
        return NO;
    }
    
    if(safeCodeText.text.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入验证码!"];
        return NO;
    }
    
    if(canUseMoney.floatValue <= 0 || canUseMoney.floatValue < withdrawMoney.text.floatValue)
    {
        [Global alertWithTitle:@"提示" msg:@"当前余额不足!"];
        return NO;
    }
    
    return YES;
}

@end
