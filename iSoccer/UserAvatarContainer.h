//
//  UserAvatarContainer.h
//  iSoccer
//
//  Created by pfg on 15/12/28.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAvatarContainer : UIView

- (instancetype)initWithFrame:(CGRect)frame andAvatar:(NSArray*)avatars;

- (void)setMember:(NSMutableArray*)members;


@end
