//
//  CreateMatchViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/20.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "CreateMatchViewController.h"
#import "CreateTableViewCell.h"
#import "CreateMatchInfoViewController.h"
#import "Global.h"
#import "MMPickerView.h"
#import "NetDataNameConfig.h"
#import "MapViewController.h"
#import "NetConfig.h"
#import "NetRequest.h"

@interface CreateMatchViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *matchTableView;
    NSArray * leftData;
    NSArray * rightData;
    NSArray * typeData;
    NSString * currentInputType;
    NSString * matchFormat;
    NSString * matchType;
    CreateTableViewCell * currentCell;
    UIDatePicker *datePicker;
    BOOL isShowPicker;
    BOOL isShowMap;
}
@end


@implementation CreateMatchViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
            leftData = @[@"比赛性质",@"比赛名称",@"比赛时间",@"场地",@"对手",@"赛制",@"球衣颜色",@"场地费",@"备注"];
            
            rightData = @[@"友谊赛",@"",@"",@"",@"",@"7人制",@"红黑",@"",@""];
            
            typeData = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
        }
    }
    return self;
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
    MatchInfo * data = [Global getInstance].matchInfo;
    
    if([Global getInstance].isInputMatchInfo == YES)
    {
        [Global getInstance].isInputMatchInfo = NO;
        
        switch (currentInputType.integerValue) {
            case 1:
                //比赛名称;
                [currentCell setRightString:data.matchName];
                break;
            case 4:
                //对手名称;
                [currentCell setRightString:data.matchOpponent];
                break;
            case 6:
                //描述
                [currentCell setRightString:data.matchColor];
                break;
            case 7:
                [currentCell setRightString:data.matchCost];
                break;
            case 8:
                [currentCell setRightString:data.matchRemark];
                break;
            default:
                break;
        }
    }
    
    if(isShowMap == YES)
    {
        isShowMap = NO;
        if(data.addressName != nil)
        {
            [currentCell setRightString:data.addressName];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Global getInstance].matchInfo = [[MatchInfo alloc]init];
    
    [Global getInstance].matchInfo.matchType = FRIEND_GAME;
    
    [Global getInstance].matchInfo.matchFormat = FORMAT_SEVEN;
    
    [Global getInstance].matchInfo.matchColor = rightData[6];
    
    isShowPicker = NO;
    
    isShowMap = NO;
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
    
    matchTableView.tableFooterView = footerView;
    
}

- (void)backMainView:(UIBarButtonItem*)sender{
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    currentCell = (CreateTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.row == 0)
    {
        NSArray * strings = @[@"友谊赛",@"正式赛"];
        
        [MMPickerView showPickerViewInView:self.view
                               withStrings:strings
                               withOptions:@{MMselectedObject:currentCell.rightLabel.text}
                                completion:^(NSString *selectedString) {
                                    //selectedString is the return value which you can use as you wish
                                    [currentCell setRightString:selectedString];
                                    matchType = selectedString;
                                } hedden:^{
                                    NSString * type;
                                    if([matchType compare:@"友谊赛"] == 0)
                                    {
                                        type = FRIEND_GAME;
                                    }else{
                                        type = REGULATION_GAME;
                                    }
                                    [Global getInstance].matchInfo.matchType = type;
                                }];
    }else if(indexPath.row == 2){
        
        
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
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *destDateString = [dateFormatter stringFromDate:minDate];
            [currentCell setRightString:destDateString];
            
            [Global getInstance].matchInfo.matchTime = [NSString stringWithFormat:@"%.0lf",minDate.timeIntervalSince1970];
        }
        datePicker.backgroundColor = [UIColor whiteColor];
        
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        datePicker.locale = locale;
        
        datePicker.minimumDate = minDate;
        [mask addSubview:datePicker];
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.view addSubview:mask];
        
        [self showPicker:datePicker];
        
        
    }else if(indexPath.row == 3){
        //调用地图;
        isShowMap = YES;
        UIStoryboard *mapView = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
        MapViewController * mpVC = mapView.instantiateInitialViewController;
        [self.navigationController pushViewController:mpVC animated:YES];
        
    }else if(indexPath.row == 5)
    {
        NSArray * strings = @[@"5人制",@"7人制",@"11人制"];
        
        [MMPickerView showPickerViewInView:self.view
                               withStrings:strings
                               withOptions:@{MMselectedObject:currentCell.rightLabel.text}
                                completion:^(NSString *selectedString) {
                                    //selectedString is the return value which you can use as you wish
                                    [currentCell setRightString:selectedString];
                                    
                                    if([selectedString compare:strings[0]] == 0)
                                    {
                                        matchFormat = FORMAT_FIVE;
                                    }else if([selectedString compare:strings[1]] == 0)
                                    {
                                        matchFormat = FORMAT_SEVEN;
                                    }else{
                                        matchFormat = FORMAT_ELEVEN;
                                    }
                                    
                                } hedden:^{
                                    [Global getInstance].matchInfo.matchFormat = matchFormat;
                                }];
    }else{
        NSString * title = leftData[indexPath.row];
        NSString * defaultSting = currentCell.rightLabel.text;
        
        currentInputType = typeData[indexPath.row];
        CreateMatchInfoViewController * changeVC = [[CreateMatchInfoViewController alloc]initWithTitle:title defaultString:defaultSting andType:currentInputType];
        
        [self.navigationController pushViewController:changeVC animated:YES];
    }
}

- (void)dateChanged:(UIDatePicker*)picker{
    NSDate *selected = [picker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    [currentCell setRightString:destDateString];
    
    [Global getInstance].matchInfo.matchTime = [NSString stringWithFormat:@"%.0lf",selected.timeIntervalSince1970];
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



- (void)hideDatePickerHandler:(UITapGestureRecognizer*)gesture{
    [self hidePicker:datePicker];
}

- (void)tapedCreateHandler:(UIButton*)sender{
    MatchInfo * data = [Global getInstance].matchInfo;
    
    if([data.matchType isEqualToString:FRIEND_GAME])
    {
        if(data.matchName == nil || data.matchName.length == 0)
        {
           data.matchName = @"友谊赛";
        }
    }
    
    if(data.matchName == nil || data.matchName.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入比赛名称"];
        return;
    }
    if(data.matchTime == nil || data.matchTime.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"请设置比赛时间"];
        return;
    }
    
    if(data.matchX == nil || data.matchY == nil)
    {
        [Global alertWithTitle:@"提示" msg:@"比赛地址未设置"];
    }
    if(data.addressName == nil || data.addressName.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"比赛地址设置无效或未设置"];
        return;
    }
    
    if(data.matchCost == nil || data.addressName.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"比赛费用未设置"];
        return;
    }
    
    if(data.matchOpponent == nil || data.matchOpponent.length == 0)
    {
        [Global alertWithTitle:@"提示" msg:@"比赛对手未设置"];
        return;
    }
    
    if([data.matchFormat isEqualToString:@""] || data.matchFormat == nil)
    {
        data.matchFormat = FORMAT_SEVEN;
        
    }
    
    if(data.matchRemark == nil)
    {
        data.matchRemark = @"";
    }
    
    if(data.cityName == nil)
    {
        data.cityName = @"成都";
    }
    
    NSDictionary *post = @{
                           TEAM_ID:[Global getInstance].currentTeamId,
                           GAME_TYPE:data.matchType,
                           GAME_TITLE_KEY:data.matchName,
                           FORMAT_ID:data.matchFormat,
                           MATCH_ADDRESS:data.addressName,
                           MATCH_X:data.matchX,
                           MATCH_Y:data.matchY,
                           GAME_JERSEY:data.matchColor,
                           GAME_TEAM_B:data.matchOpponent,
                           MATCH_TIME:data.matchTime,
                           MATCH_FEE:data.matchCost,
                           @"cityName":data.cityName,
                           @"remarks":data.matchRemark
                           };

    NSMutableDictionary * postData = [post mutableCopy];
    [NetRequest POST:CREATE_MATCH parameters:postData atView:self.view andHUDMessage:@"创建中.." success:^(id resposeObject) {
        
        NSString *code = resposeObject[@"code"];
        
        if(code.integerValue == 2)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [[Global getInstance].mainVC showLoginView:YES];
            }];
        }else{
            
            [Global alertWithTitle:@"恭喜!" msg:@"比赛创建成功!"];
            
            [Global getInstance].isCreateMatchSuccssed = YES;
            
            [self backMainView:nil];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"接口出错");
    }];
}

@end
