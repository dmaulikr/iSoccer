//
//  AlreadyViewCell.m
//  iSoccer
//
//  Created by Linus on 16/8/12.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "AlreadyViewCell.h"
#import "Global.h"

#import "NetRequest.h"
#import "NetConfig.h"
#import "NetDataNameConfig.h"

@implementation AlreadyViewCell
{
    __weak IBOutlet UILabel *shopNameText;
    __weak IBOutlet UIImageView *shopImageView;
    __weak IBOutlet UILabel *fieldNameText;
    __weak IBOutlet UILabel *phoneNumberText;
    __weak IBOutlet UILabel *reservaTime;
    __weak IBOutlet UILabel *goodsText;
    __weak IBOutlet UILabel *payMsgText;
    __weak IBOutlet UILabel *useOrfailureMsgText;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIView *topTapView;
    
    __weak IBOutlet UIView *rightTapView;
    NSMutableDictionary * _data;
    __weak IBOutlet UIView *topLine;
    __weak IBOutlet UIView *bottomLine;
    BOOL isDelete;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    
    isDelete = YES;
    topLine.frame = CGRectMake(topLine.frame.origin.x, topLine.frame.origin.y, topLine.frame.size.width, 0.5);
    
    
    bottomLine.frame = CGRectMake(bottomLine.frame.origin.x, bottomLine.frame.origin.y, bottomLine.frame.size.width, 0.5);
    
    shopNameText.text = [_data objectForKey:@"shopName"];
    
    NSString * url = [_data objectForKey:@"fieldPicture"];
    if(url == nil)
    {
        url = @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1470995253&di=136283ffc1d31bd40bd6f4a4a4cab266&src=http://pic1.cxtuku.com/00/13/26/b200a3c06718.jpg";
    }
    
    shopImageView.layer.masksToBounds = YES;
    shopImageView.layer.cornerRadius = 3;
    
    [shopImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    shopImageView.contentMode =  UIViewContentModeScaleAspectFill;
    shopImageView.autoresizingMask = UIViewAutoresizingNone;
    shopImageView.clipsToBounds  = YES;
    
    [Global loadImageFadeIn:shopImageView andUrl:url isLoadRepeat:YES];
    
    NSString * shopName = [_data objectForKey:@"shopName"];
    shopNameText.text = shopName;
    
    
    NSString * fieldName = [_data objectForKey:@"fieldName"];
    
    fieldNameText.text = fieldName;
    
    NSString * phoneNumber = [_data objectForKey:@"orderMobile"];
    
    phoneNumberText.text = phoneNumber;
    
    NSMutableArray * goods = [_data objectForKey:@"goodsList"];
    
    NSNumber * startTime = [_data objectForKey:@"fieldTimeStart"];
    
    NSInteger startIntTime = startTime.integerValue / 1000;
    
    NSNumber * endTime = [_data objectForKey:@"fieldTimeEnd"];
    
    NSInteger endIntTime = endTime.integerValue / 1000;
    
    NSDate * date = [NSDate date];
    NSInteger nowTime = date.timeIntervalSince1970;
    
    
    if(nowTime < startIntTime)
    {
        //比赛未开始;
        NSInteger temp = startIntTime - nowTime;
        if(temp > 172800)
        {
            //比赛未开始两天前可以取消订单显示取消订单
            [deleteButton setTitle:@"取消预订" forState:UIControlStateNormal];
            isDelete = NO;
        }else{
            isDelete = YES;
            [deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
            if(nowTime < endIntTime)
            {
                [deleteButton setHidden:YES];
            }
        }
        
    }else{
        //比赛已经开始;
        if(nowTime > endIntTime)
        {
            //比赛已经结束可以删除;
            isDelete = YES;
            [deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
            
        }else{
            //比赛未结束还在比赛中
            [deleteButton setHidden:YES];//隐藏
            [deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
        }
        
    }
    
    
    
    NSString * goodsString;
    if(goods.count > 0)
    {
        NSMutableDictionary * good = goods[0];
        
        goodsString = [good objectForKey:@"goodsName"];
    }else
    {
        goodsString = @"无";
    }
    
    NSString * gameTime = [_data objectForKey:@"gameTimeStr"];
    
    goodsText.text = goodsString;
    
    payMsgText.text = [_data objectForKey:@"finishTime"];
    
    //NSString * orderCreateTime = [_data objectForKey:@"orderCreateTime"];
    
    
    NSString * orderStateStr = [_data objectForKey:@"orderStateStr"];
    
    if([orderStateStr isEqualToString:@"未使用"])
    {
        //没有使用显示验证码;
        
        NSString * orderCode = [_data objectForKey:@"orderCheckCode"];
        
        useOrfailureMsgText.text = [NSString stringWithFormat:@"验证码: %@",orderCode];
        
        
    }else if([orderStateStr isEqualToString:@"已使用"])
    {
        //已使用显示已使用时间以及文字;
        useOrfailureMsgText.text = [NSString stringWithFormat:@"%@ %@",gameTime,orderStateStr];
        
    }else{
        //已过期显示已经过期时间和文字;
        useOrfailureMsgText.text = [NSString stringWithFormat:@"%@ %@",gameTime,orderStateStr];
    }
    
    
    deleteButton.layer.borderColor = [UIColor colorWithRed:59.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1].CGColor;
    deleteButton.layer.borderWidth = 0.5;
    deleteButton.layer.masksToBounds = YES;
    deleteButton.layer.cornerRadius = 2;
    
    
    [deleteButton addTarget:self action:@selector(tapDeleteHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
    shopImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageHandler:)];
    
    [shopImageView addGestureRecognizer:tapImage];
    
    
    topTapView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapTop = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopHandler:)];
    
    [topTapView addGestureRecognizer:tapTop];
    
    rightTapView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapRight = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOrderDetailHandler:)];
    [rightTapView addGestureRecognizer:tapRight];

    reservaTime.text = gameTime;
    
    
    UIColor *grayColor = [UIColor colorWithRed:232.0/255.0 green:230.0/255.0 blue:234.0/255.0 alpha:1.0];
    
    
    UIView * topL = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    
    topL.backgroundColor = grayColor;
    
    [self addSubview:topL];
    
    
    UIView * bottomL= [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    bottomL.backgroundColor = grayColor;
    
    [self addSubview:bottomL];
    
}




- (void)setViewWithData:(NSMutableDictionary*)data{
 
    //NSLog(@"%@",data);
    
    _data = data;
    
}

- (void)tapImageHandler:(UITapGestureRecognizer*)gesture{
    NSLog(@"场地详情");
    
    NSString * fieldId = [_data objectForKey:@"fieldId"];
    
    NSDictionary * post = @{@"fieldId":fieldId};
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:GET_FIELD_DETAIL_BY_FIELDID parameters:postData atView:self.superview.superview.superview andHUDMessage:@"获取中。." success:^(id resposeObject) {
        NSLog(@"%@",resposeObject);
        
        NSMutableDictionary * data = resposeObject[@"data"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_SHOW_FIELD_DETAIL_BY_ORDER object:data];
        
    } failure:^(NSError *error) {
        NSLog(@"获取失败");
    }];
    
}


- (void)tapTopHandler:(UITapGestureRecognizer*)gesture{
    NSLog(@"商家首页");
    
    NSString * shopId = [_data objectForKey:@"shopId"];
    
    NSDictionary * post = @{@"shopId":shopId};
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    
    [NetRequest POST:GET_SHOP_DETAIL_BY_SHOPID parameters:postData atView:self.superview.superview.superview andHUDMessage:@"加载中.." success:^(id resposeObject) {
        NSLog(@"%@",resposeObject);
        
        NSMutableDictionary * data = resposeObject[@"data"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_SHOW_FIELD_INDEX_BY_ORDER object:data];
        
    } failure:^(NSError *error) {
        NSLog(@"获取失败");
    }];
    
}


- (void)tapOrderDetailHandler:(UITapGestureRecognizer*)gesture{
    NSLog(@"订单详情");
    
    [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_SHOW_ORDER_DETAIL object:_data];
    
}

- (void)tapDeleteHandler:(UIButton*)sender{
    
    if(isDelete == YES)
    {
        
        UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"确认删除" message:@"确认删除此订单？" delegate:self cancelButtonTitle:@"取消删除" otherButtonTitles:@"确认删除", nil];
        
        [alerView show];
    }else{
        
        UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"用户须知" message:@"确认退款金额将返回至用户个人账户." delegate:self cancelButtonTitle:@"取消退款" otherButtonTitles:@"确认退款", nil];
        
        [alerView show];
  
    }
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1)
    {
        
        NSString * orderId = [_data objectForKey:@"orderId"];
        
        NSDictionary * post = @{@"orderId":orderId};
        
        NSMutableDictionary * postData = [post mutableCopy];
        if(isDelete)
        {
            [NetRequest POST:DELETE_ORDER_ONE parameters:postData atView:self.superview.superview.superview andHUDMessage:@"删除中.." success:^(id resposeObject) {
                
                NSLog(@"%@",resposeObject);
                NSString * code = resposeObject[@"code"];
                if(code.integerValue == 1)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_REFRESH_ORDER object:nil];
                }
                
            } failure:^(NSError *error) {
                NSLog(@"删除失败");
            }];

        }else{
            //点击确认;
            [NetRequest POST:CANCEL_RESERVATION_ORDER parameters:postData atView:self.superview.superview.superview andHUDMessage:@"取消中.." success:^(id resposeObject) {
                
                NSLog(@"%@",resposeObject);
                NSString * code = resposeObject[@"code"];
                if(code.integerValue == 1)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_REFRESH_ORDER object:nil];
                }
                
            } failure:^(NSError *error) {
                NSLog(@"取消失败");
            }];

        }
    }
}

@end
