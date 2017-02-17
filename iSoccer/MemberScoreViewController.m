//
//  MemberScoreViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/7.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "MemberScoreViewController.h"
#import "UserData.h"
#import "UserGoalData.h"
#import "MemberGoalTableViewCell.h"
#import "Global.h"
#import "MMPickerView.h"
#import "NetRequest.h"
#import "NetConfig.h"
#import "NetDataNameConfig.h"
#import "NSString+WPAttributedMarkup.h"
@interface MemberScoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * hasMemberData;
    NSMutableArray * memberData;
    NSMutableArray * goalData;
    NSInteger sumScore;
    UITableView * goalTableView;
    UIView *footerView;
    UILabel *scoreLabel;
    NSInteger hasScore;
    NSInteger currentGoalCount;
    NSInteger currentMemberIndex;
    NSString * _matchId;
    BOOL _isMe;
}


@end

@implementation MemberScoreViewController


- (instancetype)initWithMembers:(NSMutableArray*)members andGoals:(NSMutableArray*)goals andSumScore:(NSInteger)score andMatchId:(NSString*)matchId andMe:(BOOL)isMe
{
    self = [super init];
    if (self) {
        self.title = @"进球信息";
        
        _matchId = matchId;
        _isMe = isMe;
        hasMemberData = [members mutableCopy];
        memberData = [members mutableCopy];
        goalData = [goals mutableCopy];
        sumScore = score;
        hasScore = sumScore;
        
        NSInteger sum = hasMemberData.count;
        
        for(NSInteger i = 0; i < sum;i++ )
        {
            for(NSInteger j = 0; j < goalData.count;j++)
            {
                UserData * user = [hasMemberData objectAtIndex:i];
                UserGoalData * goal = [[UserGoalData alloc]initWithData:[goalData objectAtIndex:j]];
                
                if([user.userId compare:goal.userId] == 0)
                {
                    //检测到相同从总列表删除;
                    [hasMemberData removeObjectAtIndex:i];
                    
                    i--;//重置到前一位;
                    sum--;
                    hasScore -= goal.goalCount;
                    break;
                }
                
            }
        }
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_DELETE_SCORE object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteHandler:) name:EVENT_DELETE_SCORE object:nil];
    
    goalTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    goalTableView.dataSource = self;
    goalTableView.delegate = self;
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    UILabel * memberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 25)];
    
    memberLabel.text = @"球员";
    memberLabel.textColor = [UIColor blackColor];
    memberLabel.textAlignment = NSTextAlignmentCenter;
    memberLabel.font = [UIFont systemFontOfSize:18];
    
    memberLabel.center = CGPointMake(memberLabel.frame.size.width / 2 + 20, headerView.frame.size.height/2);
    
    [headerView addSubview:memberLabel];
    
    
    UILabel * goalsLabel = [[UILabel alloc]initWithFrame:memberLabel.frame];
    goalsLabel.text = @"进球";
    goalsLabel.textColor = memberLabel.textColor;
    goalsLabel.textAlignment = memberLabel.textAlignment;
    goalsLabel.font = memberLabel.font;
    goalsLabel.center = CGPointMake(headerView.frame.size.width/2, headerView.frame.size.height/2);
    [headerView addSubview:goalsLabel];
    
    headerView.backgroundColor = [UIColor colorWithRed:243.0/255 green:241.0/255 blue:242.0/255 alpha:1.0];
    
    goalTableView.tableHeaderView = headerView;
    
    
    footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(0, 0, self.view.frame.size.width - 40, 45);
    [addButton setTitle:@"增加记录" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    addButton.titleLabel.font = [UIFont systemFontOfSize:20];
    
    addButton.backgroundColor = [UIColor blackColor];
    
    addButton.layer.cornerRadius = 4;
    
    addButton.center = CGPointMake(footerView.frame.size.width/2, footerView.frame.size.height/2 - 6);
    
    [addButton addTarget:self action:@selector(addHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:addButton];
    
    scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
    
    scoreLabel.textColor = [UIColor colorWithRed:135.0/255 green:134.0/255 blue:140.0/255 alpha:1.0];
    
    NSDictionary* style1 = @{@"red": [UIColor redColor]};
    
    scoreLabel.attributedText = [[NSString stringWithFormat:@"本次比赛进<red>%zd</red>个球,还剩<red>%zd</red>个进球信息",sumScore,hasScore] attributedStringWithStyleBook:style1];
    
    scoreLabel.font = [UIFont systemFontOfSize:14];
    
    scoreLabel.center = CGPointMake(footerView.frame.size.width/2, addButton.center.y + addButton.frame.size.height/2 + 12);
    
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    
    [footerView addSubview:scoreLabel];
    
    goalTableView.tableFooterView = footerView;
    
    [self.view addSubview:goalTableView];
    
    if(_isMe == NO)
    {
        scoreLabel.hidden = YES;
        addButton.hidden = YES;
    }
    
}

- (void)addHandler:(UIButton*)sender{
    if(hasScore == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"记录已经达到总分数上限!"];
        return;
    }
    
    if(hasMemberData.count == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"已经没有可新增队员!"];
        return;
    }
    
    [self showPickerView];
}

- (void)showPickerView{
    NSMutableArray * scores = [NSMutableArray array];
    
    for(NSInteger i = 1;i <= hasScore;i++)
    {
        [scores addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    
    //默认只能为1;
    currentGoalCount = 1;
    
    NSMutableArray * memberNames = [NSMutableArray array];
    
    for(NSInteger i = 0;i < hasMemberData.count;i++)
    {
        UserData * member = hasMemberData[i];
        [memberNames addObject:member.userName];
    }
    
    NSArray * data = @[memberNames,scores];
    
    
    [MMPickerView showPickerViewInViewComponents:self.view withStrings:data withOptions:nil withComponents:nil completion:^(NSString *selectString, NSInteger component) {
        
        if(component == 0)
        {
            currentMemberIndex = [memberNames indexOfObject:selectString];
        }else{
            currentGoalCount = selectString.integerValue;
        }
        
    } hedden:^{
        //调用更改信息;
        
        UserData * userMember = hasMemberData[currentMemberIndex];
        
        NSNumber * goalCount = [NSNumber numberWithInteger:currentGoalCount];
        
        NSDictionary * post = @{
                                MEMBER_ID:userMember.userId,
                                MATCH_ID:_matchId,
                                GOAL_COUNT:goalCount
                                };
        NSMutableDictionary * postData = [post mutableCopy];
        
        [NetRequest POST:ADD_RECORED_SCORE parameters:postData atView:self.view andHUDMessage:@"添加中.." success:^(id resposeObject) {
            
            
            NSString *code = resposeObject[@"code"];
            
            if(code.integerValue == 2)
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[Global getInstance].mainVC showLoginView:YES];
                }];
            }else{

                goalData = resposeObject[GOAL_LIST];
                currentMemberIndex = 0;
                currentGoalCount = 1;
            
                for(NSInteger i = 0; i < hasMemberData.count;i++ )
                {
                    for(NSInteger j = 0; j < goalData.count;j++)
                    {
                        UserData * user = [hasMemberData objectAtIndex:i];
                        UserGoalData * goal = [[UserGoalData alloc]initWithData:[goalData objectAtIndex:j]];
                    
                        if([user.userId compare:goal.userId] == 0)
                        {
                            //检测到相同从总列表删除;
                            [hasMemberData removeObjectAtIndex:i];
                        
                            i--;//重置到前一位;
                        }
                    
                    }
                }
 
                [goalTableView reloadData];
                [self updateFooterLabel];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"添加出错");
        }];
    }];
}

- (void)deleteHandler:(NSNotification*)notification
{
    NSString * rowString = notification.object;
    
    NSInteger row = rowString.integerValue;
    
    UserGoalData * goal = [[UserGoalData alloc]initWithData:goalData[row]];
    
    NSDictionary * post = @{
                            GOAL_ID:goal.goalId,
                            };
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:DELETE_RECORED_SCORE parameters:postData atView:self.view andHUDMessage:@"删除中.." success:^(id resposeObject) {
        
        NSString *code = resposeObject[@"code"];
        
        if(code.integerValue == 2)
        {
            
            [self dismissViewControllerAnimated:YES completion:^{
                [[Global getInstance].mainVC showLoginView:YES];
            }];
        
        }else{
        
        NSMutableDictionary *dic = goalData[row];
        
        NSString *memberId = [dic objectForKey:USER_ID];
        
        [goalData removeObjectAtIndex:row];
        
        /** 添加把删除的人到可用列表**/
        for(NSInteger i = 0;i < memberData.count;i++)
        {
            UserData * member = memberData[i];
            if([member.userId compare:memberId] == 0)
            {
                [hasMemberData addObject:member];
            }
        }
        
        [goalTableView reloadData];
        
        [self updateFooterLabel];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"调用失败");
    }];
}

- (void)updateFooterLabel{
    
    NSInteger useGoals = 0;
    
    for(NSInteger i = 0;i < goalData.count;i++)
    {
        UserGoalData * goal = [[UserGoalData alloc]initWithData:goalData[i]];
        
        useGoals += goal.goalCount;
    }
    
    hasScore = sumScore - useGoals;
    
    NSDictionary* style1 = @{@"red": [UIColor redColor]};
    
    scoreLabel.attributedText = [[NSString stringWithFormat:@"本次比赛进<red>%zd</red>个球,还剩<red>%zd</red>个进球信息",sumScore,hasScore] attributedStringWithStyleBook:style1];
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return goalData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*identifier = @"goalCell";
    
    MemberGoalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell)
    {
        cell = [[MemberGoalTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier andRow:indexPath.row];
    }
    if(_isMe == NO)
    {
        cell.deleteButton.hidden = YES;
    }
    
    UserGoalData * goal = [[UserGoalData alloc]initWithData:[goalData objectAtIndex:indexPath.row]];
    
    cell.memberLabel.text = goal.userName;
    cell.goalLabel.text = [NSString stringWithFormat:@"%zd",goal.goalCount];
    
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    RecordTableViewCell *cell = (RecordTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_isMe == NO)
        return;
    
    MemberGoalTableViewCell * cell = (MemberGoalTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableArray * scores = [NSMutableArray array];
    
    for(NSInteger i = 1;i <= sumScore;i++)
    {
        [scores addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    
    NSMutableArray * memberNames = [NSMutableArray array];
    
    for(NSInteger i = 0;i < memberData.count;i++)
    {
        UserData * member = memberData[i];
        [memberNames addObject:member.userName];
    }
    
    NSArray * data = @[memberNames,scores];
    
    NSMutableArray * components = [NSMutableArray array];
    for(NSInteger i = 0;i < 2;i++)
    {
    
        NSInteger row;
        
        if(i == 0)
        {
            row = [memberNames indexOfObject:cell.memberLabel.text];
        }else{
            row = cell.goalLabel.text.integerValue - 1;
        }
    
        NSDictionary * dic = @{@"row":[NSString stringWithFormat:@"%zd",row],@"component":[NSString stringWithFormat:@"%zd",i]};
        [components addObject:dic];
    }
    
    UserGoalData * goal =  [[UserGoalData alloc]initWithData:goalData[indexPath.row]];
    
    [MMPickerView showPickerViewInViewComponents:self.view withStrings:data withOptions:nil withComponents:components completion:^(NSString *selectString, NSInteger component) {
        if(component == 0)
        {
            cell.memberLabel.text = selectString;
        }else{
            cell.goalLabel.text = selectString;
        }
        
    } hedden:^{
        //调用更改接口;
        
        NSNumber * goalNumber = [NSNumber numberWithInteger:cell.goalLabel.text.integerValue];
        
        NSInteger index = [memberNames indexOfObject:cell.memberLabel.text];
        
        UserData * userMember = memberData[index];
        
        NSDictionary * post = @{
                                GOAL_ID:goal.goalId,
                                GOAL_COUNT:goalNumber,
                                MEMBER_ID:userMember.userId
                                };
        NSMutableDictionary * postData = [post mutableCopy];
        [NetRequest POST:UPDATE_RECORED_SCORE parameters:postData atView:self.view andHUDMessage:@"更新中.." success:^(id resposeObject) {
            NSLog(@"更新成功");
            
            NSString *code = resposeObject[@"code"];
            
            if(code.integerValue == 2)
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[Global getInstance].mainVC showLoginView:YES];
                }];
            }else{
            
            [goalData[indexPath.row] setValue:goalNumber forKey:GOAL_COUNT];
            [goalData[indexPath.row] setValue:userMember.userId forKey:USER_ID];
            [goalData[indexPath.row] setValue:userMember.userName forKey:USER_NAME];
            
            [goalTableView reloadData];
            [self updateFooterLabel];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"更改进球失败!");
        }];
        
    }];
    
}

@end
