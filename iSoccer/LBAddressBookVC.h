//
//  LBAddressBookVC.h
//  iSoccer
//
//  Created by pfg on 16/2/16.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBAddressBookVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSMutableArray *personArray;
@property (nonatomic, copy) NSString *jekAddressBookMessage;
@end
