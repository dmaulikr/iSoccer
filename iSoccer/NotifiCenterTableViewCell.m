//
//  NotifiCenterTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/1/26.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "NotifiCenterTableViewCell.h"

@implementation NotifiCenterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _noticeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 54, 54)];
        
        _noticeIcon.layer.masksToBounds = YES;
        _noticeIcon.layer.cornerRadius = 4;
        
        _noticeIcon.image = [UIImage imageNamed:@"default_team_icon.jpg"];
        
        [self.contentView addSubview:_noticeIcon];
        
        
        _noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_noticeIcon.frame.origin.x + _noticeIcon.frame.size.width + 6, _noticeIcon.frame.origin.y, size.width * 0.5, 27)];
        
        _noticeLabel.text = @"信蜂球队";
        
        _noticeLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
        _noticeLabel.font = [UIFont systemFontOfSize:16];
        
        [self.contentView addSubview:_noticeLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_noticeLabel.frame.origin.x + _noticeLabel.frame.size.width + 2, _noticeLabel.frame.origin.y, size.width - (_noticeLabel.frame.size.width + _noticeLabel.frame.origin.x), _noticeLabel.frame.size.height)];
        
        _timeLabel.text = @"2016-1-26";
        
        _timeLabel.textColor = _noticeLabel.textColor;
        _timeLabel.font = _noticeLabel.font;
        
        [self.contentView addSubview:_timeLabel];
        
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_noticeLabel.frame.origin.x, _noticeLabel.frame.origin.y + _noticeLabel.frame.size.height + 4, size.width - _noticeLabel.frame.origin.x, 27)];
        
        _contentLabel.text = @"下午纠纷等发达发大发的安抚大师范德萨发的啊是发大水发大水发的";
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_contentLabel];

    }
    return self;
}

@end
