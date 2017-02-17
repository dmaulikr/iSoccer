//
//  TeamData.m
//  iSoccer
//
//  Created by pfg on 16/1/12.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "TeamData.h"

@implementation TeamData

- (instancetype)initWithData:(NSMutableDictionary*)data
{
    self = [super init];
    if (self) {
        NSNumber * memberCount = [data objectForKey:@"memberCount"];
        _memberCount = memberCount.integerValue;
        NSNumber * winCount = [data objectForKey:@"winCount"];
        _winCount = winCount.integerValue;
        NSNumber * matchCount = [data objectForKey:@"matchCount"];
        _matchCount = matchCount.integerValue;
        
        _teamName = [data objectForKey:@"teamName"];
        
        _teamType = [data objectForKey:@"userType"];
        
        _teamId = [data objectForKey:@"teamId"];
        
        _teamLogo = [data objectForKey:@"teamLogo"];
        
        _teamHeadId = [data objectForKey:@"userId"];
        
        _registTime = [data objectForKey:@"registTime"];
        
        _userTeamId = [data objectForKey:@"userTeamId"];
        
        _remark = [data objectForKey:@"teamRemark"];
        
        _teamLabel = [data objectForKey:@"teamLabel"];
        
        _addTime = [data objectForKey:@"addTime"];
        
        _teamCode = [data objectForKey:@"teamCode"];
    }
    return self;
}

@end
