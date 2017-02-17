//
//  ChageTeamInfoViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/14.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "ChageTeamInfoViewController.h"
#import "Global.h"
#import "NetDataNameConfig.h"

@interface ChageTeamInfoViewController ()<UITextFieldDelegate>
{
    NSString * defaultString;
    NSString * _type;
}
@end

@implementation ChageTeamInfoViewController

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
    
    
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 45)];
    
    textField.backgroundColor = [UIColor whiteColor];
    
    textField.textColor = [UIColor blackColor];
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.delegate = self;
    
    textField.font = [UIFont systemFontOfSize:16];
    
    textField.text = defaultString;
    
    [self.view addSubview:textField];
    
}

#pragma mark -- UITextFieldDelegate;

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    NSMutableDictionary * data = [Global getInstance].teamMessageData;
    
    switch (_type.integerValue) {
        case 1:
            [data setValue:textField.text forKey:TEAM_NAME];
            break;
        case 5:
            //标签;
            [data setValue:textField.text forKey:TEAM_LABEL];
            break;
        case 6:
            //描述
            [data setValue:textField.text forKey:TEAM_REMARK];
            break;
        default:
            break;
    }
    
    if([defaultString compare:textField.text] != 0)
    {
        [Global getInstance].isUpdateCreateTeamDetail = YES;
        [Global getInstance].teamDataType = _type;
    }
    
    return YES;
}

@end
