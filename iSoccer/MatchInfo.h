//
//  MatchInfo.h
//  iSoccer
//
//  Created by pfg on 16/1/20.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchInfo : NSObject
@property (nonatomic,strong)NSString * matchType;
@property (nonatomic,strong)NSString * matchName;
@property (nonatomic,strong)NSString * matchTime;
@property (nonatomic,strong)NSString * matchX;
@property (nonatomic,strong)NSString * matchY;
@property (nonatomic,strong)NSString * matchOpponent;
@property (nonatomic,strong)NSString * matchFormat;
@property (nonatomic,strong)NSString * matchCost;
@property (nonatomic,strong)NSString * matchColor;
@property (nonatomic,strong)NSString * addressName;

@property (nonatomic,strong)NSString * matchRemark;//备注;
@property (nonatomic,strong)NSString * cityName;
@end
