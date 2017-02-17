//
//  ChangeOrderViewController.m
//  iSoccer
//
//  Created by Linus on 16/8/11.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "ChangeOrderViewController.h"

#import "Global.h"

@interface ChangeOrderViewController ()<UITextFieldDelegate>
{
    NSString * defaultString;
    
    UITextField * textField;
}
@end

@implementation ChangeOrderViewController

- (instancetype)initWithTitle:(NSString*)title defaultString:(NSString*)defaultStr
{
    self = [super init];
    if (self) {
        
        self.title = title;
        defaultString = defaultStr;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 45)];
    
    textField.backgroundColor = [UIColor whiteColor];
    
    textField.textColor = [UIColor blackColor];
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.delegate = self;
    
    textField.font = [UIFont systemFontOfSize:16];
    
    textField.text = defaultString;
    
    textField.keyboardType = UIKeyboardTypePhonePad;
    
    [self.view addSubview:textField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [textField becomeFirstResponder];
    
}

- (void)keyboardWillBeHidden{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark -- UITextFieldDelegate;

- (BOOL)textFieldShouldEndEditing:(UITextField *)textFields{
    
    
    [Global getInstance].reservationPhoneNumber = textFields.text;
    
    if([defaultString compare:textFields.text] != 0)
    {
        [Global getInstance].isUpdateReservationPhoneNumber = YES;
    }
    
    return YES;
}


@end
