//
//  FieldDetailTableViewCell.h
//  iSoccer
//
//  Created by Linus on 16/8/8.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FieldDetailTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


- (void)setFieldNameFunction:(NSString*)name;

- (void)setFieldPictureFunction:(NSMutableArray*)picList andShopId:(NSString*)shopId;


@end
