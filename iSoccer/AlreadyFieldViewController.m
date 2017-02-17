//
//  AlreadyFieldViewController.m
//  iSoccer
//
//  Created by Linus on 16/8/11.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "AlreadyFieldViewController.h"
#import "AlreadyFieldTableViewCell.h"

#import "NetDataNameConfig.h"
#import "NetConfig.h"
#import "NetRequest.h"
#import "Global.h"
#import "FieldIndexViewController.h"
#import "FieldDetailViewController.h"
#import "OrderDetailViewController.h"
@interface AlreadyFieldViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * alreadyTableView;
    NSMutableArray * dataSource;
}

@end

@implementation AlreadyFieldViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_SHOW_FIELD_DETAIL_BY_ORDER object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_SHOW_FIELD_INDEX_BY_ORDER object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_REFRESH_ORDER object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_SHOW_ORDER_DETAIL object:nil];
}


- (instancetype)initWithData:(NSMutableArray*)data
{
    self = [super init];
    if (self) {
        dataSource = data;
        self.title = @"已预订球场";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1.0];
    
    
    alreadyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    
    alreadyTableView.backgroundColor = [UIColor clearColor];
    
    alreadyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    alreadyTableView.dataSource = self;
    alreadyTableView.delegate = self;
    
    [self.view addSubview:alreadyTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFieldDetailHandler:) name:EVENT_SHOW_FIELD_DETAIL_BY_ORDER object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFieldIndexHandler:) name:EVENT_SHOW_FIELD_INDEX_BY_ORDER object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshHandler:) name:EVENT_REFRESH_ORDER object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showOrderDetail:) name:EVENT_SHOW_ORDER_DETAIL object:nil];
}

- (void)showOrderDetail:(NSNotification*)notification
{
    NSMutableDictionary * data = [notification object];
    
    OrderDetailViewController * orderDetailVC = [[OrderDetailViewController alloc]initWithData:data];
    
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (void)refreshHandler:(NSNotification*)notification
{
    NSMutableDictionary * postData = [NSMutableDictionary dictionary];
    
    
    [NetRequest POST:GET_ORDER_LIST parameters:postData atView:self.view andHUDMessage:@"刷新中.." success:^(id resposeObject) {
        NSLog(@"%@",resposeObject);
        
        NSMutableArray * data = resposeObject[@"data"];
        dataSource = data;
        
        [alreadyTableView reloadData];
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
    
    NSString * shopIconUrl = [fieldData objectForKey:@"fieldLogo"];
    
    NSMutableArray * picList = [fieldData objectForKey:@"shopFieldImgList"];
        
    FieldDetailViewController * fieldDetailVC = [[FieldDetailViewController alloc]initWithTitle:fieldName andPicList:picList andFieldIconUrl:shopIconUrl andAddress:shopAddress andShopName:shopName andId:shopId andFieldId:fieldId];
        
    [self.navigationController pushViewController:fieldDetailVC animated:YES];
        
   
}



#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    static NSString * alreadyCell = @"alreadyCell";
    
    AlreadyFieldTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:alreadyCell];
    
    NSMutableDictionary * data = dataSource[indexPath.section];
    
 
    cell = [[AlreadyFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:alreadyCell andData:data];
    
    return cell;
}


#pragma mark -- UITableViewDelegate





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //CGSize size = [UIScreen mainScreen].bounds.size;
    
    return 250;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 6;
}

@end




