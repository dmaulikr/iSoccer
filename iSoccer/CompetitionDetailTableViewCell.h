//
//  CompetitionDetailTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/5/19.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompetitionDetailTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,strong)UIImageView * selectedIcon;

@property (nonatomic,strong)UIImageView * unselectedIcon;

@property (nonatomic,strong)UIImageView * headIcon;

@property (nonatomic,strong)UILabel * titleLabel;

@property (nonatomic,strong)UILabel * remarkLabel;

@property (nonatomic,strong)UILabel * noneLabel;


@property (assign,nonatomic)BOOL isNone;


@end
