//
//  CompetitionViewController.m
//  iSoccer
//
//  Created by pfg on 16/5/19.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "CompetitionViewController.h"
#import "CompetitionTableViewCell.h"
#import "Global.h"
#import "CompetitionDetailViewController.h"

@interface CompetitionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    IBOutlet UITableView *competitionTableView;
    
    NSMutableArray * dataSource;
    
    
}

@end

@implementation CompetitionViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    competitionTableView.backgroundColor = [UIColor clearColor];
    competitionTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    dataSource = [Global getInstance].eventList;
    
    competitionTableView.dataSource = self;
    competitionTableView.delegate = self;
    
}

-(void)backMainView:(UIBarButtonItem*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString * competitionCell = @"competitionCell";
    
    CompetitionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:competitionCell];
    
    NSMutableDictionary * data = dataSource[indexPath.row];
    
    NSString * url = [data objectForKey:@"groupbuy_image"];
    
    
    
    if(!cell)
    {
        cell = [[CompetitionTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:competitionCell];
    }
    [Global loadImageFadeIn:cell.imageIcon andUrl:url isLoadRepeat:YES];
    
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    return size.height * 0.3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击;
    
    NSMutableDictionary * data = dataSource[indexPath.row];
    
    CompetitionDetailViewController * competitionDetailVC = [[CompetitionDetailViewController alloc]initWithData:data];
    
    [self.navigationController pushViewController:competitionDetailVC animated:YES];
}

@end
