//
//  UserViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/4.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "UserViewController.h"

#import "UserTableViewCell.h"
#import "Global.h"
#import "UserData.h"
#import "ChageViewController.h"
#import "NetDataNameConfig.h"
#import "NetConfig.h"
#import "NetRequest.h"
#import "MMPickerView.h"
#import "Base64.h"
#import "NSURLSessionTask+MultipartFormData.h"
#import "OpenUDID.h"
#import <SDWebImageManager.h>
#import "ChagePasswordViewController.h"

@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation UserViewController
{
    UITableView * userTableView;
    NSArray * dataSource;
    NSArray * sectionData;
    NSArray * leftData;
    NSArray * rightData;
    NSArray * typeData;
    NSMutableArray *countriesArray;
    NSString * memberAvatarUrl;
    
    NSMutableArray *heightArray;
    NSMutableArray *weightArray;
    NSMutableArray *ageArray;
    
    NSMutableDictionary * _data;
    
    BOOL _isMe;
    BOOL _isMain;
    BOOL _isMeTeam;
    
    UserTableViewCell * currentCell;
}

- (void)viewWillAppear:(BOOL)animated{
    
    if ( self.navigationController.navigationBarHidden == YES )
    {
        [self.view setBounds:CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    else
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self updateUserData];
}

- (instancetype)initWithData:(NSMutableDictionary*)data andIsMe:(BOOL)isMe isMainEnter:(BOOL)isMain andIsMeTeam:(BOOL)isMeTeam
{
    self = [super init];
    if (self) {
        
        _data = data;
        
        _isMain = isMain;
        
        _isMe = isMe;
        
        _isMeTeam = isMeTeam;
        
        if(_isMain && _isMeTeam && _isMe == NO)
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"踢出比赛" style:UIBarButtonItemStyleDone target:self action:@selector(deleteMatchHandler:)];
        }
        
        if(isMe)
        {
            self.title = @"我";
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
        }else{
            self.title = @"球员信息";
            if(isMain == YES)
            {
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
            }
            
        }
    }
    return self;
}

- (void)updateUserData{
    
    UserData * userData;
    if(_data != nil)
    {
        
        userData = [Global setUserDataByDictionary:_data];
    }else{
        userData = [Global getInstance].userData;
    }
    NSString *age = userData.age;
    
    NSString *height = userData.height;
    
    NSString *weight = userData.weight;
    if(_isMe == NO)
    {
        memberAvatarUrl = userData.avatarUrl;
    }
    NSString * phoneNumber;
    
    if(userData.phoneNumber.length < 11)
    {
        phoneNumber = userData.bindingMobile;
    }else{
        phoneNumber = userData.phoneNumber;
    }
    rightData = @[@[@"",userData.userName,phoneNumber,userData.email],@[age,userData.sex,height,weight,userData.position,userData.nationality,userData.remark],@[@""]];
    
    [userTableView reloadData];

    if([Global getInstance].isChangeUserData == YES)
    {
        //调用接口传输数据;
        [Global getInstance].isChangeUserData = NO;
        UserData * userData = [Global getInstance].userData;
        
        NSString * type = [Global getInstance].userDataType;
        NSString * postDataType;
        NSString * changeData;
        switch (type.integerValue) {
            case 0:
                //头像;
                break;
            case 1:
                //姓名;
                postDataType = USER_NAME;
                changeData = userData.userName;
                break;
            case 2:
                //手机号码
                postDataType = PHONE_NUMBER;
                changeData = userData.phoneNumber;
                break;
            case 3:
                //电子邮箱;
                postDataType = EMAIL;
                changeData = userData.email;
                break;
            case 4:
                //年龄
                postDataType = AGE;
                changeData = userData.age;
                break;
            case 5:
                //性别
                postDataType = SEX;
                changeData = userData.sex;
                break;
            case 6:
                //身高
                postDataType = HEIGHT;
                changeData = userData.height;
                break;
            case 7:
                //体重
                postDataType = WEIGHT;
                changeData = userData.weight;
                break;
            case 8:
                //位置
                postDataType = POSITION;
                changeData = userData.position;
                break;
            case 9:
                //国籍
                postDataType = NATIONLITY;
                changeData = userData.nationality;
                break;
            case 10:
                //自我评价
                postDataType = REMARK;
                changeData = userData.remark;
                break;
            default:
                break;
        }
        
        NSDictionary *post = @{
                               postDataType: changeData,
                               PHONE_NUMBER:userData.phoneNumber
                               };
        
        NSMutableDictionary * postData = [post mutableCopy];
        [NetRequest POST:CHANGE_USER_DATA parameters:postData atView:self.view andHUDMessage:@"更改中.." success:^(id resposeObject) {
            
            NSString *code = resposeObject[@"code"];
            
            if(code.integerValue == 2)
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[Global getInstance].mainVC showLoginView:YES];
                }];
            }
    
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_isMe)
    {
        sectionData = @[@"4",@"7",@"1"];
        
       
        leftData = @[@[@"头像",@"姓名",@"手机号码",@"电子邮箱"],@[@"年龄",@"性别",@"身高",@"体重",@"位置",@"国籍",@"自我评价"],@[@"修改密码"]];
        
        
        typeData = @[@[@"0",@"1",@"2",@"3"],@[@"4",@"5",@"6",@"7",@"8",@"9",@"10"],@[@"11"]];
    }else
    {
        sectionData = @[@"4",@"7"];
        leftData = @[@[@"头像",@"姓名",@"手机号码",@"电子邮箱"],@[@"年龄",@"性别",@"身高",@"体重",@"位置",@"国籍",@"自我评价"]];
        typeData = @[@[@"0",@"1",@"2",@"3"],@[@"4",@"5",@"6",@"7",@"8",@"9",@"10"]];
    }

    
    heightArray = [[NSMutableArray alloc] init];
    
    NSInteger initHeight = 120;//初始120cm 到 200cm
    for(NSInteger i = initHeight;i <= 200;i++)
    {
        NSString * height = [NSString stringWithFormat:@"%zdcm",i];
        [heightArray addObject:height];
    }
    
    weightArray = [[NSMutableArray alloc]init];
    
    NSInteger initWeight = 50;//初始50kg 到 100kg
    
    for(NSInteger i = initWeight;i <= 100;i++)
    {
        NSString *weight = [NSString stringWithFormat:@"%zdkg",i];
        [weightArray addObject:weight];
    }
    
    ageArray = [[NSMutableArray alloc]init];
    
    NSInteger initAge = 12;//初始12岁 到 35岁;
    for(NSInteger i = initAge;i <= 35;i++)
    {
        NSString *age = [NSString stringWithFormat:@"%zd岁",i];
        [ageArray addObject:age];
    }
    
    countriesArray = [[NSMutableArray alloc] init];
    
    NSLocale *locale = [NSLocale currentLocale];
    
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    
    for (NSString *countryCode in countryArray)
        
    {
        
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        
        if([displayNameString compare:@"中国"] != 0)
        {
            [countriesArray addObject:displayNameString];
        }
    }
    
    [countriesArray insertObject:@"中国" atIndex:0];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    
    
    
    userTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    userTableView.delegate = self;
    userTableView.dataSource = self;
    
    userTableView.sectionFooterHeight = 1.0;
    if(_isMe)
    {
        UIView * footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        
        UIButton * exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        exitButton.frame = CGRectMake(0, 0, self.view.frame.size.width - 30, 48);
        
        [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        exitButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [exitButton addTarget:self action:@selector(exitHandler:) forControlEvents:UIControlEventTouchUpInside];
        exitButton.backgroundColor = [UIColor blackColor];
        exitButton.layer.masksToBounds = YES;
        exitButton.layer.cornerRadius = 4;
        
        exitButton.center = CGPointMake(footerView.frame.size.width/2, footerView.frame.size.height/2);
        
        [footerView addSubview:exitButton];
        
        userTableView.tableFooterView = footerView;
        
        userTableView.frame = CGRectMake(userTableView.frame.origin.x, userTableView.frame.origin.y, userTableView.frame.size.width, userTableView.frame.size.height - 64);
    }else{
        
        UserData * meUserData = [Global getInstance].userData;
        UserData * currentData = [Global setUserDataByDictionary:_data];
        
        if([meUserData.userId isEqualToString:currentData.userId] == NO && _isMeTeam == YES)
        {
            UIView * footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
            
            UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
            deleteButton.frame = CGRectMake(0, 0, self.view.frame.size.width - 30, 48);
            
            [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [deleteButton setTitle:@"移除队员" forState:UIControlStateNormal];
            deleteButton.titleLabel.font = [UIFont systemFontOfSize:16];
            
            [deleteButton addTarget:self action:@selector(deleteTeamHandler:) forControlEvents:UIControlEventTouchUpInside];
            deleteButton.backgroundColor = [UIColor blackColor];
            deleteButton.layer.masksToBounds = YES;
            deleteButton.layer.cornerRadius = 4;
            
            deleteButton.center = CGPointMake(footerView.frame.size.width/2, footerView.frame.size.height/2);
            
            [footerView addSubview:deleteButton];
            
            userTableView.tableFooterView = footerView;
            
            userTableView.frame = CGRectMake(userTableView.frame.origin.x, userTableView.frame.origin.y, userTableView.frame.size.width, userTableView.frame.size.height - 64);
        }
    }
    
    [self.view addSubview:userTableView];
    
}

- (void)backMainView:(UIBarButtonItem*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteTeamHandler:(UIButton*)sender{
    UserData * currentData = [Global setUserDataByDictionary:_data];
    
    NSString * teamId = [Global getInstance].currentDeleteTeamId;
    
    
    NSLog(@"teamId = %@",teamId);
    
    NSDictionary * post = @{@"teamId":teamId,@"deletedUserId":currentData.userId};
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [Global getInstance].isDeleteMatchMemberSuccessed = NO;
    
    [NetRequest POST:DELETE_MEMBER parameters:postData atView:self.view andHUDMessage:@"移除中.." success:^(id resposeObject) {
        NSLog(@"成功");
        
        [Global getInstance].isDeleteMatchMemberSuccessed = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"报错");
    }];
    
}

- (void)deleteMatchHandler:(UIBarButtonItem*)sender{
    NSLog(@"踢出比赛");
    
    NSString * currentDeleteMatchId = [Global getInstance].currentDeleteMatchId;
    
    UserData * userData = [Global setUserDataByDictionary:_data];
    
    NSString * deleteUserId = userData.userId;
    
    NSDictionary * post = @{MATCH_ID:currentDeleteMatchId,@"deletedUserId":deleteUserId};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:DELETE_MATCH_MEMBER parameters:postData atView:self.view andHUDMessage:@"踢出中.." success:^(id resposeObject) {
        //踢出成功;
        
        [Global getInstance].isDeleteMatchMemberSuccessed = YES;
        
        [self backMainView:nil];
    } failure:^(NSError *error) {
        NSLog(@"踢出失败");
    }];
    
}

- (void)exitHandler:(UIButton*)sender{
    NSLog(@"退出登录");
    
    NSDictionary * post = @{};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:EXIT_LOGIN parameters:postData atView:self.view andHUDMessage:@"退出中.." success:^(id resposeObject) {
        //[Global alertWithTitle:@"提示" msg:@"退出成功!"];
        //处理弹出登陆界面;
        
        NSString *code = resposeObject[@"code"];
        
        if(code.integerValue == 2)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [[Global getInstance].mainVC showLoginView:YES];
            }];
        }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ACCOUNT_SAVE];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:PASSWORD_SAVE];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"openId"];
        
        [Global getInstance].avatarImage = nil;
            
        [self dismissViewControllerAnimated:YES completion:^{
             [[Global getInstance].mainVC showLoginView:YES];
        }];
        }

    } failure:^(NSError *error) {
        NSLog(@"退出失败");
    }];
}


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString * numberString = sectionData[section];
    
    return numberString.integerValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL isHead = NO;

    CGFloat height = 46;
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        height = 82;
        isHead = YES;
    }
    
    if(indexPath.section == 1 && indexPath.row == 6)
    {
        height = 105;
    }
    
    static NSString * identifier = @"userCell";
    
    UserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell)
    {
        cell = [[UserTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString * leftStr = leftData[indexPath.section][indexPath.row];
    
    [cell setLeftString:leftStr];
    
    [cell setHeight:height];
    
    if(rightData)
    {
        NSString * rightStr = rightData[indexPath.section][indexPath.row];
        
        [cell setRightString:rightStr];
        
        if(isHead)
        {
            NSString * avatarUrl;
            if(_isMe == YES)
            {
                avatarUrl = [Global getInstance].userData.avatarUrl;
            }else{
                avatarUrl = memberAvatarUrl;
            }
            
            
            if([Global getInstance].avatarImage != nil && _isMe == YES)
            {
                cell.avatarIcon.image = [Global getInstance].avatarImage;
            }else{
                if([avatarUrl rangeOfString:@".png"].location != NSNotFound || [avatarUrl rangeOfString:@".jpg"].location != NSNotFound)
                {
                    [Global loadImageFadeIn:cell.avatarIcon andUrl:avatarUrl isLoadRepeat:YES];
                }else{
                    cell.avatarIcon.image = [UIImage imageNamed:@"default_icon_head.jpg"];
                }
            }
        }else{
            
        }
    }
    
    if(indexPath.section == 0 && indexPath.row == 2)
    {
        cell.arrowIcon.hidden = YES;//电话号码无法修改;
    }
    
    if(_isMe == NO)
    {
        cell.arrowIcon.hidden = YES;
    }
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionData.count;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_isMe == NO)
        return;
    
    NSString * title = leftData[indexPath.section][indexPath.row];
    NSString * defaultString = rightData[indexPath.section][indexPath.row];
    UserData * userData = [Global getInstance].userData;
    
    currentCell = (UserTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {

        NSString * avatarUrl = [Global getInstance].userData.avatarUrl;
        [[SDWebImageManager sharedManager].imageCache removeImageForKey:avatarUrl];

        
        //上传头像;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles: @"相册",@"拍照",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
        
    }else if(indexPath.section == 2 && indexPath.row == 0)
    {
        
        if([Global getInstance].isOtherLogin == YES)
        {
            [Global alertWithTitle:@"提示" msg:@"微信用户无法修改密码!"];
        }else{
            UIStoryboard * story = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
            ChagePasswordViewController *changeVC = [story instantiateViewControllerWithIdentifier:@"changepassword"];
            
            [self.navigationController pushViewController:changeVC animated:YES];
        }
        
        
        
    }else if(indexPath.section == 1 && indexPath.row == 4){
        //位置;
        NSArray *strings = @[@"全能",@"前锋",@"中锋",@"后卫",@"门将"];
        
        NSString * selectString;
        if(currentCell.rightLabel.text.length == 0)
        {
            selectString = strings[0];
            
            [Global getInstance].isChangeUserData = YES;
            [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
            
            [Global getInstance].userData.position = selectString;
            
            currentCell.rightLabel.text = selectString;
            
        }else{
            selectString = currentCell.rightLabel.text;
        }
        
        [MMPickerView showPickerViewInView:self.view withStrings:strings withOptions:@{MMselectedObject:selectString} completion:^(NSString *selectedString) {
            if([selectedString compare:userData.position] != 0)
            {
                [Global getInstance].isChangeUserData = YES;
                [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
                
                [Global getInstance].userData.position = selectedString;
            }
        } hedden:^{
            [self updateUserData];
        }];
        
        
    }else if(indexPath.section == 1 && indexPath.row == 5)
    {
        
        NSString * selectString;
        if(currentCell.rightLabel.text.length == 0)
        {
            selectString = countriesArray[0];
            
            [Global getInstance].isChangeUserData = YES;
            [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
            
            [Global getInstance].userData.nationality = selectString;
            
            currentCell.rightLabel.text = selectString;
            
        }else{
            NSInteger index = [countriesArray indexOfObject:currentCell.rightLabel.text];
            if(index < countriesArray.count)
            {
                selectString = currentCell.rightLabel.text;
            }else{
                selectString = countriesArray[0];
                
                [Global getInstance].isChangeUserData = YES;
                [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
                
                [Global getInstance].userData.nationality = selectString;
                
                currentCell.rightLabel.text = selectString;
            }

        }
        
        [MMPickerView showPickerViewInView:self.view withStrings:countriesArray withOptions:@{MMselectedObject:selectString} completion:^(NSString *selectedString) {
            if([selectedString compare:userData.nationality] != 0)
            {
                [Global getInstance].isChangeUserData = YES;
                [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
                
                [Global getInstance].userData.nationality = selectedString;
            }
        } hedden:^{
            [self updateUserData];
        }];
        
    }else if(indexPath.section == 1 && indexPath.row == 1)
    {
        
        NSArray *strings = @[@"男",@"女"];
        
        NSString * selectString;
        if(currentCell.rightLabel.text.length == 0)
        {
            selectString = strings[0];
            
            [Global getInstance].isChangeUserData = YES;
            [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
            
            [Global getInstance].userData.sex = selectString;
            
            currentCell.rightLabel.text = selectString;
            
        }else{
            selectString = currentCell.rightLabel.text;
        }
        
        [MMPickerView showPickerViewInView:self.view
                               withStrings:strings
                               withOptions:@{MMselectedObject:selectString}
                                completion:^(NSString *selectedString) {
                                    //selectedString is the return value which you can use as you wish
                                    if([selectedString compare:userData.sex] != 0)
                                    {
                                        [Global getInstance].isChangeUserData = YES;
                                        [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
                                        
                                        [Global getInstance].userData.sex = selectedString;
                                    }
                                    
                                } hedden:^{
                                    //关闭过后;
                                    [self updateUserData];
                                }];
        
        
    }else if(indexPath.section == 0 && indexPath.row == 2)
    {
        return;
    }else if(indexPath.section == 1 && indexPath.row == 0){
        
        
        NSString * selectString;
        if(currentCell.rightLabel.text.length == 0)
        {
            selectString = ageArray[ageArray.count / 2];
            
            [Global getInstance].isChangeUserData = YES;
            [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
            
            [Global getInstance].userData.age = selectString;
            
            currentCell.rightLabel.text = selectString;
            
        }else{
            
            NSInteger index = [ageArray indexOfObject:currentCell.rightLabel.text];
            if(index < ageArray.count)
            {
                selectString = currentCell.rightLabel.text;
            }else{
                selectString = ageArray[ageArray.count / 2];
                
                [Global getInstance].isChangeUserData = YES;
                [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
                
                [Global getInstance].userData.age = selectString;
                
                currentCell.rightLabel.text = selectString;
            }
        }
        
        
        [MMPickerView showPickerViewInView:self.view
                               withStrings:ageArray
                               withOptions:@{MMselectedObject:selectString}
                                completion:^(NSString *selectedString) {
                                    //selectedString is the return value which you can use as you wish
                                    if([selectedString compare:userData.age] != 0)
                                    {
                                        [Global getInstance].isChangeUserData = YES;
                                        [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
                                        
                                        [Global getInstance].userData.age = selectedString;
                                    }
                                    
                                } hedden:^{
                                    //关闭过后;
                                    [self updateUserData];
                                }];
        
        
        
    } else if(indexPath.section == 1 && indexPath.row == 2){
        NSString * selectString;
        if(currentCell.rightLabel.text.length == 0)
        {
            selectString = heightArray[heightArray.count / 2];
            
            [Global getInstance].isChangeUserData = YES;
            [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
            
            [Global getInstance].userData.height = selectString;
            
            currentCell.rightLabel.text = selectString;
            
        }else{
            NSInteger index = [heightArray indexOfObject:currentCell.rightLabel.text];
            if(index < heightArray.count)
            {
                selectString = currentCell.rightLabel.text;
            }else{
                selectString = heightArray[heightArray.count / 2];
                
                [Global getInstance].isChangeUserData = YES;
                [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
                
                [Global getInstance].userData.height = selectString;
                
                currentCell.rightLabel.text = selectString;
            }

        }
        
        
        [MMPickerView showPickerViewInView:self.view
                               withStrings:heightArray
                               withOptions:@{MMselectedObject:selectString}
                                completion:^(NSString *selectedString) {
                                    //selectedString is the return value which you can use as you wish
                                    if([selectedString compare:userData.height] != 0)
                                    {
                                        [Global getInstance].isChangeUserData = YES;
                                        [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
                                        
                                        [Global getInstance].userData.height = selectedString;
                                    }
                                    
                                } hedden:^{
                                    //关闭过后;
                                    [self updateUserData];
                                }];

    } else if(indexPath.section == 1 && indexPath.row == 3)
    {
        NSString * selectString;
        if(currentCell.rightLabel.text.length == 0)
        {
            selectString = weightArray[weightArray.count / 2];
            
            
            [Global getInstance].isChangeUserData = YES;
            [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
            
            [Global getInstance].userData.weight = selectString;
            
            currentCell.rightLabel.text = selectString;
            
        }else{
            NSInteger index = [weightArray indexOfObject:currentCell.rightLabel.text];
            if(index < weightArray.count)
            {
                selectString = currentCell.rightLabel.text;
            }else{
                selectString = weightArray[weightArray.count / 2];
                
                [Global getInstance].isChangeUserData = YES;
                [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
                
                [Global getInstance].userData.weight = selectString;
                
                currentCell.rightLabel.text = selectString;
            }

        }
        
        
        [MMPickerView showPickerViewInView:self.view
                               withStrings:weightArray
                               withOptions:@{MMselectedObject:selectString}
                                completion:^(NSString *selectedString) {
                                    //selectedString is the return value which you can use as you wish
                                    if([selectedString compare:userData.weight] != 0)
                                    {
                                        [Global getInstance].isChangeUserData = YES;
                                        [Global getInstance].userDataType = typeData[indexPath.section][indexPath.row];
                                        
                                        [Global getInstance].userData.weight = selectedString;
                                    }
                                    
                                } hedden:^{
                                    //关闭过后;
                                    [self updateUserData];
                                }];
    }else{
        
        BOOL isHeight = NO;
        
        NSLog(@"%zd,%zd",indexPath.section,indexPath.row);
        
        if(indexPath.section == 1 && indexPath.row == 6)
        {
            isHeight = YES;
        }
        NSLog(@"%zd",isHeight);
        
        ChageViewController * changeVC = [[ChageViewController alloc]initWithTitle:title defaultString:defaultString andType:typeData[indexPath.section][indexPath.row] isHighHeight:isHeight];
        
        [self.navigationController pushViewController:changeVC animated:YES];
    }
}

//设置间隔高度;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 46;
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        height = 82;
    }
    
    if(indexPath.section == 1 && indexPath.row == 6)
    {
        height = 105;
    }
    
    return height;
}


#pragma UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    
    switch (buttonIndex) {
        case 0:{
            // 相册
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        }
        case 1:{
            // 判断是否支持相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                // 拍照
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }else{
                [Global alertWithTitle:@"提示" msg:@"当前设备不支持拍照功能"];
                return;
            }
            break;
        }
        case 2:{
            return;
        }
    }
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - 保存图片至沙盒

-(void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.3);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - image picker delegte

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UserData * userData = [Global getInstance].userData;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    currentCell.avatarIcon.image = savedImage;
    
    [Global getInstance].avatarImage = savedImage;
    
    UIImage * upImage = [Global imageCompressForWidth:savedImage targetWidth:200];
    
    NSString * uuid = [OpenUDID value];
    
    NSDictionary * postData = @{
                                USER_ID:userData.userId,
                                UUID:uuid
                                       };
    
    [NSURLSessionTask asynAtPort:UP_AVATAR_ICON withParameters:postData multipartBuilder:^(id<XTMultipartPostBuilder> fileBody) {
        NSData *imagedata=UIImagePNGRepresentation(upImage);
        [fileBody appendFileData:imagedata fileName:@"imageName.png" parameterKey:@"images"];
    } completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dic = [Global JSONObjectWithData:data];
        
        if(dic){
            if ([dic[@"code"] integerValue]==1) {
                NSLog(@"上传成功");
                
            }else{
             
            }
        }
    }];

    //[self postUpImage:[self imageCompressForWidth:savedImage targetWidth:150]];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
