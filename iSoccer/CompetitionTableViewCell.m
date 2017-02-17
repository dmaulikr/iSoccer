//
//  CompetitionTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/5/19.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "CompetitionTableViewCell.h"
#import "Global.h"

#define H_GAP 30
#define V_GAP 30

@implementation CompetitionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        UIView * whiteBg = [[UIView alloc]initWithFrame:CGRectMake(H_GAP - 10, V_GAP - 10, size.width - (H_GAP - 10) * 2, size.height * 0.3 - (V_GAP - 10) * 2)];
        
        whiteBg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteBg];
        
        _imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(H_GAP, V_GAP, size.width - H_GAP*2, size.height * 0.3 - V_GAP*2)];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_imageIcon];
    }
    
    return self;
}

@end
