//
//  RechargeViewController.m
//  iSoccer
//
//  Created by pfg on 16/2/2.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "RechargeViewController.h"
#import "ZFBViewController.h"
#import "Global.h"
#import "NetRequest.h"
#import "NetConfig.h"
#import "WXApi.h"
#import "WXUtil.h"
#import "PaySuccessViewController.h"

#define APP_ID          @"wx72d476f91da4162f"               //APPID
#define APP_SECRET      @"e764dd695a050e5d01fdc02fe8be5dcc" //appsecret
//商户号，填写商户对应参数
#define MCH_ID          @"1309399901"
//商户API密钥，填写相应参数
#define PARTNER_ID      @"68f4455ae3ad1fbf2fe7e6f7c7577fdb"
@interface RechargeViewController ()<UIActionSheetDelegate>
{
    
    IBOutlet UITextField *moneyText;
}

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [moneyText addTarget:self action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
    
    [Global getInstance].rechargeVC = self;
    
    [Global getInstance].isRecharge = YES;
    
    [moneyText becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    if([Global getInstance].isPaySuccessed == YES)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//充值按钮
- (IBAction)rechargeHandler:(id)sender {
    
    [moneyText resignFirstResponder];
    if(!moneyText.text.floatValue)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入正确金额"];
        return;
    }
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"微信充值",@"支付宝充值",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)changeTextField:(UITextField*)textField{
    
    if(moneyText.text.floatValue)
    {
        NSRange range = [moneyText.text rangeOfString:@"."];
        
        if(range.length > 0)
        {
            NSString * tempString = [moneyText.text substringFromIndex:NSMaxRange(range)];
            if(tempString.length >= 3)
            {
                NSString * money = [NSString stringWithFormat:@"%.2lf",textField.text.doubleValue];
                
                moneyText.text = money;
            }

        }
        
    }
}

#pragma mark -- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:{
            //微信充值;
            [self payByWinXin];
            break;
        }
        case 1:{
            //支付宝充值;
            [self payByZFB];
            break;
        }
    }
}
- (void)payByWinXin{
    
    NSString * accountId = [Global getInstance].currentAccountId;
    
    NSDictionary * post = @{@"account":accountId,@"total_fee":moneyText.text};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:RECHARGE_BY_WX parameters:postData atView:self.view andHUDMessage:@"微信调用中.." success:^(id resposeObject) {
        NSString * code = resposeObject[@"code"];
        
        if(code.integerValue == 2)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [[Global getInstance].mainVC showLoginView:YES];
            }];
        }else{
            NSString * prePayId = resposeObject[@"prepay_id"];
            NSString * stamp = resposeObject[@"timeStamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = MCH_ID;
            req.prepayId            = prePayId;
            req.nonceStr            = resposeObject[@"nonceStr"];
            req.timeStamp           = stamp.intValue;
            req.package             = @"Sign=WXPay";
            
            //第二次签名参数列表
            NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
            [signParams setObject: APP_ID        forKey:@"appid"];
            [signParams setObject: req.nonceStr    forKey:@"noncestr"];
            [signParams setObject: req.package      forKey:@"package"];
            [signParams setObject: req.partnerId        forKey:@"partnerid"];
            [signParams setObject: stamp forKey:@"timestamp"];
            [signParams setObject: req.prepayId     forKey:@"prepayid"];
            //生成签名
            NSString *sign  = [self createMd5Sign:signParams];
            req.sign                = sign;
            
            [WXApi sendReq:req];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"付款失败!");
    }];
}

- (void)payByZFB{
    ZFBViewController * ZFBVC = [[UIStoryboard storyboardWithName:@"PayAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"payzfb"];
    
    [ZFBVC rechargetWithMoney:moneyText.text];
    
    [self.navigationController pushViewController:ZFBVC animated:YES];
}

-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", PARTNER_ID];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    //输出Debug Info
    
    return md5Sign;
}

- (void)WeixinPaySuccess{
    PaySuccessViewController * successVC = [[UIStoryboard storyboardWithName:@"PayAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"success"];
    
    [self.navigationController pushViewController:successVC animated:YES];
    
    [Global getInstance].isPaySuccessed = YES;
}

/**
 *  关闭键盘
 *
 *  @param touches
 *  @param event
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [moneyText resignFirstResponder];
}

@end
