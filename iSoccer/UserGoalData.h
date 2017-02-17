//
//  UserGoalData.h
//  iSoccer
//
//  Created by pfg on 16/1/11.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserGoalData : NSObject

@property (nonatomic,strong)NSString * userId;
@property (nonatomic,strong)NSString * matchId;
@property (nonatomic,strong)NSString * teamName;
@property (nonatomic,strong)NSString * userName;
@property (nonatomic,strong)NSString * goalId;
@property (nonatomic,assign)NSInteger goalCount;

- (instancetype)initWithData:(NSMutableDictionary*)data;

@end
