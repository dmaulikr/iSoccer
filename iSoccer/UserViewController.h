//
//  UserViewController.h
//  iSoccer
//
//  Created by pfg on 16/1/4.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController
- (instancetype)initWithData:(NSMutableDictionary*)data andIsMe:(BOOL)isMe isMainEnter:(BOOL)isMain andIsMeTeam:(BOOL)isMeTeam;
@end
