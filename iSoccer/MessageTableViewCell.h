//
//  MessageTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/1/13.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isTitle:(NSString*)title;

@property (nonatomic,strong)UILabel *matchTypeLabel;
@property (nonatomic,strong)UILabel *matchNameLabel;
@property (nonatomic,strong)UILabel *matchScoreLabel;
@property (nonatomic,strong)UILabel *matchTimeLabel;

@end
