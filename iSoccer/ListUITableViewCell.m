//
//  ListUITableViewCell.m
//  iSoccer
//
//  Created by pfg on 15/10/27.
//  Copyright © 2015年 iSoccer. All rights reserved.
//

#import "ListUITableViewCell.h"

#define LOCATION 0.42
#define GAP 0.48

@implementation ListUITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withHeight:(CGFloat)height
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        CGFloat thisHeight = height;
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, thisHeight, self.frame.size.width, 1)];
        
        line.backgroundColor = [UIColor colorWithRed:238/255.0f green:239/255.0f blue:240/255.0f alpha:1];
        
        //[self.contentView addSubview:line];
        
        _logoImage = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, thisHeight * LOCATION, thisHeight * LOCATION)];
        
        _logoImage.center = CGPointMake(thisHeight/2, thisHeight/2);
        
        [self.contentView addSubview:_logoImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(thisHeight * GAP + _logoImage.center.x + _logoImage.frame.size.width/2, 0, self.frame.size.width - _logoImage.center.x,thisHeight)];
        
        _titleLabel.textColor = [UIColor blackColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:_titleLabel];
        
    }
    
    return self;
}

@end
