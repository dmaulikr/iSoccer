//
//  NoticeDetailTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/1/27.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "NoticeDetailTableViewCell.h"

@implementation NoticeDetailTableViewCell
{
    CGSize size;
    NSInteger _type;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(NSInteger)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        _type = type;
        size = [UIScreen mainScreen].bounds.size;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, size.width - 24, self.frame.size.height)];
        
        if(type == 0)
        {
            self.frame = CGRectMake(0, 0, size.width, 40);
            
            _contentLabel.font = [UIFont systemFontOfSize:20];
            
            _contentLabel.textColor = [UIColor blackColor];
            
        }else{
            self.frame = CGRectMake(0, 0, size.width, 250);
            
            _contentLabel.font = [UIFont systemFontOfSize:16];
            _contentLabel.textColor = [UIColor lightGrayColor];
        }
        
        _contentLabel.numberOfLines = 0;
        
        
        
        [self.contentView addSubview:_contentLabel];
        
    }
    return self;
    
}

- (void)setContentString:(NSString*)content{
    CGFloat height = [self heightForString:content fontSize:16 andWidth:size.width - 24] + 4;
    
    if(_type == 1)
    {
         _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, 4, size.width - 24, height);
        
        self.frame = CGRectMake(0, 0, size.width, _contentLabel.frame.size.height + 8);
        
    }
    _contentLabel.text = content;
}


//获得字符串的高度
-(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

@end
