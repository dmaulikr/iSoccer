//
//  ChageViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/4.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "ChageViewController.h"
#import "Global.h"


@interface ChageViewController ()<UITextViewDelegate>
{
    NSString * defaultString;
    NSString * _type;
    UITextView * _textView;
    
    UILabel * remainLabel;
    
    BOOL _isHeight;
}

@end

@implementation ChageViewController

- (instancetype)initWithTitle:(NSString*)title defaultString:(NSString*)defaultStr andType:(NSString*)type isHighHeight:(BOOL)isHeight
{
    self = [super init];
    if (self) {
        
        self.title = title;
        defaultString = defaultStr;
        _type = type;
        _isHeight = isHeight;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    if ( self.navigationController.navigationBarHidden == YES )
    {
        [self.view setBounds:CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    else
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    
    CGFloat height = 45;
    if(_isHeight)
    {
        height = 100;
    }
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, height)];
    if(_type.integerValue == 4 || _type.integerValue == 6 || _type.integerValue == 7)
    {
        _textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    if(_type.integerValue == 2)
    {
        _textView.keyboardType = UIKeyboardTypePhonePad;
    }
    
    
    
    _textView.delegate = self;
    
    _textView.textAlignment = NSTextAlignmentLeft; // 设置字体对其方式
    
    _textView.backgroundColor = [UIColor whiteColor];
    
    _textView.textColor = [UIColor blackColor];
    
    _textView.layer.borderWidth = 0.5f;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _textView.font = [UIFont systemFontOfSize:16];
    
    _textView.text = defaultString;
    
    [self.view addSubview:_textView];
    
    [_textView setEditable:YES]; // 设置时候可以编辑
    
    
    if(_isHeight)
    {
        remainLabel = [[UILabel alloc]initWithFrame:CGRectMake(_textView.frame.size.width - 30, _textView.frame.origin.y + _textView.frame.size.height - 30, 30, 30)];
        
        remainLabel.text = [NSString stringWithFormat:@"%zd",100 -defaultString.length];
        
        remainLabel.textAlignment = NSTextAlignmentCenter;
        
        remainLabel.textColor = [UIColor lightGrayColor];
        
        [self.view addSubview:remainLabel];
        
    }

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardWillBeHidden)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [_textView becomeFirstResponder];
    
}

- (void)keyboardWillBeHidden{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    
    if(textView.text.length > 100)
    {
        textView.text = [textView.text substringToIndex:100];
    }
    
    remainLabel.text = [NSString stringWithFormat:@"%zd",100 - textView.text.length];
    
    switch (_type.integerValue) {
        case 0:
            //头像;
            break;
        case 1:
            //姓名;
            [Global getInstance].userData.userName = textView.text;
            break;
        case 2:
            //手机号码
            [Global getInstance].userData.phoneNumber = textView.text;
            break;
        case 3:
            //电子邮箱;
            [Global getInstance].userData.email = textView.text;
            break;
        case 4:
            //年龄
            [Global getInstance].userData.age = textView.text;
            break;
        case 5:
            //性别
            [Global getInstance].userData.sex = textView.text;
            break;
        case 6:
            //身高
            [Global getInstance].userData.height = textView.text;
            break;
        case 7:
            //体重
            [Global getInstance].userData.weight = textView.text;
            break;
        case 8:
            //位置
            [Global getInstance].userData.position = textView.text;
            break;
        case 9:
            //国籍
            [Global getInstance].userData.nationality = textView.text;
            break;
        case 10:
            //自我评价
            [Global getInstance].userData.remark = textView.text;
            break;
        default:
            break;
    }
    
    if([defaultString compare:textView.text] != 0)
    {
        [Global getInstance].isChangeUserData = YES;
        [Global getInstance].userDataType = _type;
    }
}



@end
