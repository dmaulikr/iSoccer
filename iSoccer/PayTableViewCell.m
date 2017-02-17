//
//  PayTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/1/29.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "PayTableViewCell.h"
#import "NetConfig.h"
#import "NetRequest.h"
#import "Global.h"
#import "PayAccountViewController.h"
#import "WithdrawViewController.h"

@implementation PayTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andHeight:(CGFloat)cellHeight{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.frame = CGRectMake(0, 0, size.width, cellHeight);
        
        _accountBg = [[UIView alloc]init];
        
        _accountBg.frame = CGRectMake(15, 15, size.width - 30, cellHeight - 15);
        
        _accountBg.backgroundColor = [UIColor colorWithRed:73/225.0 green:177/225.0 blue:229/225.0 alpha:1.0];
        
        _accountBg.layer.cornerRadius = 8;
        
        [self.contentView addSubview:_accountBg];
        
        UIView * hLine = [[UIView alloc]init];
        
        hLine.frame = CGRectMake(_accountBg.frame.origin.x, _accountBg.frame.size.height * 0.46 + _accountBg.frame.origin.y, _accountBg.frame.size.width, 0.5);
        hLine.backgroundColor = [UIColor whiteColor];
        
        hLine.alpha = 0.3;
        
        [self.contentView addSubview:hLine];
        
        
        UIView * vOneLine = [[UIView alloc]init];
        vOneLine.frame = CGRectMake(_accountBg.frame.origin.x + _accountBg.frame.size.width * 0.33, hLine.frame.origin.y, 0.5, _accountBg.frame.size.height * 0.54);
        
        vOneLine.backgroundColor = [UIColor whiteColor];
        vOneLine.alpha = 0.3;
        [self.contentView addSubview:vOneLine];
        
        UIView *vTowLine = [[UIView alloc]init];
        vTowLine.frame = CGRectMake(_accountBg.frame.origin.x + _accountBg.frame.size.width * 0.66,hLine.frame.origin.y,0.5, vOneLine.frame.size.height);
        
        vTowLine.backgroundColor = [UIColor whiteColor];
        vTowLine.alpha = 0.3;
        [self.contentView addSubview:vTowLine];
        
        _logoBg = [self createCornerRadiusAndColor:[UIColor colorWithRed:48/255.0 green:138/225.0 blue:207/225.0 alpha:1.0]];
        
        [self.contentView addSubview:_logoBg];
        
        
        UIView * whiteHeadBg = [[UIView alloc]initWithFrame:CGRectMake(30,0,68, 68)];
        
        whiteHeadBg.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:whiteHeadBg];
        
        
        _cellIcon = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 60, 60)];
        
        _cellIcon.layer.masksToBounds = YES;
        
        _cellIcon.contentMode = UIViewContentModeScaleAspectFill;
        
        _cellIcon.image = [UIImage imageNamed:@"default_team_icon.jpg"];
        [whiteHeadBg addSubview:_cellIcon];
        
        
        _cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(whiteHeadBg.frame.origin.x + whiteHeadBg.frame.size.width + 6, 15, size.width - 40 - whiteHeadBg.frame.origin.x - whiteHeadBg.frame.size.width, 25)];
        
        _cellLabel.font = [UIFont systemFontOfSize:16];
        
        _cellLabel.textColor = [UIColor whiteColor];
        
        _cellLabel.text = @"账户名称";
        [self.contentView addSubview:_cellLabel];
        
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(_cellLabel.frame.origin.x
                                                              , _cellLabel.frame.origin.y
                                                               + _cellLabel.frame.size.height + 2, _cellLabel.frame.size.width, 20)];
        
        _moneyLabel.text = @"余额: ￥24.30";
        _moneyLabel.textColor = [UIColor whiteColor];
        
        _moneyLabel.font = [UIFont systemFontOfSize:13];
        
        [self.contentView addSubview:_moneyLabel];
        
        _logoLabel = [[UILabel alloc]init];
        _logoLabel.frame = CGRectMake(0, 0, _logoBg.frame.size.width, _logoBg.frame.size.height);
        _logoLabel.text = @"个人账户";
        _logoLabel.textColor = [UIColor whiteColor];
        _logoLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
        _logoLabel.textAlignment = NSTextAlignmentCenter;
        [_logoBg addSubview:_logoLabel];
        
        
        UIButton * rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rechargeBtn.frame = CGRectMake(0, 0, _accountBg.frame.size.width * 0.07, _accountBg.frame.size.width * 0.075);
        [rechargeBtn setImage:[UIImage imageNamed:@"account_recharge.png"] forState:UIControlStateNormal];
        
        CGFloat btnX = _accountBg.frame.origin.x + (vOneLine.frame.origin.x - _accountBg.frame.origin.x)/2;
        
        CGFloat btnY = hLine.frame.origin.y + ((_accountBg.frame.size.height + _accountBg.frame.origin.y) - hLine.frame.origin.y)/2;
        
        rechargeBtn.center = CGPointMake(btnX, btnY);
        
        [rechargeBtn addTarget:self action:@selector(rechargeHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:rechargeBtn];
        
        
        UILabel * rechargeLabel = [[UILabel alloc]init];
        
        rechargeLabel.frame = CGRectMake(0, rechargeBtn.frame.origin.y + rechargeBtn.frame.size.height + 2, 50, 20);
        rechargeLabel.text = @"充值";
        rechargeLabel.textColor = [UIColor whiteColor];
        rechargeLabel.font = [UIFont systemFontOfSize:12];
        rechargeLabel.center = CGPointMake(rechargeBtn.center.x, rechargeLabel.center.y);
        rechargeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:rechargeLabel];
        
        
        UIButton * withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        withdrawBtn.frame = CGRectMake(0, 0, _accountBg.frame.size.width * 0.07, _accountBg.frame.size.width * 0.075);
        [withdrawBtn setImage:[UIImage imageNamed:@"account_withdraw.png"] forState:UIControlStateNormal];
        
        withdrawBtn.center = CGPointMake(rechargeBtn.center.x + _accountBg.frame.size.width * 0.33, rechargeBtn.center.y);
        
        [withdrawBtn addTarget:self action:@selector(withdrawHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:withdrawBtn];
        
        UILabel * withdrawLabel = [[UILabel alloc]init];
        
        withdrawLabel.frame = CGRectMake(0, withdrawBtn.frame.origin.y + withdrawBtn.frame.size.height + 2, 50, 20);
        withdrawLabel.text = @"提现";
        withdrawLabel.textColor = [UIColor whiteColor];
        withdrawLabel.font = [UIFont systemFontOfSize:12];
        withdrawLabel.center = CGPointMake(withdrawBtn.center.x, withdrawLabel.center.y);
        withdrawLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:withdrawLabel];
        
        
        
        UIButton * detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        detailBtn.frame = CGRectMake(0, 0, _accountBg.frame.size.width * 0.07, _accountBg.frame.size.width * 0.075);
        [detailBtn setImage:[UIImage imageNamed:@"account_detail.png"] forState:UIControlStateNormal];
        
        detailBtn.center = CGPointMake(withdrawBtn.center.x + _accountBg.frame.size.width * 0.33, withdrawBtn.center.y);
        
        [detailBtn addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:detailBtn];
        
        UILabel * detailLabel = [[UILabel alloc]init];
        
        detailLabel.frame = CGRectMake(0, detailBtn.frame.origin.y + detailBtn.frame.size.height + 2, 50, 20);
        detailLabel.text = @"交易记录";
        detailLabel.textColor = [UIColor whiteColor];
        detailLabel.font = [UIFont systemFontOfSize:12];
        detailLabel.center = CGPointMake(detailBtn.center.x, detailLabel.center.y);
        detailLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:detailLabel];
        
    }
    
    return self;
}

- (void)showDetailView:(UIButton*)sender{
    NSDictionary * post = @{@"accountId":_accountId};
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:GET_ACCOUNT_RECORD parameters:postData atView:self.superview.superview andHUDMessage:@"获取中.." success:^(id resposeObject) {
        NSMutableDictionary * result = resposeObject[@"account"];
        
        PayAccountViewController * accountVC = [[UIStoryboard storyboardWithName:@"PayAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"account"];
        
        NSString * nameTitle = _cellLabel.text;
        
        [accountVC setTitle:[NSString stringWithFormat:@"%@的账户",nameTitle]];
        [accountVC setData:result];
        
        [[Global getInstance].payVC.navigationController pushViewController:accountVC animated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"报错");
    }];
}

- (void)rechargeHandler:(UIButton*)sender{
    NSLog(@"充值");
    
    [Global getInstance].currentAccountId = _accountId;
    
    RechargeViewController * rechargeVC = [[UIStoryboard storyboardWithName:@"PayAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"recharge"];
    [[Global getInstance].payVC.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)withdrawHandler:(UIButton*)sender{
    NSLog(@"提现");
    
    [Global getInstance].currentAccountId = _accountId;
    
    WithdrawViewController * withdrawVC = [[UIStoryboard storyboardWithName:@"PayAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"withdraw"];
    
    [withdrawVC setHasMoney:_money];
    [[Global getInstance].payVC.navigationController pushViewController:withdrawVC animated:YES];
}

- (UIView*)createCornerRadiusAndColor:(UIColor*)color{
    
    CGFloat width = _accountBg.frame.size.width * 0.14;
    CGFloat height = _accountBg.frame.size.height * 0.13;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_accountBg.frame.origin.x + (_accountBg.frame.size.width - width), _accountBg.frame.origin.y, width, height)];
    view.backgroundColor = color;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
    return view;
}

@end
