//
//  UserGoalData.m
//  iSoccer
//
//  Created by pfg on 16/1/11.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "UserGoalData.h"
#import "NetDataNameConfig.h"

@implementation UserGoalData


- (instancetype)initWithData:(NSMutableDictionary*)data
{
    self = [super init];
    if (self) {
        _userId = [data objectForKey:USER_ID];
        _matchId = [data objectForKey:MATCH_ID];
        _teamName = [data objectForKey:GAME_TEAM_A];
        _userName = [data objectForKey:USER_NAME];
        _goalId = [data objectForKey:GOAL_ID];
        
        NSNumber * count = [data objectForKey:GOAL_COUNT];
        _goalCount = count.integerValue;
    }
    return self;
}

@end
