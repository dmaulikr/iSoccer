//
//  MemberGoalTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/1/11.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberGoalTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andRow:(NSInteger)row;

@property (nonatomic,strong)UILabel * memberLabel;

@property (nonatomic,strong)UILabel * goalLabel;

@property (nonatomic,strong)UIButton * deleteButton;

@end
