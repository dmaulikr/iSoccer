//
//  NotifiCenterTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/1/26.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifiCenterTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,strong)UIImageView *noticeIcon;
@property (nonatomic,strong)UILabel *noticeLabel;
@property (nonatomic,strong)UILabel * contentLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@end
