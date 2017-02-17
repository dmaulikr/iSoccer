//
//  MemberTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/1/13.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isTitle:(NSString*)title;

@property (nonatomic,strong)UIImageView *userIcon;
@property (nonatomic,strong)UILabel *userNameLabel;
@property (nonatomic,strong)UILabel *userMatchLabel;
@end
