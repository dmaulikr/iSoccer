//
//  PayAccountViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/30.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "PayAccountViewController.h"
#import "AccountRecordTableViewCell.h"
#import "Global.h"
#import "RechargeViewController.h"
#import "WithdrawViewController.h"
#import "NetConfig.h"
#import "NetRequest.h"

@interface PayAccountViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *accountTableView;
    IBOutlet UIButton *moneyButton;
    NSMutableArray * _keys;
    
    IBOutlet UILabel *hasMoneyText;
    NSMutableArray * dataSounrce;
    NSString * hasMoney;
    NSString * moneyFloatView;
}

@end

@implementation PayAccountViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        dataSounrce = [NSMutableArray array];
        _keys = [NSMutableArray array];
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated{
    if([Global getInstance].isPaySuccessed == YES || [Global getInstance].isWithdrawSuccessed == YES)
    {
        NSString * accountId = [Global getInstance].currentAccountId;
        
        NSDictionary * post = @{@"accountId":accountId};
        
        NSMutableDictionary * postData = [post mutableCopy];
        
        [NetRequest POST:GET_ACCOUNT_RECORD parameters:postData atView:self.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
            NSMutableDictionary * result = resposeObject[@"account"];
            
            [self setData:result];
        } failure:^(NSError *error) {
            NSLog(@"报错");
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    moneyButton.userInteractionEnabled =NO;
    accountTableView.rowHeight = 56;
    accountTableView.tableFooterView = [UIView new];
    
    hasMoneyText.text = hasMoney;
}
- (IBAction)rechargeHandler:(id)sender {
    //充值;
    NSLog(@"充值");
    RechargeViewController * rechargeVC = [[UIStoryboard storyboardWithName:@"PayAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"recharge"];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (IBAction)withdrawalsHandler:(id)sender {
    //提现;
    NSLog(@"提现");
    WithdrawViewController * withdrawVC = [[UIStoryboard storyboardWithName:@"PayAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"withdraw"];
    
    [withdrawVC setHasMoney:moneyFloatView];
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

- (void)setData:(NSMutableDictionary*)data{
    
    NSNumber * haveMoney = [data objectForKey:@"accountBalance"];
    moneyFloatView = [NSString stringWithFormat:@"%.2lf",haveMoney.floatValue];
    NSString * money = [NSString stringWithFormat:@"(￥%.2lf)",haveMoney.floatValue];
    hasMoney = money;
    
    [Global getInstance].currentAccountId = [data objectForKey:@"accountId"];
    
    NSMutableArray *list = [data objectForKey:@"payList"];
    
    NSMutableString * oldTime = [NSMutableString stringWithString:@""];
    
    for(NSInteger i = 0;i < list.count;i++)
    {
        NSMutableDictionary * dic = list[i];
        NSString * currentTime = [Global getSimpleDateByTime:[dic objectForKey:@"finishTime"]];
        
        if([currentTime compare:oldTime] != 0)
        {
            [_keys addObject:currentTime];
        }
        
        oldTime = [NSMutableString stringWithString:currentTime];
    }
    
    for(NSInteger i = 0;i < _keys.count;i++)
    {
        NSString * time = _keys[i];
        NSMutableArray * array = [NSMutableArray array];
        for(NSInteger j = 0;j < list.count;j++)
        {
            NSMutableDictionary * dic = list[j];
            NSString * currentTime = [Global getSimpleDateByTime:[dic objectForKey:@"finishTime"]];
            if([time compare:currentTime] == 0)
            {
                [array addObject:dic];
            }
        }
        [dataSounrce addObject:array];
    }
        
    [accountTableView reloadData];
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray * currentData = dataSounrce[section];
    return currentData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"accountRecordCell";
    
    AccountRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[AccountRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSMutableDictionary * currentData = dataSounrce[indexPath.section][indexPath.row];
    
    NSString * payType = [currentData objectForKey:@"payFor"];
    
    NSString * addOrSub;
    NSString * title;
    NSString * address = @"";
    switch(payType.integerValue)
    {
        case 1:
            //充值;
            addOrSub = @"+";
            title = @"充值";
            break;
        case 2:
            //场地费;
            addOrSub = @"-";
            title = @"场地费支付";
            address = [currentData objectForKey:@"address"];
            break;
        case 3:
            //提现;
            addOrSub = @"-";
            title = @"提现";
            break;
    }
    NSNumber * money = [currentData objectForKey:@"payAmount"];
    
    NSString * moneyStr = [NSString stringWithFormat:@"%@ ￥%.2lf",addOrSub,money.floatValue];
    
    cell.moneyLabel.text = moneyStr;
    
    cell.titleLabel.text = title;
    
    NSString * time = [Global getDateByTime:[currentData objectForKey:@"finishTime"] isSimple:NO];
    
    NSString * timeAndAddress;
    if(address.length > 0)
    {
        timeAndAddress = [NSString stringWithFormat:@"%@\n%@",address,time];
    }else{
        timeAndAddress = [NSString stringWithFormat:@"%@",time];
    }

    cell.timeLabel.text = timeAndAddress;
    
    return cell;
}

//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_keys count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _keys[section];
}

#pragma mark -- UITableViewDelegate

@end
