//
//  MemberGoalTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/1/11.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "MemberGoalTableViewCell.h"
#import "NetDataNameConfig.h"

@implementation MemberGoalTableViewCell
{
    NSInteger _row;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andRow:(NSInteger)row
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _row = row;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        _memberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        
        _memberLabel.textColor = [UIColor blackColor];
        
        _memberLabel.font = [UIFont systemFontOfSize:16];
        
        _memberLabel.textAlignment = NSTextAlignmentCenter;
        
        _memberLabel.center = CGPointMake(20 + _memberLabel.frame.size.width/2, _memberLabel.frame.size.height/2);
        
        [self.contentView addSubview:_memberLabel];
        
        
        _goalLabel = [[UILabel alloc]initWithFrame:_memberLabel.frame];
        
        _goalLabel.textColor = _memberLabel.textColor;
        
        _goalLabel.font = _memberLabel.font;
        
        _goalLabel.textAlignment = _memberLabel.textAlignment;
        
        _goalLabel.center = CGPointMake(size.width/2, _goalLabel.center.y);
        
        [self.contentView addSubview:_goalLabel];
        
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(0, 0, 20, 26);
        
        [_deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        
        _deleteButton.center = CGPointMake(size.width - 20 - _deleteButton.frame.size.width/2, _memberLabel.frame.size.height/2);
        [_deleteButton addTarget:self action:@selector(tapedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_deleteButton];
        
        
        
    }
    return self;
}
-(void)tapedDeleteButton:(UIButton*)sender{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_DELETE_SCORE object:[NSString stringWithFormat:@"%zd",_row]];
}

@end
