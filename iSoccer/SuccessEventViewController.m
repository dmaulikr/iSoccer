//
//  SuccessEventViewController.m
//  iSoccer
//
//  Created by pfg on 16/5/25.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "SuccessEventViewController.h"
#import "Global.h"

@interface SuccessEventViewController ()
{
    NSString * url;
}

@end

@implementation SuccessEventViewController

- (instancetype)initWithUrl:(NSString*)codeUrl
{
    self = [super init];
    if (self) {
        self.title = @"报名参加";
        url = codeUrl;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView * successImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.3, self.view.frame.size.width * 0.3)];
    
    successImage.image = [UIImage imageNamed:@"pay_success_icon.png"];
    
    successImage.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height * 0.2);
    
    [self.view addSubview:successImage];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    titleLabel.font = [UIFont systemFontOfSize:20];
    
    titleLabel.textColor = [UIColor blackColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = @"报名成功";
    
    titleLabel.center = CGPointMake(successImage.center.x, successImage.center.y + successImage.frame.size.height/2 + self.view.frame.size.height * 0.05 + titleLabel.frame.size.height/2);
    
    [self.view addSubview:titleLabel];
    
    
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, 40)];
    
    contentLabel.font = [UIFont systemFontOfSize:14];
    
    contentLabel.textColor = [UIColor grayColor];
    
    contentLabel.textAlignment = NSTextAlignmentCenter;
    
    contentLabel.numberOfLines = 0;
    
    contentLabel.text = @"你的资料已提交,参赛检录时请出示此二维码给赛事工作人员.";
    
    contentLabel.center = CGPointMake(self.view.frame.size.width/2, titleLabel.center.y + titleLabel.frame.size.height/2 + self.view.frame.size.height * 0.025 + contentLabel.frame.size.height/2);
    
    [self.view addSubview:contentLabel];
    
    
    _codeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.4, self.view.frame.size.width * 0.4)];
    
    _codeImage.center = CGPointMake(contentLabel.center.x,contentLabel.center.y + contentLabel.frame.size.height/2 + self.view.frame.size.height * 0.025 +_codeImage.frame.size.height/2);
    
    [Global loadImageFadeIn:_codeImage andUrl:url isLoadRepeat:YES];
    
    
    _codeImage.backgroundColor = [UIColor blackColor];
    
    
    [self.view addSubview:_codeImage];
    
    UIColor * color = [UIColor blackColor];
    
    UIButton *button = [self createButtonByTitle:@"我知道了" andColor:color andWidth:self.view.frame.size.width - 30];
    
    button.center = CGPointMake(_codeImage.center.x, _codeImage.center.y + _codeImage.frame.size.height/2 + self.view.frame.size.height * 0.025 + button.frame.size.height/2);
    
    [button addTarget:self action:@selector(tapBackHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)tapBackHandler:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton*)createButtonByTitle:(NSString*)title andColor:(UIColor*)color andWidth:(CGFloat)width{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0,0, width, self.view.frame.size.height * 0.08);
    button.backgroundColor = color;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    
    return button;
}


@end
