//
//  TeamViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/12.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamTableViewCell.h"
#import "Global.h"
#import "NetDataNameConfig.h"
#import "TeamData.h"
#import "NSString+WPAttributedMarkup.h"
#import "NetRequest.h"
#import "NetConfig.h"
#import "TeamMessageViewController.h"
#import <SDWebImageManager.h>

@interface TeamViewController ()
{
    NSMutableArray * dataSource;
    
    NSInteger currentPage;
    
    NSInteger currentRow;
    
    TeamTableViewCell * currentCell;
}

@end

@implementation TeamViewController
{
    IBOutlet UITableView *teamTableView;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.title = @"球队";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
    }
    return self;
}
- (IBAction)selectHandler:(id)sender {
    
    UISegmentedControl * segmented = (UISegmentedControl*)sender;
    
    NSMutableArray * allData = [Global getInstance].teamList;
    
    dataSource = [NSMutableArray array];
    
    if(segmented.selectedSegmentIndex == 1)
    {
        for(NSInteger i = 0;i < allData.count;i++)
        {
            TeamData * teamData = [[TeamData alloc]initWithData:allData[i]];
            if([teamData.teamType compare:@"1"] == 0)
            {
                //自己创建;
                [dataSource addObject:teamData];
            }
        }
        [teamTableView reloadData];

    }else{
        for(NSInteger i = 0;i < allData.count;i++)
        {
            TeamData * teamData = [[TeamData alloc]initWithData:allData[i]];
            if([teamData.teamType compare:@"0"] == 0)
            {
                //加入的;
                [dataSource addObject:teamData];
            }
        }
        
        [teamTableView reloadData];
    }
    currentPage = segmented.selectedSegmentIndex;
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    if([Global getInstance].isUpdateCreateTeamList == YES)
    {
        [Global getInstance].isUpdateCreateTeamList = NO;
        
        TeamData *teamData = [Global getInstance].teamData;
        
        [[SDWebImageManager sharedManager].imageCache removeImageForKey:teamData.teamLogo];
        
        NSDictionary * post = @{};
        NSMutableDictionary * postData = [post mutableCopy];
        
        [NetRequest POST:GET_TEAM parameters:postData atView:self.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
            
            NSString *code = resposeObject[@"code"];
            
            if(code.integerValue == 2)
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[Global getInstance].mainVC showLoginView:YES];
                }];
            }else{
            
            [Global getInstance].teamList = resposeObject[TEAM_LIST];
            
            [self updateView];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"错误");
        }];
        
        return;
    }
    
    [self updateView];
}

- (void)updateView{
    
    
    NSMutableArray * allData = [Global getInstance].teamList;
    
    dataSource = [NSMutableArray array];
    
    if(currentPage == 1)
    {
        for(NSInteger i = 0;i < allData.count;i++)
        {
            TeamData * teamData = [[TeamData alloc]initWithData:allData[i]];
            if([teamData.teamType compare:@"1"] == 0)
            {
                //自己创建;
                [dataSource addObject:teamData];
            }
        }
        [teamTableView reloadData];
        
    }else{
        for(NSInteger i = 0;i < allData.count;i++)
        {
            TeamData * teamData = [[TeamData alloc]initWithData:allData[i]];
            if([teamData.teamType compare:@"0"] == 0)
            {
                //加入的;
                [dataSource addObject:teamData];
            }
        }
        
        [teamTableView reloadData];
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    
    currentPage = 0;
    
    
    NSMutableArray * allData = [Global getInstance].teamList;
    dataSource = [NSMutableArray array];
    
    
    for(NSInteger i = 0;i < allData.count;i++)
    {
        TeamData * teamData = [[TeamData alloc]initWithData:allData[i]];
        if([teamData.teamType compare:@"0"] == 0)
        {
            //加入的;
            [dataSource addObject:teamData];
        }
    }
    
    teamTableView.tableFooterView = [[UIView alloc]init];
}

- (void)backMainView:(UIBarButtonItem*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* identifier = @"teamCell";
    
    TeamTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell)
    {
        cell = [[TeamTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 116);
    }
    
    TeamData * teamData  = dataSource[indexPath.row];
    
    cell.teamTitleLabel.text = teamData.teamName;
    
    cell.teamLabel.text = teamData.teamLabel;
    
    cell.teamDisLabel.text = teamData.remark;
    
    [Global loadImageFadeIn:cell.teamIcon andUrl:teamData.teamLogo isLoadRepeat:YES];
    
    NSDictionary* style1 = @{@"red": [UIColor orangeColor]};
    
    cell.teamSumMatchLabel.attributedText = [[NSString stringWithFormat:@"参与<red>%zd</red>球赛",teamData.matchCount] attributedStringWithStyleBook:style1];
    
    cell.teamWinLabel.attributedText = [[NSString stringWithFormat:@"胜<red>%zd</red>场",teamData.winCount] attributedStringWithStyleBook:style1];
    
    cell.teamMemberLabel.attributedText = [[NSString stringWithFormat:@"共<red>%zd</red>名球员",teamData.memberCount] attributedStringWithStyleBook:style1];
    
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    currentRow = indexPath.row;
    TeamData * teamData = dataSource[currentRow];
    
    currentCell = (TeamTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [Global getInstance].teamData = teamData;
    
    NSDictionary * post = @{
                            USER_TEAM_ID:teamData.userTeamId
                            };
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:GET_TEAM_INFO parameters:postData atView:self.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
        
        NSString *code = resposeObject[@"code"];
        
        if(code.integerValue == 2)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [[Global getInstance].mainVC showLoginView:YES];
            }];
        }else{
        
        NSMutableDictionary * data = resposeObject[@"team"];
        
        TeamMessageViewController * teamMessageVC = [[TeamMessageViewController alloc]initWithData:data andType:teamData.teamType];
        
        [self.navigationController pushViewController:teamMessageVC animated:YES];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"获取失败..");
    }];
}


@end
