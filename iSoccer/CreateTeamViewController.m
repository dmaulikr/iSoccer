//
//  CreateTeamViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/18.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "CreateTeamViewController.h"
#import "Global.h"
#import "CreateTableViewCell.h"
#import "CreateTeamInfoViewController.h"
#import "MMPickerView.h"
#import "NetConfig.h"
#import "NetDataNameConfig.h"
#import "OpenUDID.h"
#import "NSURLSessionTask+MultipartFormData.h"

@interface CreateTeamViewController ()
{
    NSArray * sectionData;
    NSArray * leftData;
    NSArray * arrowData;
    NSArray * typeData;
    NSArray * rightData;
    NSString * currentInputType;
    NSString * matchFormat;
    BOOL isCreater;
    UIImage * createTeamIcon;
    
    IBOutlet UITableView *detailTableView;
    
    CreateTableViewCell * currentCell;
    
    UIDatePicker * datePicker;
    BOOL isShowPicker;
    NSTimeInterval currentTime;
}

@end

@implementation CreateTeamViewController

- (void)viewWillAppear:(BOOL)animated{
    if([Global getInstance].isInputTeamInfo == YES)
    {
        [Global getInstance].isInputTeamInfo = NO;
        
        TeamData * data = [Global getInstance].createTeamData;
        
        switch (currentInputType.integerValue) {
            case 1:
            {
                if(data.teamName != nil)
                {
                    [currentCell setRightString:data.teamName];
                }
            }
                break;
            case 5:
            {
                if(data.teamLabel != nil)
                {
                    [currentCell setRightString:data.teamLabel];
                }
            }
                break;
            case 6:
            {
                if(data.remark != nil)
                {
                    [currentCell setRightString:data.remark];
                }
            }
                break;
            default:
                break;
        }
        
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        sectionData = @[@"4",@"3"];
        leftData = @[@[@"球队头像",@"球队名称",@"球队队长",@"成立年份"],@[@"习惯赛制",@"球队标签",@"球队描述"]];
        arrowData = @[@[@"1",@"1",@"",@"1"],@[@"1",@"1",@"1"]];
        typeData = @[@[@"0",@"1",@"2",@"3"],@[@"4",@"5",@"6"]];
    
        
        isCreater = YES;
        
        NSString * teamName = @"";
        
        NSString * userName = [Global getInstance].userData.userName;
        
        
        NSDate * nowDate = [NSDate date];
        
        NSInteger nowTime = (NSInteger)nowDate.timeIntervalSince1970;
        NSString * createTime = [NSString stringWithFormat:@"%zd",nowTime];
        
        currentTime = nowDate.timeIntervalSince1970;
        
        [Global getInstance].createTeamData.registTime = [NSString stringWithFormat:@"%zd",currentTime];
        
        NSString * time = [Global getDateByTime:createTime isSimple:YES];
        
        NSString * teamLabel = @"";
        
        NSString * teamRemark = @"";
        
        NSString * teamType = @"7人制";
        
        rightData = @[@[@"",teamName,userName,time],@[teamType,teamLabel,teamRemark]];
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    
    detailTableView.sectionFooterHeight = 1.0;
    
    isShowPicker = NO;
    
    UIView * footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    
    UIButton * createButton = [UIButton buttonWithType:UIButtonTypeSystem];
    createButton.frame = CGRectMake(0, 0, self.view.frame.size.width - 30, 48);
    
    [createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createButton setTitle:@"立即创建" forState:UIControlStateNormal];
    createButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [createButton addTarget:self action:@selector(tapedCreateHandler:) forControlEvents:UIControlEventTouchUpInside];
    createButton.backgroundColor = [UIColor blackColor];
    createButton.layer.masksToBounds = YES;
    createButton.layer.cornerRadius = 4;
    
    createButton.center = CGPointMake(footerView.frame.size.width/2, footerView.frame.size.height/2);
    
    [footerView addSubview:createButton];
    
    detailTableView.tableFooterView = footerView;
    
    [self.view addSubview:detailTableView];
    
    
    [Global getInstance].createTeamData = [[TeamData alloc]init];
    
    [Global getInstance].createTeamData.teamType = @"7人制";
    
    NSDate *senddate = [NSDate date];
    
    NSString *time = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    
    [Global getInstance].createTeamData.registTime = time;
    
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *rowString = sectionData[section];
    
    return rowString.integerValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isHead = NO;
    
    CGFloat height = 40;
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        height = 80;
        isHead = YES;
    }
    
    if(indexPath.section == 1 && indexPath.row == 2)
    {
        height = 125;
    }
    
    static NSString * identifier = @"createCell";
    
    CreateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell)
    {
        cell = [[CreateTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier andHeight:height isHead:isHead];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString * leftStr = leftData[indexPath.section][indexPath.row];
    
    
    [cell setLeftString:leftStr];
    
    if(rightData)
    {
        NSString * rightStr = rightData[indexPath.section][indexPath.row];
        
        [cell setRightString:rightStr];
        
        if(isHead)
        {
            cell.avatarIcon.image = [UIImage imageNamed:@"default_team_icon.jpg"];
        }
    }
    
    if(isCreater == NO)
    {
        cell.arrowIcon.hidden = YES;
    }else{
        NSString *showArrow = arrowData[indexPath.section][indexPath.row];
        
        if(showArrow.length > 0)
        {
            cell.arrowIcon.hidden = NO;
        }else{
            cell.arrowIcon.hidden = YES;
        }
    }
    
    return cell;
}

#pragma mark -- UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    currentCell = (CreateTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    NSString * title = leftData[indexPath.section][indexPath.row];
    NSString * defaultString = currentCell.rightLabel.text;
    
    if(indexPath.section == 0 && indexPath.row == 0 && isCreater == YES)
    {
        //上传头像;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles: @"相册",@"拍照",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
        
        
    }else if(indexPath.section == 0 && indexPath.row == 3 && isCreater == YES){
        UIView * mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        UIView * blackBg = [[UIView alloc]initWithFrame:mask.frame];
        
        blackBg.userInteractionEnabled = YES;
        blackBg.backgroundColor = [UIColor blackColor];
        blackBg.alpha = 0.4;
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDatePickerHandler:)];
        
        [blackBg addGestureRecognizer:tapGesture];
        
        [mask addSubview:blackBg];
        
        
        NSDate* minDate = [NSDate date];
        if(datePicker == nil)
        {
            datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0.0,0,self.view.frame.size.width,self.view.frame.size.height/3)];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yy-MM-dd"];
            NSString *destDateString = [dateFormatter stringFromDate:minDate];
            [currentCell setRightString:destDateString];
            
            [Global getInstance].matchInfo.matchTime = [NSString stringWithFormat:@"%.0lf",minDate.timeIntervalSince1970];
        }
        datePicker.backgroundColor = [UIColor whiteColor];
        
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        datePicker.maximumDate = minDate;
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        datePicker.locale = locale;
        
        
        [mask addSubview:datePicker];
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.view addSubview:mask];
        
        
        [self showPicker:datePicker];
    }
    else if(indexPath.section == 1 && indexPath.row == 0 && isCreater == YES)
    {
        
        NSArray * strings = @[@"5人制",@"7人制",@"8人制"];
        
        [MMPickerView showPickerViewInView:self.view
                               withStrings:strings
                               withOptions:@{MMselectedObject:currentCell.rightLabel.text}
                                completion:^(NSString *selectedString) {
                                    //selectedString is the return value which you can use as you wish
                                    [currentCell setRightString:selectedString];
                                    matchFormat = selectedString;
                                } hedden:^{
                                    [Global getInstance].createTeamData.teamType = matchFormat;
                                }];
        
    }
    else{
        
        NSString * hasArrow = arrowData[indexPath.section][indexPath.row];
        
        if(hasArrow.length > 0 && isCreater == YES)
        {
            BOOL isHeight = NO;
            if(indexPath.section == 1 && indexPath.row == 2)
            {
                isHeight = YES;
            }
            
            currentInputType = typeData[indexPath.section][indexPath.row];
            CreateTeamInfoViewController * changeVC = [[CreateTeamInfoViewController alloc]initWithTitle:title defaultString:defaultString andType:currentInputType isHighHeight:isHeight];
            
            [self.navigationController pushViewController:changeVC animated:YES];
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionData.count;
}

//设置间隔高度;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 44;
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        height = 82;
    }
    
    if(indexPath.section == 1 && indexPath.row == 2)
    {
        height = 125;
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
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - image picker delegte

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    currentCell.avatarIcon.image = savedImage;
    
    createTeamIcon = savedImage;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tapedCreateHandler:(UIButton*)sender{
    
    if([self checkInputTeamInfo] == NO)
    {
        return;
    }
    
    if(!createTeamIcon)
    {
        createTeamIcon = [UIImage imageNamed:@"default_team_icon.jpg"];
    }
    
    UIImage * upImage = [Global imageCompressForWidth:createTeamIcon targetWidth:150];
    
    UserData * userData = [Global getInstance].userData;
    
    NSString * uuid = [OpenUDID value];
    //NSString *uuid = @"81ee3ce73e83d3d4306a2d7a79958efb89679b7d";
    TeamData * teamData = [Global getInstance].createTeamData;
    
    [Global getInstance].HUD.labelText = @"创建中...";
    [self.view addSubview:[Global getInstance].HUD];
    [[Global getInstance].HUD show:YES];
    
    
    NSDictionary * postData = @{
                                TEAM_FORMAT:teamData.teamType,
                                TEAM_NAME:teamData.teamName,
                                TEAM_REMARK:teamData.remark,
                                TEAM_LABEL:teamData.teamLabel,
                                USER_ID:userData.userId,
                                REGIST_TIME:teamData.registTime,
                                UUID:uuid
                                };
    
    [NSURLSessionTask asynAtPort:CREATE_TEAM withParameters:postData multipartBuilder:^(id<XTMultipartPostBuilder> fileBody) {
        NSData *imagedata=UIImagePNGRepresentation(upImage);
        [fileBody appendFileData:imagedata fileName:@"imageName.png" parameterKey:@"images"];
    } completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dic = [Global JSONObjectWithData:data];
        
        if(dic){
            if ([dic[@"code"] integerValue]==1) {
                
                [Global alertWithTitle:@"恭喜!" msg:@"创建成功"];
                [Global getInstance].isCreateTeamSuccssed = YES;
                
                [self dismissViewControllerAnimated:YES completion:nil];
                [[Global getInstance].HUD hide:YES];
                
            }else{
                [[Global getInstance].HUD hide:YES];
                NSString *message = dic[@"msg"];
                [Global alertWithTitle:@"提示！" msg:message];
            }
        }
    }];
}


- (BOOL)checkInputTeamInfo{
    TeamData * teamData = [Global getInstance].createTeamData;
    
    if(teamData.teamName == nil || teamData.teamName.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入球队名称"];
        return NO;
    }
    
    if(teamData.teamType == nil || teamData.teamType.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入习惯赛制"];
        return NO;
    }
    
    if(teamData.teamLabel == nil)
    {
        teamData.teamLabel = @"";
    }
    
    if(teamData.remark == nil)
    {
        teamData.remark = @"";
    }
    
    return YES;
}

- (void)dateChanged:(UIDatePicker*)picker{
    NSDate *selected = [picker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    [currentCell setRightString:destDateString];
    currentTime = selected.timeIntervalSince1970;
    
    [Global getInstance].createTeamData.registTime = [NSString stringWithFormat:@"%.0lf",currentTime];
    
    [Global getInstance].matchInfo.matchTime = [NSString stringWithFormat:@"%.0lf",selected.timeIntervalSince1970];
}


- (void)hideDatePickerHandler:(UITapGestureRecognizer*)gesture{
    [self hidePicker:datePicker];
}
- (void)showPicker:(UIDatePicker*)picker{
    if(isShowPicker == YES)
        return;
    
    isShowPicker = YES;
    
    picker.center = CGPointMake(picker.center.x,self.view.frame.size.height + picker.frame.size.height/2);
    [UIView animateWithDuration:0.4 animations:^{
        picker.center = CGPointMake(picker.center.x, self.view.frame.size.height - picker.frame.size.height/2);
    }];
}
- (void)hidePicker:(UIDatePicker*)picker{
    if(isShowPicker == NO)
        return;
    
    isShowPicker = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        picker.center = CGPointMake(picker.center.x,self.view.frame.size.height + picker.frame.size.height/2);
    } completion:^(BOOL finished) {
        [picker.superview removeFromSuperview];//删除;
    }];
}


@end
