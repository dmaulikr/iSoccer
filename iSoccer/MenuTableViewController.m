//
//  MenuTableViewController.m
//  iSoccer
//
//  Created by pfg on 15/10/28.
//  Copyright © 2015年 iSoccer. All rights reserved.
//

#import "MenuTableViewController.h"
#import "HomeViewController.h"
#import "SecondViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"
#import "ListUITableViewCell.h"
#import "UserNavigationController.h"
#import "UserViewController.h"
#import <UIImageView+WebCache.h>
#import "Global.h"
#import "TeamNavigationViewController.h"
#import "TeamViewController.h"
#import "NetConfig.h"
#import "NetRequest.h"
#import "NetDataNameConfig.h"

#import "NotifiCenterNavigationViewController.h"
#import "FindTeamNavigationViewController.h"
#import "PayNavigationViewController.h"
#import "InvitationNavigationViewController.h"
#import "MobileNavigationViewController.h"
#import "NewNotifiCenterNavigationController.h"
#import "CompetitionNavigationViewController.h"
#import "ReservationNavigationViewController.h"
#import "Reachability.h"

#import <WZLBadgeImport.h>

#define HEADER_H (self.view.frame.size.height * 0.17)
#define HEAD_H (self.view.frame.size.height * 0.09)

@interface MenuTableViewController ()
{
    NSArray *titles;
    UserNavigationController *userNav;
    
    TeamNavigationViewController *teamNav;
    SecondViewController *secondViewController;
    
    UILabel *label;
    UIImageView *imageView;
    ListUITableViewCell * messageCell;
}

@end

@implementation MenuTableViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self updateMessageCount];
    [self updateTitleAndAvatar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    titles = @[@"球队", @"财务", @"邀请加入",@"加入球队/创建球队", @"通知", @"赛事",@"球场预订",@"我"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, HEADER_H)];
        
        view.backgroundColor = [UIColor blackColor];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (HEADER_H - HEAD_H)/2 + 10, HEAD_H, HEAD_H)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"default_icon_head.jpg"];
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width + imageView.frame.origin.x + 10, (HEADER_H - 22)/2 + 10, 200, 24)];
        label.text = @"信 蜂";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    
    
    //我的资料界面;
    
    secondViewController = [[SecondViewController alloc] init];
    
    UIStoryboard *loginAndRegister = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
    teamNav = loginAndRegister.instantiateInitialViewController;
    
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    //去掉分割 ；
    return nil;
    
//    if (sectionIndex == 0)
//        return nil;
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
//    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
//    label.text = @"Friends Online";
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    [view addSubview:label];
//    
//    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    //去掉分割；
    return 0;
    
//    if (sectionIndex == 0)
//        return 0;
//    
//    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MainViewController *mainVC = (MainViewController *)self.frostedViewController.contentViewController;
    
    if (indexPath.section == 0 && indexPath.row == 7) {
        
        UserData * userData = [Global getInstance].userData;
        if(userData != nil)
        {
            UserViewController * userVC = [[UserViewController alloc]initWithData:nil andIsMe:YES isMainEnter:NO andIsMeTeam:YES];
            userNav = [[UserNavigationController alloc] initWithRootViewController:userVC];
            [mainVC presentViewController:userNav animated:YES completion:nil];
        }else{
            [mainVC showLoginView:YES];
        }
    } else if(indexPath.section == 0 && indexPath.row == 0)
    {
        
        NSDictionary * post = @{};
        NSMutableDictionary * postData = [post mutableCopy];
        
        [NetRequest POST:GET_TEAM parameters:postData atView:mainVC.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
            
            NSString *code = resposeObject[@"code"];
            if(code.integerValue == 2)
            {
                [[Global getInstance].mainVC showLoginView:YES];

            }else{
            
            [Global getInstance].teamList = resposeObject[TEAM_LIST];
            
            [mainVC presentViewController:teamNav animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"错误");
        }];
        
        
    }else if(indexPath.section == 0 && indexPath.row == 4)
    {
        NSDictionary * post = @{@"pageNumber":@"0"};
        NSMutableDictionary * postData = [post mutableCopy];
        
        [NetRequest POST:ALL_NOTICE parameters:postData atView:mainVC.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
            NSString *code = resposeObject[@"code"];
            if(code.integerValue == 2)
            {
                [[Global getInstance].mainVC showLoginView:YES];
                
            }else{
                    [Global getInstance].notifiList = resposeObject[NOTICE_LIST];
                
                UIStoryboard *notifiCenter = [UIStoryboard storyboardWithName:@"NewNotifiCenter" bundle:nil];
                NewNotifiCenterNavigationController * notifiNav = notifiCenter.instantiateInitialViewController;
                [mainVC presentViewController:notifiNav animated:YES completion:nil];

            }

        } failure:^(NSError *error) {
            NSLog(@"报错");
        }];
        
//        NSDictionary * post = @{};
//        NSMutableDictionary * postData = [post mutableCopy];
//        [NetRequest POST:GET_NOTIFICENTER parameters:postData atView:mainVC.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
//            
//            NSString *code = resposeObject[@"code"];
//            
//            if(code.integerValue == 2)
//            {
//                [[Global getInstance].mainVC showLoginView:YES];
//
//            }else{
//            
//            [Global getInstance].notifiList = resposeObject[NOTICE_LIST];
//            
//            UIStoryboard *notifiCenter = [UIStoryboard storyboardWithName:@"NotifiCenter" bundle:nil];
//            NotifiCenterNavigationViewController * centerNav = notifiCenter.instantiateInitialViewController;
//            [mainVC presentViewController:centerNav animated:YES completion:nil];
//            }
//            
//        } failure:^(NSError *error) {
//            NSLog(@"错误");
//        }];

    }else if (indexPath.section == 0 && indexPath.row == 3)
    {
        //加入球队;
        UIStoryboard *findTeam = [UIStoryboard storyboardWithName:@"FindTeam" bundle:nil];
        FindTeamNavigationViewController * findTeamVC = findTeam.instantiateInitialViewController;
        [mainVC presentViewController:findTeamVC animated:YES completion:nil];
    }else if(indexPath.section == 0 && indexPath.row == 1){
        
        UserData * userData = [Global getInstance].userData;
        
        if(userData.phoneNumber.length < 11 && userData.bindingMobile.length < 11)
        {
            //未取到手机号码需要弹出绑定手机界面;
            UIStoryboard *invitationStoryBoard = [UIStoryboard storyboardWithName:@"Mobile" bundle:nil];
            MobileNavigationViewController * mobileNav = invitationStoryBoard.instantiateInitialViewController;
            
            [mainVC presentViewController:mobileNav animated:YES completion:nil];
            
            return;
        }
        
        NSDictionary * post = @{};
        NSMutableDictionary * postData = [post mutableCopy];
        
        [NetRequest POST:GET_PAY_ACCOUNT parameters:postData atView:mainVC.view andHUDMessage:@"获取中..." success:^(id resposeObject) {
            NSString *code = resposeObject[@"code"];
            if(code.integerValue == 2)
            {
                [[Global getInstance].mainVC showLoginView:YES];
            }else{
                
                [Global getInstance].payAccountList = resposeObject[@"accountList"];
                
                UIStoryboard *payStory = [UIStoryboard storyboardWithName:@"PayAccount" bundle:nil];
                PayNavigationViewController * payVC = payStory.instantiateInitialViewController;
                [mainVC presentViewController:payVC animated:YES completion:nil];
                
            }
        } failure:^(NSError *error) {
            NSLog(@"获取财务失败");
        }];
        
    }else if(indexPath.section == 0 && indexPath.row == 2)
    {
        NSDictionary * post = @{};
        NSMutableDictionary * postData = [post mutableCopy];

        [NetRequest POST:GET_TEAM parameters:postData atView:mainVC.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
            
            NSString *code = resposeObject[@"code"];
            
            if(code.integerValue == 2)
            {
                
                [[Global getInstance].mainVC showLoginView:YES];
                
            }else{
                
                [Global getInstance].teamList = resposeObject[TEAM_LIST];
                NSLog(@"%@",resposeObject);
                
                UIStoryboard *invitationStoryBoard = [UIStoryboard storyboardWithName:@"Invitation" bundle:nil];
                InvitationNavigationViewController * invitationNav = invitationStoryBoard.instantiateInitialViewController;
                
                [mainVC presentViewController:invitationNav animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"错误");
        }];
        
    }else if(indexPath.section == 0 && indexPath.row == 5)
    {
        //[Global alertWithTitle:@"提示" msg:@"功能暂未开放,敬请期待下个版本"];
        //赛事;
        NSDictionary * post = @{@"pageNumber":@"0"};
        NSMutableDictionary * postData = [post mutableCopy];
        
        [NetRequest POST:ALL_COMPETITION parameters:postData atView:mainVC.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
            NSString *code = resposeObject[@"code"];
            if(code.integerValue == 2)
            {
                [[Global getInstance].mainVC showLoginView:YES];
            }else{
                
                [Global getInstance].eventList = resposeObject[@"eventList"];
                
                UIStoryboard *competitionStoryboard = [UIStoryboard storyboardWithName:@"Competition" bundle:nil];
                CompetitionNavigationViewController * competitionNav = competitionStoryboard.instantiateInitialViewController;
                
                [mainVC presentViewController:competitionNav animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            NSLog(@"报错");
        }];
        
    }else{
        
        
        [NetRequest POST:GET_ALL_RESERVATION parameters:nil atView:mainVC.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
            [Global getInstance].reservationDatas = resposeObject[@"data"];
            
            UIStoryboard *reservationStoryboard = [UIStoryboard storyboardWithName:@"Reservation" bundle:nil];
            ReservationNavigationViewController * reservationNav = reservationStoryboard.instantiateInitialViewController;
            
            [mainVC presentViewController:reservationNav animated:YES completion:nil];
        } failure:^(NSError *error) {
            NSLog(@"获取失败!");
        }];
        
        
        
    }
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.view.frame.size.height - (HEADER_H + 24))/12;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"menuCell";
    
    ListUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ListUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withHeight:(self.view.frame.size.height - (HEADER_H + 24))/12];
    }
    NSInteger index = indexPath.row + 1;
    NSString * iconName = [NSString stringWithFormat:@"menu%ld.png",(long)index];
    
    cell.logoImage.image = [UIImage imageNamed:iconName];
    
    NSString * title = titles[indexPath.row];
    
    if([title compare:@"通知"] == 0)
    {
        UserData * userData = [Global getInstance].userData;
        
        [cell.logoImage showBadgeWithStyle:WBadgeStyleNumber value:userData.messageCount animationType:WBadgeAnimTypeNone];
        cell.logoImage.badgeCenterOffset  = CGPointMake(8, -3);
        messageCell = cell;
    }
    
    cell.titleLabel.text = titles[indexPath.row];
    
    
   
    return cell;
}

- (void)updateTitleAndAvatar{
    
    
    UserData * userData = [Global getInstance].userData;
    
    label.text = userData.userName;
    
    UIImage * savedImage = [Global getInstance].avatarImage;
    if(savedImage)
    {
        imageView.image = savedImage;
    }else{
        
        if([userData.avatarUrl rangeOfString:@".png"].location != NSNotFound || [userData.avatarUrl rangeOfString:@".jpg"].location != NSNotFound)
        {
            [Global loadImageFadeIn:imageView andUrl:userData.avatarUrl  isLoadRepeat:YES];
        }else{
            imageView.image = [UIImage imageNamed:@"default_icon_head.jpg"];
        }
        
        
    }
    
    [messageCell.logoImage showBadgeWithStyle:WBadgeStyleNumber value:userData.messageCount animationType:WBadgeAnimTypeNone];
    messageCell.logoImage.badgeCenterOffset  = CGPointMake(8, -3);
}

- (void)updateMessageCount{
    if(messageCell != nil)
    {
        UserData * userData = [Global getInstance].userData;
        [messageCell.logoImage showBadgeWithStyle:WBadgeStyleNumber value:userData.messageCount animationType:WBadgeAnimTypeNone];
        messageCell.logoImage.badgeCenterOffset  = CGPointMake(8, -3);
    }
}


// 是否wifi
- (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
- (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}


@end
