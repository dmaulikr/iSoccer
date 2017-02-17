//
//  Base64.m
//  iSoccer
//
//  Created by pfg on 15/12/18.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import "Base64.h"

@implementation Base64

//判断是否含有Alpha通道;
+ (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

//image转换为base64
+ (NSString *) imageToBase64: (UIImage *) image
{
    NSData *imageData = nil;
    
    if ([Base64 imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
    }
    
    return [NSString stringWithFormat:@"%@",
            [imageData base64EncodedStringWithOptions: 0]];
    
}

@end
