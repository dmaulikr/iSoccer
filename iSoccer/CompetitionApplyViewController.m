//
//  CompetitionApplyViewController.m
//  iSoccer
//
//  Created by pfg on 16/5/20.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "CompetitionApplyViewController.h"
#import "ApplyTableViewCell.h"
#import "NetDataNameConfig.h"
#import "Global.h"
#import "NetRequest.h"
#import "NetConfig.h"
#import "OpenUDID.h"
#import "NSURLSessionTask+MultipartFormData.h"
#import "ChangeIDViewController.h"
#import "SuccessEventViewController.h"


#define GAP self.view.frame.size.height * 0.01

@interface CompetitionApplyViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    
    UITableView * applyTableView;
    NSArray * dataSource;
    NSArray * sectionData;
    NSArray * leftData;
    NSArray * rightData;
    BOOL isFront;//表示传正面还是背面;
    
    NSMutableString * idCardFront;//身份证正面ID;
    NSMutableString * idCardBack;//身份证背面ID;
    
    ApplyTableViewCell * IDCardCell;
    ApplyTableViewCell * currentCell;
    
    IDData * idData;
    
    NSString * type;
}

@end

@implementation CompetitionApplyViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_UPLOAD_PHOTO object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DELETE_PHOTO object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"提交资料";
        
        sectionData = @[@"请填写个人真实资料",@"上传身份证照片"];
        
        leftData = @[@[@"姓名",@"手机号码",@"身份证号码"],@[@""]];
        
        dataSource = @[@"3",@"1"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    if([Global getInstance].isInputIdData == YES)
    {
        [Global getInstance].isInputIdData = NO;
        
        switch (type.integerValue) {
            case 0:
            {
                idData.name = [Global getInstance].currentIDdata.name;
                currentCell.rightLabel.text = idData.name;
            }
                break;
            case 1:
            {
                idData.phone = [Global getInstance].currentIDdata.phone;
                currentCell.rightLabel.text = idData.phone;
            }
                break;
            case 2:
            {
                idData.idNumber = [Global getInstance].currentIDdata.idNumber;
                currentCell.rightLabel.text = idData.idNumber;
            }
                break;
            default:
                break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    idData = [[IDData alloc]init];
    
    applyTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    applyTableView.delegate = self;
    applyTableView.dataSource = self;
    
    [self.view addSubview:applyTableView];
    
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.49)];
    
    UILabel * footTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
    
    footTitleLabel.text = @"足球管家提醒你";
    footTitleLabel.textColor = [UIColor blackColor];
    footTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    footTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    [footView addSubview:footTitleLabel];
    
    UILabel * footContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(GAP, footTitleLabel.frame.size.height + GAP/2, self.view.frame.size.width - GAP * 2, self.view.frame.size.height * 0.26 - footTitleLabel.frame.size.height)];
    
    footContentLabel.text = @"1、请填写你的真实信息，否则可能会不通过简录比赛\n\n2、足球管家会保护您的隐私,不会泄露给第三人\n\n3、赛制组织受理球队团体参赛申请,请才加比赛确认你所在的球队已经参与该比赛";
    footContentLabel.textColor = [UIColor grayColor];
    footContentLabel.font = [UIFont systemFontOfSize:14];
    footContentLabel.numberOfLines = 0;
    
    [footView addSubview:footContentLabel];
    
    
    UIButton * button = [self createButtonByTitle:@"提交比赛申请" andColor:[UIColor blackColor] andWidth:self.view.frame.size.width * 0.9];
    
    button.center = CGPointMake(footView.frame.size.width/2, footContentLabel.frame.origin.y + footContentLabel.frame.size.height + button.frame.size.height/2 + GAP);
    
    [button addTarget:self action:@selector(applyButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:button];
    
    
    applyTableView.tableFooterView = footView;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upFrontIdCard) name:EVENT_UPLOAD_IDCARD_FRONT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upBackIdCard) name:EVENT_UPLOAD_IDCARD_BACK object:nil];

    
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_UPLOAD_PHOTO object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DELETE_PHOTO object:nil];

}

- (void)upFrontIdCard{
    //上传正面;
    isFront = YES;
    [self showActionSheet];
    
}

- (void)upBackIdCard{
    //上传背面;
    isFront = NO;
    [self showActionSheet];
}

- (void)showActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"相册",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)applyButtonHandler:(UIButton*)sender{
    //NSLog(@"嘻嘻");
    
    if(!idData.name || idData.name.length < 1)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入名字!"];
        return;
    }
    if(!idData.phone || idData.phone.length != 11)
    {
        [Global alertWithTitle:@"提示" msg:@"手机号码格式错误,请填写!"];
        return;
    }
    
    if(!idData.idNumber || idData.idNumber.length < 18)
    {
        [Global alertWithTitle:@"提示" msg:@"身份证号码不正确,请填写!"];
        return;
    }
    
    if(!idData.idFrontImg || idData.idFrontImg.length < 1)
    {
        [Global alertWithTitle:@"提示" msg:@"请上传身份证正面!"];
        return;
    }
    
    if(!idData.idBackImg || idData.idBackImg.length < 1)
    {
        [Global alertWithTitle:@"提示" msg:@"请上传身份证背面!"];
        return;
    }
    
    NSDictionary * post = @{@"userName":idData.name,@"phone":idData.phone,@"eventId":_currentEventId,@"teamId":_currentTeamId,@"identityCard":idData.idNumber,@"identityCardImage1":idData.idFrontImg,@"identityCardImage2":idData.idBackImg};
    
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:JOIN_EVENT parameters:postData atView:self.view andHUDMessage:@"提交中..." success:^(id resposeObject) {
        
        NSMutableDictionary * data = resposeObject[@"eventUser"];
        
        if(data)
        {
            NSString * codeUrl = [data objectForKey:@"qRcode"];
            
            SuccessEventViewController * successVC = [[SuccessEventViewController alloc]initWithUrl:codeUrl];
            
            [self.navigationController pushViewController:successVC animated:YES];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"错误");
    }];
    
}

- (UIButton*)createButtonByTitle:(NSString*)title andColor:(UIColor*)color andWidth:(CGFloat)width{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0,0, width, self.view.frame.size.height * 0.08);
    button.backgroundColor = color;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    
    return button;
}

#pragma mark -- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
        
    [self presentViewController:imagePickerController animated:YES completion:nil];
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
                                USER_ID:user.userId,
                                UUID:uuid
                                };
    
    [Global getInstance].HUD.labelText = @"上传中...";
    
    [[Global getInstance].HUD show:YES];
    
    [self.view addSubview:[Global getInstance].HUD];
    
    [NSURLSessionTask asynAtPort:UPLOAD_IDCARD withParameters:postData multipartBuilder:^(id<XTMultipartPostBuilder> fileBody) {
        NSData *imagedata=UIImagePNGRepresentation(upImage);
        [fileBody appendFileData:imagedata fileName:@"image.png" parameterKey:@"groupbuy_image"];
        
    } completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dic = [Global JSONObjectWithData:data];
        
        if(dic){
            if ([dic[@"result"] integerValue]==1) {
                NSLog(@"上传成功");
                
                NSString * fileName = dic[@"file_name"];
                NSString * fileUrl = dic[@"file_url"];
                
                if(isFront)
                {
                    [Global loadImageFadeIn:IDCardCell.frontIdCardImage andUrl:fileUrl isLoadRepeat:YES];
                    idCardFront = [NSMutableString stringWithFormat:@"%@",fileName];
                    
                    idData.idFrontImg = idCardFront;
                }else{
                    [Global loadImageFadeIn:IDCardCell.backIdCardImage andUrl:fileUrl isLoadRepeat:YES];
                    idCardBack = [NSMutableString stringWithFormat:@"%@",fileName];
                    
                    idData.idBackImg = idCardBack;
                }
                
                [[Global getInstance].HUD hide:YES];
            }else{
                [[Global getInstance].HUD hide:YES];
                //NSString *msg = dic[@"msg"];
                [Global alertWithTitle:@"提示" msg:@"上传失败，请重试!"];
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




#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSString * data = dataSource[section];
    
    return data.integerValue;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return dataSource.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionData[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    static NSString * applyCell = @"applyCell";
    CGFloat height;
    BOOL isUpload;
    
    if(indexPath.section == 0)
    {
        height = 40;
        isUpload = NO;
    }else{
        height = size.height * 0.27;
        isUpload = YES;
    }
    
    ApplyTableViewCell * cell = [[ApplyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:applyCell andHeight:height isUpload:isUpload];
    
    if(isUpload)
    {
        IDCardCell = cell;
    }
    
    NSString * leftString = leftData[indexPath.section][indexPath.row];
    cell.leftLabel.text = leftString;
    
    return cell;
}


#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat height;
    if(indexPath.section == 0)
    {
        height = 40;
    }else{
        height = size.height * 0.27;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section != 0)
    {
        return;
    }
    
    currentCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString * title = leftData[indexPath.section][indexPath.row];
    
    type = [NSString stringWithFormat:@"%zd",indexPath.row];
    
    ChangeIDViewController * changeVC = [[ChangeIDViewController alloc]initWithTitle:title defaultString:currentCell.rightLabel.text andType:type];
    
    [self.navigationController pushViewController:changeVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;{
    return 24;
}



@end
