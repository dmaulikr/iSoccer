//
//  CompetitionTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/5/19.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompetitionTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;



@property (nonatomic,strong)UIImageView * imageIcon;

@end
