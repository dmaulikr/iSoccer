//
//  NewNotifiCenterViewController.m
//  iSoccer
//
//  Created by pfg on 16/5/3.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "NewNotifiCenterViewController.h"
#import "LinusTableView.h"
#import "NewNotifiCellTableViewCell.h"
#import "Global.h"
#import "NetRequest.h"
#import "NetConfig.h"
#import "NetDataNameConfig.h"

@interface NewNotifiCenterViewController ()<LinusTableViewDelegate>
{
    LinusTableView * noticeTableView;
    
    NSMutableArray * dataSource;
    
    NSInteger pageNumber;
}

@end

@implementation NewNotifiCenterViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
        
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_DELETE_NOTICE object:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EVENT_DELETE_NOTICE object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary * post  = @{};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:ONE_KEY_READING parameters:postData atView:self.view andHUDMessage:nil success:^(id resposeObject) {
        NSLog(@"一键阅读成功!");
        
        [Global getInstance].userData.messageCount = 0;
    } failure:^(NSError *error) {
        NSLog(@"哈哈哈");
    }];
    
    pageNumber = 0;
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    
    dataSource = [Global getInstance].notifiList;
    
    noticeTableView = [[LinusTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    noticeTableView.tableView.backgroundColor = [UIColor clearColor];
    
    noticeTableView.backgroundColor = [UIColor clearColor];
    
    [noticeTableView setPageEnable:NO];
    
    noticeTableView.delegate = self;
    
    [self.view addSubview:noticeTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteNoticeHandler) name:EVENT_DELETE_NOTICE object:nil];
}

- (void)deleteNoticeHandler{
    
    NSString * currentDeleteId = [Global getInstance].currentDeleteNoticeId;
    
    for(NSInteger i = 0;i < dataSource.count;i++)
    {
        NSMutableDictionary * data = dataSource[i];
        NSString * noticeId = [data objectForKey:@"noticeId"];
        if([noticeId isEqualToString:currentDeleteId] == YES)
        {
            [dataSource removeObjectAtIndex:i];
            break;
        }
    }
    
    CGFloat currentY = noticeTableView.tableView.contentOffset.y;
    
    [noticeTableView reloadData];
    
    noticeTableView.tableView.contentOffset = CGPointMake(noticeTableView.tableView.contentOffset.x, currentY);
    
}


#pragma mark -- LinusTableViewDelegate

-(void)upload;
{
    //下一页
    
    pageNumber += 1;
    
    NSDictionary * post = @{@"pageNumber":[NSString stringWithFormat:@"%zd",pageNumber]};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:ALL_NOTICE parameters:postData atView:self.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
        NSString *code = resposeObject[@"code"];
        if(code.integerValue == 2)
        {
            [[Global getInstance].mainVC showLoginView:YES];
            
        }else{
            
            NSMutableArray * newData = resposeObject[NOTICE_LIST];
            [dataSource addObjectsFromArray:newData];
            
            
            CGPoint oldPoint = noticeTableView.tableView.contentOffset;
            
            [noticeTableView reloadData];
            
            noticeTableView.tableView.contentOffset = oldPoint;
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"报错");
    }];
    
    [noticeTableView endUpload];
}
-(void)refresh;
{
    //刷新
    pageNumber = 0;
    NSDictionary * post = @{@"pageNumber":[NSString stringWithFormat:@"%zd",pageNumber]};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:ALL_NOTICE parameters:postData atView:self.view andHUDMessage:@"获取中.." success:^(id resposeObject) {
        NSString *code = resposeObject[@"code"];
        if(code.integerValue == 2)
        {
            [[Global getInstance].mainVC showLoginView:YES];
            
        }else{
            
            NSMutableArray * newData = resposeObject[NOTICE_LIST];
            dataSource = newData;

            [noticeTableView reloadData];
 
        }
        
    } failure:^(NSError *error) {
        NSLog(@"报错");
    }];
    [noticeTableView endRefresh];
}
-(void)scrollViewEndScroll:(NSInteger)pageIndex;
{
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return dataSource.count;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *noticeCell = @"noticeCell";
    //显示图片;
  
    NewNotifiCellTableViewCell * notifiCell = [[NewNotifiCellTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:noticeCell andData:dataSource[indexPath.row]];
    
    return notifiCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
  
    return size.height * 0.05 + cell.bounds.size.height;
  
}




- (void)backMainView:(UIBarButtonItem*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
