//
//  MainViewController.m
//  iSoccer
//
//  Created by pfg on 15/10/29.
//  Copyright © 2015年 iSoccer. All rights reserved.
//

#import "MainViewController.h"
#import "REFrostedViewController.h"
#import "LoginViewController.h"
#import "Global.h"
#import "LinusTableView.h"
#import "SoccerTableViewCell.h"

#import "NetDataNameConfig.h"

#import "CreateTeamNavigationViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "EmptyTableViewCell.h"

#import "NetConfig.h"
#import "NetRequest.h"
#import "FindTeamNavigationViewController.h"
#import <WZLBadgeImport.h>
#import "UserViewController.h"
#import "UserNavigationController.h"
#import "OpenUDID.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "PayFastNavigationViewController.h"
#import "Reachability.h"

#define TOPBAR_H (self.view.frame.size.height * 0.09)
#define CELL_TAG 200

#define AVATAR_TAG 400

#define BG_H (self.view.frame.size.height * 0.17)

#define MEMBER_A_W (self.view.frame.size.width * 0.168)
#define MEMBER_A_H (self.view.frame.size.width * 0.22)
#define MEMBER_GAP (self.view.frame.size.width * 0.04)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MainViewController ()<UIScrollViewDelegate,LinusTableViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    UIView * topBar;
    
    UILabel * teamName;
    
    UIScrollView * teamScrollView;
    NSArray * dataScoure;
    NSMutableArray * gameDatas;
    NSMutableArray * tabViews;
    NSInteger currentPage;
    AMapLocationManager * locationManager;
    AMapSearchAPI * search;
    
    UIButton * menuButton;
    UIView * whiteBg;
    NSString * pageNumber;
    BOOL isMeTeam;
    NSMutableArray * memberDetails;
    UIImageView * bgImageView;
    SoccerTableViewCell * currentCell;
    NSInteger weatherType;
    NSString * currentMatchTime;
    UIView * allMemberContainer;
}

@end

@implementation MainViewController

- (void)viewDidAppear:(BOOL)animated{

    NSString * account = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_SAVE];
    NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_SAVE];
    BOOL isLogin = [Global getInstance].isLogin;
    
    [self updateMessageCount];
    
    if(account != nil && password != nil && isLogin == NO)
    {
        currentPage = 0;
        //执行自动登陆;
        NSDictionary * post = @{
                                @"userName": account,
                                @"password": password
                                };
        
        [Global getInstance].isOtherLogin = NO;
        
        NSMutableDictionary * postData = [post mutableCopy];
        
        [NetRequest POST:LOGIN_URL parameters:postData atView:self.view andHUDMessage:@"正在登录.." success:^(id resposeObject) {
            
            [Global getInstance].isUpdate = YES;
            
            [Global getInstance].isLogin = YES;//设置已经登陆;
            
            [[Global getInstance] setGameDataByDictionary:resposeObject[@"data"]];
            
            
            [Global getInstance].userData = [Global setUserDataByDictionary:resposeObject[@"user"]];
            
            [Global getInstance].isFirstLogin = YES;
            
            [self updateMainView];
            
        } failure:^(NSError *error) {
            
            [self showLoginView:YES];
            
        }];

    }else{
        NSString * openId = [[NSUserDefaults standardUserDefaults] objectForKey:@"openId"];
        //NSString * wxOpenId = @"oN8IoswgsKt3WwIwGRWI6CRjnhIY";

        if(openId != nil && isLogin == NO)
        {
            currentPage = 0;
            //微信自动登录;
            NSString *udid = [OpenUDID value];
            
            
            NSString * getUrl = [NSString stringWithFormat:@"%@%@&uuid=%@",AUTO_LOGIN,openId,udid];
            
            
            [NetRequest GET:getUrl parameters:nil atView:self.view andHUDMessage:@"登录中." success:^(id resposeObject) {
                
                [Global getInstance].isUpdate = YES;
                
                [Global getInstance].isLogin = YES;//设置已经登陆;
                
                [Global getInstance].isFirstLogin = YES;
                
                [[Global getInstance] setGameDataByDictionary:resposeObject[@"data"]];
                
                [Global getInstance].userData = [Global setUserDataByDictionary:resposeObject[@"user"]];
                
                [Global getInstance].isOtherLogin = YES;
                [self updateMainView];
                
            } failure:^(NSError *error) {
                NSLog(@"登录失败了!");
            }];
        }else{
            //手动登陆;//或者微信登陆;
            if(isLogin == YES || [Global getInstance].isOtherLogin == YES)
            {
                [self updateMainView];
            }else{
                [self showLoginView:NO];
            }
        }
    }
}

- (void)updateMainView{
    if([Global getInstance].isUpdate == YES)
    {
        [Global getInstance].isUpdate = NO;
        [self newLoadAllTeam];
    }
    
    if([Global getInstance].isCreateMatchSuccssed == YES || [Global getInstance].isPaySuccessed == YES)
    {
        [Global getInstance].isCreateMatchSuccssed = NO;
        [Global getInstance].isPaySuccessed = NO;
        [self refreshDataSource];
    }
    
    if([Global getInstance].isCreateTeamSuccssed == YES)
    {
        [Global getInstance].isCreateTeamSuccssed = NO;
        [self refreshAllTeamDataSource];
    }
    
    if([Global getInstance].isDeleteMatchMemberSuccessed == YES)
    {
        [Global getInstance].isDeleteMatchMemberSuccessed = NO;
        [self tapHideAllMember:nil];
        [self refreshDataSource];
    }
    
    UserData * userData = [Global getInstance].userData;
    [menuButton showBadgeWithStyle:WBadgeStyleNumber value:userData.messageCount animationType:WBadgeAnimTypeNone];
    
    if(gameDatas && gameDatas.count > 0)
    {
        NSMutableDictionary * currentData = gameDatas[currentPage];
        
        NSString * type =  [currentData objectForKey:USER_TYPE];
        
        isMeTeam = NO;
        if([type compare:@"1"] == 0)
        {
            isMeTeam = YES;
        }
    }else{
        isMeTeam = NO;
    }
    
    if([Global getInstance].isFirstLogin == YES)
    {
        //添加定位信息;
        
        
//        locationManager = [[AMapLocationManager alloc]init];
//        
//        [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
//        
//        [locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//            [Global getInstance].userMatchX = location.coordinate.latitude;
//            [Global getInstance].userMatchY = location.coordinate.longitude;
//            //NSLog(@"reGeocode:%@", regeocode);
//        }];
//        
//        [self initSearch];
        
        NSMutableDictionary * postData = [NSMutableDictionary dictionary];
        
        [NetRequest POST:JUDGE_UN_CHARGE parameters:postData atView:self.view andHUDMessage:@"加载中.." success:^(id resposeObject) {

            
            NSMutableArray * datas = resposeObject[@"list"];
            
            
            [Global getInstance].isFirstLogin = NO;
            
            
            if(datas.count > 0)
            {
                NSMutableDictionary * data = datas[0];
                
                NSString * matchId = [data objectForKey:MATCH_ID];
                
                if(matchId != nil)
                {
                    [Global getInstance].currentMatchId = matchId;
                    
                    NSDictionary * post = @{MATCH_ID:matchId};
                    
                    NSMutableDictionary * postData = [post mutableCopy];
                    
                    [NetRequest POST:GET_PAY_DETAIL parameters:postData atView:self.view andHUDMessage:@"获取价格.." success:^(id resposeObject) {
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
                
            }
            
            
            NSString * userId = [Global getInstance].userData.userId;
            
            NSString *udid = [OpenUDID value];
            
            NSDictionary * versionPost = @{@"equDev":@"ios",USER_ID:userId,@"uuid":udid};
            NSMutableDictionary * postVersionData = [versionPost mutableCopy];
            
            [NetRequest POST:JUDGE_VERSION_UPDATE parameters:postVersionData atView:self.view andHUDMessage:@"加载中." success:^(id resposeObject) {
                
                NSString *code = resposeObject[@"code"];
                
                if(code.integerValue == 2)
                {
                    [self showLoginView:YES];
                }else{
                    NSMutableDictionary * versionData = resposeObject[@"version"];
                    
                    NSString * version = [versionData objectForKey:@"versionCode"];
                    
                    NSDictionary * infoDic = [[NSBundle mainBundle] infoDictionary];
                    
                    NSString * currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
                    
                    
                    if([version isEqualToString:currentVersion] == NO)
                    {
                        NSLog(@"%@,%@",version,currentVersion);
                        
                        
                        NSString *versionNum = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
                        NSString *currentVersionNum = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                        
                        NSLog(@"%@,%@",versionNum,currentVersionNum);
                        
                        if(versionNum.integerValue > currentVersionNum.integerValue)
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本:%@",version]
                                                                            message:@"是否前往App Store升级"
                                                                           delegate:self
                                                                  cancelButtonTitle:nil
                                                                  otherButtonTitles:@"稍后再说",@"现在升级",nil];
                            
                            [alert show];
                        }
                        
                    }
                    
                }
                
                
            } failure:^(NSError *error) {
                NSLog(@"检测版本出错!");
            }];
            
            
        } failure:^(NSError *error) {
            NSLog(@"哈哈哈");
        }];
    }
    
    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/zu-qiu-guan-jia/id1081270914?l=en&mt=8"]];
    }
}

- (void)updateMessageCount{
    UserData * userData = [Global getInstance].userData;
    [menuButton showBadgeWithStyle:WBadgeStyleNumber value:userData.messageCount animationType:WBadgeAnimTypeNone];
}

- (void)newLoadAllTeam{
    gameDatas = [Global getInstance].gameDatas;

    CGPoint oldPoint = CGPointMake(0, 0);
    if(tabViews.count > 0)
    {
        LinusTableView *oldTableView = tabViews[currentPage];
        oldPoint =  oldTableView.tableView.contentOffset;
    }

    for(NSInteger i = 0;i < tabViews.count;i++)
    {
        LinusTableView * tabelView = tabViews[i];
        [tabelView removeFromSuperview];
    }
    
    [tabViews removeAllObjects];
    
    
    teamScrollView.contentSize = CGSizeMake(teamScrollView.frame.size.width * gameDatas.count, teamScrollView.frame.size.height);
    
    
    if(gameDatas.count == 0)
    {
        UIStoryboard *findTeam = [UIStoryboard storyboardWithName:@"FindTeam" bundle:nil];
        FindTeamNavigationViewController * findTeamVC = findTeam.instantiateInitialViewController;
        [self presentViewController:findTeamVC animated:YES completion:nil];
        //未加入任何球队,也未创建过任何球队.
        return;
    }
    
    NSMutableDictionary * currentData = gameDatas[currentPage];
    
    NSString * type =  [currentData objectForKey:USER_TYPE];
    
    [Global getInstance].currentTeamId = [currentData objectForKey:TEAM_ID];
    BOOL isMe = NO;
    if([type compare:@"1"] == 0)
    {
        isMe = YES;
    }
    [Global getInstance].isMeTeam = isMe;
    
    NSString * teamNameStr = [currentData objectForKey:@"teamName"];
    
    teamName.text = teamNameStr;
    
    NSMutableArray * list = [currentData objectForKey:MATCH_LIST];
    if(list.count > 0)
    {
        pageNumber = [((NSMutableDictionary*)list[list.count - 1]) objectForKey:@"pageNumber"];
        NSLog(@"初始化，得到pageNumber = %@",pageNumber);
    }
    
    if(gameDatas)
    {
        
        //NSLog(@"%@",gameDatas);
        for(NSInteger i = 0;i < gameDatas.count;i++)
        {
            LinusTableView * tableView = [[LinusTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 14, self.view.frame.size.height - BG_H)];
            
            tableView.pageEnable = YES;
            
            tableView.center = CGPointMake(teamScrollView.frame.size.width/2 + teamScrollView.frame.size.width * i, teamScrollView.frame.size.height/2);
            
            tableView.delegate = self;
            
            [teamScrollView addSubview:tableView];
            
            [tabViews addObject:tableView];
            
            tableView.tableView.tag = CELL_TAG + i;
            
        }
        
        LinusTableView *newTableView = tabViews[currentPage];
        if(newTableView)
        {
            newTableView.tableView.contentOffset = oldPoint;
        }
    }

    [self scrollViewEndScroll:0];
}

- (void)showLoginView:(BOOL)isAnimation{
    
    currentPage = 0;
    UIStoryboard *loginAndRegister = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
    LoginViewController *lrVC = loginAndRegister.instantiateInitialViewController;
    [Global getInstance].loginView = lrVC;
    [self presentViewController:lrVC animated:isAnimation completion:nil];
}


/* 初始化search. */
- (void)initSearch
{
    [AMapSearchServices sharedServices].apiKey = @"d8d256064d8f502d8e209102074ea045";
    search = [[AMapSearchAPI alloc] init];
}

- (void)searchForecastWeather
{
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city                      = @"北京";
    request.type                      = AMapWeatherTypeForecast;
    
    [search AMapWeatherSearch:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册地图appkey
    [AMapLocationServices sharedServices].apiKey = @"d8d256064d8f502d8e209102074ea045";
    
    weatherType = -1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;//禁用滚动视图自动适应;
    
    tabViews = [NSMutableArray array];
    
    dataScoure = @[[UIColor whiteColor],[UIColor lightGrayColor],[UIColor grayColor]];
    
    
//    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];//添加屏幕滑动显示菜单栏功能;
    
    self.view.backgroundColor = [UIColor blackColor];
    //自定义导航栏足球按钮.
    topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), TOPBAR_H)];
    
    teamName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, TOPBAR_H)];
    teamName.textAlignment = NSTextAlignmentCenter;
    
    teamName.textColor = [UIColor whiteColor];
    
    teamName.text = @"";
    teamName.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    
    teamName.center = CGPointMake(self.view.frame.size.width/2, TOPBAR_H/2);
    
    [topBar addSubview:teamName];
    
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.1 , self.view.frame.size.width * 0.1);
    
    menuButton.center = CGPointMake(menuButton.frame.size.width / 2 + 12, topBar.frame.size.height/2);
    
    [menuButton setImage:[UIImage imageNamed:@"menu_btn.png"] forState:UIControlStateNormal];
    
    [menuButton addTarget:self action:@selector(tapedButtonShowMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [topBar addSubview:menuButton];
    
    
    UIButton * createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    createButton.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.1, self.view.frame.size.width * 0.1);
    createButton.center = CGPointMake(self.view.frame.size.width - createButton.frame.size.width/2 - 12, topBar.frame.size.height/2);
    [createButton setImage:[UIImage imageNamed:@"create_btn.png"] forState:UIControlStateNormal];
    
    [createButton addTarget:self action:@selector(tapedButtonCreateGame:) forControlEvents:UIControlEventTouchUpInside];
    
    [topBar addSubview:createButton];
    
    
    [self.view addSubview:topBar];
    
    
    //队伍横向滚动视图
    teamScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20 + TOPBAR_H, self.view.frame.size.width, self.view.frame.size.height - self.view.frame.size.height * 0.163)];
    
    
    teamScrollView.contentSize = CGSizeMake(teamScrollView.frame.size.width * 3, teamScrollView.frame.size.height);
    
    teamScrollView.backgroundColor = [UIColor clearColor];
    
    teamScrollView.pagingEnabled = YES;
    
    [teamScrollView setShowsHorizontalScrollIndicator:YES];//设置横向滑动;
    
    teamScrollView.delegate = self;
    
//    UIImageView * uploadBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 24)];
//    uploadBar.image = [UIImage imageNamed:@"up_load_bar.png"];
//    
//    uploadBar.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - uploadBar.frame.size.height/2 - 4);
//    
//    [self.view addSubview:uploadBar];
    
    
    //加载队伍新闻内容;
    
    for(NSInteger i = 0;i < 1;i++)
    {
        LinusTableView * tableView = [[LinusTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 14, self.view.frame.size.height - BG_H)];
        
        tableView.pageEnable = YES;
        
        tableView.center = CGPointMake(teamScrollView.frame.size.width/2 + teamScrollView.frame.size.width * i, tableView.frame.size.height/2);
        
        tableView.delegate = self;
        
        [teamScrollView addSubview:tableView];
        
        [tabViews addObject:tableView];
    }
    
    [self.view addSubview:teamScrollView];//先隐藏;
    
}

-(void)tapedButtonCreateGame:(UIButton*)sender{
    //创建比赛获球队;
    if(isMeTeam == YES)
    {
        UIStoryboard *loginAndRegister = [UIStoryboard storyboardWithName:@"CreateTeamAndMatch" bundle:nil];
        CreateTeamNavigationViewController * teamCreateNav = loginAndRegister.instantiateInitialViewController;
        
        [self presentViewController:teamCreateNav animated:YES completion:nil];
    }else{
        [Global alertWithTitle:@"提示" msg:@"您不是本队的队长无法创建比赛!"];
    }
    
 
}

- (void)tapedButtonShowMenu:(UIButton*)sender
{
    if([self IsEnable3G] == NO && [self IsEnableWIFI] == NO)
    {
        [Global alertWithTitle:@"提示" msg:@"您似乎与网络断开"];
        
        [self showLoginView:YES];
        return;
    }
    
    [self.frostedViewController presentMenuViewController];
}


- (void)uploadDataSource{
    NSDictionary * post = @{TEAM_ID:[Global getInstance].currentTeamId,@"pageNumber":pageNumber};
    
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:UPLOAD_PAGE parameters:postData atView:self.view andHUDMessage:@"加载中.." success:^(id resposeObject) {
        NSMutableArray * list = resposeObject[MATCH_LIST];
        
        NSMutableDictionary * currentData = gameDatas[currentPage];
        NSMutableArray * currentList = [currentData objectForKey:MATCH_LIST];
        
        [currentList addObjectsFromArray:list];
        
        [currentData setValue:currentList forKey:MATCH_LIST];
        
        [[Global getInstance].gameDatas replaceObjectAtIndex:currentPage withObject:currentData];
        
        LinusTableView * currentTableView = tabViews[currentPage];
        
        CGPoint oldPoint = currentTableView.tableView.contentOffset;
        
        [currentTableView reloadData];
        
        currentTableView.tableView.contentOffset = oldPoint;
        
        if(list.count > 0)
        {
            pageNumber = [((NSMutableDictionary*)list[list.count - 1]) objectForKey:@"pageNumber"];
            NSLog(@"新加载，得到pageNumber = %@",pageNumber);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"错误");
    }];
}

- (void)refreshAllTeamDataSource{
    
    NSDictionary * post = @{};
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:REFRESH_TEAM_ALL_INFO parameters:postData atView:self.view andHUDMessage:@"刷新中.." success:^(id resposeObject) {
        
        
        NSString *code = resposeObject[@"code"];
        
        if(code.integerValue == 2)
        {
            [self showLoginView:YES];
        }else{
            NSMutableArray * teamList = resposeObject[TEAM_LIST];
            
            [Global getInstance].gameDatas = teamList;
            
            [self newLoadAllTeam];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"刷新失败");
    }];
}

- (void)refreshDataSource{
    
    NSDictionary * post = @{TEAM_ID:[Global getInstance].currentTeamId};
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    LinusTableView * tableView = tabViews[currentPage];
    
    [NetRequest POST:REFRESH_TEAM_MAIN_INFO parameters:postData atView:self.view andHUDMessage:@"刷新中.." success:^(id resposeObject) {
        
        NSString *code = resposeObject[@"code"];
        
        if(code.integerValue == 2)
        {
            [self showLoginView:YES];
        }else{
            NSMutableArray * matchList = resposeObject[MATCH_LIST];
            NSMutableDictionary * currentData = gameDatas[currentPage];
            [currentData setValue:matchList forKey:MATCH_LIST];
        
            [[Global getInstance].gameDatas replaceObjectAtIndex:currentPage withObject:currentData];
            NSMutableArray * list = [currentData objectForKey:MATCH_LIST];
            if(list.count > 0)
            {
               pageNumber = [((NSMutableDictionary*)list[list.count - 1]) objectForKey:@"pageNumber"];
            }
        
            [tableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"刷新失败");
    }];
    
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    [self.frostedViewController panGestureRecognized:sender];
    
}

#pragma mark -- LinusTableViewDelegate

- (void)scrollViewEndScroll:(NSInteger)pageIndex{
    
    if(gameDatas.count < 1)
    {
        return;
    }
    
    LinusTableView * tableView = tabViews[currentPage];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageIndex inSection:0];
    
    currentCell = (SoccerTableViewCell*)[tableView.tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableDictionary * currentData = gameDatas[currentPage];
    
    NSMutableArray * matchList = [currentData objectForKey:MATCH_LIST];
    
    if(matchList.count == 0)
    {
        return;
    }
    NSMutableDictionary * match = matchList[pageIndex];
    
    NSString * matchX = [match objectForKey:@"matchX"];
    NSString * matchY = [match objectForKey:@"matchY"];
    NSString * matchTime = [match objectForKey:MATCH_TIME];
    
    NSString * matchId = [match objectForKey:MATCH_ID];
    
    CLLocationCoordinate2D to;
    
    to.latitude = matchX.floatValue;
    
    to.longitude = matchY.floatValue;
    
    CLLocation * location = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    [self getCity:location andTime:matchTime andId:matchId];
    
}

- (void)getCity:(CLLocation*)location andTime:(NSString*)time andId:(NSString*)matchId
{
    CLGeocoder *geo =[[CLGeocoder alloc]init];
    
    [geo reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            if(city == nil)
            {
                city = @"成都";
            }
            [self getWeatherBy:city andTime:time andId:matchId];
        }
    }];
}

- (void)getWeatherBy:(NSString*)cityName andTime:(NSString*)time andId:(NSString*)matchId;
{
    NSDictionary * post = @{@"cityName":cityName,@"date":time,MATCH_ID:matchId};
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:WEATHER_GET parameters:postData atView:nil andHUDMessage:nil success:^(id resposeObject) {
        
        NSString * code = resposeObject[@"code"];
        
        if(code.integerValue == 3)
        {
            LinusTableView * tableView = tabViews[currentPage];
            
            [self scrollViewEndScroll:tableView.currentPage];
            
        }else{
            NSString * weather = resposeObject[@"weather"];
            
            if(currentCell == nil)
            {
                LinusTableView * tableView = tabViews[currentPage];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                
                currentCell = (SoccerTableViewCell*)[tableView.tableView cellForRowAtIndexPath:indexPath];
            }
            NSMutableDictionary * currentData = gameDatas[currentPage];
            
            NSMutableArray * matchList = [currentData objectForKey:MATCH_LIST];
            
            if(matchList.count > 0)
            {
                currentCell.weatherLabel.text = weather;
                [self changeBgColor:weather];
            }
            
        }
    } failure:^(NSError *error) {
        NSLog(@"获取失败！");
    }];
}

- (void)upload{
    
    
    NSMutableDictionary * matchList = gameDatas[currentPage];
    
    NSMutableArray * teamDatas = [matchList objectForKey:MATCH_LIST];
    
    LinusTableView * tableView = tabViews[currentPage];
    
    if(teamDatas.count > 0)
    {
        [self uploadDataSource];
    }
    [tableView endUpload];
}

- (void)refresh{
    LinusTableView * tableView = tabViews[currentPage];
    
    [self refreshDataSource];
    
    [tableView endRefresh];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height - self.view.frame.size.height * 0.163;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = tableView.tag - CELL_TAG;
    NSMutableDictionary * matchList = gameDatas[index];
    NSMutableArray * teamDatas = [matchList objectForKey:MATCH_LIST];

    NSString * type =  [matchList objectForKey:USER_TYPE];
    BOOL isMe = NO;
    if([type compare:@"1"] == 0)
    {
        isMe = YES;
    }
    if(teamDatas.count == 0)
    {
        static NSString *emptyIdent = @"emptyCell";
        //显示图片;
        EmptyTableViewCell * emptyCell = [tableView dequeueReusableCellWithIdentifier:emptyIdent];
        if(!emptyCell)
        {
            emptyCell = [[EmptyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:emptyIdent];
        }
        [emptyCell setCreateButtonVisible:(!isMe)];
        
        return emptyCell;
        
    }
    
    NSMutableDictionary *  dic = [teamDatas objectAtIndex:indexPath.row];
    
    static NSString * identifier = @"mainCell";
    
    SoccerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[SoccerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - BG_H);
    
    if(!teamDatas)
        [cell setViewData:@{} andIsMe:NO];
    else
        [cell setViewData:dic andIsMe:isMe];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(gameDatas == nil)
    {
        return 0;
    }
    
    NSInteger index = tableView.tag - CELL_TAG;
    
    if(index < 0)
    {
        return 0;
    }
    
    NSMutableDictionary * matchList = gameDatas[index];
    
    NSMutableArray * teamDatas = [matchList objectForKey:MATCH_LIST];
    
    if(teamDatas.count == 0)
    {
        return 1;
    }
    
    return teamDatas.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"1");
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    gameDatas = [Global getInstance].gameDatas;
    
    if(gameDatas.count == 0)
        return;
    
    currentPage = (NSInteger)round(scrollView.contentOffset.x / CGRectGetWidth(self.view.frame));
    
    NSMutableDictionary * currentData = gameDatas[currentPage];
    
    NSString * type =  [currentData objectForKey:USER_TYPE];
    
    if([type compare:@"1"] == 0)
    {
        isMeTeam = YES;
        [Global getInstance].isMeTeam = YES;
    }else{
        [Global getInstance].isMeTeam = NO;
        isMeTeam = NO;
    }
    
    [Global getInstance].currentTeamId = [currentData objectForKey:TEAM_ID];
    
    NSString * teamNameStr = [currentData objectForKey:TEAM_NAME];
    teamName.text = teamNameStr;
    
    NSMutableArray * list = [currentData objectForKey:MATCH_LIST];
    if(list.count > 0)
    {
        pageNumber = [((NSMutableDictionary*)list[list.count - 1]) objectForKey:@"pageNumber"];
        NSLog(@"左右滑动，得到pageNumber = %@",pageNumber);
    }
    
    LinusTableView * tableView = tabViews[currentPage];
    
    [self scrollViewEndScroll:tableView.currentPage];
    
}

- (void)showRemarks:(NSString*)remarks{
    //显示文本备注;
    UIView * maskView = [[UIView alloc]initWithFrame:self.view.frame];
    
    maskView.backgroundColor = [UIColor blackColor];
    
    maskView.alpha = 0.4;
    
    UIView * remarksContainer = [[UIView alloc]initWithFrame:self.view.frame];
    
    [remarksContainer addSubview:maskView];
    
    CGFloat height = MEMBER_A_H;
    
    if(whiteBg != nil)
    {
        whiteBg.frame = CGRectMake(0, 0, self.view.frame.size.width - 40, height + 30);
    }else{
        whiteBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, height + MEMBER_GAP * 2)];
    }
    
    whiteBg.backgroundColor = [UIColor whiteColor];
    
    whiteBg.layer.masksToBounds = YES;
    whiteBg.layer.cornerRadius = 6;
    
    whiteBg.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    UILabel * remarksLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, whiteBg.frame.size.width, whiteBg.frame.size.height)];
    
    remarksLabel.text = remarks;
    
    remarksLabel.numberOfLines = 0;
    
    remarksLabel.textColor = [UIColor lightGrayColor];
    
    remarksLabel.font = [UIFont systemFontOfSize:16];
    
    remarksLabel.textAlignment = NSTextAlignmentCenter;
    
    [whiteBg addSubview:remarksLabel];
    
    [remarksContainer addSubview:whiteBg];
    
    [self.view addSubview:remarksContainer];
    
    whiteBg.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.4 animations:^{
        whiteBg.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    
    UITapGestureRecognizer * tapHide = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHideRemarks:)];
    
    [remarksContainer addGestureRecognizer:tapHide];
}

- (void)tapHideRemarks:(UITapGestureRecognizer*)tapGesutre
{
    [UIView animateWithDuration:0.4 animations:^{
        whiteBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [allMemberContainer removeFromSuperview];
        [whiteBg removeFromSuperview];
        whiteBg = nil;
        
        [tapGesutre.view removeFromSuperview];
    }];
}

- (void)showAllMemberByData:(NSMutableArray*)data andTime:(NSString *)time{
    //显示所有成员;
    
    if(data.count == 0)
        return;
    
    currentMatchTime = time;
    
    memberDetails = data;
    
    
    
    if(!allMemberContainer)
    {
        UIView * maskView = [[UIView alloc]initWithFrame:self.view.frame];
        
        maskView.backgroundColor = [UIColor blackColor];
        
        maskView.alpha = 0.4;
        
        allMemberContainer = [[UIView alloc]initWithFrame:self.view.frame];
        
        [allMemberContainer addSubview:maskView];
    }
    
    
    NSInteger num = data.count / 4;
    
    if(data.count % 4 > 0)
    {
        num += 1;
    }
    
    CGFloat height = num * MEMBER_A_H + (num - 1) * MEMBER_GAP;
    
    if(whiteBg != nil)
    {
        whiteBg.frame = CGRectMake(0, 0, self.view.frame.size.width - 40, height + 30);
    }else{
        whiteBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, height + MEMBER_GAP * 2)];
    }
    
    whiteBg.backgroundColor = [UIColor whiteColor];
    
    whiteBg.layer.masksToBounds = YES;
    whiteBg.layer.cornerRadius = 6;
    
    whiteBg.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    [allMemberContainer addSubview:whiteBg];
    
    for(NSInteger i = 0;i < data.count;i++)
    {
        NSMutableDictionary * userData = data[i];
        
        NSString * url = [userData objectForKey:@"photo"];
        //NSString * name = [userData objectForKey:@"nickName"];
        NSString * matchCount = [userData objectForKey:MATCH_COUNT];
        
        matchCount = [NSString stringWithFormat:@"参赛%@",matchCount];
        
        UIView * userAvatar = [self createAvatarByUrl:url andName:matchCount];
        
        userAvatar.tag = AVATAR_TAG + i;
        
        userAvatar.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * avatarTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarShowDetail:)];
        
        [userAvatar addGestureRecognizer:avatarTapGesture];
        
        NSInteger row = i % 4;
        
        NSInteger col = i / 4.0;
        
        userAvatar.center = CGPointMake(MEMBER_A_W /2 + MEMBER_GAP + row * MEMBER_A_W + row * MEMBER_GAP, MEMBER_A_H/2 + MEMBER_GAP + col * MEMBER_A_H + col * MEMBER_GAP);
        
        [whiteBg addSubview:userAvatar];
    }
    
    
    [self.view addSubview:allMemberContainer];
    
    whiteBg.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.4 animations:^{
        whiteBg.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    
    UITapGestureRecognizer * tapHide = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHideAllMember:)];
    
    [allMemberContainer addGestureRecognizer:tapHide];
}

//显示个人资料;

- (void)tapAvatarShowDetail:(UITapGestureRecognizer*)gesture{
    NSInteger index = gesture.view.tag - AVATAR_TAG;
    
    NSMutableDictionary * memberData = memberDetails[index];
    
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval currentTime =[date timeIntervalSince1970];
    
    BOOL isShowDelete = NO;
    
    //判断是否是自己队伍以及时间
    if(isMeTeam)
    {
        if(currentMatchTime.integerValue - currentTime > 1800)
        {
            isShowDelete = YES;
        }
    }
    
    UserViewController * userVC = [[UserViewController alloc]initWithData:memberData andIsMe:NO isMainEnter:YES andIsMeTeam:isShowDelete];
    UserNavigationController *userNav = [[UserNavigationController alloc] initWithRootViewController:userVC];
    
    [self presentViewController:userNav animated:YES completion:nil];
 
}

- (UIView*)createAvatarByUrl:(NSString*)url andName:(NSString*)name{
    
    UIView * container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MEMBER_A_W, MEMBER_A_H)];
    container.backgroundColor = [UIColor whiteColor];
    
    container.layer.masksToBounds = YES;
    container.layer.cornerRadius = 4;
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, MEMBER_A_W - 4, MEMBER_A_W - 4)];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 4;
    
    imageView.image = [UIImage imageNamed:@"default_icon_head.jpg"];
    
    if(url.length > 0)
    {
        [Global loadImageFadeIn:imageView andUrl:url isLoadRepeat:YES];
    }
    [container addSubview:imageView];
    
    UILabel * nameText = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height, container.frame.size.width, MEMBER_A_H - imageView.frame.size.height)];
    
    nameText.text = name;
    
    nameText.textColor = [UIColor lightGrayColor];
    
    nameText.font = [UIFont systemFontOfSize:12];
    
    nameText.textAlignment = NSTextAlignmentCenter;
    
    [container addSubview:nameText];
    
    return container;
    
}

- (void)tapHideAllMember:(UITapGestureRecognizer*)gesture{
    
    [UIView animateWithDuration:0.4 animations:^{
        whiteBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [allMemberContainer removeFromSuperview];
        [whiteBg removeFromSuperview];
        whiteBg = nil;
    }];
}

- (void)changeBgColor:(NSString*)string{
    
    UIColor * bgColor;
    
    if(bgImageView == nil)
    {
        bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.47)];
    }
    
    NSInteger newType = 0;
    
    if([string hasSuffix:@"雨"] || [string hasSuffix:@"雪"] || [string hasSuffix:@"阴"]){
        //阴天;
        bgColor = UIColorFromRGB(0x040000);
        UIImage * image = [UIImage imageNamed:@"weather_rain.jpg"];
        bgImageView.image = image;
        newType = 0;
    }
    
    if([string hasSuffix:@"云"])
    {
        //多云;
        bgColor = UIColorFromRGB(0x438dcf);
        UIImage * image = [UIImage imageNamed:@"weather_cloud.jpg"];
        bgImageView.image = image;
        newType = 1;
    }
    
    if([string hasSuffix:@"晴"])
    {
        //晴天
        bgColor = UIColorFromRGB(0x438dcf);
        UIImage * image = [UIImage imageNamed:@"weather_sun.jpg"];
        bgImageView.image = image;
        newType = 2;
    }
    
    
    if(weatherType == newType)
    {
        return;
    }
    
    weatherType = newType;
    
    bgImageView.alpha = 0;
    
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.view.backgroundColor = bgColor;
        bgImageView.alpha = 1.0;
    }];
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
