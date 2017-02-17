//
//  CompetitionDetailViewController.h
//  iSoccer
//
//  Created by pfg on 16/5/19.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompetitionDetailViewController : UIViewController

- (instancetype)initWithData:(NSMutableDictionary*)data;

@property (nonatomic,strong)NSString * currentEventId;

@end
