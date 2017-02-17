//
//  ApplyTableViewCell.h
//  iSoccer
//
//  Created by pfg on 16/5/20.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andHeight:(CGFloat)height isUpload:(BOOL)upload;

@property (nonatomic,strong)UILabel * leftLabel;
@property (nonatomic,strong)UITextField * rightLabel;

@property (nonatomic,strong)UIImageView * arrowIcon;

@property (nonatomic,strong)UIImageView * frontIdCardImage;
@property (nonatomic,strong)UIImageView * backIdCardImage;

@end
