//
//  NewNotifiCellTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/5/3.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "NewNotifiCellTableViewCell.h"
#import "Global.h"
#import "NetRequest.h"
#import "NetConfig.h"
#import "NetDataNameConfig.h"

#import <QuartzCore/QuartzCore.h>

#define V_GAP ([UIScreen mainScreen].bounds.size.height * 0.008)


@implementation NewNotifiCellTableViewCell
{
    UIView * whiteBg;
    UIView *titleBg;
    UILabel * noticeTimeLabel;
    
    NSMutableDictionary *dataSource;
    NSString * noticeId;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andData:(NSMutableDictionary*)data{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        dataSource = data;
        
        //type; 0:创建比赛,1:加入比赛,2:比赛前24消失提醒,3:比赛前1小时提醒,4:取消比赛,5:球队加入新成员,6:充值成功,7:支付成功,8:提现成功,9:未支付场地费提示,10:比赛不足6人,11:删除比赛.
        UIColor *titleRedColor = [UIColor colorWithRed:211.0/255.0 green:98.0/255.0 blue:99.0/255.0 alpha:1];
        UIColor *titleBlueColor = [UIColor colorWithRed:89.0/255.0 green:155.0/255.0 blue:213.0/255.0 alpha:1];
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        
        self.backgroundColor = [UIColor clearColor];
        
        
        whiteBg = [[UIView alloc]initWithFrame:CGRectMake(size.width * 0.035, 0, size.width * 0.93, size.height * 0.46)];
        
        whiteBg.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:whiteBg];
        
        self.frame = CGRectMake(0, 0, size.width, whiteBg.frame.size.height);
        
        titleBg = [[UIView alloc]initWithFrame:CGRectMake(whiteBg.frame.origin.x, 0, whiteBg.frame.size.width, whiteBg.frame.size.height * 0.16)];
        
        UILabel * msgTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake((titleBg.frame.size.width - 45) * 0.5, 2, 45, 15)];
        
        msgTypeLabel.text = @"消息类型";
        msgTypeLabel.font = [UIFont systemFontOfSize:11];
        msgTypeLabel.textColor = [UIColor whiteColor];
        
        [titleBg addSubview:msgTypeLabel];
        
        
        UIBezierPath *maskTitlePath = [UIBezierPath bezierPathWithRoundedRect:titleBg.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4,4)];
        CAShapeLayer *maskTitleLayer = [[CAShapeLayer alloc] init];
        maskTitleLayer.frame = titleBg.bounds;
        maskTitleLayer.path = maskTitlePath.CGPath;
        titleBg.layer.mask = maskTitleLayer;
        
        
        [self.contentView addSubview:titleBg];
        
        
        noticeTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(V_GAP + titleBg.frame.origin.x, titleBg.frame.origin.y + titleBg.frame.size.height + 4, whiteBg.frame.size.width - 12, 20)];
        
        noticeTimeLabel.textColor = [UIColor lightGrayColor];
        
        noticeTimeLabel.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:noticeTimeLabel];
        
        CGSize screenWH = [UIScreen mainScreen].bounds.size;
    
        UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(0, 0, screenWH.width / 375 * 20, screenWH.height / 667 * 24);
        [deleteButton setImage:[UIImage imageNamed:@"delete_write.png"] forState:UIControlStateNormal];
        deleteButton.center = CGPointMake(titleBg.frame.size.width - titleBg.frame.size.width * 0.06, titleBg.frame.size.height/2);
        [deleteButton addTarget:self action:@selector(tapDeleteHandler:) forControlEvents:UIControlEventTouchUpInside];
        [titleBg addSubview:deleteButton];

        noticeId = [data objectForKey:@"noticeId"];
        
        NSString * type = [data objectForKey:@"noticeType"];
        
        switch(type.integerValue)
        {
            case 0:
                //创建比赛
                [self setZeroType:titleBlueColor];
                break;
            case 1:
                //加入比赛
                [self setOneType:titleBlueColor];
                break;
            case 2:
                //比赛前24小时提醒
                [self setTwoType:titleBlueColor];
                break;
            case 3:
                //比赛前1小时提醒
                [self setThreeType:titleBlueColor];
                break;
            case 4:
                //取消比赛
                [self setFourType:titleBlueColor];
                break;
            case 5:
                //球队加入新成员
                [self setFiveType:titleBlueColor];
                break;
            case 6:
                //充值成功
                [self setSixType:titleRedColor];
                break;
            case 7:
                //支付成功
                [self setSevenType:titleRedColor];
                break;
            case 8:
                //提现成功
                [self setEightType:titleRedColor];
                break;
            case 9:
                //赛事报名成功;
                //NSLog(@"%@",data);
                [self setNineType:titleBlueColor];
                break;
            case 10:
                //比赛不足6人
                [self setTenType:titleBlueColor];
                break;
            case 12:
                //预订球场通知;
                [self setTwelveType:titleRedColor];
                break;
        }
        
    }
    return self;
    
}

- (void)tapDeleteHandler:(UIButton*)sender{
    
    NSDictionary * post = @{@"noticeId":noticeId};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:DELETE_NOTICE parameters:postData atView:self.superview.superview andHUDMessage:@"删除中.." success:^(id resposeObject) {
        
        [Global getInstance].currentDeleteNoticeId = noticeId;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_DELETE_NOTICE object:nil];
        
    } failure:^(NSError *error) {
        NSLog(@"报错");
    }];
}


//type12
- (void)setTwelveType:(UIColor*)titleColor{
    titleBg.backgroundColor = titleColor;
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, titleBg.frame.size.width, titleBg.frame.size.height - 15)];
    title.text = @"预订球场";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [titleBg addSubview:title];
    
    
    NSString * time = [dataSource objectForKey:@"noticeTime"];
    noticeTimeLabel.text = time;
    
    NSString * userId = [dataSource objectForKey:@"userId"];
    NSNumber * payAmount = [dataSource objectForKey:@"payAmount"];
    NSString * payString = [NSString stringWithFormat:@"%.2lf元",payAmount.floatValue];
    NSString * matchTime = [dataSource objectForKey:@"noticeTime"];
    
    NSString * contentString = [dataSource objectForKey:@"noticeContent"];
    
    
    UILabel * moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(noticeTimeLabel.frame.origin.x + 10, noticeTimeLabel.frame.origin.y + noticeTimeLabel.frame.size.height + V_GAP * 2,noticeTimeLabel.frame.size.width - 20 , 40)];
    
    moneyLabel.textColor = [UIColor grayColor];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    moneyLabel.text = @"支付金额";
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:moneyLabel];
    
    NSString * content = [NSString stringWithFormat:@"%@",payString];
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.frame.origin.x, moneyLabel.frame.origin.y + moneyLabel.frame.size.height + V_GAP * 2, moneyLabel.frame.size.width, whiteBg.frame.size.height * 0.1)];
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    //contentLabel.backgroundColor = [UIColor blueColor];
    contentLabel.font = [UIFont systemFontOfSize:24];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.text = content;
    [self.contentView addSubview:contentLabel];
    [self addShapeByPreView:contentLabel];
    
    UILabel * userIdLabel = [self createMessageLabel:@"支付账号" andContent:userId];
    userIdLabel.center = CGPointMake(contentLabel.center.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + V_GAP * 3 + userIdLabel.frame.size.height/2);
    [self.contentView addSubview:userIdLabel];
    
    NSString * message = [NSString stringWithFormat:@"%@: %@",@"订单详情",contentString];
    
    UILabel * matchNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, noticeTimeLabel.frame.size.width - 20, 40)];
    
    matchNameLabel.font = [UIFont systemFontOfSize:14];
    matchNameLabel.textColor = [UIColor grayColor];
    matchNameLabel.text = message;
    matchNameLabel.numberOfLines = 0;
    matchNameLabel.center = CGPointMake(userIdLabel.center.x, userIdLabel.center.y + userIdLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchNameLabel];
    
    UILabel * matchTimeLabel = [self createMessageLabel:@"订单时间" andContent:matchTime];
    matchTimeLabel.center = CGPointMake(matchNameLabel.center.x, matchNameLabel.center.y + matchNameLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchTimeLabel];
    
    [self setWhiteBgHeight:matchTimeLabel];
    
}


//type9
- (void)setNineType:(UIColor*)titleColor{
    titleBg.backgroundColor = titleColor;
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, titleBg.frame.size.width, titleBg.frame.size.height - 15)];
    
    title.text = @"赛事参加成功";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    
    [titleBg addSubview:title];
    
    NSString * time = [dataSource objectForKey:@"noticeTime"];
    
    noticeTimeLabel.text = time;
    
    NSString * matchName = [dataSource objectForKey:@"matchName"];
    
    NSString * startTime = [dataSource objectForKey:@"startDate"];
    
    NSString * endTime = [dataSource objectForKey:@"endDate"];
    
    NSString * sTime = [Global getDateByTime:startTime isSimple:YES];
    NSString * eTime = [Global getDateByTime:endTime isSimple:YES];
    
    NSString * showTime = [NSString stringWithFormat:@"%@ 至 %@",sTime,eTime];
    
    
    NSString * content = [NSString stringWithFormat:@"您好!\n您已经成功提交〖%@〗报名资料",matchName];
    
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(noticeTimeLabel.frame.origin.x + 10, noticeTimeLabel.frame.origin.y + noticeTimeLabel.frame.size.height + V_GAP * 2, noticeTimeLabel.frame.size.width - 20, whiteBg.frame.size.height * 0.3)];
    
    contentLabel.numberOfLines = 0;
    //contentLabel.backgroundColor = [UIColor blueColor];
    
    contentLabel.font = [UIFont systemFontOfSize:15];
    
    contentLabel.textColor = [UIColor redColor];
    
    contentLabel.text = content;
    
    [self.contentView addSubview:contentLabel];
    
    
    [self addShapeByPreView:contentLabel];
    
    UILabel * matchNameLabel = [self createMessageLabel:@"比赛名称" andContent:matchName];
    
    matchNameLabel.center = CGPointMake(contentLabel.center.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + V_GAP * 3 + matchNameLabel.frame.size.height/2);
    
    [self.contentView addSubview:matchNameLabel];
    
    UILabel * matchTimeLabel = [self createMessageLabel:@"比赛时间" andContent:showTime];
    
    matchTimeLabel.center = CGPointMake(matchNameLabel.center.x, matchNameLabel.center.y + matchNameLabel.frame.size.height + V_GAP);
    
    [self.contentView addSubview:matchTimeLabel];
    [self setWhiteBgHeight:matchTimeLabel];
}


//type10
- (void)setTenType:(UIColor*)titleColor{
    titleBg.backgroundColor = titleColor;
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, titleBg.frame.size.width, titleBg.frame.size.height - 15)];
    title.text = @"参赛人数不足提醒";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [titleBg addSubview:title];
    
    
    NSString * time = [dataSource objectForKey:@"noticeTime"];
    noticeTimeLabel.text = time;
    
    NSString * matchName = [dataSource objectForKey:@"matchName"];
    NSString * matchTime = [dataSource objectForKey:@"matchTime"];
    NSString * matchAddress = [dataSource objectForKey:@"matchPlace"];
    NSString * matchOpponent = [dataSource objectForKey:@"matchOpponent"];
    NSNumber * teamMemberCount = [dataSource objectForKey:@"teamMemberCount"];
    NSString * number = [NSString stringWithFormat:@"%zd",teamMemberCount.integerValue];
    
    NSString * content = [NSString stringWithFormat:@"您好!\n%@创建的〖%@〗比赛人数不足6人",matchTime,matchName];
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(noticeTimeLabel.frame.origin.x + 10, noticeTimeLabel.frame.origin.y + noticeTimeLabel.frame.size.height + V_GAP * 2, noticeTimeLabel.frame.size.width - 20, whiteBg.frame.size.height * 0.3)];
    contentLabel.numberOfLines = 0;
    //contentLabel.backgroundColor = [UIColor blueColor];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor redColor];
    contentLabel.text = content;
    [self.contentView addSubview:contentLabel];
    [self addShapeByPreView:contentLabel];
    
    UILabel * matchNameLabel = [self createMessageLabel:@"比赛名称" andContent:matchName];
    matchNameLabel.center = CGPointMake(contentLabel.center.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + V_GAP * 3 + matchNameLabel.frame.size.height/2);
    [self.contentView addSubview:matchNameLabel];
    UILabel * matchTimeLabel = [self createMessageLabel:@"比赛时间" andContent:matchTime];
    matchTimeLabel.center = CGPointMake(matchNameLabel.center.x, matchNameLabel.center.y + matchNameLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchTimeLabel];
    UILabel * matchAddressLabel = [self createMessageLabel:@"比赛场地" andContent:matchAddress];
    matchAddressLabel.center = CGPointMake(matchTimeLabel.center.x, matchTimeLabel.center.y + matchTimeLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchAddressLabel];
    UILabel * matchOpponentLabel = [self createMessageLabel:@"比赛对手" andContent:matchOpponent];
    matchOpponentLabel.center = CGPointMake(matchAddressLabel.center.x, matchAddressLabel.center.y + matchAddressLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchOpponentLabel];
    
    UILabel * matchNumberLabel = [self createMessageLabel:@"参赛人数" andContent:number];
    matchNumberLabel.center = CGPointMake(matchOpponentLabel.center.x, matchOpponentLabel.center.y + matchOpponentLabel.frame.size.height+ V_GAP);
    [self.contentView addSubview:matchNumberLabel];
    
    [self setWhiteBgHeight:matchNumberLabel];
    
}

//type8
- (void)setEightType:(UIColor*)titleColor{
    titleBg.backgroundColor = titleColor;
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, titleBg.frame.size.width, titleBg.frame.size.height - 15)];
    title.text = @"提现申请提交成功通知";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [titleBg addSubview:title];
    
    
    NSString * time = [dataSource objectForKey:@"noticeTime"];
    noticeTimeLabel.text = time;
    
    NSString * userId = [dataSource objectForKey:@"userId"];
    NSNumber * payAmount = [dataSource objectForKey:@"payAmount"];
    NSString * payString = [NSString stringWithFormat:@"%.2lf元",payAmount.floatValue];
    NSString * userNick = [dataSource objectForKey:@"nickName"];
    NSString * cardNumber = [dataSource objectForKey:@"cardNumber"];
    NSString * cashBank = [dataSource objectForKey:@"cashBank"];
    NSString * cashName = [dataSource objectForKey:@"cashName"];
    
    UILabel * moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(noticeTimeLabel.frame.origin.x + 10, noticeTimeLabel.frame.origin.y + noticeTimeLabel.frame.size.height + V_GAP * 2,noticeTimeLabel.frame.size.width - 20 , 20)];
    
    moneyLabel.textColor = [UIColor grayColor];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    moneyLabel.text = @"提现金额";
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:moneyLabel];
    
    NSString * content = [NSString stringWithFormat:@"%@",payString];
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.frame.origin.x, moneyLabel.frame.origin.y + moneyLabel.frame.size.height + V_GAP * 2, moneyLabel.frame.size.width, whiteBg.frame.size.height * 0.1)];
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    //contentLabel.backgroundColor = [UIColor blueColor];
    contentLabel.font = [UIFont systemFontOfSize:24];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.text = content;
    [self.contentView addSubview:contentLabel];
    [self addShapeByPreView:contentLabel];
    
    UILabel * userIdLabel = [self createMessageLabel:@"支付账号" andContent:userId];
    userIdLabel.center = CGPointMake(contentLabel.center.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + V_GAP * 3 + userIdLabel.frame.size.height/2);
    [self.contentView addSubview:userIdLabel];
    
    UILabel * userNickLabel = [self createMessageLabel:@"支付昵称" andContent:userNick];
    userNickLabel.center = CGPointMake(userIdLabel.center.x, userIdLabel.center.y + userIdLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:userNickLabel];
    
    UILabel * matchNameLabel = [self createMessageLabel:@"开户行" andContent:cashBank];
    matchNameLabel.center = CGPointMake(userNickLabel.center.x, userNickLabel.center.y + userNickLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchNameLabel];
    
    UILabel * matchAddressLabel = [self createMessageLabel:@"持卡人" andContent:cashName];
    matchAddressLabel.center = CGPointMake(matchNameLabel.center.x, matchNameLabel.center.y + matchNameLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchAddressLabel];
    
    UILabel * matchTimeLabel = [self createMessageLabel:@"卡  号" andContent:cardNumber];
    matchTimeLabel.center = CGPointMake(matchAddressLabel.center.x, matchAddressLabel.center.y + matchAddressLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchTimeLabel];
    
    [self setWhiteBgHeight:matchTimeLabel];
    
}

//type7
- (void)setSevenType:(UIColor*)titleColor{
    titleBg.backgroundColor = titleColor;
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, titleBg.frame.size.width, titleBg.frame.size.height - 15)];
    title.text = @"场地费支付成功";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [titleBg addSubview:title];
    
    
    NSString * time = [dataSource objectForKey:@"noticeTime"];
    noticeTimeLabel.text = time;
    
    NSString * userId = [dataSource objectForKey:@"userId"];
    NSNumber * payAmount = [dataSource objectForKey:@"payAmount"];
    NSString * payString = [NSString stringWithFormat:@"%.2lf元",payAmount.floatValue];
    NSString * userNick = [dataSource objectForKey:@"nickName"];
    NSString * matchName = [dataSource objectForKey:@"matchName"];
    NSString * matchTime = [dataSource objectForKey:@"matchTime"];
    NSString * matchAddress = [dataSource objectForKey:@"matchPlace"];
    
    UILabel * moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(noticeTimeLabel.frame.origin.x + 10, noticeTimeLabel.frame.origin.y + noticeTimeLabel.frame.size.height + V_GAP * 2,noticeTimeLabel.frame.size.width - 20 , 20)];
    
    moneyLabel.textColor = [UIColor grayColor];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    moneyLabel.text = @"支付金额";
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:moneyLabel];
    
    NSString * content = [NSString stringWithFormat:@"%@",payString];
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.frame.origin.x, moneyLabel.frame.origin.y + moneyLabel.frame.size.height + V_GAP * 2, moneyLabel.frame.size.width, whiteBg.frame.size.height * 0.1)];
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    //contentLabel.backgroundColor = [UIColor blueColor];
    contentLabel.font = [UIFont systemFontOfSize:24];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.text = content;
    [self.contentView addSubview:contentLabel];
    [self addShapeByPreView:contentLabel];
    
    UILabel * userIdLabel = [self createMessageLabel:@"支付账号" andContent:userId];
    userIdLabel.center = CGPointMake(contentLabel.center.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + V_GAP * 3 + userIdLabel.frame.size.height/2);
    [self.contentView addSubview:userIdLabel];
    
    UILabel * userNickLabel = [self createMessageLabel:@"支付昵称" andContent:userNick];
    userNickLabel.center = CGPointMake(userIdLabel.center.x, userIdLabel.center.y + userIdLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:userNickLabel];
    
    UILabel * matchNameLabel = [self createMessageLabel:@"比赛名称" andContent:matchName];
    matchNameLabel.center = CGPointMake(userNickLabel.center.x, userNickLabel.center.y + userNickLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchNameLabel];
    
    UILabel * matchAddressLabel = [self createMessageLabel:@"比赛场地" andContent:matchAddress];
    matchAddressLabel.center = CGPointMake(matchNameLabel.center.x, matchNameLabel.center.y + matchNameLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchAddressLabel];
    
    UILabel * matchTimeLabel = [self createMessageLabel:@"比赛时间" andContent:matchTime];
    matchTimeLabel.center = CGPointMake(matchAddressLabel.center.x, matchAddressLabel.center.y + matchAddressLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchTimeLabel];

    
    [self setWhiteBgHeight:matchTimeLabel];
}


//type6
- (void)setSixType:(UIColor*)titleColor{
    titleBg.backgroundColor = titleColor;
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, titleBg.frame.size.width, titleBg.frame.size.height - 15)];
    title.text = @"账户充值成功";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [titleBg addSubview:title];
    
    
    NSString * time = [dataSource objectForKey:@"noticeTime"];
    noticeTimeLabel.text = time;
    
    NSString * userId = [dataSource objectForKey:@"userId"];
    NSNumber * payAmount = [dataSource objectForKey:@"payAmount"];
    NSString * payString = [NSString stringWithFormat:@"%.2lf元",payAmount.floatValue];
    NSString * userNick = [dataSource objectForKey:@"nickName"];
    NSString * blance = [dataSource objectForKey:@"blance"];
    NSString * blanceString = [NSString stringWithFormat:@"%.2lf元",blance.floatValue];
    
    
    UILabel * moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(noticeTimeLabel.frame.origin.x + 10, noticeTimeLabel.frame.origin.y + noticeTimeLabel.frame.size.height + V_GAP * 2,noticeTimeLabel.frame.size.width - 20 , 20)];
    
    moneyLabel.textColor = [UIColor grayColor];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    moneyLabel.text = @"充值金额";
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:moneyLabel];
    
    NSString * content = [NSString stringWithFormat:@"%@",payString];
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.frame.origin.x, moneyLabel.frame.origin.y + moneyLabel.frame.size.height + V_GAP * 2, moneyLabel.frame.size.width, whiteBg.frame.size.height * 0.1)];
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    //contentLabel.backgroundColor = [UIColor blueColor];
    contentLabel.font = [UIFont systemFontOfSize:24];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.text = content;
    [self.contentView addSubview:contentLabel];
    [self addShapeByPreView:contentLabel];
    
    UILabel * userIdLabel = [self createMessageLabel:@"充值账号" andContent:userId];
    userIdLabel.center = CGPointMake(contentLabel.center.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + V_GAP * 3 + userIdLabel.frame.size.height/2);
    [self.contentView addSubview:userIdLabel];
    
    UILabel * userNickLabel = [self createMessageLabel:@"充值昵称" andContent:userNick];
    userNickLabel.center = CGPointMake(userIdLabel.center.x, userIdLabel.center.y + userIdLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:userNickLabel];
    
    UILabel * haveMoneyLabel = [self createMessageLabel:@"账户余额" andContent:blanceString];
    haveMoneyLabel.center = CGPointMake(userNickLabel.center.x, userNickLabel.center.y + userNickLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:haveMoneyLabel];
    
    [self setWhiteBgHeight:haveMoneyLabel];
    
    
}
//type5
- (void)setFiveType:(UIColor*)titleColor{
    titleBg.backgroundColor = titleColor;
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, titleBg.frame.size.width, titleBg.frame.size.height - 15)];
    title.text = @"球队加入新成员";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [titleBg addSubview:title];
    
    
    NSString * time = [dataSource objectForKey:@"noticeTime"];
    noticeTimeLabel.text = time;
    
    NSString * contentString = [dataSource objectForKey:@"noticeContent"];
    NSString * teamName = [dataSource objectForKey:@"teamName"];
    
    NSString * content = [NSString stringWithFormat:@"您好!\n%@",contentString];
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(noticeTimeLabel.frame.origin.x + 10, noticeTimeLabel.frame.origin.y + noticeTimeLabel.frame.size.height + V_GAP * 2, noticeTimeLabel.frame.size.width - 20, whiteBg.frame.size.height * 0.3)];
    contentLabel.numberOfLines = 0;
    //contentLabel.backgroundColor = [UIColor blueColor];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor redColor];
    contentLabel.text = content;
    [self.contentView addSubview:contentLabel];
    [self addShapeByPreView:contentLabel];
    
    UILabel * teamNameLabel = [self createMessageLabel:@"球队名称" andContent:teamName];
    teamNameLabel.center = CGPointMake(contentLabel.center.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + V_GAP * 3 + teamNameLabel.frame.size.height/2);
    [self.contentView addSubview:teamNameLabel];
    
    
    [self setWhiteBgHeight:teamNameLabel];
}

//type4
-(void)setFourType:(UIColor*)titleColor{
    titleBg.backgroundColor = titleColor;
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, titleBg.frame.size.width, titleBg.frame.size.height - 15)];
    title.text = @"取消比赛通知";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [titleBg addSubview:title];
    
    
    NSString * time = [dataSource objectForKey:@"noticeTime"];
    noticeTimeLabel.text = time;
    
    NSString * matchName = [dataSource objectForKey:@"matchName"];
    NSString * matchTime = [dataSource objectForKey:@"matchTime"];
    NSString * matchAddress = [dataSource objectForKey:@"matchPlace"];
    NSString * matchOpponent = [dataSource objectForKey:@"matchOpponent"];
    
    NSString * content = [NSString stringWithFormat:@"您好!\n您已经成功取消〖%@〗",matchName];
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(noticeTimeLabel.frame.origin.x + 10, noticeTimeLabel.frame.origin.y + noticeTimeLabel.frame.size.height + V_GAP * 2, noticeTimeLabel.frame.size.width - 20, whiteBg.frame.size.height * 0.3)];
    contentLabel.numberOfLines = 0;
    //contentLabel.backgroundColor = [UIColor blueColor];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor redColor];
    contentLabel.text = content;
    [self.contentView addSubview:contentLabel];
    [self addShapeByPreView:contentLabel];
    
    UILabel * matchNameLabel = [self createMessageLabel:@"比赛名称" andContent:matchName];
    matchNameLabel.center = CGPointMake(contentLabel.center.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + V_GAP * 3 + matchNameLabel.frame.size.height/2);
    [self.contentView addSubview:matchNameLabel];
    UILabel * matchTimeLabel = [self createMessageLabel:@"比赛时间" andContent:matchTime];
    matchTimeLabel.center = CGPointMake(matchNameLabel.center.x, matchNameLabel.center.y + matchNameLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchTimeLabel];
    UILabel * matchAddressLabel = [self createMessageLabel:@"比赛场地" andContent:matchAddress];
    matchAddressLabel.center = CGPointMake(matchTimeLabel.center.x, matchTimeLabel.center.y + matchTimeLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchAddressLabel];
    UILabel * matchOpponentLabel = [self createMessageLabel:@"比赛对手" andContent:matchOpponent];
    matchOpponentLabel.center = CGPointMake(matchAddressLabel.center.x, matchAddressLabel.center.y + matchAddressLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchOpponentLabel];
    
    
    [self setWhiteBgHeight:matchOpponentLabel];
    
}

//type3
-(void)setThreeType:(UIColor*)titleColor{
    titleBg.backgroundColor = titleColor;
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, titleBg.frame.size.width, titleBg.frame.size.height - 15)];
    title.text = @"比赛前1小时";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [titleBg addSubview:title];
    
    
    NSString * time = [dataSource objectForKey:@"noticeTime"];
    noticeTimeLabel.text = time;
    
    NSString * matchName = [dataSource objectForKey:@"matchName"];
    NSString * matchTime = [dataSource objectForKey:@"matchTime"];
    NSString * matchAddress = [dataSource objectForKey:@"matchPlace"];
    NSString * matchOpponent = [dataSource objectForKey:@"matchOpponent"];
    NSNumber * teamMemberCount = [dataSource objectForKey:@"teamMemberCount"];
    NSString * number = [NSString stringWithFormat:@"%zd",teamMemberCount.integerValue];
    
    NSString * content = [NSString stringWithFormat:@"您好!\n%@您有一场〖%@〗即将开始",matchTime,matchName];
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(noticeTimeLabel.frame.origin.x + 10, noticeTimeLabel.frame.origin.y + noticeTimeLabel.frame.size.height + V_GAP * 2, noticeTimeLabel.frame.size.width - 20, whiteBg.frame.size.height * 0.3)];
    contentLabel.numberOfLines = 0;
    //contentLabel.backgroundColor = [UIColor blueColor];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor redColor];
    contentLabel.text = content;
    [self.contentView addSubview:contentLabel];
    [self addShapeByPreView:contentLabel];
    
    UILabel * matchNameLabel = [self createMessageLabel:@"比赛名称" andContent:matchName];
    matchNameLabel.center = CGPointMake(contentLabel.center.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + V_GAP * 3 + matchNameLabel.frame.size.height/2);
    [self.contentView addSubview:matchNameLabel];
    UILabel * matchTimeLabel = [self createMessageLabel:@"比赛时间" andContent:matchTime];
    matchTimeLabel.center = CGPointMake(matchNameLabel.center.x, matchNameLabel.center.y + matchNameLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchTimeLabel];
    UILabel * matchAddressLabel = [self createMessageLabel:@"比赛场地" andContent:matchAddress];
    matchAddressLabel.center = CGPointMake(matchTimeLabel.center.x, matchTimeLabel.center.y + matchTimeLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchAddressLabel];
    UILabel * matchOpponentLabel = [self createMessageLabel:@"比赛对手" andContent:matchOpponent];
    matchOpponentLabel.center = CGPointMake(matchAddressLabel.center.x, matchAddressLabel.center.y + matchAddressLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchOpponentLabel];
    
    UILabel * matchNumberLabel = [self createMessageLabel:@"参赛人数" andContent:number];
    matchNumberLabel.center = CGPointMake(matchOpponentLabel.center.x, matchOpponentLabel.center.y + matchOpponentLabel.frame.size.height+ V_GAP);
    [self.contentView addSubview:matchNumberLabel];
    
    [self setWhiteBgHeight:matchNumberLabel];
}

//type2
- (void)setTwoType:(UIColor*)titleColor{
    titleBg.backgroundColor = titleColor;
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, titleBg.frame.size.width, titleBg.frame.size.height - 15)];
    title.text = @"比赛前24小时";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [titleBg addSubview:title];
    
    
    NSString * time = [dataSource objectForKey:@"noticeTime"];
    noticeTimeLabel.text = time;
    
    NSString * matchName = [dataSource objectForKey:@"matchName"];
    NSString * matchTime = [dataSource objectForKey:@"matchTime"];
    NSString * matchAddress = [dataSource objectForKey:@"matchPlace"];
    NSString * matchOpponent = [dataSource objectForKey:@"matchOpponent"];
    NSNumber * teamMemberCount = [dataSource objectForKey:@"teamMemberCount"];
    NSString * number = [NSString stringWithFormat:@"%zd",teamMemberCount.integerValue];
    
    NSString * content = [NSString stringWithFormat:@"您好!\n%@您有一场〖%@〗即将开始",matchTime,matchName];
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(noticeTimeLabel.frame.origin.x + 10, noticeTimeLabel.frame.origin.y + noticeTimeLabel.frame.size.height + V_GAP * 2, noticeTimeLabel.frame.size.width - 20, whiteBg.frame.size.height * 0.3)];
    contentLabel.numberOfLines = 0;
    //contentLabel.backgroundColor = [UIColor blueColor];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor redColor];
    contentLabel.text = content;
    [self.contentView addSubview:contentLabel];
    [self addShapeByPreView:contentLabel];
    
    UILabel * matchNameLabel = [self createMessageLabel:@"比赛名称" andContent:matchName];
    matchNameLabel.center = CGPointMake(contentLabel.center.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + V_GAP * 3 + matchNameLabel.frame.size.height/2);
    [self.contentView addSubview:matchNameLabel];
    UILabel * matchTimeLabel = [self createMessageLabel:@"比赛时间" andContent:matchTime];
    matchTimeLabel.center = CGPointMake(matchNameLabel.center.x, matchNameLabel.center.y + matchNameLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchTimeLabel];
    UILabel * matchAddressLabel = [self createMessageLabel:@"比赛场地" andContent:matchAddress];
    matchAddressLabel.center = CGPointMake(matchTimeLabel.center.x, matchTimeLabel.center.y + matchTimeLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchAddressLabel];
    UILabel * matchOpponentLabel = [self createMessageLabel:@"比赛对手" andContent:matchOpponent];
    matchOpponentLabel.center = CGPointMake(matchAddressLabel.center.x, matchAddressLabel.center.y + matchAddressLabel.frame.size.height + V_GAP);
    [self.contentView addSubview:matchOpponentLabel];
    
    UILabel * matchNumberLabel = [self createMessageLabel:@"参赛人数" andContent:number];
    matchNumberLabel.center = CGPointMake(matchOpponentLabel.center.x, matchOpponentLabel.center.y + matchOpponentLabel.frame.size.height+ V_GAP);
    [self.contentView addSubview:matchNumberLabel];
    
    [self setWhiteBgHeight:matchNumberLabel];
}


//type 1
- (void)setOneType:(UIColor*)titleColor{
    titleBg.backgroundColor = titleColor;
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, titleBg.frame.size.width, titleBg.frame.size.height - 15)];
    
    title.text = @"加入比赛";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    
    [titleBg addSubview:title];
    
    
    NSString * time = [dataSource objectForKey:@"noticeTime"];
    
    noticeTimeLabel.text = time;
    
    NSString * matchName = [dataSource objectForKey:@"matchName"];
    
    NSString * matchTime = [dataSource objectForKey:@"matchTime"];
    
    NSString * nickName = [dataSource objectForKey:@"nickName"];
    
    NSString * matchAddress = [dataSource objectForKey:@"matchPlace"];
    
    NSString * matchOpponent = [dataSource objectForKey:@"matchOpponent"];
    
    NSString * content = [NSString stringWithFormat:@"您好!\n%@已经成功加入〖%@〗比赛",nickName,matchName];
    
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(noticeTimeLabel.frame.origin.x + 10, noticeTimeLabel.frame.origin.y + noticeTimeLabel.frame.size.height + V_GAP * 2, noticeTimeLabel.frame.size.width - 20, whiteBg.frame.size.height * 0.3)];
    
    contentLabel.numberOfLines = 0;
    //contentLabel.backgroundColor = [UIColor blueColor];
    
    contentLabel.font = [UIFont systemFontOfSize:15];
    
    contentLabel.textColor = [UIColor redColor];
    
    contentLabel.text = content;
    
    [self.contentView addSubview:contentLabel];
    
    
    [self addShapeByPreView:contentLabel];
    
    UILabel * matchNameLabel = [self createMessageLabel:@"比赛名称" andContent:matchName];
    
    matchNameLabel.center = CGPointMake(contentLabel.center.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + V_GAP * 3 + matchNameLabel.frame.size.height/2);
    
    [self.contentView addSubview:matchNameLabel];
    
    UILabel * matchTimeLabel = [self createMessageLabel:@"比赛时间" andContent:matchTime];
    
    matchTimeLabel.center = CGPointMake(matchNameLabel.center.x, matchNameLabel.center.y + matchNameLabel.frame.size.height + V_GAP);
    
    [self.contentView addSubview:matchTimeLabel];
    
    UILabel * matchAddressLabel = [self createMessageLabel:@"比赛场地" andContent:matchAddress];
    
    matchAddressLabel.center = CGPointMake(matchTimeLabel.center.x, matchTimeLabel.center.y + matchTimeLabel.frame.size.height + V_GAP);
    
    [self.contentView addSubview:matchAddressLabel];
    
    UILabel * matchOpponentLabel = [self createMessageLabel:@"比赛对手" andContent:matchOpponent];
    
    matchOpponentLabel.center = CGPointMake(matchAddressLabel.center.x, matchAddressLabel.center.y + matchAddressLabel.frame.size.height + V_GAP);
    
    [self.contentView addSubview:matchOpponentLabel];
    [self setWhiteBgHeight:matchOpponentLabel];
}


//type 0
- (void)setZeroType:(UIColor*)titleColor{
    titleBg.backgroundColor = titleColor;
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, titleBg.frame.size.width, titleBg.frame.size.height - 15)];
    
    title.text = @"创建比赛";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;

    [titleBg addSubview:title];
    
    NSString * time = [dataSource objectForKey:@"noticeTime"];
    
    noticeTimeLabel.text = time;
    
    NSString * matchName = [dataSource objectForKey:@"matchName"];
    
    NSString * matchTime = [dataSource objectForKey:@"matchTime"];
    
    NSString * nickName = [dataSource objectForKey:@"teamName"];
    
    NSString * matchAddress = [dataSource objectForKey:@"matchPlace"];
    
    NSString * matchOpponent = [dataSource objectForKey:@"matchOpponent"];
    
    //NSString * contentString = [dataSource objectForKey:@"noticeContent"];
    
    NSString * content = [NSString stringWithFormat:@"您好!\n%@已经成功创建一个〖%@〗的比赛",nickName,matchName];
    
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(noticeTimeLabel.frame.origin.x + 10, noticeTimeLabel.frame.origin.y + noticeTimeLabel.frame.size.height + V_GAP * 2, noticeTimeLabel.frame.size.width - 20, whiteBg.frame.size.height * 0.3)];
    
    contentLabel.numberOfLines = 0;
    //contentLabel.backgroundColor = [UIColor blueColor];
    
    contentLabel.font = [UIFont systemFontOfSize:15];
    
    contentLabel.textColor = [UIColor redColor];
    
    contentLabel.text = content;
    
    [self.contentView addSubview:contentLabel];
    
    
    [self addShapeByPreView:contentLabel];
    
    UILabel * matchNameLabel = [self createMessageLabel:@"比赛名称" andContent:matchName];
    
    matchNameLabel.center = CGPointMake(contentLabel.center.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + V_GAP * 3 + matchNameLabel.frame.size.height/2);
    
    [self.contentView addSubview:matchNameLabel];
    
    UILabel * matchTimeLabel = [self createMessageLabel:@"比赛时间" andContent:matchTime];
    
    matchTimeLabel.center = CGPointMake(matchNameLabel.center.x, matchNameLabel.center.y + matchNameLabel.frame.size.height + V_GAP);
    
    [self.contentView addSubview:matchTimeLabel];
    
    UILabel * matchAddressLabel = [self createMessageLabel:@"比赛场地" andContent:matchAddress];
    
    matchAddressLabel.center = CGPointMake(matchTimeLabel.center.x, matchTimeLabel.center.y + matchTimeLabel.frame.size.height + V_GAP);
    
    [self.contentView addSubview:matchAddressLabel];
    
    UILabel * matchOpponentLabel = [self createMessageLabel:@"比赛对手" andContent:matchOpponent];
    
    matchOpponentLabel.center = CGPointMake(matchAddressLabel.center.x, matchAddressLabel.center.y + matchAddressLabel.frame.size.height + V_GAP);
    
    [self.contentView addSubview:matchOpponentLabel];
    
    [self setWhiteBgHeight:matchOpponentLabel];
    
}

//创建内容条;
- (UILabel*)createMessageLabel:(NSString*)title andContent:(NSString*)content
{
    NSString * message = [NSString stringWithFormat:@"%@: %@",title,content];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, noticeTimeLabel.frame.size.width - 20, 20)];
    
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
    label.text = message;
    
    return label;
    
}
//画虚线;
- (void)addShapeByPreView:(UIView*)view{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:6],
      [NSNumber numberWithInt:3],nil]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, whiteBg.frame.origin.x, view.frame.origin.y + view.frame.size.height + V_GAP * 2);
    CGPathAddLineToPoint(path, NULL, whiteBg.frame.origin.x + whiteBg.frame.size.width,view.frame.origin.y + view.frame.size.height + V_GAP * 2);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [self.contentView.layer addSublayer:shapeLayer];
}
//修正背景高度；
- (void)setWhiteBgHeight:(UILabel*)lastLabel
{
    whiteBg.frame = CGRectMake(whiteBg.frame.origin.x, whiteBg.frame.origin.y, whiteBg.frame.size.width,lastLabel.frame.origin.y + lastLabel.frame.size.height + 5);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:whiteBg.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4,4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = whiteBg.bounds;
    maskLayer.path = maskPath.CGPath;
    whiteBg.layer.mask = maskLayer;
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, whiteBg.frame.size.height);
}


@end
