//
//  TeamMessageViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/13.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "TeamMessageViewController.h"
#import "NetDataNameConfig.h"
#import "NetRequest.h"
#import "NetConfig.h"
#import "Global.h"
#import "MessageTableViewCell.h"
#import "MemberTableViewCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "TeamDetailViewController.h"
#import "UserViewController.h"
#import "RecordViewController.h"

@interface TeamMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString * _type;
    
    NSMutableDictionary * _infoData;
    
    UITableView * teamTableView;
    
    NSArray * sectionData;
    
    NSInteger currentSelectIndex;
    
    NSMutableArray * _matchList;
    
    NSMutableArray * _userList;
    
    UIImageView * headerIcon;
    
    UILabel * teamLabel;
    UILabel  * teamTitle;
    
    NSString * teamId;
    NSString * selectedUserId;
    
}

@end

@implementation TeamMessageViewController

- (instancetype)initWithData:(NSMutableDictionary*)data andType:(NSString*)type
{
    self = [super init];
    if (self) {
        self.title = @"球队信息";
        _type = type;
        
        NSLog(@"%@",_type);
        _infoData = data;
        
        _matchList = [NSMutableArray array];
        
        teamId = [_infoData objectForKey:TEAM_ID];
        
        NSMutableArray *matchList = [_infoData objectForKey:MATCH_LIST];
        
        NSMutableArray *matchOne = [NSMutableArray array];
        NSMutableArray *matchTwo = [NSMutableArray array];
        
        _userList = [_infoData objectForKey:USER_LIST];
        
        for(NSInteger i = 0;i < matchList.count;i++)
        {
            NSMutableDictionary *matchData = matchList[i];
            NSString * type = [matchData objectForKey:@"atendance"];
            if([type compare:@"0"] == 0)
            {
                //未出勤;
                [matchOne addObject:matchData];
            }else{
                //已出勤;
                [matchTwo addObject:matchData];
            }
        }
        [_matchList addObject:matchTwo];
        [_matchList addObject:matchOne];
        
        sectionData = @[@"4",@"4"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    if([Global getInstance].isUpdateCreateTeamMessage == YES)
    {
        [Global getInstance].isUpdateCreateTeamMessage = NO;
        
        _infoData = [Global getInstance].teamMessageData;
        
        [Global getInstance].isUpdateCreateTeamList = YES;
        
        [self updateTeamInfo];

    }
    
    if([Global getInstance].isDeleteMatchMemberSuccessed == YES)
    {
        [Global getInstance].isDeleteMatchMemberSuccessed = NO;
        
        for(NSInteger i = 0;i < _userList.count;i++)
        {
            NSMutableDictionary * userData = _userList[i];
            
            NSString * userId = [userData objectForKey:USER_ID];
            
            if([selectedUserId isEqualToString:userId] == YES)
            {
                [_userList removeObjectAtIndex:i];
                break;
            }
        }

        [teamTableView reloadData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    
    teamTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    
    teamTableView.delegate = self;
    teamTableView.dataSource = self;
    
    currentSelectIndex = 0;
    
    teamTableView.sectionFooterHeight = 1.0;
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 130)];
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView * teamInfoHeader = [self createTeamInfo];
    
    teamInfoHeader.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTeamDetailHandler:)];
    
    [teamInfoHeader setGestureRecognizers:@[tapGesture]];
    
    
    [headerView addSubview:teamInfoHeader];
    
    teamTableView.tableHeaderView = headerView;
    
    UISegmentedControl * segmented = [[UISegmentedControl alloc]initWithItems:@[@"参加比赛",@"球队成员"]];
    
    segmented.frame = CGRectMake(teamInfoHeader.frame.origin.x, teamInfoHeader.frame.origin.y + teamInfoHeader.frame.size.height + 12, self.view.frame.size.width - 24, 28);
    
    segmented.selectedSegmentIndex = 0;
    
    segmented.tintColor = [UIColor blackColor];
    
    [segmented addTarget:self action:@selector(selectedChangedHandler:) forControlEvents:UIControlEventValueChanged];
    
    [headerView addSubview:segmented];
    
    [self.view addSubview:teamTableView];
}

- (void)tapTeamDetailHandler:(UITapGestureRecognizer*)gesture{
    
    NSString * userTimeId = [_infoData objectForKey:TEAM_ID];
    
    NSDictionary *post = @{TEAM_ID:userTimeId};
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:GET_TEAM_DETAIL parameters:postData atView:self.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
        NSString *code = resposeObject[@"code"];
        
        if(code.integerValue == 2)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [[Global getInstance].mainVC showLoginView:YES];
            }];
        }else{
        
        NSMutableDictionary * teamData = resposeObject[@"team"];
        
        TeamDetailViewController * teamDetailVC = [[TeamDetailViewController alloc]initWithData:teamData andType:_type];
        [self.navigationController pushViewController:teamDetailVC animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"获取错误");
    }];
    
    
}

- (void)selectedChangedHandler:(UISegmentedControl*)sender{
    currentSelectIndex = sender.selectedSegmentIndex;
    
    [teamTableView reloadData];
}
- (void)updateTeamInfo{
    if([Global getInstance].teamImage != nil)
    {
        headerIcon.image = [Global getInstance].teamImage;
    }
    
    NSString * teamLabelString = [_infoData objectForKey:TEAM_LABEL];
    
    teamLabel.text = teamLabelString;
    
    NSString * teamName = [_infoData objectForKey:TEAM_NAME];
    teamTitle.text = teamName;
}

- (UIView*)createTeamInfo{
    UIView * teamHeaerInfo = [[UIView alloc]initWithFrame:CGRectMake(12, 12, self.view.frame.size.width - 24, 58)];
    
    headerIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 58, 58)];
    
    NSString *logo = [_infoData objectForKey:TEAM_LOGO];
    
    if(logo.length > 0)
    {
        [Global loadImageFadeIn:headerIcon andUrl:logo isLoadRepeat:YES];
    }else{
        headerIcon.image = [UIImage imageNamed:@"default_team_icon.jpg"];
    }
    
    headerIcon.layer.masksToBounds = YES;
    headerIcon.layer.cornerRadius = headerIcon.frame.size.width/2;
    
    
    headerIcon.contentMode = UIViewContentModeScaleAspectFill;
    
    headerIcon.autoresizingMask = UIViewAutoresizingNone;
    
    [teamHeaerInfo addSubview:headerIcon];
    
    teamTitle = [[UILabel alloc]initWithFrame:CGRectMake(headerIcon.frame.size.width + 12, 0, teamHeaerInfo.frame.size.width - headerIcon.frame.size.width - 12, 17)];
    
    NSString * teamName = [_infoData objectForKey:GAME_TEAM_A];
    
    teamTitle.text = teamName;
    teamTitle.textColor = [UIColor blackColor];
    teamTitle.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [teamHeaerInfo addSubview:teamTitle];
    
    teamLabel = [[UILabel alloc]initWithFrame:CGRectMake(teamTitle.frame.origin.x, teamTitle.frame.size.height + 6, teamTitle.frame.size.width, 15)];
    
    teamLabel.textColor = [UIColor blackColor];
    
    teamLabel.font = [UIFont systemFontOfSize:16];
    
    NSString * teamLabelString = [_infoData objectForKey:TEAM_LABEL];
    
    teamLabel.text = teamLabelString;
    
    [teamHeaerInfo addSubview:teamLabel];
    
    UILabel * teamTime = [[UILabel alloc]initWithFrame:CGRectMake(teamTitle.frame.origin.x, teamLabel.frame.size.height + teamLabel.frame.origin.y + 6, teamLabel.frame.size.width, 15)];
    
    teamTime.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1.0];
    teamTime.font = [UIFont systemFontOfSize:15];
    
    NSString * addTime = [_infoData objectForKey:@"addTime"];
    
    NSString *time = [Global getDateByTime:addTime isSimple:YES];
    
    if([_type compare:@"0"] == 0)
    {
        teamTime.text = [NSString stringWithFormat:@"%@加入",time];
    }else{
        teamTime.text = [NSString stringWithFormat:@"%@创建",time];
    }
        
    [teamHeaerInfo addSubview:teamTime];
    
    
    UIImageView * arrowIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
    arrowIcon.frame = CGRectMake(0, 0, 8, 13);
    
    arrowIcon.center = CGPointMake(teamHeaerInfo.frame.size.width - arrowIcon.frame.size.width/2, teamHeaerInfo.frame.size.height/2);
    
    [teamHeaerInfo addSubview:arrowIcon];
    
    return teamHeaerInfo;
}


#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(currentSelectIndex == 0)
    {
        NSMutableArray * sectionNum = _matchList[section];
        return sectionNum.count + 1;
    }else{
        return _userList.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(currentSelectIndex == 0)
    {
        static NSString *identifier = @"matchCell";
        
        NSInteger index = indexPath.row;
        
        NSString *title;
        if(indexPath.row == 0 && indexPath.section == 0)
        {
            title = @"已出勤";
        }else if(indexPath.row  == 0 && indexPath.section == 1){
            title = @"未出勤";
        }else{
            title = @"";
        }
        MessageTableViewCell * cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier isTitle:title];
        
        if([title compare:@""] != 0)
        {
            return cell;
        }
        index = index - 1;//减去第一个标题栏;
        if(index < 0)
        {
            index = 0;
        }
        NSMutableDictionary * matchData = _matchList[indexPath.section][index];
        
        NSString * gameType = [matchData objectForKey:GAME_TYPE];
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
        cell.matchTypeLabel.text = gameType;
        NSString * matchName = [matchData objectForKey:GAME_TITLE_KEY];
        
        cell.matchNameLabel.text = matchName;
        
        
        NSString * teamA = [matchData objectForKey:GAME_TEAM_A];
        NSString * teamB = [matchData objectForKey:GAME_TEAM_B];
        NSString * teamSoure = [matchData objectForKey:MATCH_SCORE];
        
        NSString * scoreString = [NSString stringWithFormat:@"%@ %@ %@",teamA,teamSoure,teamB];
        cell.matchScoreLabel.text = scoreString;
        
        NSString * matchTime = [matchData objectForKey:MATCH_TIME];
        NSString *timeString = [Global getDateByTime:matchTime isSimple:YES];
        NSString *time = [NSString stringWithFormat:@"比赛时间:%@",timeString];
        
        cell.matchTimeLabel.text = time;
        
        return cell;
        
    }else{
        
        static NSString *identifier = @"memberCell";
        
        NSInteger index = indexPath.row;
        
        NSString *title;
        if(indexPath.row == 0)
        {
            title = @"按累计出勤场次排列";
        }else{
            title = @"";
        }
        MemberTableViewCell * cell = [[MemberTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier isTitle:title];
        
        if([title compare:@""] != 0)
        {
            return cell;
        }
        index = index - 1;//减去第一个标题栏;
        if(index < 0)
        {
            index = 0;
        }
        NSMutableDictionary * memberData = _userList[index];
        
        NSString * photo = [memberData objectForKey:USER_PHOTO];
        
        if(photo.length > 0)
        {
           [Global loadImageFadeIn:cell.userIcon andUrl:photo isLoadRepeat:YES];
        }
        NSString * memberName = [memberData objectForKey:USER_NAME];
        
        cell.userNameLabel.text = memberName;
        
        NSDictionary* orangeStyle = @{@"orange": [UIColor orangeColor]};
        
        NSNumber * goal = [memberData objectForKey:GOAL_NUM];
        NSNumber * matchCount = [memberData objectForKey:MATCH_COUNT];
        
        
        cell.userMatchLabel.attributedText = [[NSString stringWithFormat:@"参与<orange>%zd</orange>场比赛,进<orange>%zd</orange>进球.",matchCount.integerValue,goal.integerValue] attributedStringWithStyleBook:orangeStyle];
        
        return cell;
    }
}

#pragma mark -- UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)//去掉标题点击;
        return;
    
    if(currentSelectIndex == 0)
    {
        NSMutableDictionary * recordData =  _matchList[indexPath.section][indexPath.row - 1];
        NSString * matchId = [recordData objectForKey:MATCH_ID];
        NSDictionary * post = @{MATCH_ID:matchId};
        NSMutableDictionary * postData =[post mutableCopy];
        [NetRequest POST:GET_RECORD parameters:postData atView:self.view andHUDMessage:@"加载中..." success:^(id resposeObject) {
            
            NSString *code = resposeObject[@"code"];
            
            if(code.integerValue == 2)
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[Global getInstance].mainVC showLoginView:YES];
                }];
            }else{
            
            NSMutableDictionary * data = resposeObject[@"match"];
            
            RecordViewController * rdVC = [[RecordViewController alloc]initWithData:data andIsMe:NO];
            
            [self.navigationController pushViewController:rdVC animated:YES];
            }
        } failure:^(NSError *error) {
            
        }];

    }else{
        NSMutableDictionary * memberData = _userList[indexPath.row - 1];
        
        [Global getInstance].currentDeleteTeamId = teamId;
        
        selectedUserId = [memberData objectForKey:USER_ID];
        
        BOOL isMeTeam;
        
        if([_type compare:@"0"] == 0)
        {
            isMeTeam = NO;
        }else{
            isMeTeam = YES;
        }
        
        UserViewController * memberVC = [[UserViewController alloc]initWithData:memberData andIsMe:NO isMainEnter:NO andIsMeTeam:isMeTeam];
        [self.navigationController pushViewController:memberVC animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(currentSelectIndex == 0)
        return _matchList.count;
    else
        return 1;
}

//设置间隔高度;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 66;
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        height = 40;
    }
    
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        height = 40;
    }
    
    return height;
}

@end
