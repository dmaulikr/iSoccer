//
//  TeamSourcePanel.m
//  iSoccer
//
//  Created by pfg on 15/12/25.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import "TeamSourcePanel.h"
#import "NetDataNameConfig.h"

#define BG_W (size.width * 0.67)
#define BG_H (size.height * 0.18)

@implementation TeamSourcePanel
{
    UILabel * sourceA;
    UILabel * sourceB;
    
    UILabel * teamB;
    UILabel * teamA;
}
- (instancetype)initWithSourceData:(NSMutableArray *)sourceData andNameData:(NSMutableDictionary *)nameData{
    CGSize size = [UIScreen mainScreen].bounds.size;
    self = [super initWithFrame:CGRectMake(0, 0, BG_W, BG_H)];
    
    if(self)
    {
        UIView * bg = [[UIView alloc]initWithFrame:self.frame];
        bg.layer.masksToBounds = YES;
        
        bg.layer.cornerRadius = 6;
        bg.backgroundColor = [UIColor blackColor];
        bg.alpha = 0.4;
        
        [self addSubview:bg];
        
        sourceA = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height - self.frame.size.height * 0.18)];
        
        sourceA.textColor = [UIColor whiteColor];
        sourceA.font = [UIFont systemFontOfSize:70 weight:UIFontWeightBold];
        
        sourceA.text = sourceData[0];
        
        sourceA.textAlignment = NSTextAlignmentCenter;
        
        sourceA.center = CGPointMake(self.frame.size.width/4, (self.frame.size.height - self.frame.size.height * 0.18)/2);
        
        
        sourceB = [[UILabel alloc]initWithFrame:sourceA.frame];
        
        sourceB.textColor = [UIColor whiteColor];
        
        sourceB.textAlignment = NSTextAlignmentCenter;
        
        sourceB.font = sourceA.font;
        
        sourceB.text = sourceData[1];
        
        sourceB.center = CGPointMake(self.frame.size.width - self.frame.size.width/4, sourceA.center.y);
        
        [self addSubview:sourceA];
        [self addSubview:sourceB];
        
        UILabel * sourceSign = [[UILabel alloc]initWithFrame:sourceA.frame];
        
        sourceSign.text = @":";
        
        sourceSign.textColor = sourceA.textColor;
        
        sourceSign.textAlignment = sourceA.textAlignment;
        
        sourceSign.font = sourceA.font;
        
        sourceSign.center = CGPointMake(bg.center.x, sourceA.center.y - 4);
        
        [self addSubview:sourceSign];
        
        teamA = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, sourceA.frame.size.width, self.frame.size.height * 0.18)];
        
        teamA.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        
        teamA.textColor = sourceA.textColor;
        
        teamA.text = [nameData objectForKey:GAME_TEAM_A];
        
        teamA.textAlignment = NSTextAlignmentCenter;
        
        teamA.center = CGPointMake(sourceA.center.x, self.frame.size.height - self.frame.size.height * 0.18);
        
        [self addSubview:teamA];
        
        teamB = [[UILabel alloc]initWithFrame:teamA.frame];
        teamB.font = teamA.font;
        teamB.textColor = teamA.textColor;
        teamB.textAlignment = teamA.textAlignment;
        teamB.text = [nameData objectForKey:GAME_TEAM_B];
        teamB.center = CGPointMake(sourceB.center.x, teamA.center.y);
        [self addSubview:teamB];
        
    }
    
    return self;
    
}

- (void)setData:(NSMutableArray*)sourceData andNameData:(NSMutableDictionary*)nameData{
    sourceA.text = sourceData[0];
    sourceB.text = sourceData[1];
    
    teamA.text = [nameData objectForKey:@"AA"];
    teamB.text = [nameData objectForKey:@"BB"];
}

@end
