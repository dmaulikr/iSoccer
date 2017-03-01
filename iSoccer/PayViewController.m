//
//  PayViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/29.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "PayViewController.h"
#import "Global.h"
#import "PayTableViewCell.h"
#import "PayAccountViewController.h"
#import "NetConfig.h"
#import "NetRequest.h"

#define CELL_H (self.view.frame.size.height * 0.30)

@interface PayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *payTableView;
    
    NSMutableArray * dataSounce;
    
}

@end

@implementation PayViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
        
        NSMutableArray * accountList = [Global getInstance].payAccountList;
        
        NSMutableArray * userAccountList = [NSMutableArray array];
        NSMutableArray * teamAccountList = [NSMutableArray array];
        
        dataSounce = [NSMutableArray array];
        
        for(NSInteger i = 0;i < accountList.count;i++)
        {
            NSMutableDictionary * data = accountList[i];
            
            NSString * type = [data objectForKey:@"accountType"];
            
            if(type.integerValue == 1)
            {
                //个人账户;
                [userAccountList addObject:data];
            }else{
                //球队账户;
                [teamAccountList addObject:data];
            }
        }
        
        [dataSounce addObject:userAccountList];
        [dataSounce addObject:teamAccountList];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    if([Global getInstance].isPaySuccessed == YES || [Global getInstance].isWithdrawSuccessed == YES)
    {
        [Global getInstance].isPaySuccessed = NO;
        [Global getInstance].isWithdrawSuccessed = NO;
        
        
        NSDictionary * post = @{};
        NSMutableDictionary * postData = [post mutableCopy];
        [NetRequest POST:GET_PAY_ACCOUNT parameters:postData atView:self.view andHUDMessage:@"获取中..." success:^(id resposeObject) {
            NSString *code = resposeObject[@"code"];
            if(code.integerValue == 2)
            {
                [[Global getInstance].mainVC showLoginView:YES];
            }else{
                
                [Global getInstance].payAccountList = resposeObject[@"accountList"];
                NSMutableArray * accountList = [Global getInstance].payAccountList;
                
                NSMutableArray * userAccountList = [NSMutableArray array];
                NSMutableArray * teamAccountList = [NSMutableArray array];
                
                [dataSounce removeAllObjects];
                
                for(NSInteger i = 0;i < accountList.count;i++)
                {
                    NSMutableDictionary * data = accountList[i];
                    
                    NSString * type = [data objectForKey:@"accountType"];
                    
                    if(type.integerValue == 1)
                    {
                        //个人账户;
                        [userAccountList addObject:data];
                    }else{
                        //球队账户;
                        [teamAccountList addObject:data];
                    }
                }
                
                [dataSounce addObject:userAccountList];
                [dataSounce addObject:teamAccountList];
                
                
                [payTableView reloadData];
            }
        } failure:^(NSError *error) {
            NSLog(@"获取财务失败");
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    payTableView.sectionFooterHeight = 1.0;
    
    payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    payTableView.rowHeight = CELL_H;
    
    payTableView.backgroundColor = [UIColor blackColor];
    
    [Global getInstance].payVC  = self;
    
}

- (void)backMainView:(UIBarButtonItem*)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSMutableArray * data = dataSounce[section];
    
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * payIdentifier = @"payCell";
    
    PayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:payIdentifier];
    
    if(!cell)
    {
        cell = [[PayTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:payIdentifier andHeight:CELL_H];
    }
    
    if(indexPath.section == 1)
    {
        cell.accountBg.backgroundColor = [UIColor colorWithRed:89/255.0 green:191/255.0 blue:179/255.0 alpha:1.0];
        cell.logoBg.backgroundColor = [UIColor colorWithRed:242/255.0 green:137/255.0 blue:8/255.0 alpha:1.0];
        cell.logoLabel.text = @"球队账户";
    }
    
    NSMutableDictionary * data = dataSounce[indexPath.section][indexPath.row];
    
    NSString * accountId = [data objectForKey:@"accountId"];
    
    cell.cellLabel.text = [data objectForKey:@"accountName"];
    
    cell.accountId = accountId;
    
    NSNumber * accountBalance = [data objectForKey:@"accountBalance"];
    
    cell.money = [NSString stringWithFormat:@"%.2lf",accountBalance.floatValue];
    
    NSString * money = [NSString stringWithFormat:@"余额: %.2lf元",accountBalance.floatValue];
    
    cell.moneyLabel.text = money;
    
    NSString * url = [data objectForKey:@"accountLogo"];
    
    if(url.length > 0)
    {
        [Global loadImageFadeIn:cell.cellIcon andUrl:url isLoadRepeat:YES];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSounce.count;
}



@end
