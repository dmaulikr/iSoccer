//
//  TeamDetailViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/14.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "TeamDetailViewController.h"

#import "UserTableViewCell.h"
#import "NetDataNameConfig.h"
#import "Global.h"
#import "ChageTeamInfoViewController.h"
#import "OpenUDID.h"
#import "NetConfig.h"
#import "NetRequest.h"
#import "MMPickerView.h"
#import "NSURLSessionTask+MultipartFormData.h"

@interface TeamDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView * detailTableView;
    NSArray * sectionData;
    NSArray * leftData;
    NSArray * rightData;
    
    NSArray *arrowData;
    NSArray *typeData;
    
    NSString * teamIconUrl;
    BOOL isCreater;
    
    NSString * teamID;
    
    
    UserTableViewCell * currentCell;
    
    NSString * matchFormat;
    UIDatePicker * datePicker;
    
    NSString * createTime;
    NSString * registerTime;
    BOOL isShowPicker;
}

@end

@implementation TeamDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    if([Global getInstance].isUpdateCreateTeamDetail == YES)
    {
        [Global getInstance].isUpdateCreateTeamDetail = NO;
        
        [Global getInstance].isUpdateCreateTeamMessage = YES;
        
        NSString * type = [Global getInstance].teamDataType;
        NSString * postType;
    
        NSMutableDictionary * _infoData = [Global getInstance].teamMessageData;
    
        switch (type.integerValue) {
                
            case 1:
                postType = TEAM_NAME;
                break;
            case 5:
                //标签;
                postType = TEAM_LABEL;
                break;
            case 6:
                //描述
                postType = TEAM_REMARK;
                break;
            default:
                break;
        }
    
        NSString * value = [_infoData objectForKey:postType];
    
        NSDictionary * post = @{TEAM_ID:teamID,postType:value};
        
        [currentCell setRightString:value];
        
        NSMutableDictionary * postData = [post mutableCopy];
    
        [NetRequest POST:UP_TEAM_DETAIL parameters:postData atView:self.view andHUDMessage:@"更新中.." success:^(id resposeObject) {
            NSString *code = resposeObject[@"code"];
            
            if(code.integerValue == 2)
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[Global getInstance].mainVC showLoginView:YES];
                }];
            }
            
            if(code.integerValue == 1)
            {
                [Global getInstance].isUpdateCreateTeamMessage = YES;
                [Global getInstance].isUpdateCreateTeamList = YES;
                
                if(postType == TEAM_NAME)
                {
                    [Global getInstance].isCreateTeamSuccssed = YES;
                }
                
            }
            
        } failure:^(NSError *error) {
            NSLog(@"更新失败");
        }];
    }
}
- (instancetype)initWithData:(NSMutableDictionary*)data andType:(NSString*)type
{
    self = [super init];
    if (self) {
        
        [Global getInstance].teamMessageData = data;
        
        self.title = @"球队详情";
        sectionData = @[@"4",@"3"];
        leftData = @[@[@"球队头像",@"球队名称",@"球队队长",@"成立年份"],@[@"习惯赛制",@"球队标签",@"球队描述"]];
        arrowData = @[@[@"1",@"1",@"",@"1"],@[@"1",@"1",@"1"]];
        typeData = @[@[@"0",@"1",@"2",@"3"],@[@"4",@"5",@"6"]];
        
        if([type compare:@"1"] == 0)
        {
            isCreater = YES;
        }else{
            isCreater = NO;
        }
        
        
        
        NSString * teamName = [data objectForKey:GAME_TEAM_A];
        
        NSString * userName = [data objectForKey:USER_NAME];
        
        registerTime = [data objectForKey:REGIST_TIME];
        
        NSString * time = [Global getDateByTime:registerTime isSimple:YES];
        
        NSString * teamLabel = [data objectForKey:TEAM_LABEL];
        
        NSString * teamRemark = [data objectForKey:TEAM_REMARK];
        
        NSString * teamType = [data objectForKey:TEAM_FORMAT];
        
        teamID = [data objectForKey:TEAM_ID];
        
        rightData = @[@[@"",teamName,userName,time],@[teamType,teamLabel,teamRemark]];
        
        teamIconUrl = [data objectForKey:TEAM_LOGO];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    
    isShowPicker = NO;
    detailTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    
    detailTableView.sectionFooterHeight = 1.0;
    
    [self.view addSubview:detailTableView];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *rowString = sectionData[section];
    
    return rowString.integerValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isHead = NO;
    
    CGFloat height = 46;
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        height = 82;
        isHead = YES;
    }
    
    if(indexPath.section == 1 && indexPath.row == 2)
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
            [Global loadImageFadeIn:cell.avatarIcon andUrl:teamIconUrl isLoadRepeat:YES];
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
    NSString * title = leftData[indexPath.section][indexPath.row];
    NSString * defaultString = rightData[indexPath.section][indexPath.row];
    currentCell = (UserTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
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
        
        
    }else if(indexPath.section == 0 && indexPath.row == 3 && isCreater == YES)
    {
        UIView * mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        UIView * blackBg = [[UIView alloc]initWithFrame:mask.frame];
        
        blackBg.userInteractionEnabled = YES;
        blackBg.backgroundColor = [UIColor blackColor];
        blackBg.alpha = 0.4;
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDatePickerHandler:)];
        
        [blackBg addGestureRecognizer:tapGesture];
        
        [mask addSubview:blackBg];
        
        
        NSDate* minDate = [NSDate dateWithTimeIntervalSince1970:registerTime.integerValue];
        if(datePicker == nil)
        {
            datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0.0,0,self.view.frame.size.width,self.view.frame.size.height/3)];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yy-MM-dd"];
            NSString *destDateString = [dateFormatter stringFromDate:minDate];
            [currentCell setRightString:destDateString];
            
        }
        datePicker.backgroundColor = [UIColor whiteColor];
        
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        datePicker.locale = locale;
        datePicker.maximumDate = [NSDate date];
        
        [mask addSubview:datePicker];
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.view addSubview:mask];
        
        [self showPicker:datePicker];    }
    else if(indexPath.section == 1 && indexPath.row == 0 && isCreater == YES)
    {
        
        NSArray * strings = @[@"5人制",@"7人制",@"8人制"];
        [currentCell setRightString:@"5人制"];
        
        [MMPickerView showPickerViewInView:self.view
                               withStrings:strings
                               withOptions:nil
                                completion:^(NSString *selectedString) {
                                    //selectedString is the return value which you can use as you wish
                                    [currentCell setRightString:selectedString];
                                    matchFormat = selectedString;
                                } hedden:^{
                                    //后调用接口;
                                    NSString * postType = TEAM_FORMAT;
                                    NSDictionary * post = @{TEAM_ID:teamID,postType:matchFormat};
                                    
                                    NSMutableDictionary * postData = [post mutableCopy];
                                    
                                    [NetRequest POST:UP_TEAM_DETAIL parameters:postData atView:self.view andHUDMessage:@"更新中.." success:^(id resposeObject) {
                                        NSString *code = resposeObject[@"code"];
                                        
                                        if(code.integerValue == 2)
                                        {
                                            [self dismissViewControllerAnimated:YES completion:^{
                                                [[Global getInstance].mainVC showLoginView:YES];
                                            }];
                                        }
                                    } failure:^(NSError *error) {
                                        NSLog(@"更新失败");
                                    }];
                                }];

    }
    else{
        
        NSString * hasArrow = arrowData[indexPath.section][indexPath.row];
        
        if(hasArrow.length > 0 && isCreater == YES)
        {
            ChageTeamInfoViewController * changeVC = [[ChageTeamInfoViewController alloc]initWithTitle:title defaultString:defaultString andType:typeData[indexPath.section][indexPath.row]];
            
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
    
    CGFloat height = 40;
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        height = 80;
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
    UserData * userData = [Global getInstance].userData;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    currentCell.avatarIcon.image = savedImage;
    
    [Global getInstance].teamImage = savedImage;
    
    UIImage * upImage = [Global imageCompressForWidth:savedImage targetWidth:150];
    
    NSString * uuid = [OpenUDID value];
    
    NSDictionary * postData = @{
                                TEAM_ID:teamID,
                                USER_ID:userData.userId,
                                UUID:uuid
                                };
    
    [NSURLSessionTask asynAtPort:UP_TEAM_LOGO withParameters:postData multipartBuilder:^(id<XTMultipartPostBuilder> fileBody) {
        NSData *imagedata=UIImagePNGRepresentation(upImage);
        [fileBody appendFileData:imagedata fileName:@"imageName.png" parameterKey:@"images"];
    } completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dic = [Global JSONObjectWithData:data];
        
        if(dic){
            if ([dic[@"code"] integerValue]==1) {
                NSLog(@"上传成功");
                
                [Global getInstance].isUpdateCreateTeamMessage = YES;
                
            }else{
                
            }
        }
    }];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)hideDatePickerHandler:(UITapGestureRecognizer*)gesture{
    [self hidePicker:datePicker];
}

- (void)dateChanged:(UIDatePicker*)picker{
    NSDate *selected = [picker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    [currentCell setRightString:destDateString];
    
    createTime = [NSString stringWithFormat:@"%.0lf",selected.timeIntervalSince1970];
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
     
        //后调用接口;
        if(createTime != nil)
        {
            NSDictionary * post = @{TEAM_ID:teamID,REGIST_TIME:createTime};
            
            NSMutableDictionary * postData = [post mutableCopy];
            
            [NetRequest POST:UP_TEAM_DETAIL parameters:postData atView:self.view andHUDMessage:@"更新中.." success:^(id resposeObject) {
                NSString *code = resposeObject[@"code"];
                
                if(code.integerValue == 2)
                {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[Global getInstance].mainVC showLoginView:YES];
                    }];
                }
            } failure:^(NSError *error) {
                NSLog(@"更新失败");
            }];

        }

    }];
}


@end
