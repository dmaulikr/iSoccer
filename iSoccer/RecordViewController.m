//
//  RecordViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/5.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordTableViewCell.h"
#import "NetDataNameConfig.h"
#import "Global.h"
#import "UserData.h"
#import "NetConfig.h"
#import "MMPickerView.h"
#import "NSURLSessionTask+MultipartFormData.h"
#import "MemberScoreViewController.h"
#import "OpenUDID.h"
#import "NetRequest.h"

#define PHOTO_WH 90

@interface RecordViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView * recordTableView;
    NSArray * sectionData;
    NSArray * leftData;
    NSArray * rightData;
    NSMutableArray * photoData;
    NSString * matchId;
    NSString * photoId;
    NSArray * arrowData;
    NSMutableArray * _sourePickerData;
    
    RecordTableViewCell * currentCell;
    
    NSMutableArray * sourceData;
    
    NSMutableArray * memberData;
    NSString * matchScoreString;
    NSMutableDictionary * _matchData;
    BOOL isChaged;
    BOOL _isMe;
    
    BOOL isDelete;
}

@end

@implementation RecordViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_UPLOAD_PHOTO object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DELETE_PHOTO object:nil];
}

- (instancetype)initWithData:(NSMutableDictionary *)data andIsMe:(BOOL)isMe
{
    self = [super init];
    if (self) {
        self.title = @"比赛回顾";
        if(isMe == YES)
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
        }
        if(isMe == YES)
        {
            _isMe = [Global getInstance].isMeTeam;
        }else{
            _isMe = isMe;
        }
        
        
        _sourePickerData = [NSMutableArray array];
        
        _matchData = data;
        
        memberData = [NSMutableArray array];
        
        NSMutableArray *userList = [data objectForKey:USER_LIST];
        
        for(NSInteger i = 0;i < userList.count;i++)
        {
            NSMutableDictionary * userData = userList[i];
            [memberData addObject:[Global setUserDataByDictionary:userData]];
        }
        
        NSMutableArray * teamASource = [NSMutableArray array];
        NSMutableArray * teamBSource = [NSMutableArray array];
        for(NSInteger i = 0;i < 100;i ++)
        {
            [teamASource addObject:[NSString stringWithFormat:@"%zd",i]];
            [teamBSource addObject:[NSString stringWithFormat:@"%zd",i]];
        }
        
        [_sourePickerData addObject:teamASource];
        [_sourePickerData addObject:teamBSource];
        
        NSString * teamBName = [data objectForKey:GAME_TEAM_B];
        
        matchId = [data objectForKey:MATCH_ID];

        sourceData = [data objectForKey:GAME_SOURCE];
        
        matchScoreString = [NSString stringWithFormat:@"%@:%@",sourceData[0],sourceData[1]];
        
        photoData = [data objectForKey:MATCH_PIC_LIST];
        
        if(sourceData == nil || sourceData.count == 0)
        {
            sourceData = [NSMutableArray array];
            [sourceData addObject:@"0"];
            [sourceData addObject:@"0"];
        }
        
        NSString * timeString = [data objectForKey:MATCH_TIME];
        
        timeString = [Global getDateByTime:timeString isSimple:NO];
        
        NSString * address = [data objectForKey:MATCH_ADDRESS];
        
        NSString *matchSoure = [NSString stringWithFormat:@"%@:%@",sourceData[0],sourceData[1]];
        
        rightData = @[@[teamBName,matchSoure,timeString,address,@"进球信息"],@[@"",@""]];
        
        
    }
    return self;
}

- (void)deletePhoto:(NSNotification*)sender{
    NSLog(@"调用删除头像");
    
    isDelete = YES;
    
    photoId = [sender object];//通过这个获取到传递的对象
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"删除",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)uploadPhoto:(NSNotification*)sender{
    NSLog(@"调用上传头像");
    
    isDelete = NO;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"相册",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sectionData = @[@"5",@"2"];
    leftData = @[@[@"对手",@"比分",@"比赛时间",@"场地",@"进球"],@[@"图片",@""]];
    arrowData = @[@[@"",@"1",@"",@"",@"1"],@[@"",@"1"]];
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    
    recordTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    recordTableView.delegate = self;
    recordTableView.dataSource = self;
    
    recordTableView.sectionFooterHeight = 1.0;
    
    [self.view addSubview:recordTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPhoto:) name:EVENT_UPLOAD_PHOTO object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePhoto:) name:EVENT_DELETE_PHOTO object:nil];
}

- (void)backMainView:(UIBarButtonItem*)sender{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_UPLOAD_PHOTO object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DELETE_PHOTO object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *number = sectionData[section];
    
    return number.integerValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%zd == %zd",indexPath.section,indexPath.row);
    NSMutableArray * photo;
    
    CGFloat height = 44;
    
    if(indexPath.section == 0 && indexPath.row == 6)
    {
        height = 55;
    }
    
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        photo = photoData;

        NSInteger number;
        
        NSInteger addNum = 1;
        if(_isMe == NO)
        {
            addNum = 0;
        }
        
        if(photo.count < 9)
        {
            number = photo.count + addNum ;
            
            //如果没有满9个添加一个上传按钮;
        }else{
            number = photo.count;
            //如果满了就不加
        }
        NSInteger row = number/ 3.0;
        //
        NSInteger excess = number % 3;
        
        if(excess > 0)
        {
            row += 1;
        }
        CGFloat gap = 6;//中间间隙;
        
        CGFloat bottomAndTop = 8;//上下边距;
        
        height =  row * PHOTO_WH + (row - 1) * gap + bottomAndTop;
    }
    
    static NSString * identifier = @"recordCell";
    
    RecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell)
    {
        cell = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier andHeight:height photo:photo];
        
        cell.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString * leftStr = leftData[indexPath.section][indexPath.row];
    
    
    [cell setLeftString:leftStr];
    
    if(rightData)
    {
        NSString * rightStr = rightData[indexPath.section][indexPath.row];
        
        [cell setRightString:rightStr];
    }
    
    if(_isMe == NO)
    {
        
        if(indexPath.section == 0 && indexPath.row == 4)
        {
            cell.arrowIcon.hidden = NO;//特殊判断;
        }else{
            cell.arrowIcon.hidden = YES;
        }
        
        cell.uploadButton.hidden = YES;
    }else{
        NSString * isShowArrow = arrowData[indexPath.section][indexPath.row];
        if(isShowArrow.length == 0)
        {
            cell.arrowIcon.hidden = YES;
        }
    }
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionData.count;
}
#pragma mark -- UITableViewDelegate


//设置间隔高度;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RecordTableViewCell *cell = (RecordTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    currentCell = (RecordTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        if(_isMe == NO)
        {
            return;
        }

        NSMutableArray * components = [NSMutableArray array];
        
        for(NSInteger i = 0;i < sourceData.count;i++)
        {
            NSString *row = [NSString stringWithFormat:@"%@",sourceData[i]];
            
            NSDictionary * dic = @{@"row":row,@"component":[NSString stringWithFormat:@"%zd",i]};
            [components addObject:dic];
        }
        
        
        [MMPickerView showPickerViewInViewComponents:self.view withStrings:_sourePickerData withOptions:nil withComponents:components completion:^(NSString *selectString, NSInteger component) {
            NSString * result;
            sourceData[component] = selectString;
            result = [NSString stringWithFormat:@"%@:%@",sourceData[0],sourceData[1]];
            
            matchScoreString = [NSString stringWithString:result];
            [currentCell setRightString:result];
            
            isChaged = YES;
        } hedden:^{
            //调用更改信息;
           if(isChaged == YES)
           {
               isChaged = NO;
               NSDictionary * post = @{
                                       MATCH_ID:matchId,
                                       MATCH_SCORE:matchScoreString
                                       };
               
               NSMutableDictionary *postData = [post mutableCopy];
               
               [NetRequest POST:UPDATE_RECORD parameters:postData atView:self.view andHUDMessage:@"更改中.." success:^(id resposeObject) {
                   NSLog(@"更改成功");
                   
                   NSString *code = resposeObject[@"code"];
                   
                   if(code.integerValue == 2)
                   {
                       [self dismissViewControllerAnimated:YES completion:^{
                           [[Global getInstance].mainVC showLoginView:YES];
                       }];
                   }else{
                   
                   NSMutableArray * gameDatas = [Global getInstance].gameDatas;
                   
                   
                   for(NSInteger i = 0;i < gameDatas.count;i++)
                   {
                       NSMutableDictionary * data = gameDatas[i];
                       
                       NSMutableArray * matchList = [data objectForKeyedSubscript:MATCH_LIST];
                       
                       for(NSInteger j = 0;j < matchList.count;j++)
                       {
                           NSMutableDictionary * match = matchList[j];
                           
                           NSString * mid = [match objectForKeyedSubscript:MATCH_ID];
                           
                           if([matchId compare:mid] == 0)
                           {
                               NSMutableArray * scores = [NSMutableArray array];
                               [scores addObject:sourceData[0]];
                               [scores addObject:sourceData[1]];
                               
                               NSString * matchScore = [NSString stringWithFormat:@"%@:%@",sourceData[0],sourceData[1]];
                               
                               [match setValue:scores forKey:GAME_SOURCE];
                               [match setValue:matchScore forKey:MATCH_SCORE];
                               
                               [Global getInstance].isUpdate = YES;
                               break;
                           }
                       }
                       if([Global getInstance].isUpdate == YES)
                       {
                           break;
                       }
                   }
                   }
                   
               } failure:^(NSError *error) {
                   NSLog(@"更改失败");
               }];
           }
            
        }];
    }else if(indexPath.section == 0 && indexPath.row == 4)
    {
        NSLog(@"进入记录进球信息");
        
        NSDictionary * post = @{
                                MATCH_ID:matchId
                                };
        
        NSMutableDictionary * postData = [post mutableCopy];
        
        [NetRequest POST:GET_RECORD_SCORE parameters:postData atView:self.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
            
            NSString *code = resposeObject[@"code"];
            
            if(code.integerValue == 2)
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[Global getInstance].mainVC showLoginView:YES];
                }];
            }else{
            
            NSInteger sumGolbs = [NSString stringWithFormat:@"%@",sourceData[0]].integerValue;
            
            NSMutableArray *goals = resposeObject[GOAL_LIST];
            
            MemberScoreViewController * memberVC = [[MemberScoreViewController alloc]initWithMembers:memberData andGoals:goals andSumScore:sumGolbs andMatchId:matchId andMe:_isMe];
            
            [self.navigationController pushViewController:memberVC animated:YES];
            
            }
        } failure:^(NSError *error) {
           
            NSLog(@"获取进球信息,报错!");
        }];
    }
}

- (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.2);
}


#pragma UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if(isDelete)
    {
        //执行删除图片操作;
        
        if(buttonIndex == 0)
        {
            NSDictionary * post = @{@"matchId":matchId,@"pictureId":photoId};
            
            NSMutableDictionary * postData = [post mutableCopy];
            
            [NetRequest POST:DELETE_RECORD_PHOTO parameters:postData atView:self.view andHUDMessage:@"删除中.." success:^(id resposeObject) {
                NSLog(@"删除成功刷新");
                
                photoData = [resposeObject objectForKey:MATCH_PIC_LIST];
                [recordTableView reloadData];
                
            } failure:^(NSError *error) {
                NSLog(@"删除失败!");
            }];
            
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
        [Global getInstance].isDeleting = NO;
    }else{
        NSUInteger sourceType = 0;
        
        switch (buttonIndex) {
            case 0:{
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}


#pragma mark - image picker delegte

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *savedImage = image;
    
    UIImage * upImage = [Global imageCompressForWidth:savedImage targetWidth:self.view.frame.size.width];
    
    
    
    UserData * user = [Global getInstance].userData;
    
    NSString *uuid = [OpenUDID value];
    
    NSDictionary * postData = @{
                                MATCH_ID:matchId,
                                USER_ID:user.userId,
                                UUID:uuid
                                };

    [Global getInstance].HUD.labelText = @"上传中...";
    
    [[Global getInstance].HUD show:YES];
    
    [self.view addSubview:[Global getInstance].HUD];
    
    [NSURLSessionTask asynAtPort:UP_RECORD_PHOTO withParameters:postData multipartBuilder:^(id<XTMultipartPostBuilder> fileBody) {
        NSData *imagedata=UIImagePNGRepresentation(upImage);
        [fileBody appendFileData:imagedata fileName:@"imageName.png" parameterKey:@"images"];
        
    } completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dic = [Global JSONObjectWithData:data];
        
        if(dic){
            if ([dic[@"code"] integerValue]==1) {
                NSLog(@"上传成功");
                photoData = [dic objectForKey:MATCH_PIC_LIST];
                [[Global getInstance].HUD hide:YES];
                
                [recordTableView reloadData];
            }else{
                [[Global getInstance].HUD hide:YES];
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

@end
