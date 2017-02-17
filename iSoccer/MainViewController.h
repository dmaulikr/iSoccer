//
//  MainViewController.h
//  iSoccer
//
//  Created by pfg on 15/10/29.
//  Copyright © 2015年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
- (void)updateMessageCount;
- (void)showLoginView:(BOOL)isAnimation;
- (void)showAllMemberByData:(NSMutableArray*)data andTime:(NSString*)time;
- (void)showRemarks:(NSString*)remarks;
- (void)changeBgColor:(NSString*)string;
@end
