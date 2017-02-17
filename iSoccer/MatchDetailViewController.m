//
//  MatchDetailViewController.m
//  iSoccer
//
//  Created by pfg on 16/5/10.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "MatchDetailViewController.h"
#import "CreateTableViewCell.h"
#import "NetConfig.h"
#import "Global.h"
#import "NetRequest.h"
#import "NetDataNameConfig.h"

@interface MatchDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * matchTableView;
    
    NSArray * leftData;
    NSArray * rightData;
    NSArray * typeData;
    NSString * currentInputType;
    NSString * matchFormat;
    NSString * matchType;
    NSString * matchID;
    CreateTableViewCell * currentCell;
    UIDatePicker *datePicker;
    BOOL isShowPicker;
    BOOL isShowMap;
}

@end

@implementation MatchDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.title = @"比赛详情";
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
        leftData = @[@"比赛性质",@"比赛名称",@"比赛时间",@"场地",@"对手",@"赛制",@"球衣颜色",@"场地费",@"备注"];
        
        
        NSMutableDictionary * dataSouce = [Global getInstance].currentMatchData;
        
        matchID = [dataSouce objectForKey:MATCH_ID];
        
        NSString * gameType = [dataSouce objectForKey:GAME_TYPE];
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

        NSString * gameTitleString = [dataSouce objectForKey:GAME_TITLE_KEY];
        
        
        NSString * gameTime = [dataSouce objectForKey:MATCH_TIME];
        
        NSString * time = [Global getDateByTime:gameTime isSimple:NO];
        NSString * gameAddress = [dataSouce objectForKey:MATCH_ADDRESS];
        NSString * teamBName = [dataSouce objectForKey:GAME_TEAM_B];
        
        
        NSString * gameFormat = [dataSouce objectForKey:GAME_FORMAT];
        
        if([gameFormat isEqualToString:@""])
        {
            NSString * formatId = [dataSouce objectForKey:@"formatId"];
            
            if([formatId isEqualToString:FORMAT_FIVE])
            {
                gameFormat = @"5人制";
            }else if([formatId isEqualToString:FORMAT_SEVEN])
            {
                gameFormat = @"7人制";
            }else if([formatId isEqualToString:FORMAT_ELEVEN])
            {
                gameFormat = @"11人制";
            }
        }
        
        NSString * remarks = [dataSouce objectForKey:@"remarks"];
        NSString * gameJersey = [dataSouce objectForKey:GAME_JERSEY];
        
        NSNumber * fee = [dataSouce objectForKey:MATCH_FEE];
        
        NSString * matchFee;
        
        if(fee.floatValue == 0)
        {
            matchFee = @"免费";
        }else{
            matchFee = [NSString stringWithFormat:@"%.2lf",fee.floatValue];
        }
        
        rightData = @[gameType,gameTitleString,time,gameAddress,teamBName,gameFormat,gameJersey,matchFee,remarks];
        
        typeData = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    matchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    
    matchTableView.delegate = self;
    matchTableView.dataSource = self;
    matchTableView.frame = CGRectMake(matchTableView.frame.origin.x, matchTableView.frame.origin.y, matchTableView.frame.size.width, matchTableView.frame.size.height - 64);
    
    
    [self.view addSubview:matchTableView];
    
    UIView * footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(0, 0, self.view.frame.size.width - 30, 48);
    
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消比赛" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [cancelButton addTarget:self action:@selector(tapedCancelMatch:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.backgroundColor = [UIColor blackColor];
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 4;
    
    cancelButton.center = CGPointMake(footerView.frame.size.width/2, footerView.frame.size.height/2);
    
    if([Global getInstance].isMeTeam == YES)
    {
        [cancelButton setHidden:NO];
    }else{
        [cancelButton setHidden:YES];
    }
    
    [footerView addSubview:cancelButton];
    
    matchTableView.tableFooterView = footerView;
    
}

-(void)tapedCancelMatch:(UIButton*)sender{
    NSLog(@"取消比赛");
    
    NSDictionary * post = @{MATCH_ID:matchID};
    NSMutableDictionary *postData = [post mutableCopy];
    
    [NetRequest POST:CANCEL_MATCH parameters:postData atView:self.view andHUDMessage:@"取消中.." success:^(id resposeObject) {
        NSLog(@"取消比赛中成功");
        
        [Global getInstance].isCreateMatchSuccssed = YES;
        [self backMainView:nil];
        
    } failure:^(NSError *error) {
        NSLog(@"失败!");
    }];
    
}

-(void)backMainView:(UIBarButtonItem*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return leftData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"createCell";
    
    CreateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    CGFloat height = 46;
    
    if(indexPath.row == 8)
    {
        height = 80;
    }
    
    if(!cell)
    {
        cell = [[CreateTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier andHeight:height isHead:NO];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString * leftStr = leftData[indexPath.row];
    
    
    [cell setLeftString:leftStr];
    
    cell.arrowIcon.hidden = YES;
    
    if(rightData)
    {
        NSString * rightStr = rightData[indexPath.row];
        
        [cell setRightString:rightStr];
        
    }
    
    return cell;
    
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 46;
    
    if(indexPath.row == 8)
    {
        return 80;
    }
    
    return height;
}
@end
