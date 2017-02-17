//
//  ListUITableViewCell.h
//  iSoccer
//
//  Created by pfg on 15/10/27.
//  Copyright © 2015年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListUITableViewCell : UITableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withHeight:(CGFloat)height;

@property (nonatomic,strong)UIImageView *logoImage;

@property (nonatomic,strong)UILabel * titleLabel;

@end
