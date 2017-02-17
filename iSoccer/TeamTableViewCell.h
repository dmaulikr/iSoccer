//
//  TeamTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/1/12.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView * teamIcon;

@property (nonatomic,strong)UILabel * teamTitleLabel;

@property (nonatomic,strong)UILabel * teamLabel;//标签;

@property (nonatomic,strong)UILabel * teamDisLabel;//描述;

@property (nonatomic,strong)UILabel * teamSumMatchLabel;

@property (nonatomic,strong)UILabel * teamWinLabel;

@property (nonatomic,strong)UILabel * teamMemberLabel;

@end
