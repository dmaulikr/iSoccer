//
//  LinusTableView.h
//  iSoccer
//
//  Created by pfg on 15/12/21.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LinusTableViewDelegate <NSObject>
-(void)upload;
-(void)refresh;
-(void)scrollViewEndScroll:(NSInteger)pageIndex;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface LinusTableView : UIView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>


@property (nonatomic,assign)NSInteger currentPage;

@property (nonatomic,assign)BOOL pageEnable;


@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,assign)id<LinusTableViewDelegate> delegate;

-(void)reloadData;
-(void)endUpload;
-(void)endRefresh;

@end
