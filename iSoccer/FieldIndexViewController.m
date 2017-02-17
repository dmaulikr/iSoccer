//
//  FieldIndexViewController.m
//  iSoccer
//
//  Created by Linus on 16/8/9.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "FieldIndexViewController.h"

#import "FieldIndexTableViewCell.h"

#import "Global.h"
#import "NetRequest.h"
#import "NetConfig.h"
#import "FieldDetailViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define FIELD_TAG 200

#define SYSTEM_VERSION_LESS_THAN [[UIDevice currentDevice] systemVersion]

@interface FieldIndexViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView * fieldIndexTableView;
    
    NSArray * iconDataSource;
    NSArray * messageDataSource;
    
    NSMutableDictionary * _shopData;
    
    NSMutableArray * fieldsData;
    
    
}

@end

@implementation FieldIndexViewController


- (instancetype)initWithData:(NSMutableDictionary*)shopData
{
    self = [super init];
    if (self) {
        
        NSString * shopName = [shopData objectForKey:@"shopName"];
        
        self.title = shopName;
        
        _shopData = shopData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    iconDataSource = @[@"address.png",@"tel.png"];
    
    NSString * shopAdress = [_shopData objectForKey:@"shopAddress"];
    
    NSString * shopText = [NSString stringWithFormat:@"地址: %@",shopAdress];
    
    NSString * shopTel = [_shopData objectForKey:@"shopTelephone"];
    
    NSString * shopTelText = [NSString stringWithFormat:@"电话: %@",shopTel];
    
    messageDataSource =  @[shopText,shopTelText];
    
    fieldIndexTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    
    fieldIndexTableView.delegate = self;
    fieldIndexTableView.dataSource = self;
    
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.3)];
    
    UIImageView * headerImageView = [[UIImageView alloc]initWithFrame:headerView.frame];
    
    [headerImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    headerImageView.contentMode =  UIViewContentModeScaleAspectFill;
    headerImageView.autoresizingMask = UIViewAutoresizingNone;
    headerImageView.clipsToBounds  = YES;
    
    NSString * imageUrl = [_shopData objectForKey:@"shopUrl"];
    
    [Global loadImageFadeIn:headerImageView andUrl:imageUrl isLoadRepeat:YES];
    
    [headerView addSubview:headerImageView];
    
    fieldIndexTableView.tableHeaderView = headerView;
    
    fieldsData = [_shopData objectForKey:@"fieldList"];
    
    
    NSInteger col;
    
    if(fieldsData.count % 2 == 0)
    {
        col = fieldsData.count / 2;
    }else{
        col = fieldsData.count / 2 + 1;
    }
    
    CGFloat gap = (self.view.frame.size.width - self.view.frame.size.width * 0.9) / 3;
    
    //CGFloat imageWidth = self.view.frame.size.width * 0.85;
    
    CGFloat imageHeight = self.view.frame.size.height * 0.26;
    
    CGFloat footViewHeight = imageHeight * col + gap * (col - 1);

    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, footViewHeight + 40)];
    
    
    for(NSInteger i = 0; i < fieldsData.count;i ++)
    {
        UIView * view = [self createFieldByData:fieldsData[i]];
        
        NSInteger index = i % 2;
        
        NSInteger indexCol;
        if(index == 0)
        {
            indexCol = i / 2;
        }else{
            indexCol = i / 2;
        }
        
        view.center = CGPointMake(view.frame.size.width/2 + gap + view.frame.size.width * index + index * gap, view.frame.size.height/2 + indexCol * gap + indexCol * view.frame.size.height);
        
        view.userInteractionEnabled = YES;
        
        view.tag = FIELD_TAG + i;
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFieldHandler:)];
        [view addGestureRecognizer:tapGesture];
        
        [footerView addSubview:view];
    }
    
    fieldIndexTableView.tableFooterView = footerView;
    
    [self.view addSubview:fieldIndexTableView];

}


- (void)tapFieldHandler:(UITapGestureRecognizer*)gesture{
    
    NSInteger index = gesture.view.tag - FIELD_TAG;
    
    
    NSMutableDictionary * currentData = fieldsData[index];
    
    
    NSString * shopName = [_shopData objectForKey:@"shopName"];
    
    [currentData setValue:shopName forKey:@"shopName"];
    
    NSString * address = [_shopData objectForKey:@"shopAddress"];
    
    [currentData setValue:address forKey:@"shopAddress"];
    
    
    NSString * fieldId = [currentData objectForKey:@"fieldId"];
    
    NSString * fieldName = [currentData objectForKey:@"fieldName"];
    
    NSString * shopAddress = [currentData objectForKey:@"shopAddress"];
    
    NSString * shopId = [currentData objectForKey:@"shopId"];
    
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


- (UIView*)createFieldByData:(NSMutableDictionary*)data{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width * 0.9 / 2, size.height* 0.26 )];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView  * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, view.frame.size.width - 12, view.frame.size.height * 0.66)];
    
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingNone;
    imageView.clipsToBounds  = YES;
    
    NSString * imgUrl = [data objectForKey:@"fieldImage"];
    
    [Global loadImageFadeIn:imageView andUrl:imgUrl isLoadRepeat:YES];
    
    [view addSubview:imageView];
    
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, imageView.frame.origin.y + imageView.frame.size.height + 6, imageView.frame.size.width, view.frame.size.height * 0.1)];
    
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor blackColor];
    
    NSString * fieldName = [data objectForKey:@"fieldName"];
    
    nameLabel.text = fieldName;
    
    [view addSubview:nameLabel];
    
    
    UILabel * costLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, nameLabel.frame.origin.y + nameLabel.frame.size.height + 4, imageView.frame.size.width, view.frame.size.height * 0.1)];
    
    
    costLabel.font = [UIFont systemFontOfSize:14];
    
    costLabel.textColor = [UIColor orangeColor];
    
    NSNumber * minPrice = [data objectForKey:@"minPrice"];
    
    NSNumber * maxPrice = [data objectForKey:@"maxPrice"];
    
    costLabel.text = [NSString stringWithFormat:@"%zd - %zd元/场",minPrice.integerValue,maxPrice.integerValue];
    
    [view addSubview:costLabel];
    
    return view;
    
}


#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1)
    {
        //点击确认;
        NSString * tel = [_shopData objectForKey:@"shopTelephone"];
        NSString * url = [NSString stringWithFormat:@"tel:%@",tel];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
        
    }
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *fieldIndexCell = @"fieldIndexCell";
    
    FieldIndexTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:fieldIndexCell];
    
    if(!cell)
    {
        cell = [[FieldIndexTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:fieldIndexCell];
    }
    
    
    NSString * icon = iconDataSource[indexPath.row];
    NSString * message = messageDataSource[indexPath.row];
    
    cell.imageIcon.image = [UIImage imageNamed:icon];
    
    cell.messageLabel.text = message;
    
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    NSString * locationX = [_shopData objectForKey:@"shopLat"];
    
    NSString * locationY = [_shopData objectForKey:@"shopLng"];
    
    NSString * tel = [_shopData objectForKey:@"shopTelephone"];
    
    
    
    if(indexPath.row == 0)
    {
        NSLog(@"%@ , %@",locationX,locationY);
        
        [self showMapToGps:locationX andY:locationY];
    }else{
        
        UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"拨打商家电话" message:[NSString stringWithFormat:@"%@",tel] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
        [alerView show];
    }
}

- (void)showMapToGps:(NSString*)locationX andY:(NSString*)locationY{
    
    CGFloat userMatchX = [Global getInstance].userMatchX;
    CGFloat userMatchY = [Global getInstance].userMatchY;
    
    
    CGFloat matchX = locationX.floatValue;
    
    CGFloat matchY = locationY.floatValue;
    
    if ([SYSTEM_VERSION_LESS_THAN compare:@"6.0"] == 0) { // ios6以下，调用高德 map
        
        NSString * urlString = [NSString stringWithFormat:@""@"http://m.amap.com/?from=%g,%g(from)&to=%g,%g(to)",userMatchX,userMatchY,matchX,matchY];
        
        NSURL *aURL = [NSURL URLWithString:urlString];
        
        [[UIApplication sharedApplication] openURL:aURL];
        
    } else { // 直接调用ios自己带的apple map
        
        CLLocationCoordinate2D to;
        
        to.latitude = matchX;
        
        to.longitude = matchY;
        
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
        
        toLocation.name = @"球场";
        
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    }
}


@end
