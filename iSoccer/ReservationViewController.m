//
//  ReservationViewController.m
//  iSoccer
//
//  Created by Linus on 16/8/3.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "ReservationViewController.h"
#import "ReservationTableViewCell.h"

#import "FieldDetailViewController.h"
#import "FieldIndexViewController.h"
#import "AlreadyFieldViewController.h"


#import "Global.h"
#import "NetDataNameConfig.h"
#import "NetRequest.h"
#import "NetConfig.h"
@interface ReservationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *reservationTabelView;

@end

@implementation ReservationViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_SHOW_FIELD_DETAIL object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_SHOW_FIELD_INDEX object:nil];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
        
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"已预订" style:UIBarButtonItemStyleDone target:self action:@selector(showReserved:)];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataSource = [Global getInstance].reservationDatas;
    
    _reservationTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _reservationTabelView.delegate = self;
    _reservationTabelView.dataSource = self;
    
    _reservationTabelView.backgroundColor = [UIColor clearColor];
    
    _reservationTabelView.tableFooterView = [[UIView alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFieldDetailHandler:) name:EVENT_SHOW_FIELD_DETAIL object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFieldIndexHandler:) name:EVENT_SHOW_FIELD_INDEX object:nil];
    
}

- (void)backMainView:(UIBarButtonItem*)sender{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_SHOW_FIELD_DETAIL object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_SHOW_FIELD_INDEX object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)showReserved:(UIBarButtonItem*)sender{
    NSLog(@"显示已预订界面");
    
    NSMutableDictionary * postData = [NSMutableDictionary dictionary];
    
    
    [NetRequest POST:GET_ORDER_LIST parameters:postData atView:self.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
        NSLog(@"%@",resposeObject);
        
        NSMutableArray * data = resposeObject[@"data"];
        AlreadyFieldViewController * alreadyVC = [[AlreadyFieldViewController alloc]initWithData:data];
        
        [self.navigationController pushViewController:alreadyVC animated:YES];
        
        
    } failure:^(NSError *error) {
        NSLog(@"获取失败");
    }];
}

- (void)showFieldIndexHandler:(NSNotification*)notification{
    NSMutableDictionary * data = [notification object];
    
    FieldIndexViewController * fieldIndexVC = [[FieldIndexViewController alloc]initWithData:data];
    
    [self.navigationController pushViewController:fieldIndexVC animated:YES];
    
}

- (void)showFieldDetailHandler:(NSNotification*)notification{
    NSMutableDictionary * fieldData = [notification object];
    
    NSString * shopId = [fieldData objectForKey:@"shopId"];
    
    NSString * fieldId = [fieldData objectForKey:@"fieldId"];
    
    NSString * fieldName = [fieldData objectForKey:@"fieldName"];
    
    NSString * shopName = [fieldData objectForKey:@"shopName"];
    
    NSString * shopAddress = [fieldData objectForKey:@"shopAddress"];
    
    NSLog(@"%@",fieldData);
    
    NSDictionary * post = @{@"fieldId":fieldId};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:GET_FIELD_DETAIL_BY_FIELDID parameters:postData atView:self.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
        NSLog(@"%@",resposeObject);
        
        NSMutableDictionary * data = resposeObject[@"data"];
        
        NSMutableArray * picList = [data objectForKey:@"shopFieldImgList"];
        
        NSString * shopIconUrl = [data objectForKey:@"fieldLogo"];
        
        FieldDetailViewController * fieldDetailVC = [[FieldDetailViewController alloc]initWithTitle:fieldName andPicList:picList andFieldIconUrl:shopIconUrl andAddress:shopAddress andShopName:shopName andId:shopId andFieldId:fieldId];
        
        [self.navigationController pushViewController:fieldDetailVC animated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"获取失败");
    }];
}


#pragma mark -- UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    static NSString* reservationCell = @"resvationCell";
    
    ReservationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reservationCell];
    
    if(!cell)
    {
        cell = [[ReservationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reservationCell];
    }
    
    NSMutableDictionary * currentData = dataSource[indexPath.section];
    
    
    NSLog(@"%@",currentData);
    
    
    NSString * shopTel = [currentData objectForKey:@"shopTelephone"];
    
    NSString * shopAddress = [currentData  objectForKey:@"shopAddress"];
    
    NSString * shopLat = [currentData objectForKey:@"shopLat"];
    
    NSString * shopLng = [currentData objectForKey:@"shopLng"];
    
    NSString * titleImageUrl = [currentData objectForKey:@"shopUrl"];
    
    
    NSDictionary * shopData = @{@"shopTelephone":shopTel,@"shopAddress":shopAddress,
                                @"shopLat":shopLat,@"shopLng":shopLng,
                                @"shopUrl":titleImageUrl};
    
    NSMutableDictionary * shopMutableData = [shopData mutableCopy];
    
    [cell setShopData:shopMutableData];
    
    NSString * titleName = [currentData objectForKey:@"shopName"];
    cell.titleName.text = titleName;
    
    [Global loadImageFadeIn:cell.titleImageView andUrl:titleImageUrl isLoadRepeat:YES];
    
    NSMutableArray * fieldDatas = [currentData objectForKey:@"fieldList"];
    
    [cell setFieldScrollData:fieldDatas];
    
    
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    return size.height * 0.6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 20;
}

@end
