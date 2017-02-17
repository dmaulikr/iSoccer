//
//  RecordTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/1/6.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andHeight:(CGFloat)height photo:(NSMutableArray*)photoData;

- (void)setLeftString:(NSString*)string;
- (void)setRightString:(NSString*)string;
@property (nonatomic,strong)UIImageView * arrowIcon;
@property (nonatomic,strong)UIButton * uploadButton;
@end
