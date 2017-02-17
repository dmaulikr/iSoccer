//
//  PaySuccessViewController.m
//  iSoccer
//
//  Created by pfg on 16/2/2.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "Global.h"

@interface PaySuccessViewController ()
{
    __weak IBOutlet UILabel *checkCodeText;
    
    __weak IBOutlet UILabel *codeText;
}

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([Global getInstance].fieldOrderCheckCode == nil)
    {
        checkCodeText.hidden = YES;
        codeText.hidden = YES;
    }else{
        codeText.text = [Global getInstance].fieldOrderCheckCode;
        
        checkCodeText.hidden = NO;
        codeText.hidden = NO;
    }
}
- (IBAction)backAccountDetailHandler:(id)sender {
    //返回
    if([Global getInstance].isRecharge)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}





@end
