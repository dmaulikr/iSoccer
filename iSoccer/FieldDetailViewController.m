//
//  FieldDetailViewController.m
//  iSoccer
//
//  Created by Linus on 16/8/5.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "FieldDetailViewController.h"
#import "FieldDetailTableViewCell.h"
#import "Global.h"

#import "OrderViewController.h"
#import "NetDataNameConfig.h"

#import "NetRequest.h"
#import "NetConfig.h"

#define DEFAULT_HEIGHT 44

@interface FieldDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * fieldTabelView;
    NSMutableArray * picDatas;
    
    NSString * fieldName;
    NSString * fieldIconUrl;
    NSString * fieldAddress;
    NSString * _shopName;
    NSString * _shopId;
    NSString * _fieldId;
}

@end

@implementation FieldDetailViewController


- (instancetype)initWithTitle:(NSString*)title andPicList:(NSMutableArray*)picList andFieldIconUrl:(NSString*)iconUrl andAddress:(NSString*)address andShopName:(NSString*)shopName andId:(NSString*)shopId andFieldId:(NSString*)fieldId
{
    self = [super init];
    if (self) {
        
        self.title = title;
        
        picDatas = picList;
        
        fieldName = title;
        
        fieldIconUrl = iconUrl;
        
        fieldAddress = address;
        
        _shopName = shopName;
        
        _shopId = shopId;
        
        _fieldId = fieldId;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    fieldTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    
    
     self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    
    
    fieldTabelView.delegate = self;
    fieldTabelView.dataSource = self;
    
    UIView * headerTableView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    headerTableView.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat iconWH = headerTableView.frame.size.height * 0.5;
    
    UIImageView * fieldIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.05, (headerTableView.frame.size.height - iconWH)/2, iconWH, iconWH)];
    
    [fieldIcon setContentScaleFactor:[[UIScreen mainScreen] scale]];
    fieldIcon.contentMode =  UIViewContentModeScaleAspectFill;
    fieldIcon.autoresizingMask = UIViewAutoresizingNone;
    fieldIcon.clipsToBounds  = YES;
    
    
    fieldIcon.layer.masksToBounds = YES;
    fieldIcon.layer.cornerRadius = fieldIcon.frame.size.width/2;
    
    [Global loadImageFadeIn:fieldIcon andUrl:fieldIconUrl isLoadRepeat:YES];
    [headerTableView addSubview:fieldIcon];
    
    UILabel * shopName = [[UILabel alloc]initWithFrame:CGRectMake(fieldIcon.frame.origin.x + fieldIcon.frame.size.width + fieldIcon.frame.origin.x, fieldIcon.frame.origin.y, self.view.frame.size.width/2, fieldIcon.frame.size.height/2)];
    
    shopName.text = _shopName;
    
    shopName.textColor = [UIColor blackColor];
    
    shopName.font = [UIFont systemFontOfSize:18];
    
    [headerTableView addSubview:shopName];
    
    
    UILabel * address = [[UILabel alloc]initWithFrame:CGRectMake(shopName.frame.origin.x, shopName.frame.origin.y + shopName.frame.size.height, shopName.frame.size.width, shopName.frame.size.height)];
    
    address.text = fieldAddress;
    address.textColor = [UIColor lightGrayColor];
    address.font = [UIFont systemFontOfSize:15];
    
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(shopName.frame.origin.x + shopName.frame.size.width + 4, shopName.frame.origin.y, 20, 20)];
    
    icon.center = CGPointMake(icon.center.x, shopName.center.y);
    
    icon.image = [UIImage imageNamed:@"shang.png"];
    
    [headerTableView addSubview:icon];
    
    
    [headerTableView addSubview:address];
    
    
    fieldTabelView.tableHeaderView = headerTableView;
    
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    
    fieldTabelView.tableFooterView = footerView;
    
    
    [self.view addSubview:fieldTabelView];
    
    
    [self setFieldButtonFunction];
    
    
}

- (void)showOrderHandler{
    
    NSDictionary * dic = @{@"fieldId":_fieldId,@"shopId":_shopId};
    
    
    NSMutableDictionary * postData =[dic mutableCopy];
    

    
    [NetRequest POST:GET_FIELD_ORDER parameters:postData atView:self.view andHUDMessage:@"加载中.." success:^(id resposeObject) {
        
        NSLog(@"%@",resposeObject);
        
        NSMutableDictionary * data = resposeObject[@"data"];
        
        OrderViewController * orderVC = [[OrderViewController alloc]initWithData:data andFieldName:fieldName];
        
        
        [self.navigationController pushViewController:orderVC animated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"获取订单失败");
    }];
}


- (void)setFieldButtonFunction{
    //CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIView * whiteBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:232.0/255.0 alpha:1.0];
    
    [whiteBg addSubview:line];
    
    
    whiteBg.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - whiteBg.frame.size.height/2 - 64);
    
    whiteBg.backgroundColor = [UIColor whiteColor];
    
    UIButton * reservationButton = [self createButtonByTitle:@"立即预订球场" andColor:[UIColor colorWithRed:20.0/255 green:20.0/255 blue:20.0/255 alpha:1]];
    
    [whiteBg addSubview:reservationButton];
    
    
    [reservationButton addTarget:self action:@selector(tapReservationHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:whiteBg];
}

- (void)tapReservationHandler:(UIButton*)sender{
    NSLog(@"预订球场");
    
    //NSDictionary * sendDic = @{@"fieldId":_fieldId,@"shopId":_shopId};
    
    [self showOrderHandler];
}


- (UIButton*)createButtonByTitle:(NSString*)title andColor:(UIColor*)color{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(size.width * 0.1,6,size.width - (size.width * 0.1 * 2), DEFAULT_HEIGHT + 4);
    button.backgroundColor = color;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    
    return button;
}




#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    static NSString * fieldDetailCell = @"fieldDetailCell";
    
    
    FieldDetailTableViewCell *cell = [[FieldDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:fieldDetailCell];

    
    if(indexPath.row == 0)
    {
        [cell setFieldNameFunction:fieldName];
    }else if(indexPath.row == 1)
    {
        [cell setFieldPictureFunction:picDatas andShopId:_shopId];
    }
    
    return cell;
}

#pragma mark -- UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    if(indexPath.row == 1)
    {
        CGFloat height = picDatas.count * (size.height * 0.3 + size.width * 0.05);
        return height;
    }else if(indexPath.row == 2)
    {
        return 60;
    }
    
    return DEFAULT_HEIGHT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0;
}
@end
