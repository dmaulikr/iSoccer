//
//  MemberTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/1/13.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "MemberTableViewCell.h"

@implementation MemberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isTitle:(NSString*)title
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if([title compare:@""] != 0)
        {
            UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, size.width - 12, 40)];
            titleLabel.text = title;
            
            titleLabel.font = [UIFont systemFontOfSize:18];
            
            titleLabel.textColor = [UIColor blackColor];
            
            [self.contentView addSubview:titleLabel];
        }else{
            
            _userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 8, 50, 50)];
            
            _userIcon.image = [UIImage imageNamed:@"default_icon_head.jpg"];
            
            _userIcon.layer.masksToBounds = YES;
            _userIcon.layer.cornerRadius = _userIcon.frame.size.height/2;
            
            [self.contentView addSubview:_userIcon];
            
            _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_userIcon.frame.origin.x + _userIcon.frame.size.width + 12, 0, 70, 66)];
            
            _userNameLabel.textColor = [UIColor blackColor];
            
            _userNameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
            
            _userNameLabel.text = @"张伟";
            
            [self.contentView addSubview:_userNameLabel];
            
            _userMatchLabel = [[UILabel alloc]initWithFrame:CGRectMake(_userNameLabel.frame.origin.x + _userNameLabel.frame.size.width + 10, 0, size.width - _userNameLabel.frame.origin.x + _userNameLabel.frame.size.width, 66)];
            
            _userMatchLabel.textColor = [UIColor lightGrayColor];
            
            _userMatchLabel.font = [UIFont systemFontOfSize:15];
            
            [self.contentView addSubview:_userMatchLabel];
        }
        
    }
    return self;
}


@end
