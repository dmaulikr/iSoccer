//
//  EmptyTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/1/22.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setCreateButtonVisible:(BOOL)visible;
@end
