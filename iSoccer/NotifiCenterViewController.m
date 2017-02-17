//
//  NotifiCenterViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/25.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "NotifiCenterViewController.h"
#import "Global.h"
#import "NotifiCenterTableViewCell.h"
#import <WZLBadgeImport.h>
#import "NotifiCenterDetailViewController.h"
#import "NetConfig.h"
#import "NetRequest.h"

@interface NotifiCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *centerTableView;
    NSMutableArray * dataSource;
}

@end


@implementation NotifiCenterViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
        
        dataSource = [Global getInstance].notifiList;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    centerTableView.rowHeight = 70;
    centerTableView.sectionFooterHeight = 1.0;
    centerTableView.tableFooterView = [[UIView alloc]init];
    
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge>0) {
        //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
        badge = 0;
        //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    }
    
    NSDictionary * post  = @{};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:ONE_KEY_READING parameters:postData atView:self.view andHUDMessage:nil success:^(id resposeObject) {
        NSLog(@"一键阅读成功!");
        
        [Global getInstance].userData.messageCount = 0;
    } failure:^(NSError *error) {
        NSLog(@"哈哈哈");
    }];
}

- (void)backMainView:(UIBarButtonItem*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identifier = @"noticeCell";
    NotifiCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[NotifiCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSMutableDictionary * data = [dataSource objectAtIndex:indexPath.row];
    
    NSString * notice = [data objectForKey:@"noticeTitle"];
    NSString * content = [data objectForKey:@"noticeContent"];
    NSString * time = [data objectForKey:@"noticeTime"];
    
    NSString * status = [data objectForKey:@"noticeStatus"];
    
    NSString * photo = [data objectForKey:@"noticePhoto"];
    
    if([status compare:@"0"] == 0)
    {
        [cell showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
        
        cell.badgeCenterOffset = CGPointMake(-259, cell.noticeIcon.frame.origin.y + 2);
    }
    
    if(photo.length > 0)
    {
        [Global loadImageFadeIn:cell.noticeIcon andUrl:photo isLoadRepeat:YES];
    }
   
    
    cell.noticeLabel.text = notice;
    cell.contentLabel.text = content;
    cell.timeLabel.text = time;
    
    return cell;
}

#pragma mark -- UITableViewDelegate

//设置间隔高度;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary * data = [dataSource objectAtIndex:indexPath.row];
    
    NSString * noticeID = [data objectForKey:@"noticeId"];
    NSString * status = [data objectForKey:@"noticeStatus"];
    
    if([status compare:@"0"] == 0)
    {
        NSDictionary * post = @{@"noticeId":noticeID};
        NSMutableDictionary * postData = [post mutableCopy];
        
        [NetRequest POST:GET_NOTICE_DETAIL parameters:postData atView:self.view andHUDMessage:@"加载中.." success:^(id resposeObject) {
            
            
            NSString *code = resposeObject[@"code"];
            
            if(code.integerValue == 2)
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[Global getInstance].mainVC showLoginView:YES];
                }];
            }else{
            
            NotifiCenterDetailViewController * notifiDetailVC = [[NotifiCenterDetailViewController alloc]initWithData:data];
            
            [self.navigationController pushViewController:notifiDetailVC animated:YES];
            [data setValue:@"1" forKey:@"noticeStatus"];
            
            NotifiCenterTableViewCell * cell = (NotifiCenterTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            
            [cell clearBadge];
            
            //[Global getInstance].userData.messageCount -= 1;
                
                
            //获取应用程序消息通知标记数（即小红圈中的数字）
            NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
            if (badge>0) {
                //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
                badge--;
                //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
                [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            }
                
            }
            
        } failure:^(NSError *error) {
            NSLog(@"失败!");
        }];
    }else{
        NotifiCenterDetailViewController * notifiDetailVC = [[NotifiCenterDetailViewController alloc]initWithData:data];
        
        [self.navigationController pushViewController:notifiDetailVC animated:YES];
    }
}

@end
