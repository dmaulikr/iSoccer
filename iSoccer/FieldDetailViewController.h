//
//  FieldDetailViewController.h
//  iSoccer
//
//  Created by Linus on 16/8/5.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FieldDetailViewController : UIViewController

- (instancetype)initWithTitle:(NSString*)title andPicList:(NSMutableArray*)picList andFieldIconUrl:(NSString*)iconUrl andAddress:(NSString*)address andShopName:(NSString*)shopName andId:(NSString*)shopId andFieldId:(NSString*)fieldId;
@end
