//
//  MessageTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/1/13.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

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
            
            UIView *gameSign = [[UIView alloc]initWithFrame:CGRectMake(12, 12, 40, 18)];
            
            _matchTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, gameSign.frame.size.width, gameSign.frame.size.height)];
            _matchTypeLabel.font = [UIFont systemFontOfSize:12];
            _matchTypeLabel.textColor = [UIColor whiteColor];
            
            _matchTypeLabel.textAlignment = NSTextAlignmentCenter;
            [gameSign addSubview:_matchTypeLabel];
            
            gameSign.userInteractionEnabled = NO;
            
            gameSign.backgroundColor = [UIColor colorWithRed:(236.0/255.0) green:71.0/255.0 blue:57.0/255 alpha:1.0];
            
            [self.contentView addSubview:gameSign];
            
            _matchNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(gameSign.frame.origin.x + gameSign.frame.size.width + 6, gameSign.frame.origin.y, size.width - gameSign.frame.origin.x - gameSign.frame.size.width, 15)];
            _matchNameLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
            _matchNameLabel.textColor = [UIColor blackColor];
            
            [self.contentView addSubview:_matchNameLabel];
            
            _matchScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(gameSign.frame.origin.x, gameSign.frame.origin.y + gameSign.frame.size.height + 6, _matchNameLabel.frame.size.width/2, 13)];
            
            _matchScoreLabel.font = [UIFont systemFontOfSize:14];
            _matchScoreLabel.textColor = [UIColor blackColor];
            
            [self.contentView addSubview:_matchScoreLabel];
            
            _matchTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(size.width - 12 - _matchScoreLabel.frame.size.width, _matchScoreLabel.frame.origin.y, _matchScoreLabel.frame.size.width, _matchScoreLabel.frame.size.height)];
            
            _matchTimeLabel.font = [UIFont systemFontOfSize:14];
            _matchTimeLabel.textColor = [UIColor colorWithRed:134.0/255 green:134.0/255 blue:134.0/255 alpha:1.0];
            [self.contentView addSubview:_matchTimeLabel];
            
        }
        
    }
    return self;
}

@end
