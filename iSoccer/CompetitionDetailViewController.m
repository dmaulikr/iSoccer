//
//  CompetitionDetailViewController.m
//  iSoccer
//
//  Created by pfg on 16/5/19.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "CompetitionDetailViewController.h"
#import "Global.h"

#import "CompetitionDetailTableViewCell.h"
#import "CompetitionApplyViewController.h"
#import "NetRequest.h"
#import "NetConfig.h"
#import "SuccessEventViewController.h"

#define V_GAP 10
#define H_GAP 20

@interface CompetitionDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary * dataSource;
    
    UIImageView * titleImageView;
    UIWebView * webView;
    UIView * container;
    UITableView * chooseTableView;
    
    NSMutableArray * chooseData;
    
    NSInteger currentSelectedIndex;
    
    UIButton * nextStepButton;
    
    BOOL isApply;
}

@end

@implementation CompetitionDetailViewController


- (instancetype)initWithData:(NSMutableDictionary*)data
{
    self = [super init];
    if (self) {
        
        dataSource = data;
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.25)];
    
    NSString * titleUrl = [dataSource objectForKey:@"groupbuy_image"];
    
    NSNumber * eventId = [dataSource objectForKey:@"id"];
    
    _currentEventId = [NSString stringWithFormat:@"%zd",eventId.integerValue];
    
    [Global loadImageFadeIn:titleImageView andUrl:titleUrl isLoadRepeat:YES];
    
    [self.view addSubview:titleImageView];
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(H_GAP, titleImageView.frame.size.height + V_GAP, self.view.frame.size.width - H_GAP*2, self.view.frame.size.height * 0.5)];
    
    webView.scrollView.showsHorizontalScrollIndicator = NO;
 
    NSString * htmlSting = [dataSource objectForKey:@"content"];
    
    [webView loadHTMLString:htmlSting baseURL:nil];
    
    [self.view addSubview:webView];
    
    
    UIButton * joinButton = [self createButtonByTitle:@"申请参加比赛" andColor:[UIColor blackColor] andWidth:self.view.frame.size.width * 0.75];
    
    joinButton.center = CGPointMake(self.view.frame.size.width/2, webView.frame.origin.y + webView.frame.size.height + V_GAP + joinButton.frame.size.height/2);
    
    [joinButton addTarget:self action:@selector(tapJoinHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:joinButton];
    
}

- (void)tapJoinHandler:(UIButton*)sender{
    NSLog(@"申请");
    
    NSDictionary * post = @{@"eventId":_currentEventId};
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:CHECK_IS_JOIN parameters:postData atView:self.view andHUDMessage:@"申请中.." success:^(id resposeObject) {
        
        NSMutableDictionary * data = resposeObject[@"eventUser"];
        
        if(data == nil)
        {
            [self showChooseType];
        }else{
            NSString * codeUrl = [data objectForKey:@"qRcode"];
            
            SuccessEventViewController * successVC = [[SuccessEventViewController alloc]initWithUrl:codeUrl];
            
            [Global loadImageFadeIn:successVC.codeImage andUrl:codeUrl isLoadRepeat:YES];
            
            [self.navigationController pushViewController:successVC animated:YES];
        }
        //[self showChooseType];
    } failure:^(NSError *error) {
        NSLog(@"报错");
    }];
}

- (void)showChooseType
{
    
    isApply = NO;
    
    NSDictionary * dataLeader = @{@"teamLogo":@"comp_leader.png",@"teamName":@"我是队长",@"teamLabel":@"(带领自己的球队参加比赛)"};
    
    NSDictionary * dataTeam = @{@"teamLogo":@"comp_team.png",@"teamName":@"我是队员",@"teamLabel":@"(加入其它球队参与比赛)"};
    
    NSDictionary * dataNone = @{@"teamLogo":@"",@"teamName":@"",@"teamLabel":@"温馨提示:一场比赛限一个身份证ID参赛,如果您以球员身份参与比赛,您将不能以队长身份参与比赛,请谨慎选择."};
    
    chooseData = [NSMutableArray array];
    
    [chooseData addObject:dataLeader];
    [chooseData addObject:dataTeam];
    [chooseData addObject:dataNone];
    
    currentSelectedIndex = 0;
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [[[UIApplication sharedApplication]keyWindow]addSubview:container];
    
    UIView * mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.3;
    
    [container addSubview:mask];
    
    UIView * whiteBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width * 0.85, size.height * 0.46)];
    
    whiteBG.backgroundColor = [UIColor whiteColor];
    
    whiteBG.layer.cornerRadius = 8;
    
    whiteBG.layer.masksToBounds = YES;
    
    whiteBG.center = CGPointMake(size.width/2, size.height/2);
    
    [container addSubview:whiteBG];
    
    
    UIView * lineOne = [[UIView alloc]initWithFrame:CGRectMake(0, whiteBG.frame.size.height * 0.2, whiteBG.frame.size.width, 0.5)];
    lineOne.backgroundColor = [UIColor colorWithRed:171.0/255 green:171.0/255 blue:171.0/255 alpha:1.0];
    [whiteBG addSubview:lineOne];
    
    UIView * lineTwo = [[UIView alloc]initWithFrame:CGRectMake(0, whiteBG.frame.size.height*0.8, whiteBG.frame.size.width, 0.5)];
    lineTwo.backgroundColor = [UIColor colorWithRed:171.0/255 green:171.0/255 blue:171.0/255 alpha:1.0];;
    [whiteBG addSubview:lineTwo];
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, whiteBG.frame.size.width, lineOne.frame.origin.y)];
    
    title.textColor = [UIColor blackColor];
    
    title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.text = @"选择参赛身份";
    
    [whiteBG addSubview:title];
    
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"comp_close.png"] forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(closeShowHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    closeButton.frame = CGRectMake(0, 0, 30, 30);
    
    closeButton.center = CGPointMake(whiteBG.frame.size.width - closeButton.frame.size.width/2 - H_GAP/2, H_GAP/2 + closeButton.frame.size.height/2);
    
    [whiteBG addSubview:closeButton];
    
    if(!chooseTableView)
    {
        chooseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, lineOne.frame.origin.y, whiteBG.frame.size.width, lineTwo.frame.origin.y - lineOne.frame.origin.y) style:UITableViewStylePlain];
        
        chooseTableView.dataSource = self;
        chooseTableView.delegate = self;
        
        chooseTableView.tableFooterView = [UIView new];
        
    }else{
        [chooseTableView reloadData];
    }
    
    [whiteBG addSubview:chooseTableView];
    
    nextStepButton = [self createButtonByTitle:@"下一步" andColor:[UIColor blackColor] andWidth:self.view.frame.size.width * 0.7];
    
    nextStepButton.center = CGPointMake(whiteBG.frame.size.width/2, lineTwo.frame.origin.y + (whiteBG.frame.size.height - lineTwo.frame.origin.y)/2);
    
    [nextStepButton addTarget:self action:@selector(nextStepHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [whiteBG addSubview:nextStepButton];
    
    
}

- (void)nextStepHandler:(UIButton*)sender{
    NSLog(@"下一步");

    if(isApply == NO)
    {
        NSInteger type;
        if(currentSelectedIndex == 0)
        {
            type = 1;
        }else{
            type = 0;
        }
        
        NSString * userType = [NSString stringWithFormat:@"%zd",type];
        
        NSDictionary * post = @{@"userType":userType};
        NSMutableDictionary * postData = [post mutableCopy];
        
        
        [NetRequest POST:GET_TEAM_BY_TYPE parameters:postData atView:self.view andHUDMessage:@"获取队伍中.." success:^(id resposeObject) {
            
            isApply = YES;
            
            currentSelectedIndex = 0;
            
            chooseData = resposeObject[@"teamList"];
            
            [chooseTableView reloadData];
            
            [nextStepButton setTitle:@"申请参加比赛" forState:UIControlStateNormal];
            
        } failure:^(NSError *error) {
            NSLog(@"错误");
        }];
    }else{
        //申请;
        
        NSMutableDictionary * data = chooseData[currentSelectedIndex];
        [self closeShowHandler:nil];
        CompetitionApplyViewController * applyVC = [[CompetitionApplyViewController alloc]init];
        applyVC.currentTeamId = [data objectForKey:@"teamId"];
        NSNumber * eventId = [dataSource objectForKey:@"id"];
        
        applyVC.currentEventId = [NSString stringWithFormat:@"%zd",eventId.integerValue];
        [self.navigationController pushViewController:applyVC animated:YES];
        
    }
    
}

- (void)closeShowHandler:(UIButton*)sender{
    NSLog(@"关闭申请");
    [container removeFromSuperview];
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

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return chooseData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    static NSString * chooseCell = @"chooseCell";
    CompetitionDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:chooseCell];
    
    if(!cell)
    {
        cell = [[CompetitionDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:chooseCell];
    }
    
    NSMutableDictionary * data = chooseData[indexPath.row];
    
    NSString * imageUrl = [data objectForKey:@"teamLogo"];
    
    NSString * title = [data objectForKey:@"teamName"];
    
    NSString * remark = [data objectForKey:@"teamLabel"];
    
    
    [Global loadImageFadeIn:cell.headIcon andUrl:imageUrl isLoadRepeat:YES];
    
    cell.titleLabel.text = title;
    
    cell.remarkLabel.text = remark;
    
    if(imageUrl.length < 1 && title.length < 1)
    {
        //简介
        cell.isNone = YES;
        cell.selectedIcon.hidden = YES;
        cell.unselectedIcon.hidden = YES;
        cell.headIcon.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.remarkLabel.hidden = YES;
        cell.noneLabel.hidden = NO;
        cell.noneLabel.text = remark;
    }else{
        cell.isNone = NO;
        //cell.selectedIcon.hidden = NO;
        cell.unselectedIcon.hidden = NO;
        cell.headIcon.hidden = NO;
        cell.titleLabel.hidden = NO;
        cell.remarkLabel.hidden = NO;
        cell.noneLabel.hidden = YES;
    }
    
    if(indexPath.row != currentSelectedIndex)
    {
        cell.selectedIcon.hidden = YES;
    }else{
        cell.selectedIcon.hidden = NO;
    }
    
    
    return cell;
    
}
#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    return size.height * 0.09;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CompetitionDetailTableViewCell * cell = (CompetitionDetailTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.isNone)
    {
        return;
    }
    
    currentSelectedIndex = indexPath.row;
    
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%zd",indexPath.row);
    CompetitionDetailTableViewCell * cell = (CompetitionDetailTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.isNone)
    {
        return;
    }
    
    cell.selectedIcon.hidden = NO;
    
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    for(NSInteger i = 0; i < chooseData.count;i++)
    {
        NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
        CompetitionDetailTableViewCell * tempCell = (CompetitionDetailTableViewCell*)[tableView cellForRowAtIndexPath:index];
        
        if(i != indexPath.row)
        {
            tempCell.selectedIcon.hidden = YES;
        }
    }
}

@end
