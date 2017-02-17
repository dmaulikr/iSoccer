//
//  CALayer+BorderColor.m
//  iSoccer
//
//  Created by pfg on 15/12/22.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import "CALayer+BorderColor.h"

@implementation CALayer (BorderColor)

- (UIColor *)borderColorFromUIColor {
    
    return self.borderColorFromUIColor;
    
}

-(void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}


@end
