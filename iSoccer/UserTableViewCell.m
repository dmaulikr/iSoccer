//
//  UserTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/1/4.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "UserTableViewCell.h"
#import "Global.h"
#import <UIImageView+WebCache.h>

@implementation UserTableViewCell
{
    UILabel * leftLabel;
    CGSize size;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        
        CGFloat height = self.contentView.frame.size.height;
        
        size = [UIScreen mainScreen].bounds.size;
        
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(size.width * 0.19 * 0.26, 0, size.width * 0.24, height)];
        
        leftLabel.textColor = [UIColor blackColor];
        leftLabel.font = [UIFont systemFontOfSize:17];
        
        [self.contentView addSubview:leftLabel];
        
        
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftLabel.frame.origin.x * 2 + leftLabel.frame.size.width, 0, size.width * 0.57, height)];
        
        if(height == 105)
        {
            _rightLabel.textAlignment = NSTextAlignmentLeft;
        }else{
            _rightLabel.textAlignment = NSTextAlignmentRight;
        }
        
        _rightLabel.textColor = [UIColor lightGrayColor];
        
        _rightLabel.numberOfLines = 0;
        
        _rightLabel.font = [UIFont systemFontOfSize:14];
        
        [_rightLabel setEnabled:NO];
        
        [self.contentView addSubview:_rightLabel];
        
        _arrowIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
        
        _arrowIcon.frame = CGRectMake(0, 0, leftLabel.frame.size.width * 0.16 - 8, leftLabel.frame.size.width * 0.16);
        _arrowIcon.center = CGPointMake(_rightLabel.frame.origin.x + _rightLabel.frame.size.width + _arrowIcon.frame.size.width/2 + 10, height/2);
        
        
        [self.contentView addSubview:_arrowIcon];
     
        _avatarIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, height - 10, height - 10)];
        
        
        _avatarIcon.contentMode = UIViewContentModeScaleAspectFill;
        
        _avatarIcon.autoresizingMask = UIViewAutoresizingNone;
        _avatarIcon.center = CGPointMake(_rightLabel.frame.origin.x + _rightLabel.frame.size.width - _avatarIcon.frame.size.width/2,height/2);
        
        _avatarIcon.layer.cornerRadius = _avatarIcon.frame.size.width/2;
        _avatarIcon.layer.masksToBounds = YES;
            
        [self.contentView addSubview:_avatarIcon];
    }
    
    return self;
    
}

- (void)setHeight:(CGFloat)height{
    leftLabel.frame = CGRectMake(size.width * 0.19 * 0.26, 0, size.width * 0.24, height);
    _rightLabel.frame = CGRectMake(leftLabel.frame.origin.x * 2 + leftLabel.frame.size.width, 0, size.width * 0.57, height);
    _avatarIcon.frame = CGRectMake(0, 0, height - 8, height - 8);
     _avatarIcon.center = CGPointMake(_rightLabel.frame.origin.x + _rightLabel.frame.size.width - _avatarIcon.frame.size.width/2,height/2);
    _arrowIcon.center = CGPointMake(_rightLabel.frame.origin.x + _rightLabel.frame.size.width + _arrowIcon.frame.size.width/2 + 10, height/2);
    _avatarIcon.layer.cornerRadius = _avatarIcon.frame.size.width/2;
    if(height != 82)
    {
        _avatarIcon.hidden = YES;
    }else{
        _avatarIcon.hidden = NO;
    }
}


- (void)setLeftString:(NSString*)string
{
    leftLabel.text = string;
}

- (void)setRightString:(NSString*)string
{
    _rightLabel.text = string;
}

@end
