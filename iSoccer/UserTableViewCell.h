//
//  UserTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/1/4.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setLeftString:(NSString*)string;
- (void)setRightString:(NSString*)string;

- (void)setHeight:(CGFloat)height;

@property (nonatomic,strong)UIImageView * arrowIcon;

@property (nonatomic,strong)UILabel * rightLabel;

@property (nonatomic,strong)UIImageView * avatarIcon;

@end
