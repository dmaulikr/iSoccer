//
//  NotifiCenterDetailViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/26.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "NotifiCenterDetailViewController.h"
#import "NoticeDetailTableViewCell.h"


@interface NotifiCenterDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * detailTabelView;
    NSString * noticeTitle;
    NSString * noticeContent;
    NSString * noticeTime;
}

@end

@implementation NotifiCenterDetailViewController

- (instancetype)initWithData:(NSMutableDictionary*)data
{
    self = [super init];
    if (self) {
        
        self.title = @"详情";
        
        noticeTitle = [data objectForKey:@"noticeTitle"];
        noticeContent = [data objectForKey:@"noticeContent"];
        noticeTime = [data objectForKey:@"noticeTime"];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    detailTabelView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    detailTabelView.sectionFooterHeight = 1.0;
    
    detailTabelView.dataSource = self;
    detailTabelView.delegate = self;
    
    detailTabelView.separatorInset = UIEdgeInsetsMake(0,12, 0, 12);        // 设置端距，这里表示separator离左边和右边均80像素
    
    detailTabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    [self.view addSubview:detailTabelView];
}




#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"noticeDetailCell";
    
    NoticeDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell)
    {
        cell = [[NoticeDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier withType:indexPath.row];
    }
    if(indexPath.row == 0)
    {
        [cell setContentString:noticeTitle];
    }else{
        [cell setContentString:noticeContent];
    }
    return cell;
}

#pragma mark -- UITableViewDelegate
//设置间隔高度;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeDetailTableViewCell *cell = (NoticeDetailTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

@end
