//
//  Base64.h
//  iSoccer
//
//  Created by pfg on 15/12/18.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface Base64 : NSObject

+ (BOOL) imageHasAlpha: (UIImage *) image;

+ (NSString *) imageToBase64: (UIImage *) image;

@end
