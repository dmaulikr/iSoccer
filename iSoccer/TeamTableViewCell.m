//
//  TeamTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/1/12.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "TeamTableViewCell.h"

@implementation TeamTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        self.frame = CGRectMake(0, 0, size.width, 116);
        
        _teamIcon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 58, 58)];
        
        _teamIcon.image = [UIImage imageNamed:@"default_team_icon.jpg"];
        
        _teamIcon.layer.masksToBounds = YES;
        _teamIcon.contentMode = UIViewContentModeScaleAspectFill;
        _teamIcon.autoresizingMask = UIViewAutoresizingNone;
        
        _teamIcon.layer.cornerRadius = _teamIcon.frame.size.width/2;
        
        [self.contentView addSubview:_teamIcon];
        
        _teamTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_teamIcon.frame.origin.x + _teamIcon.frame.size.width + 12, 12, self.frame.size.width - (_teamIcon.frame.origin.x + _teamIcon.frame.size.width), 18)];
        
        _teamTitleLabel.text = @"信蜂";
        
        _teamTitleLabel.textColor = [UIColor blackColor];
        
        _teamTitleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        
        [self.contentView addSubview:_teamTitleLabel];
        
        _teamLabel = [[UILabel alloc]initWithFrame:CGRectMake(_teamTitleLabel.frame.origin.x, _teamTitleLabel.frame.origin.y +_teamTitleLabel.frame.size.height + 6, self.frame.size.width - (_teamIcon.frame.origin.x + _teamIcon.frame.size.width), 13)];
        
        _teamLabel.text = @"高新区域9号楼";
        
        _teamLabel.textColor = [UIColor blackColor];
        
        _teamLabel.font = [UIFont systemFontOfSize:16];
        
        [self.contentView addSubview:_teamLabel];
        
        _teamDisLabel = [[UILabel alloc]initWithFrame:CGRectMake(_teamLabel.frame.origin.x, _teamLabel.frame.origin.y + _teamLabel.frame.size.height + 6, self.frame.size.width - (_teamIcon.frame.origin.x + _teamIcon.frame.size.width), 13)];
        
        _teamDisLabel.text = @"一直成熟的队伍";
        
        _teamDisLabel.textColor = [UIColor lightGrayColor];
        
        _teamDisLabel.font = [UIFont systemFontOfSize:16];
        
        [self.contentView addSubview:_teamDisLabel];
        
        
        _teamSumMatchLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 92, 18)];
        
        _teamSumMatchLabel.center = CGPointMake(size.width/2 - size.width/3, 116 - 12 - _teamSumMatchLabel.frame.size.height / 2);
        
        _teamSumMatchLabel.textAlignment = NSTextAlignmentCenter;
        
        _teamSumMatchLabel.textColor = [UIColor colorWithRed:132.0/255 green:132.0/255 blue:132.0/255 alpha:1.0];
        
        _teamSumMatchLabel.font = [UIFont systemFontOfSize:14];
        
        _teamSumMatchLabel.backgroundColor = [UIColor whiteColor];
        
        _teamSumMatchLabel.layer.borderWidth = 0.5;
        
        _teamSumMatchLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _teamSumMatchLabel.layer.masksToBounds = YES;
        
        _teamSumMatchLabel.layer.cornerRadius = 9;
        
        [self.contentView addSubview:_teamSumMatchLabel];
        
        _teamWinLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, _teamSumMatchLabel.frame.size.height)];
        _teamWinLabel.textAlignment = NSTextAlignmentCenter;
        _teamWinLabel.textColor = _teamSumMatchLabel.textColor;
        
        _teamWinLabel.font = _teamSumMatchLabel.font;
        
        _teamWinLabel.center = CGPointMake(size.width/2, _teamSumMatchLabel.center.y);
        
        _teamWinLabel.backgroundColor = _teamSumMatchLabel.backgroundColor;
        
        _teamWinLabel.layer.borderWidth = _teamSumMatchLabel.layer.borderWidth;
        
        _teamWinLabel.layer.borderColor = _teamSumMatchLabel.layer.borderColor;
        
        _teamWinLabel.layer.masksToBounds = YES;
        
        _teamWinLabel.layer.cornerRadius = _teamSumMatchLabel.layer.cornerRadius;
        
        [self.contentView addSubview:_teamWinLabel];
        
        
        _teamMemberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, _teamWinLabel.frame.size.height)];
        _teamMemberLabel.textAlignment = NSTextAlignmentCenter;
        
        _teamMemberLabel.textColor = _teamSumMatchLabel.textColor;
        
        _teamMemberLabel.font = _teamSumMatchLabel.font;
        
        _teamMemberLabel.center = CGPointMake(size.width/2 + size.width/3, _teamSumMatchLabel.center.y);
        _teamMemberLabel.backgroundColor = [UIColor whiteColor];
        _teamMemberLabel.layer.borderWidth = 0.5;
        _teamMemberLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _teamMemberLabel.layer.masksToBounds = YES;
        _teamMemberLabel.layer.cornerRadius = 9;
        
        [self.contentView addSubview:_teamMemberLabel];
        
        
    }
    return self;
}

@end
