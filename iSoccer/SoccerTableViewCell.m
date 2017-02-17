//
//  SoccerTableViewCell.m
//  iSoccer
//
//  Created by pfg on 15/12/21.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import "SoccerTableViewCell.h"
#import "NetDataNameConfig.h"
#import "TeamSourcePanel.h"
#import "UserAvatarContainer.h"
#import "RecordNavigationViewController.h"
#import "RecordViewController.h"
#import "Global.h"
#import "NetRequest.h"
#import "NetConfig.h"
#import "PayFastNavigationViewController.h"

#import "MatchDetailViewController.h"
#import <MapKit/MapKit.h>
#import "ProgressHUD.h"

#define BG_H (size.height * 0.17)
#define SYSTEM_VERSION_LESS_THAN [[UIDevice currentDevice] systemVersion]

@implementation SoccerTableViewCell
{
    CGSize size;
    UIImageView * bg;
    UIImageView * titleImage;
    CGFloat matchX;
    CGFloat matchY;
    //比分牌
    TeamSourcePanel * teamSourcePanel;
    UIView * gameSign;
    UILabel * typeLabel;
    UILabel * gameTitle;
    UIView * gameInfoView;
    NSMutableArray * infoLabels;
    UIButton * locationBtn;
    UIImageView * locationIcon;
    NSMutableArray * gameDataLabels;
    UserAvatarContainer * avatarContainer;
    
    NSMutableDictionary * recordData;
    
    UIButton * gameReviewButton;
    UIButton * payButton;
    UIButton * applyButton;
    UIButton * askLeaveButton;
    UIView * buttonView;
    
    NSMutableArray * memberList;
    NSString * remarks;
    NSString * matchTime;
    
    NSMutableDictionary * dataSource;
    BOOL _isMe;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        size = [UIScreen mainScreen].bounds.size;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width - size.width * 0.05, size.height - BG_H)];
        
        bg.image = [UIImage imageNamed:@"cell_bg.png"];
        
        self.backgroundColor = [UIColor clearColor];
        
        
        [self.contentView addSubview:bg];
    
        titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(bg.frame.size.width * 0.017, bg.frame.size.width * 0.017, bg.frame.size.width - bg.frame.size.width * 0.05, bg.frame.size.height * 0.37)];
        
        [titleImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
        titleImage.contentMode =  UIViewContentModeScaleAspectFill;
        titleImage.autoresizingMask = UIViewAutoresizingNone;
        titleImage.clipsToBounds  = YES;
        
        NSMutableArray * sourceData = [NSMutableArray array];
        
        [sourceData addObject:@"0"];
        [sourceData addObject:@"0"];
        
        NSMutableDictionary *teamNameData = [NSMutableDictionary dictionary];
        [teamNameData setObject:@"信蜂" forKey:@"AA"];
        [teamNameData setObject:@"恒大" forKey:@"BB"];
        
        teamSourcePanel = [[TeamSourcePanel alloc]initWithSourceData:sourceData andNameData:teamNameData];
        
        gameSign = [[UIView alloc]initWithFrame:CGRectMake(titleImage.frame.origin.x, titleImage.frame.size.height + titleImage.frame.origin.y + titleImage.frame.size.height * 0.04, bg.frame.size.width * 0.14, bg.frame.size.height * 0.04)];
        
        typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, gameSign.frame.size.width, gameSign.frame.size.height)];
        
        
        gameTitle = [[UILabel alloc]initWithFrame:CGRectMake(gameSign.frame.origin.x + gameSign.frame.size.width + 6, gameSign.frame.origin.y,titleImage.frame.size.width - 6 - gameSign.frame.size.width,gameSign.frame.size.height)];
        
        gameInfoView = [[UIView alloc]initWithFrame:CGRectMake(titleImage.frame.origin.x, gameSign.frame.origin.y + gameSign.frame.size.height + titleImage.frame.size.height * 0.03, titleImage.frame.size.width, bg.frame.size.height * 0.36)];
        
        infoLabels = [NSMutableArray array];
        gameDataLabels = [NSMutableArray array];
        
        UIButton * remarksButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        remarksButton.frame = CGRectMake(gameInfoView.frame.size.width * 0.8, 4 * gameInfoView.frame.size.height * 0.2 + 0.5, [self widthForString:@"比赛详情" fontSize:14 andHeight:gameInfoView.frame.size.height * 0.2], gameInfoView.frame.size.height * 0.2);
        
        remarksButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [remarksButton setTitle:@"比赛详情" forState:UIControlStateNormal];
        
        [remarksButton addTarget:self action:@selector(tapRemarks:) forControlEvents:UIControlEventTouchUpInside];
        
        [gameInfoView addSubview:remarksButton];
        
        NSArray * infoData = @[@"地点:",@"时间:",@"天气:",@"对手:",@"赛制:",@"球衣:"];
        //五条分割线;
        for(NSInteger i = 0;i < 6;i ++)
        {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, gameInfoView.frame.size.height * 0.2 * i, gameInfoView.frame.size.width, 1)];
            
            line.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
            
            [gameInfoView addSubview:line];
            
            UILabel * infoLabel;
            if(i < 5)
            {
                infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(gameInfoView.frame.size.width * 0.05, i * gameInfoView.frame.size.height * 0.2, [self widthForString:infoData[i] fontSize:14 andHeight:gameInfoView.frame.size.height * 0.2], gameInfoView.frame.size.height * 0.2)];
            }else{
                infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(gameInfoView.frame.size.width * 0.4, (i - 1) * gameInfoView.frame.size.height * 0.2, [self widthForString:infoData[i] fontSize:14 andHeight:gameInfoView.frame.size.height * 0.2], gameInfoView.frame.size.height * 0.2)];
            }
            
            infoLabel.text = infoData[i];
            
            infoLabel.textColor = [UIColor blackColor];
            
            infoLabel.font = [UIFont systemFontOfSize:14];
            
            
            [gameInfoView addSubview:infoLabel];
            
            [infoLabels addObject:infoLabel];
            
            
            if(i == 0)
            {
                
                locationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                
                
                locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                
                //locationBtn.backgroundColor = [UIColor blackColor];
                
                [gameInfoView addSubview:locationBtn];
                
                [locationBtn addTarget:self action:@selector(showMapToGps:) forControlEvents:UIControlEventTouchUpInside];
                
                
                locationIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location.png"]];
                
                locationIcon.frame = CGRectMake(infoLabel.frame.size.width + infoLabel.frame.origin.x + gameInfoView.frame.size.width * 0.02, 0, gameInfoView.frame.size.width * 0.035, gameInfoView.frame.size.width * 0.05);
                locationIcon.center = CGPointMake(locationIcon.center.x, gameInfoView.frame.size.height * 0.2 / 2);
                
                [gameInfoView addSubview:locationIcon];

            }else{
                
                NSInteger tempIndex = i;
                if(tempIndex > 4)
                {
                    tempIndex = 4;
                }
                
                if(i == 2)
                {
                    _weatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoLabel.frame.size.width + infoLabel.frame.origin.x + gameInfoView.frame.size.width * 0.02, tempIndex * gameInfoView.frame.size.height * 0.2, gameInfoView.frame.size.width - (infoLabel.frame.size.width + infoLabel.frame.origin.x + gameInfoView.frame.size.width * 0.05), gameInfoView.frame.size.height * 0.2)];
                    
                    _weatherLabel.textColor = [UIColor colorWithRed:101.0/255 green:101.0/255 blue:101.0/255 alpha:1];
                    _weatherLabel.font = [UIFont systemFontOfSize:14];
                    
                    [gameInfoView addSubview:_weatherLabel];
                    [gameDataLabels addObject:_weatherLabel];
                }else{
                    UILabel * gameDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoLabel.frame.size.width + infoLabel.frame.origin.x + gameInfoView.frame.size.width * 0.02, tempIndex * gameInfoView.frame.size.height * 0.2, gameInfoView.frame.size.width - (infoLabel.frame.size.width + infoLabel.frame.origin.x + gameInfoView.frame.size.width * 0.05), gameInfoView.frame.size.height * 0.2)];
                    
                    gameDataLabel.textColor = [UIColor colorWithRed:101.0/255 green:101.0/255 blue:101.0/255 alpha:1];
                    gameDataLabel.font = [UIFont systemFontOfSize:14];
                    
                    
                    if(i == 5)
                    {
                        gameDataLabel.frame = CGRectMake(gameDataLabel.frame.origin.x, gameDataLabel.frame.origin.y, gameDataLabel.frame.size.width/2, gameDataLabel.frame.size.height);//球衣字符超出特殊判断
                    }
                    
                    [gameInfoView addSubview:gameDataLabel];
                    [gameDataLabels addObject:gameDataLabel];
                    
                    
                    
                }
  
            }
        }
        
        
        gameInfoView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:gameInfoView];
        
        
        
        UIView * teamMemberView = [[UIView alloc]initWithFrame:CGRectMake(titleImage.frame.origin.x, gameInfoView.frame.origin.y + gameInfoView.frame.size.height, titleImage.frame.size.width, titleImage.frame.size.height * 0.2)];
        
        NSArray * memberData = @[@"",@"",@"",@"",@"",@"",@"",@""];
        avatarContainer = [[UserAvatarContainer alloc]initWithFrame:CGRectMake(0, 0, teamMemberView.frame.size.width, teamMemberView.frame.size.height) andAvatar:memberData];
        
        [teamMemberView addSubview:avatarContainer];
        
        
        avatarContainer.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapAvatar = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAllTeamMember:)];
        
        [avatarContainer addGestureRecognizer:tapAvatar];
        
        //teamMemberView.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:teamMemberView];
        
        buttonView = [[UIView alloc]initWithFrame:CGRectMake(titleImage.frame.origin.x, teamMemberView.frame.origin.y + teamMemberView.frame.size.height + titleImage.frame.size.height * 0.03,titleImage.frame.size.width, titleImage.frame.size.height * 0.24)];
        
        
        payButton = [self createButtonByTitle:@"支付场地费" andColor:[UIColor colorWithRed:239.0/255 green:66.0/255 blue:8/255.0 alpha:1]];
        
        payButton.center = CGPointMake(buttonView.frame.size.width/2, buttonView.frame.size.height/2);
        
        [buttonView addSubview:payButton];
        
        [payButton addTarget:self action:@selector(tapedPayHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        gameReviewButton = [self createButtonByTitle:@"比赛回顾" andColor:[UIColor colorWithRed:20.0/255 green:20.0/255 blue:20.0/255 alpha:1]];
        gameReviewButton.center = CGPointMake(buttonView.frame.size.width/2, buttonView.frame.size.height/2);
        [buttonView addSubview:gameReviewButton];
        
        [gameReviewButton addTarget:self action:@selector(tapedReviewHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        applyButton = [self createButtonByTitle:@"申请参加" andColor:gameReviewButton.backgroundColor];
        applyButton.center = gameReviewButton.center;
        [buttonView addSubview:applyButton];
        
        [applyButton addTarget:self action:@selector(tapedApplyHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        askLeaveButton = [self createButtonByTitle:@"请假" andColor:applyButton.backgroundColor];
        askLeaveButton.center = applyButton.center;
        [buttonView addSubview:askLeaveButton];
        
        [askLeaveButton addTarget:self action:@selector(tapedAskLeaveHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.contentView addSubview:buttonView];
        
        
    }
    
    return self;
}

- (UIButton*)createButtonByTitle:(NSString*)title andColor:(UIColor*)color{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(2,0, buttonView.frame.size.width - 6, buttonView.frame.size.height);
    button.backgroundColor = color;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    
    return button;
}

- (void)setViewData:(NSDictionary*)data andIsMe:(BOOL)isMe{
    
    
    dataSource = [data mutableCopy];
    
    _isMe = isMe;
    
    NSString * titleImageUrl = [data objectForKey:GAME_TITLE_IMAGE_KEY];
    
    recordData = [NSMutableDictionary dictionaryWithDictionary:data];
    
    if(titleImageUrl != nil && titleImageUrl.length > 0)
    {
        [Global loadImageFadeIn:titleImage andUrl:titleImageUrl isLoadRepeat:YES];
        
        
        
    }else
    {
        titleImage.image = [UIImage imageNamed:@"default_history.png"];
    }
    
    NSString * matchx = [data objectForKey:MATCH_X];
    NSString * matchy = [data objectForKey:MATCH_Y];
    
    matchX = matchx.floatValue;
    matchY = matchy.floatValue;
    
    [self.contentView addSubview:titleImage];
    
    NSMutableArray * sourceData = [data objectForKey:GAME_SOURCE];
    
    if(!sourceData)
    {
        sourceData = [NSMutableArray array];
        [sourceData addObject:@"0"];
        [sourceData addObject:@"0"];
    }
    
    
    NSMutableDictionary * teamNameData = [NSMutableDictionary dictionary];
    
    NSString * teamAName = [data objectForKey:GAME_TEAM_A];
    NSString * teamBName = [data objectForKey:GAME_TEAM_B];
    
    if(!teamAName)
    {
        [teamNameData setObject:@"信蜂" forKey:@"AA"];
        
    }else{
        [teamNameData setObject:teamAName forKey:@"AA"];
    }
    if(!teamBName)
    {
        [teamNameData setObject:@"恒大" forKey:@"BB"];
    }else{
        [teamNameData setObject:teamBName forKey:@"BB"];
    }
    
    [teamSourcePanel setData:sourceData andNameData:teamNameData];
    
    
    teamSourcePanel.userInteractionEnabled = NO;
    
    teamSourcePanel.center = titleImage.center;
    
    [self.contentView addSubview:teamSourcePanel];
    
    
    //比赛类型标签;
    
    NSString * gameType = [data objectForKey:GAME_TYPE];
    if(!gameType)
    {
        gameType = @"友谊赛";
    }else{
        if([gameType compare:FRIEND_GAME] == 0)
        {
            gameType = @"友谊赛";
        }else{
            gameType = @"正式赛";
        }
    }
    remarks = [data objectForKey:@"remarks"];
    
    gameSign.userInteractionEnabled = NO;
    
    gameSign.backgroundColor = [UIColor colorWithRed:(236.0/255.0) green:71.0/255.0 blue:57.0/255 alpha:1.0];
    
    
    typeLabel.text = gameType;
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.font = [UIFont systemFontOfSize:12];
    
    [gameSign addSubview:typeLabel];
    
    [self.contentView addSubview:gameSign];
    
    //比赛标题;
    NSString * gameTitleString = [data objectForKey:GAME_TITLE_KEY];
    
    if(!gameTitleString)
    {
        gameTitleString = @"高新区孵化园区友谊赛";
    }
    gameTitle.text = gameTitleString;
    gameTitle.textColor = [UIColor blackColor];
    
    gameTitle.textAlignment = NSTextAlignmentLeft;
    
    gameTitle.font = [UIFont systemFontOfSize:18];
    
    [self.contentView addSubview:gameTitle];
    
    NSString * gameFormat = [data objectForKey:GAME_FORMAT];
    
    if([gameFormat isEqualToString:@""])
    {
        NSString * formatId = [data objectForKey:@"formatId"];
        
        if([formatId isEqualToString:FORMAT_FIVE])
        {
            gameFormat = @"5人制";
        }else if([formatId isEqualToString:FORMAT_SEVEN])
        {
            gameFormat = @"7人制";
        }else if([formatId isEqualToString:FORMAT_ELEVEN])
        {
            gameFormat = @"8人制";
        }
    }
    
    NSString * gameJersey = [data objectForKey:GAME_JERSEY];
    
    NSString * gameTime = [data objectForKey:MATCH_TIME];
    
    matchTime = gameTime;
    
    NSString * gameAddress = [data objectForKey:MATCH_ADDRESS];
 
    NSArray * gameData = @[gameAddress,gameTime,@"获取天气中..",teamBName,gameFormat,gameJersey];
    
    //五条分割线;
    for(NSInteger i = 0;i < 6;i ++)
    {
        
        UILabel * infoLabel = infoLabels[i];

        if(i == 0)
        {
            CGFloat btnWidth = [self widthForString:gameData[i] fontSize:14 andHeight:gameInfoView.frame.size.height * 0.2];
            
            
            CGFloat gap = 6 + gameInfoView.frame.size.width * 0.035;
            
            
            if(btnWidth > gameTitle.frame.size.width - gap)
            {
                btnWidth = gameTitle.frame.size.width - gap;
            }
            
            locationBtn.frame = CGRectMake(infoLabel.frame.size.width + infoLabel.frame.origin.x + gameInfoView.frame.size.width * 0.02 + gameInfoView.frame.size.width * 0.05, 0, btnWidth, gameInfoView.frame.size.height * 0.2);
            
            [locationBtn setTitle:gameData[i] forState:UIControlStateNormal];
            
            
            locationIcon.frame = CGRectMake(infoLabel.frame.size.width + infoLabel.frame.origin.x + gameInfoView.frame.size.width * 0.02, 0, gameInfoView.frame.size.width * 0.035, gameInfoView.frame.size.width * 0.05);
            locationIcon.center = CGPointMake(locationIcon.center.x, gameInfoView.frame.size.height * 0.2 / 2);
            
            [gameInfoView addSubview:locationIcon];
            
            
            
        }else{
            
            NSInteger tempIndex = i;
            if(tempIndex > 4)
            {
                tempIndex = 4;
            }
            
            UILabel * gameDataLabel = gameDataLabels[i - 1];//因为去掉了0;
            
            if(i == 1)
            {
                //gameDataLabel.text = gameData[i];
                gameDataLabel.text = [Global getDateByTime:gameData[i] isSimple:NO];
            }else
                gameDataLabel.text = gameData[i];
            
           
            
        }
    }
    
    memberList = [data objectForKey:@"userList"];
    
    [avatarContainer setMember:memberList];
    
    [self buttonShowJudge];
}
//按钮显示判断;
- (void)buttonShowJudge{
    NSString * matchStatus = [recordData objectForKey:@"matchStatus"];
    NSString * isPayStr = [recordData objectForKey:@"ispay"];
    NSString * isJoinStr = [recordData objectForKey:@"isjoin"];//是否加入比赛;
    BOOL isPay = NO;
    BOOL isJoin = NO;
    
    if([isJoinStr compare:@"1"] == 0)
    {
        isJoin = YES;
    }
    if([isPayStr compare:@"1"] == 0)
    {
        isPay = YES;
    }
    
    if([matchStatus compare:@"0"] == 0)
    {
        gameReviewButton.hidden = YES;
        payButton.hidden = YES;
        //比赛未开始;
        //判断是否参加比赛;
        
        if(isJoin == YES)
        {
            applyButton.hidden = YES;
            askLeaveButton.hidden = NO;
        }else{
            applyButton.hidden = NO;
            askLeaveButton.hidden = YES;
        }
    }else if([matchStatus compare:@"1"] == 0)
    {
        applyButton.hidden = YES;
        askLeaveButton.hidden = YES;
        //比赛已经开始;
        if(isPay == YES)
        {
            payButton.hidden = YES;
            
        }else{
            payButton.hidden = NO;
        }
        
        if(isJoin == YES)
        {
            if(isPay == NO){
                payButton.frame = CGRectMake(2, payButton.frame.origin.y, buttonView.frame.size.width/2 - 4, payButton.frame.size.height);
                gameReviewButton.frame = CGRectMake(2 + payButton.frame.size.width + 4, gameReviewButton.frame.origin.y, payButton.frame.size.width, gameReviewButton.frame.size.height);
                gameReviewButton.hidden = NO;
            }else{
                gameReviewButton.frame = CGRectMake(2, gameReviewButton.frame.origin.y, buttonView.frame.size.width - 6, payButton.frame.size.height);
                gameReviewButton.hidden = NO;
            }
            
        }else{
            gameReviewButton.hidden = YES;
            
            payButton.frame = CGRectMake(2, payButton.frame.origin.y, buttonView.frame.size.width - 6, payButton.frame.size.height);
            
            payButton.hidden = YES;
        }
    }else if([matchStatus compare:@"2"] == 0)
    {
        applyButton.hidden = YES;
        askLeaveButton.hidden = YES;
        gameReviewButton.hidden = NO;
        //比赛已经被记录;
        if(isPay == YES)
        {
            payButton.hidden = YES;
            
            gameReviewButton.frame = CGRectMake(2, gameReviewButton.frame.origin.y, buttonView.frame.size.width - 6, payButton.frame.size.height);
            gameReviewButton.hidden = NO;
            
        }else{
            
            if(isJoin == YES)
            {
                payButton.hidden = NO;
                payButton.frame = CGRectMake(2, payButton.frame.origin.y, buttonView.frame.size.width/2 - 4, payButton.frame.size.height);
                gameReviewButton.frame = CGRectMake(2 + payButton.frame.size.width + 4, gameReviewButton.frame.origin.y, payButton.frame.size.width, gameReviewButton.frame.size.height);
            }else{
                gameReviewButton.frame = CGRectMake(2, gameReviewButton.frame.origin.y, buttonView.frame.size.width - 6, payButton.frame.size.height);
                payButton.hidden = YES;
            }
        }
    }
}

- (void)tapedPayHandler:(UIButton*)sender{
    NSLog(@"调用支付");
    NSString * matchId = [recordData objectForKey:MATCH_ID];
    
    [Global getInstance].currentMatchId = matchId;
    
    NSDictionary * post = @{MATCH_ID:matchId};
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:GET_PAY_DETAIL parameters:postData atView:self.superview.superview andHUDMessage:@"获取价格.." success:^(id resposeObject) {
        NSLog(@"获取成功");
        
        
        [Global getInstance].currentPayData = resposeObject[@"pay"];
        
        [Global getInstance].fieldOrderCheckCode = nil;
        
        UIStoryboard *payStory = [UIStoryboard storyboardWithName:@"PayFast" bundle:nil];
        PayFastNavigationViewController * payVC = payStory.instantiateInitialViewController;
        UIViewController * mainVC = [Global getInstance].mainVC;
        [mainVC presentViewController:payVC animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        NSLog(@"获取失败");
    }];
}

- (void)tapedReviewHandler:(UIButton*)sender{
    NSLog(@"调用回顾");
    NSString * matchId = [recordData objectForKey:MATCH_ID];
    NSDictionary * post = @{MATCH_ID:matchId};
    NSMutableDictionary * postData =[post mutableCopy];
    [NetRequest POST:GET_RECORD parameters:postData atView:self.superview.superview andHUDMessage:@"加载中..." success:^(id resposeObject) {
        
        NSString *code = resposeObject[@"code"];
        
        if(code.integerValue == 2)
        {
            [[Global getInstance].mainVC showLoginView:YES];
        }else{
        NSMutableDictionary * data = resposeObject[@"match"];
        
        RecordViewController * rdVC = [[RecordViewController alloc]initWithData:data andIsMe:YES];
        
        RecordNavigationViewController * rdNav = [[RecordNavigationViewController alloc]initWithRootViewController:rdVC];
        
        UIViewController * mainVC = [Global getInstance].mainVC;
        [mainVC presentViewController:rdNav animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}


-(void)showAllTeamMember:(UITapGestureRecognizer*)gesture{
    
    [Global getInstance].currentDeleteMatchId = [recordData objectForKey:MATCH_ID];
    
    [[Global getInstance].mainVC showAllMemberByData:memberList andTime:matchTime];
    
    
}

//+30.57330349,+104.06151910 //测试地址;
- (void)showMapToGps:(UIButton*)sender{
    
    CGFloat userMatchX = [Global getInstance].userMatchX;
    CGFloat userMatchY = [Global getInstance].userMatchY;
    
    
    if ([SYSTEM_VERSION_LESS_THAN compare:@"6.0"] == 0) { // ios6以下，调用高德 map
        
        NSString * urlString = [NSString stringWithFormat:@""@"http://m.amap.com/?from=%g,%g(from)&to=%g,%g(to)",userMatchX,userMatchY,matchX,matchY];
        
        NSURL *aURL = [NSURL URLWithString:urlString];
        
        [[UIApplication sharedApplication] openURL:aURL];
        
    } else { // 直接调用ios自己带的apple map
        
        CLLocationCoordinate2D to;
        
        to.latitude = matchX;
        
        to.longitude = matchY;
        
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
        
        toLocation.name = @"球场";
        
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    }
}

- (void)tapedApplyHandler:(UIButton*)sender{
    NSLog(@"申请");
    
    NSString * matchId = [recordData objectForKey:MATCH_ID];
    
    NSDictionary * post = @{MATCH_ID:matchId};
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:JOIN_MATCH parameters:postData atView:self.superview.superview andHUDMessage:@"申请中.." success:^(id resposeObject) {
        [ProgressHUD showSuccess:@"申请成功"];
        
        NSMutableDictionary *data = resposeObject[@"date"];
        
        [self setViewData:data andIsMe:_isMe];
        
    } failure:^(NSError *error) {
        NSLog(@"11");
    }];

    
}
- (void)tapedAskLeaveHandler:(UIButton*)sender{
    NSLog(@"请假");
    NSString * matchId = [recordData objectForKey:MATCH_ID];
    
    NSDictionary * post = @{MATCH_ID:matchId};
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:LEAVE_MATCH parameters:postData atView:self.superview.superview andHUDMessage:@"请假中.." success:^(id resposeObject) {
        [ProgressHUD showSuccess:@"已经请假"];
        
        NSMutableDictionary *data = resposeObject[@"date"];
        
        [self setViewData:data andIsMe:_isMe];
        
    } failure:^(NSError *error) {
        NSLog(@"11");
    }];
    
}

- (void)tapRemarks:(UIButton*)sender{
    
//    if(remarks && remarks.length > 0)
//    {
//        NSLog(@"点击备注");
//        //[[Global getInstance].mainVC showRemarks:remarks];
//    }
    
    [Global getInstance].isMeTeam = _isMe;
    
    [Global getInstance].currentMatchData = dataSource;
    MatchDetailViewController * matchDetailVC = [[MatchDetailViewController alloc]init];
    
    UINavigationController * matchDetailNav = [[UINavigationController alloc]initWithRootViewController:matchDetailVC];

    [[Global getInstance].mainVC presentViewController:matchDetailNav animated:YES completion:nil];
    
}

//获取字符串的宽度
-(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}
//获得字符串的高度
-(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}



@end
