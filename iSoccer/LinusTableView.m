//
//  LinusTableView.m
//  iSoccer
//
//  Created by pfg on 15/12/21.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import "LinusTableView.h"
#import "MJRefresh.h"

@implementation LinusTableView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self                                    = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = frame.size.height;
        
        _tableView.contentSize = frame.size;
        
        _tableView.bouncesZoom = NO;
        
        self.pageEnable = NO;
        
        if (YES) {
            [_tableView addHeaderWithTarget:self action:@selector(refresh)];
            [_tableView addFooterWithTarget:self action:@selector(upload)];
        }
        [self addSubview:_tableView];
    }
    return self;
}

- (void)setPageEnable:(BOOL)pageEnable{
    if(pageEnable == YES)
    {
        _tableView.pagingEnabled = YES;
    }else{
        _tableView.pagingEnabled = NO;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.delegate tableView:tableView numberOfRowsInSection:section];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [self.delegate tableView:tableView cellForRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
}
-(void)reloadData
{
    [_tableView reloadData];
}

-(void)refresh{
    [self.delegate refresh];
}

-(void)upload{
    
    [self.delegate upload];
}
-(void)endUpload{
    [_tableView footerEndRefreshing];
}
-(void)endRefresh{
    [_tableView headerEndRefreshing];
}
-(void)dealloc{
    NSLog(@"LinusTableView dealloc!");
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    
    
    /**
     round():如果参数是小数，对自身四舍五入
     ceil(): 如果参数是小数，则求最小整数，但不小于自身
     floor():如果参数是小数, 则求最大整数，但不大于自身
     */
    //根据偏移量和scrollView的宽度，计算出当前页
    
    self.currentPage = (NSInteger)round(scrollView.contentOffset.y / CGRectGetHeight(self.bounds));
    
    //NSLog(@"%lf",scrollView.contentOffset.y);
    //跟新pageControl
    //NSLog(@"page = %ld",self.currentPage);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(_tableView.pagingEnabled == NO)
    {
        return;
    }
    
    self.currentPage = (NSInteger)round(scrollView.contentOffset.y / CGRectGetHeight(self.bounds));
    
    [self.delegate scrollViewEndScroll:self.currentPage];
    
    [UIView animateWithDuration:0.1 animations:^{
        scrollView.contentOffset = CGPointMake(0,self.currentPage * _tableView.frame.size.height + _tableView.frame.size.height * 0.008 * self.currentPage);//修改正确移动位置BUG
    }];
    
    
}

@end



