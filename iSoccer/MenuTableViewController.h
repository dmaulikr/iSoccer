//
//  MenuTableViewController.h
//  iSoccer
//
//  Created by pfg on 15/10/28.
//  Copyright © 2015年 iSoccer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
- (void)updateMessageCount;

@end
