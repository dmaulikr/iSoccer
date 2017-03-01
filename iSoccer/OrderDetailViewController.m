//
//  OrderDetailViewController.m
//  iSoccer
//
//  Created by Linus on 16/8/15.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "OrderDetailViewController.h"

#import "UserTableViewCell.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * detailTableView;
    
    NSArray * leftData;
    NSArray * rightData;
    NSMutableDictionary * _data;
}

@end

@implementation OrderDetailViewController

- (instancetype)initWithData:(NSMutableDictionary*)data
{
    self = [super init];
    if (self) {
        self.title = @"订单详情";
        _data = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    leftData = @[@"支付单号",@"订单费用",@"预订球场",@"预留手机",@"场次时间",@"饮料零食",@"校验码"];
    
    NSNumber * payId = [_data objectForKey:@"payId"];
    NSString * payIdStr = [NSString stringWithFormat:@"%zd",payId.integerValue];
    NSNumber * price = [_data objectForKey:@"price"];
    NSString * priceStr = [NSString stringWithFormat:@"%.2lf元",price.floatValue];
    NSString * fieldName = [_data objectForKey:@"fieldName"];
    NSString * mobile = [_data objectForKey:@"orderMobile"];
    NSString * gameTimeStr = [_data objectForKey:@"gameTimeStr"];
    
    NSString * checkCode = [_data objectForKey:@"orderCheckCode"];
    
    NSMutableArray * goodsList = [_data objectForKey:@"goodsList"];
    
    NSString * good;
    
    if(goodsList.count > 0)
    {
        NSMutableDictionary * goodData = goodsList[0];
        NSString * goodName = [goodData objectForKey:@"goodsName"];
        good = goodName;
    }else{
        good = @"无";
    }
    
    rightData = @[payIdStr,priceStr,fieldName,mobile,gameTimeStr,good,checkCode];
    
    
    detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    
    
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    
    detailTableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:detailTableView];
    
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return leftData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString * identifier = @"userCell";
    
    UserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell)
    {
        cell = [[UserTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString * leftStr = leftData[indexPath.row];
    
    [cell setLeftString:leftStr];
    
    if(rightData)
    {
        NSString * rightStr = rightData[indexPath.row];
        
        [cell setRightString:rightStr];
        
    }
    
    cell.arrowIcon.hidden = YES;
    
    return cell;

}


#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 46;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 6;
}


@end
