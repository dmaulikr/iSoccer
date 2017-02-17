//
//  CreateTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/1/18.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "CreateTableViewCell.h"

@implementation CreateTableViewCell
{
    UILabel * leftLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andHeight:(CGFloat)height isHead:(BOOL)isHead{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(size.width * 0.19 * 0.26, 0, size.width * 0.24, height)];
        
        leftLabel.textColor = [UIColor blackColor];
        leftLabel.font = [UIFont systemFontOfSize:16];
        
        [self.contentView addSubview:leftLabel];
        
        
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftLabel.frame.origin.x * 2 + leftLabel.frame.size.width, 0, size.width * 0.57, height)];
        
        _rightLabel.textAlignment = NSTextAlignmentRight;
        
        if(height == 125)
        {
            _rightLabel.textAlignment = NSTextAlignmentLeft;
        }
        
        _rightLabel.numberOfLines = 0;

        _rightLabel.textColor = [UIColor lightGrayColor];
        _rightLabel.font = [UIFont systemFontOfSize:14];
        
        [_rightLabel setEnabled:NO];
        
        
        [self.contentView addSubview:_rightLabel];
        
        _arrowIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
        
        _arrowIcon.frame = CGRectMake(0, 0, leftLabel.frame.size.width * 0.16 - 8, leftLabel.frame.size.width * 0.16);
        _arrowIcon.center = CGPointMake(_rightLabel.frame.origin.x + _rightLabel.frame.size.width + _arrowIcon.frame.size.width/2 + 10, height/2);
        
        [self.contentView addSubview:_arrowIcon];
        
        if(isHead == YES)
        {
            _avatarIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, height - 8, height - 8)];
            
            _avatarIcon.center = CGPointMake(_rightLabel.frame.origin.x + _rightLabel.frame.size.width - _avatarIcon.frame.size.width/2,height/2);
            
            _avatarIcon.layer.masksToBounds = YES;
            _avatarIcon.layer.cornerRadius = 8;
            
            [self.contentView addSubview:_avatarIcon];
        }
        
        
    }
    
    return self;
    
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
