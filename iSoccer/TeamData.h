//
//  TeamData.h
//  iSoccer
//
//  Created by pfg on 16/1/12.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamData : NSObject

- (instancetype)initWithData:(NSMutableDictionary*)data;

@property (nonatomic,assign)NSInteger memberCount;
@property (nonatomic,assign)NSInteger winCount;
@property (nonatomic,assign)NSInteger matchCount;
@property (nonatomic,strong)NSString *teamName;
@property (nonatomic,strong)NSString *teamType;
@property (nonatomic,strong)NSString * teamId;
@property (nonatomic,strong)NSString *teamLogo;
@property (nonatomic,strong)NSString *teamHeadId;
@property (nonatomic,strong)NSString *registTime;//创建时间;
@property (nonatomic,strong)NSString * addTime;//加入时间;
@property (nonatomic,strong)NSString * remark;
@property (nonatomic,strong)NSString *teamLabel;
@property (nonatomic,strong)NSString *userTeamId;
@property (nonatomic,strong)NSString *teamCode;

@end
