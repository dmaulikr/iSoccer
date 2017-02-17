//
//  TitleSelecter.h
//  iSoccer
//
//  Created by pfg on 15/10/29.
//  Copyright © 2015年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleSelecter : UIView

- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray*)titles;

-(void)gotoSelecteByIndex:(NSInteger)page;

@end
