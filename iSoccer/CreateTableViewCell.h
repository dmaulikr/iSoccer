//
//  CreateTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/1/18.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andHeight:(CGFloat)height isHead:(BOOL)isHead;

- (void)setLeftString:(NSString*)string;
- (void)setRightString:(NSString*)string;

@property (nonatomic,strong)UIImageView * arrowIcon;
@property (nonatomic,strong)UIImageView * avatarIcon;

@property (nonatomic,strong)UILabel * rightLabel;

@end
