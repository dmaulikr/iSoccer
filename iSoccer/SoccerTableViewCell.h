//
//  SoccerTableViewCell.h
//  iSoccer
//
//  Created by pfg on 15/12/21.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoccerTableViewCell : UITableViewCell


- (void)setViewData:(NSDictionary*)data andIsMe:(BOOL)isMe;

@property (nonatomic,strong)UILabel * weatherLabel;
@end
