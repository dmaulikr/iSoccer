//
//  MemberScoreViewController.h
//  iSoccer
//
//  Created by pfg on 16/1/7.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberScoreViewController : UIViewController


- (instancetype)initWithMembers:(NSMutableArray*)members andGoals:(NSMutableArray*)goals andSumScore:(NSInteger)score andMatchId:(NSString*)matchId andMe:(BOOL)isMe;
@end
