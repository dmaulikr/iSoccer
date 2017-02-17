//
//  PayTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/1/29.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andHeight:(CGFloat)cellHeight;

@property (nonatomic,strong)UIImageView * cellIcon;

@property (nonatomic,strong)UILabel * cellLabel;

@property (nonatomic,strong)UILabel * moneyLabel;

@property (nonatomic,strong)UIView * accountBg;

@property (nonatomic,strong)UIView * logoBg;

@property (nonatomic,strong)UILabel * logoLabel;

@property (nonatomic,strong)NSString * accountId;

@property (nonatomic,strong)NSString * money;

@end
