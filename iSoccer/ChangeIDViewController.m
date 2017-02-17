//
//  ChangeIDViewController.m
//  iSoccer
//
//  Created by pfg on 16/5/24.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "ChangeIDViewController.h"
#import "Global.h"


@interface ChangeIDViewController ()
{
    NSString * defaultString;
    NSString * _type;
    UITextField * _textField;
}

@end

@implementation ChangeIDViewController

- (instancetype)initWithTitle:(NSString*)title defaultString:(NSString*)defaultStr andType:(NSString*)type
{
    self = [super init];
    if (self) {
        
        self.title = title;
        defaultString = defaultStr;
        _type = type;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 45)];
    
    _textField.backgroundColor = [UIColor whiteColor];
    
    _textField.textColor = [UIColor blackColor];
    
    _textField.font = [UIFont systemFontOfSize:16];
    
    _textField.text = defaultString;
    
    [_textField addTarget:self action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
    
    if(_type.integerValue == 1 || _type.integerValue == 2)
    {
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    [self.view addSubview:_textField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [_textField becomeFirstResponder];
    
}

- (void)keyboardWillBeHidden{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)changeTextField:(UITextField*)textField{
    IDData * data = [[IDData alloc]init];
    
    switch (_type.integerValue) {
        case 0:
            //名字;
            data.name = textField.text;
            break;
        case 1:
            //电话;
            data.phone = textField.text;
            break;
        case 2:
            //身份证号
            data.idNumber = textField.text;
            break;
        }
    
    if([defaultString compare:textField.text] != 0)
    {
        [Global getInstance].isInputIdData = YES;
    }
    
    [Global getInstance].currentIDdata = data;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textField resignFirstResponder];
}

@end
