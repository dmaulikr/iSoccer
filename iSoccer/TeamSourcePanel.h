//
//  TeamSourcePanel.h
//  iSoccer
//
//  Created by pfg on 15/12/25.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamSourcePanel : UIView

- (instancetype)initWithSourceData:(NSMutableArray*)sourceData andNameData:(NSMutableDictionary*)nameData;

- (void)setData:(NSMutableArray*)sourceData andNameData:(NSMutableDictionary*)nameData;

@end
