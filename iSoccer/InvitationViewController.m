//
//  InvitationViewController.m
//  iSoccer
//
//  Created by pfg on 16/2/15.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "InvitationViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "NetRequest.h"
#import "NetConfig.h"
#import "TeamTableViewCell.h"
#import "Global.h"
#import "LBAddressBookVC.h"

#import "WXApi.h"

@interface InvitationViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    
    IBOutlet UITableView *invitationTableView;
    
    NSMutableArray * dataSource;
    
    NSString * sendMessage;
}

@end

@implementation InvitationViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
        
        NSMutableArray *data = [Global getInstance].teamList;
        dataSource = [NSMutableArray array];
        for(NSInteger i = 0;i < data.count;i++)
        {
            TeamData * teamData = [[TeamData alloc]initWithData:data[i]];
            [dataSource addObject:teamData];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    invitationTableView.rowHeight = 116;
    
    invitationTableView.tableFooterView = [[UIView alloc]init];
}

- (void)backMainView:(UIBarButtonItem*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%zd",dataSource.count);
    
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    cell.teamSumMatchLabel.attributedText = [[NSString stringWithFormat:@"参与<red>%ld</red>球赛",(long)teamData.matchCount] attributedStringWithStyleBook:style1];
    
    cell.teamWinLabel.attributedText = [[NSString stringWithFormat:@"胜<red>%ld</red>场",(long)teamData.winCount] attributedStringWithStyleBook:style1];
    
    cell.teamMemberLabel.attributedText = [[NSString stringWithFormat:@"共<red>%ld</red>名球员",(long)teamData.memberCount] attributedStringWithStyleBook:style1];
    
    return cell;

}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击球队发送邀请码;
    
    UIActionSheet * actionSheet;
    
    if([WXApi isWXAppInstalled] == YES)
    {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"短信",@"微信",nil];
    }else{
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"短信",nil];
    }
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
    
    TeamData * teamData  = dataSource[indexPath.row];
    
    sendMessage = [NSString stringWithFormat:@"我正在使用〖足球管家〗应用，加入我的队伍吧（邀请码:%@）！",teamData.teamCode];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"短信");
        LBAddressBookVC * messageVC = [[LBAddressBookVC alloc]init];
        messageVC.jekAddressBookMessage = sendMessage;
        [self.navigationController pushViewController:messageVC animated:YES];
    }else if (buttonIndex == 1) {
        NSLog(@"微信");
        [self WeChatSendMessage];
    }
}

- (void)WeChatSendMessage{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.text = sendMessage;
    req.bText = YES;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}


@end
