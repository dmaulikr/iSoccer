//
//  CompetitionDetailTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/5/19.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "CompetitionDetailTableViewCell.h"

#define H_GAP 6
@implementation CompetitionDetailTableViewCell
{
    CGFloat cellHeight;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _isNone = NO;
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        cellHeight = size.height * 0.1;
        
        _unselectedIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cellHeight * 0.4, cellHeight * 0.4)];
        
        _unselectedIcon.image = [UIImage imageNamed:@"comp_unsele.png"];
        
        _unselectedIcon.center = CGPointMake(H_GAP + _unselectedIcon.frame.size.width/2, cellHeight/2);
        [self.contentView addSubview:_unselectedIcon];
        
        _selectedIcon = [[UIImageView alloc]initWithFrame:_unselectedIcon.frame];
        
        _selectedIcon.image = [UIImage imageNamed:@"comp_sele.png"];
        
        _selectedIcon.center = CGPointMake(_unselectedIcon.center.x, _unselectedIcon.center.y);
        
        _selectedIcon.hidden = YES;
        
        [self.contentView addSubview:_selectedIcon];
        
        
        _headIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cellHeight * 0.5, cellHeight * 0.5)];
        
        _headIcon.center = CGPointMake(_selectedIcon.center.x + _selectedIcon.frame.size.width/2 + H_GAP/2 + _headIcon.frame.size.width/2, _selectedIcon.center.y);
        
        _headIcon.layer.masksToBounds = YES;
        _headIcon.layer.cornerRadius = _headIcon.frame.size.width/2;
        
        [self.contentView addSubview:_headIcon];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headIcon.frame.origin.x + _headIcon.frame.size.width + H_GAP, _headIcon.frame.origin.y, size.width * 0.55, _headIcon.frame.size.height / 2)];
        
        _titleLabel.text = @"我是队长";
        
        _titleLabel.textColor = [UIColor lightGrayColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:_titleLabel];
        
        _remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height, _titleLabel.frame.size.width, _titleLabel.frame.size.height)];
        
        _remarkLabel.text = @"(带领自己球队参加比赛)";
        
        _remarkLabel.textColor = [UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0];
        
        _remarkLabel.font = [UIFont systemFontOfSize:11];
        
        [self.contentView addSubview:_remarkLabel];
        
        _noneLabel = [[UILabel alloc]initWithFrame:CGRectMake(_selectedIcon.frame.origin.x *2, 0, size.width * 0.85 - _selectedIcon.frame.origin.x * 4, cellHeight)];
        
        _noneLabel.textColor = [UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0];
        
        _noneLabel.numberOfLines = 0;
        
        _noneLabel.font = [UIFont systemFontOfSize:11];
        
        _noneLabel.hidden = YES;
        
        [self.contentView addSubview:_noneLabel];
        
        
        [self addShapeByPreView:self];
    }
    return self;
}

//画虚线;
- (void)addShapeByPreView:(UIView*)view{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:6],
      [NSNumber numberWithInt:3],nil]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, 0,cellHeight);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [self.contentView.layer addSublayer:shapeLayer];
}


@end
