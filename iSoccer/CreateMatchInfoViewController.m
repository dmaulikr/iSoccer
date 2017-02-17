//
//  CreateMatchInfoViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/20.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "CreateMatchInfoViewController.h"
#import "Global.h"

@interface CreateMatchInfoViewController ()
{
    NSString * defaultString;
    NSString * _type;
    UITextField * _textField;
}
@end

@implementation CreateMatchInfoViewController

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
    
    if(_type.integerValue == 7)
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
    MatchInfo * data = [Global getInstance].matchInfo;
    
    switch (_type.integerValue) {
        case 1:
            //比赛名称;
            data.matchName = textField.text;
            break;
        case 4:
            //对手名称;
            data.matchOpponent = textField.text;
            break;
        case 6:
            //描述
            data.matchColor = textField.text;
            break;
        case 7:
            //花费;
            data.matchCost = textField.text;
            break;
        case 8:
            data.matchRemark = textField.text;
            break;
        default:
            break;
    }
    
    if([defaultString compare:textField.text] != 0)
    {
        [Global getInstance].isInputMatchInfo = YES;
        
        if(_type.integerValue == 7)
        {
            if(textField.text.floatValue)
            {
                NSRange range = [textField.text rangeOfString:@"."];
                
                if(range.length > 0)
                {
                    NSString * tempString = [textField.text substringFromIndex:NSMaxRange(range)];
                    if(tempString.length >= 3)
                    {
                        NSString * money = [NSString stringWithFormat:@"%.2lf",textField.text.doubleValue];
                        
                        textField.text = money;
                    }

                }
            }else{
                data.matchCost = @"0";
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textField resignFirstResponder];
}

@end
