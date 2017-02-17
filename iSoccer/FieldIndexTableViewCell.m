//
//  FieldIndexTableViewCell.m
//  iSoccer
//
//  Created by Linus on 16/8/9.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "FieldIndexTableViewCell.h"

#define DEFAULT_HEIGHT 44

@implementation FieldIndexTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(size.width * 0.1, 0, 20 , 20)];
        
        _imageIcon.center = CGPointMake(_imageIcon.center.x, DEFAULT_HEIGHT/2);
        
        [self.contentView addSubview:_imageIcon];
        
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imageIcon.frame.origin.x + _imageIcon.frame.size.width + 6, 0, size.width, DEFAULT_HEIGHT)];
        
        _messageLabel.center = CGPointMake(_messageLabel.center.x, DEFAULT_HEIGHT / 2);
        
        _messageLabel.text = @"哈哈哈啊哈哈";
        
        _messageLabel.font = [UIFont systemFontOfSize:16];
        
        _messageLabel.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:_messageLabel];
        
        
        
    }
    return self;
}

@end
