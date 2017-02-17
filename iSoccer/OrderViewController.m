//
//  OrderViewController.m
//  iSoccer
//
//  Created by Linus on 16/8/10.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "OrderViewController.h"
#import "Global.h"
#import "UserData.h"
#import "UserTableViewCell.h"
#import "ChangeOrderViewController.h"
#import "MMPickerView.h"
#import "PayFastNavigationViewController.h"

#import "NetConfig.h"
#import "NetRequest.h"

#define DEFAULT_CELL_HEIGHT 48

@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableDictionary * _data;
    NSArray * leftData;
    NSArray * rightData;
    NSArray * arrowData;
    NSArray * typeData;
    
    CGFloat reservaCost;//场地费
    CGFloat goodsCost;//商品费;
    NSString * fieldName;//球场名字;
    
    NSMutableArray * daysData;
    
    NSMutableArray * timesData;
    
    NSMutableArray * fieldPrices;
    NSMutableArray * goodsPrices;
    
    NSMutableArray * goodsData;
    
    NSMutableArray * goodsIdData;
    NSMutableArray * fieldPricesIdData;
    
    UITableView * orderTableView;
    
    UserTableViewCell * costCell;
    UserTableViewCell * timeCell;
    
    UserTableViewCell * currentCell;
    
    NSString * currentPhoneNumber;
    NSMutableArray * fieldPriceDaysList;
    
    NSInteger dayIndex;
    NSInteger timesIndex;
    NSInteger goodIndex;
}

@end

@implementation OrderViewController


- (instancetype)initWithData:(NSMutableDictionary*)data andFieldName:(NSString*)name
{
    self = [super init];
    if (self) {
        
        self.title = @"预订球场";
        _data = data;
        fieldName = name;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    if([Global getInstance].isUpdateReservationPhoneNumber == YES)
    {
        
        NSString * changePhoneNumber = [Global getInstance].reservationPhoneNumber;
        
        currentPhoneNumber = changePhoneNumber;
        [currentCell setRightString:changePhoneNumber];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    goodIndex = 0;
    timesIndex = 0;
    dayIndex = 0;
    
    daysData = [NSMutableArray array];
    timesData = [NSMutableArray array];
    goodsData = [NSMutableArray array];
    goodsPrices = [NSMutableArray array];
    fieldPrices = [NSMutableArray array];
    goodsIdData = [NSMutableArray array];
    fieldPricesIdData = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    
    leftData = @[@"结算价格",@"预订球场",@"预订手机",@"选择时间",@"选择场次",@"饮料零食"];
    
    arrowData = @[@"0",@"0",@"1",@"1",@"1",@"1"];
    
    typeData = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    
    
    //取得默认值和默认价格;
    
    fieldPriceDaysList = [_data objectForKey:@"fieldPriceDaysList"];
    
    NSMutableDictionary * fieldDefault = fieldPriceDaysList[0];
    
    NSMutableArray * times = [fieldDefault objectForKey:@"fieldPriceList"];
    
    for(NSInteger i = 0;i < times.count;i++)
    {
        NSMutableDictionary * timeInfo = times[i];
        
        NSString * start = [timeInfo objectForKey:@"fieldTimeStart"];
        NSString * end = [timeInfo objectForKey:@"fieldTimeEnd"];
        
        NSString * time = [NSString stringWithFormat:@"%@ - %@",start,end];
        
        [timesData addObject:time];
        
        NSString * price = [timeInfo objectForKey:@"fieldPrice"];
        
        [fieldPrices addObject:price];
        
        NSString * priceId = [timeInfo objectForKey:@"fieldPriceId"];
        [fieldPricesIdData addObject:priceId];
        
    }
    
    //取出所有商品;
    NSMutableArray * goodsList = [_data objectForKey:@"goodsList"];
    
    for(NSInteger i = 0;i < goodsList.count; i++)
    {
        NSMutableDictionary * goodsInfo = goodsList[i];
        NSString * goodsPrice = [goodsInfo objectForKey:@"goodsPrice"];
        
        if(goodsPrice == nil)
        {
            [goodsPrices addObject:@"0"];
        }else{
            [goodsPrices addObject:goodsPrice];
        }
        
        NSString * goodsName = [goodsInfo objectForKey:@"goodsName"];
        [goodsData addObject:goodsName];
        
        NSString * goodsId = [goodsInfo objectForKey:@"goodsId"];
        
        if(goodsId == nil)
        {
            [goodsIdData addObject:@-1];
        }else{
            [goodsIdData addObject:goodsId];
        }
        
    }
    
    
    //取出所有天数;
    
    for(NSInteger i = 0;i < fieldPriceDaysList.count;i ++)
    {
        NSMutableDictionary * fieldPD = fieldPriceDaysList[i];
        NSString * dayString = [fieldPD objectForKey:@"fieldDay"];
        
        [daysData addObject:dayString];
    }
    
    //取出默认价格;
    NSString * costField = fieldPrices[0];
    NSString * costGood = goodsPrices[0];
    
    reservaCost = costField.floatValue;
    goodsCost = costGood.floatValue;
    
    CGFloat sumCost = reservaCost + goodsCost;
    
    NSString * sumString = [NSString stringWithFormat:@"￥%.2lf",sumCost];
    
    NSString * tel = [Global getInstance].userData.phoneNumber;
    
    if(tel == nil)
    {
        tel = @"";
    }
    
    currentPhoneNumber = tel;
    
    NSString * defaultDate = daysData[0];
    NSString * defaultTime = timesData[0];
    NSString * defaultGoods = goodsData[0];
    
    rightData = @[sumString,fieldName,tel,defaultDate,defaultTime,defaultGoods];
    
    orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    
    orderTableView.backgroundColor = [UIColor clearColor];
    
    orderTableView.delegate = self;
    
    orderTableView.dataSource = self;
    
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.16)];
    
    UIButton * reservaButton = [UIButton buttonWithType:UIButtonTypeSystem];
    reservaButton.frame = CGRectMake(0, 0, self.view.frame.size.width - 30, 48);
    
    [reservaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reservaButton setTitle:@"立即预订" forState:UIControlStateNormal];
    reservaButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [reservaButton addTarget:self action:@selector(reservaHandler:) forControlEvents:UIControlEventTouchUpInside];
    reservaButton.backgroundColor = [UIColor blackColor];
    reservaButton.layer.masksToBounds = YES;
    reservaButton.layer.cornerRadius = 4;
    
    reservaButton.center = CGPointMake(footerView.frame.size.width/2, footerView.frame.size.height/2);
    
    [footerView addSubview:reservaButton];
    
    orderTableView.tableFooterView = footerView;
    
    [self.view addSubview:orderTableView];
}


- (void)reservaHandler:(UIButton*)sender{
    NSLog(@"预订支付");
    UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"用户须知" message:@"开场前48小时取消订单，商家将全额退款；开场前48小时内取消订单或未在预订时段抵达球场，商家将不予退款。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"知道了", nil];
    
    [alerView show];
}

- (void)payHandler{
    NSString * mobile = currentPhoneNumber;
    
    NSString * priceId = fieldPricesIdData[timesIndex];
    
    NSNumber * goodsId = goodsIdData[goodIndex];
    
    NSString *goodId = [NSString stringWithFormat:@"%zd",goodsId.integerValue];
    
    
    NSString * userId = [Global getInstance].userData.userId;
    
    NSLog(@"%@",userId);
    
    NSDictionary * post;
    
    if([goodId isEqualToString:@"-1"])
    {
        post = @{@"mobiel":mobile,@"fieldPriceId":priceId};
        
    }else{
        post = @{@"mobiel":mobile,@"footballGoodsIdStr":goodId,@"fieldPriceId":priceId};
    }
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:CREAGE_ORDER_PAY parameters:postData atView:self.view andHUDMessage:@"创建订单中.." success:^(id resposeObject) {
        NSLog(@"%@",resposeObject);
        
        NSMutableDictionary * data = resposeObject[@"pay"];
        
        NSString * orderCheckCode = [data objectForKey:@"orderCheckCode"];
        
        [Global getInstance].currentPayData = data;
        
        [Global getInstance].fieldOrderCheckCode = orderCheckCode;
        
        UIStoryboard *payStory = [UIStoryboard storyboardWithName:@"PayFast" bundle:nil];
        PayFastNavigationViewController * payVC = payStory.instantiateInitialViewController;
        [self presentViewController:payVC animated:YES completion:nil];
        
        
        
    } failure:^(NSError *error) {
        NSLog(@"创建失败..");
    }];
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1)
    {
        [self payHandler];
    }
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return leftData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
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
    
    NSString *showArrow = arrowData[indexPath.row];
    if(showArrow.integerValue > 0)
    {
        cell.arrowIcon.hidden = NO;
    }else{
        cell.arrowIcon.hidden = YES;
    }
    
    if(indexPath.row == 0)
    {
        costCell = cell;
    }else if(indexPath.row == 4)
    {
        timeCell = cell;
    }
    
//    if(indexPath.row == leftData.count - 1)
//    {
//        UIColor *grayColor = [UIColor colorWithRed:232.0/255.0 green:230.0/255.0 blue:234.0/255.0 alpha:1.0];
//        
//        UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, DEFAULT_CELL_HEIGHT - 0.5, self.view.frame.size.width, 0.5)];
//        bottomLine.backgroundColor = grayColor;
//        
//        [cell addSubview:bottomLine];
//    }
    
    return cell;

}





#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    
    
    if(indexPath.row > 1)
    {
        currentCell = (UserTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        NSString * rightStirng = currentCell.rightLabel.text;
        
        if(indexPath.row == 2)
        {
            ChangeOrderViewController * changeVC = [[ChangeOrderViewController alloc]initWithTitle:@"预留电话" defaultString:rightStirng];
            
            [self.navigationController pushViewController:changeVC animated:YES];
        }else if(indexPath.row == 3)
        {
            [MMPickerView showPickerViewInView:self.view
                                   withStrings:daysData
                                   withOptions:@{MMselectedObject:rightStirng}
                                    completion:^(NSString *selectedString) {
                                        //selectedString is the return value which you can use as you wish
                                        [currentCell setRightString:selectedString];
                                        
                                        dayIndex = [daysData indexOfObject:selectedString];
                                    } hedden:^{
               
                                        NSMutableDictionary * fieldDefault = fieldPriceDaysList[dayIndex];
                                        
                                        timesData = [NSMutableArray array];
                                        fieldPrices = [NSMutableArray array];
                                        fieldPricesIdData = [NSMutableArray array];
                                        
                                        NSMutableArray * times = [fieldDefault objectForKey:@"fieldPriceList"];
                                        
                                        for(NSInteger i = 0;i < times.count;i++)
                                        {
                                            NSMutableDictionary * timeInfo = times[i];
                                            
                                            NSString * start = [timeInfo objectForKey:@"fieldTimeStart"];
                                            NSString * end = [timeInfo objectForKey:@"fieldTimeEnd"];
                                            
                                            NSString * time = [NSString stringWithFormat:@"%@ - %@",start,end];
                                            
                                            [timesData addObject:time];
                                            
                                            NSString * price = [timeInfo objectForKey:@"fieldPrice"];
                                            
                                            NSString * priceId = [timeInfo objectForKey:@"fieldPriceId"];
                                            [fieldPricesIdData addObject:priceId];
                                            
                                            [fieldPrices addObject:price];
                                            
                                        }
                                        
                                        [self updateData];
                                    }];
            
        }else if(indexPath.row == 4)
        {
            
            [MMPickerView showPickerViewInView:self.view
                                   withStrings:timesData
                                   withOptions:@{MMselectedObject:rightStirng}
                                    completion:^(NSString *selectedString) {
                                        //selectedString is the return value which you can use as you wish
                                        [currentCell setRightString:selectedString];
                                        
                                        timesIndex = [timesData indexOfObject:selectedString];
                                    } hedden:^{
                                        
                                        NSString * costField = fieldPrices[timesIndex];
                                        NSString * costGood = goodsPrices[goodIndex];
                                        
                                        reservaCost = costField.floatValue;
                                        goodsCost = costGood.floatValue;
                                        
                                        CGFloat sumCost = reservaCost + goodsCost;
                                        
                                        NSString * sumString = [NSString stringWithFormat:@"￥%.2lf",sumCost];
                                        
                                        [costCell setRightString:sumString];
                                    }];
            
        }else{
            [MMPickerView showPickerViewInView:self.view
                                   withStrings:goodsData
                                   withOptions:@{MMselectedObject:rightStirng}
                                    completion:^(NSString *selectedString) {
                                        //selectedString is the return value which you can use as you wish
                                        [currentCell setRightString:selectedString];
                                        
                                        goodIndex = [goodsData indexOfObject:selectedString];
                                    } hedden:^{
                                        
                                        NSString * costField = fieldPrices[timesIndex];
                                        NSString * costGood = goodsPrices[goodIndex];
                                        
                                        reservaCost = costField.floatValue;
                                        goodsCost = costGood.floatValue;
                                        
                                        CGFloat sumCost = reservaCost + goodsCost;
                                        
                                        NSString * sumString = [NSString stringWithFormat:@"￥%.2lf",sumCost];
                                        
                                        [costCell setRightString:sumString];
                                    }];

        }
    }
}


- (void)updateData{
    //取出默认价格;
    NSString * costField = fieldPrices[0];
    NSString * costGood = goodsPrices[goodIndex];
    
    reservaCost = costField.floatValue;
    goodsCost = costGood.floatValue;
    
    CGFloat sumCost = reservaCost + goodsCost;
    
    NSString * sumString = [NSString stringWithFormat:@"￥%.2lf",sumCost];
    
    [costCell setRightString:sumString];
    
    NSString * defaultTime = timesData[0];
    
    [timeCell setRightString:defaultTime];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return DEFAULT_CELL_HEIGHT;
}


@end
