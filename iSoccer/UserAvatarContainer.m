//
//  UserAvatarContainer.m
//  iSoccer
//
//  Created by pfg on 15/12/28.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import "UserAvatarContainer.h"
#import <UIImageView+WebCache.h>
#define GAP 5

@implementation UserAvatarContainer
{
    NSMutableArray * memberAvatars;
}

- (instancetype)initWithFrame:(CGRect)frame andAvatar:(NSArray*)avatars
{
    self = [super initWithFrame:frame];
    if (self) {
        
        memberAvatars = [NSMutableArray array];
        
        if(!avatars)
            return self;
        
        
        CGFloat avatarWidth = (frame.size.width - GAP * 7) / 8;
        
        for(NSInteger i = 0;i < avatars.count;i++)
        {
            NSString * url = avatars[i];
            
            UIImageView * avatarIcon = [[UIImageView alloc]init];
            
            avatarIcon.layer.masksToBounds = YES;
            avatarIcon.layer.cornerRadius = 4;
            
            if(url && url.length > 0)
            {
                [avatarIcon sd_setImageWithURL:[NSURL URLWithString:avatars[i]]];
            }else{
                avatarIcon.image = [UIImage imageNamed:@"default_icon_head.jpg"];
            }
            avatarIcon.frame = CGRectMake(avatarWidth * i + GAP * i, (self.frame.size.height - avatarWidth), avatarWidth, avatarWidth);
            
            [self addSubview:avatarIcon];
            [memberAvatars addObject:avatarIcon];
            
        }
        
    }
    return self;
}

- (void)initAllMember{
    for(NSInteger i = 0;i < 8;i++)
    {
        UIImageView * memberAvatarIcon = memberAvatars[i];
        
        memberAvatarIcon.image = [UIImage imageNamed:@"default_icon_head.jpg"];
    }
}

- (void)setMember:(NSMutableArray*)members
{
    [self initAllMember];
    
    NSInteger sum = members.count;
    
    if(sum > 8)
    {
        sum = 8;
    }
    
    for(NSInteger i = 0;i < sum;i++)
    {
        UIImageView * memberAvatarIcon = memberAvatars[i];
        
        NSMutableDictionary * dic = members[i];
        
        NSString * url = [dic objectForKey:@"photo"];
        
        if([url rangeOfString:@".png"].location != NSNotFound || [url rangeOfString:@".jpg"].location != NSNotFound)
        {
            [memberAvatarIcon sd_setImageWithURL:[NSURL URLWithString:url]];
        }else{
            memberAvatarIcon.image = [UIImage imageNamed:@"default_icon_head.jpg"];
        }
    }
}


@end
