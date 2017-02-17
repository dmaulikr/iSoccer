//
//  ReservationTableViewCell.h
//  iSoccer
//
//  Created by Linus on 16/8/4.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setFieldScrollData:(NSMutableArray*)datas;

- (void)setShopData:(NSMutableDictionary*)data;
@property (nonatomic,strong)UILabel * titleName;

@property (nonatomic,strong)UIImageView * titleImageView;

@property (nonatomic,strong)UIScrollView * fieldsScrollView; //三个球场显示;

@property (nonatomic,strong)NSString *fieldAddress;//球场地址名称

@property (nonatomic,strong)NSString *fieldIconUrl;//球场图标地址;

@end
