//
//  NoticeDetailTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/1/27.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeDetailTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(NSInteger)type;

@property (nonatomic,strong)UILabel * contentLabel;

- (void)setContentString:(NSString*)content;

@end
