//
//  CreateTeamInfoViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/18.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "CreateTeamInfoViewController.h"
#import "Global.h"
#import "TeamData.h"

@interface CreateTeamInfoViewController ()<UITextViewDelegate>
{
    NSString * defaultString;
    NSString * _type;
    UITextView * _textView;
    BOOL _isHeight;
    UILabel * remainLabel;
}
@end

@implementation CreateTeamInfoViewController

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
    
    _textView.delegate = self;
    
    _textView.backgroundColor = [UIColor whiteColor];
    
    _textView.textColor = [UIColor blackColor];
    
    _textView.font = [UIFont systemFontOfSize:16];
    
    _textView.text = defaultString;
    
    [self.view addSubview:_textView];
    
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -- UITextFieldDelegate;

- (void)textViewDidChange:(UITextView *)textView{
    
    
    if(textView.text.length > 100)
    {
        textView.text = [textView.text substringToIndex:100];
    }
    
    remainLabel.text = [NSString stringWithFormat:@"%zd",100 - textView.text.length];
    
    
    TeamData * data = [Global getInstance].createTeamData;
    
    switch (_type.integerValue) {
        case 1:
            //名称;
            data.teamName = textView.text;
            break;
        case 5:
            //标签;
            data.teamLabel = textView.text;
            break;
        case 6:
            //描述
            data.remark = textView.text;
            break;
        default:
            break;
    }
    
    if([defaultString compare:textView.text] != 0)
    {
        [Global getInstance].isInputTeamInfo = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}


@end
