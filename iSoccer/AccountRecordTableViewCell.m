//
//  AccountRecordTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/2/2.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "AccountRecordTableViewCell.h"
#import "Global.h"

@implementation AccountRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 0, size.width/2 - 4, 20)];
        
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
        
        _titleLabel.textColor = [UIColor blackColor];
        
        _titleLabel.text = @"场地费支付";
        
        [self.contentView addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, _titleLabel.frame.size.height, size.width/2 - 4, 40)];
        
        _timeLabel.numberOfLines = 0;
        
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        
        NSString * time = [Global getDateByTime:@"1454323759" isSimple:NO];
        
        NSString * address = @"足球俱乐部";
        
        _timeLabel.text = [NSString stringWithFormat:@"%@\n%@",time,address];
        
        [self.contentView addSubview:_timeLabel];
        
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.size.width, 0, size.width/2, 60)];
        
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        
        _moneyLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
        
        _moneyLabel.textColor = [UIColor blackColor];
        
        _moneyLabel.text = @"+ 68.00元";
        
        [self.contentView addSubview:_moneyLabel];
        
    }
    return self;
}

@end
