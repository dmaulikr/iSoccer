//
//  Global.m
//  iSoccer
//
//  Created by pfg on 15/12/18.
//  Copyright (c) 2015年 iSoccer. All rights reserved.
//

#import "Global.h"
#import <UIImageView+WebCache.h>

@implementation Global
/**
 *  提示框
 *
 *  @param title
 *  @param msg
 */
+ (void) alertWithTitle:(NSString *)title msg:(NSString *)msg{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                            message:msg
                                                                            delegate:self
                                                                   cancelButtonTitle:nil
                                                                   otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}

/**
 *10 转 16进制
 */
-(NSString *) toHex:(long long int) num
{
    NSString * result = [NSString stringWithFormat:@"%llx",num];
    return [result uppercaseString];
}


+ (void)loadImageFadeIn:(UIImageView*)imageView andUrl:(NSString*)imageUrl isLoadRepeat:(BOOL)repeat
{
    
    if([imageUrl rangeOfString:@"https:"].location == NSNotFound && [imageUrl rangeOfString:@"http:"].location == NSNotFound && imageUrl.length > 0)
    {
        imageView.image = [UIImage imageNamed:imageUrl];
        return;
    }
    
    SDWebImageOptions option;
    if(repeat)
    {
        option = SDWebImageRetryFailed;
    }else{
        option = SDWebImageRetryFailed;
    }
    
    UIActivityIndicatorView *activityIndicator;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    [imageView addSubview:activityIndicator];
    
    activityIndicator.center = CGPointMake(imageView.frame.size.width/2, imageView.frame.size.height/2);
    [activityIndicator startAnimating];
    
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:option completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        
        [activityIndicator stopAnimating];
        
        [activityIndicator removeFromSuperview];
        
        imageView.alpha = 0.0;
        [UIView animateWithDuration:0.6
                         animations:^{
                             imageView.alpha = 1.0;
                         }];
    }];
    
}

+ (id)JSONObjectWithData:(NSData *)data {
    
    // 如果没有数据返回，则直接不解析
    if (data.length == 0) {
        
        return nil;
    }
    
    // 初始化解析错误
    NSError *error = nil;
    
    // JSON解析
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return object;
}

+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}


static Global* _instance = nil;

+(instancetype)getInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
        
        _instance.HUD = [[MBProgressHUD alloc]init];
        _instance.isLogin = NO;
        _instance.sex = LdqSexMan;
        
    }) ;
    
    
    return _instance ;
}

- (void)setGameDataByDictionary:(NSMutableArray *)gameDatas{
    
//    NSMutableArray * gamesDataed = [NSMutableArray array];
//    
//    for(NSInteger i = 0;i < gameDatas.count;i++)
//    {
//        NSDictionary * match = gameDatas[i];
//        NSMutableDictionary * matched = [match mutableCopy];
//        
//        NSMutableArray * teamsed = [NSMutableArray array];
//        NSMutableArray * teams = [[match objectForKey:@"matchList"] mutableCopy];
//        
//        for(NSInteger j = 0;j < teams.count;j++)
//        {
//            NSMutableDictionary * diced = [teams[i] mutableCopy];
//            [teamsed addObject:diced];
//        }
//        
//        [matched setValue:teamsed forKey:@"matchList"];
//        
//        [gamesDataed addObject:matched];
//        
//    }
    
    _gameDatas = gameDatas;
}

+ (UserData*)setUserDataByDictionary:(NSMutableDictionary*)data{
    
    UserData * userData = [[UserData alloc]init];
    
    userData.userId = [data objectForKey:@"userId"];
    userData.userName = [data objectForKey:@"nickName"];
    userData.age = [data objectForKey:@"age"];
    userData.sex = [data objectForKey:@"sex"];
    userData.nationality = [data objectForKey:@"nationality"];
    userData.phoneNumber = [data objectForKey:@"mobile"];
    userData.weight = [data objectForKey:@"weight"];
    userData.height = [data objectForKey:@"height"];
    userData.remark = [data objectForKey:@"remark"];
    userData.avatarUrl = [data objectForKey:@"photo"];
    userData.email = [data objectForKey:@"email"];
    userData.position = [data objectForKey:@"position"];
    userData.bindingMobile = [data objectForKey:@"bindingMobile"];
    
    if(userData.bindingMobile == nil)
    {
        userData.bindingMobile = @"";
    }
    
    NSNumber * count = [data objectForKey:@"noticeCount"];
    userData.messageCount = count.integerValue;
    
    userData.deviceNumber = @"111111111122222222";
    
    return userData;
}

+ (NSString*)getDateByTime:(NSString*)time isSimple:(BOOL)simple{
    NSInteger timer = time.integerValue;
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timer];
    
    NSDateFormatter *yearFomatter = [[NSDateFormatter alloc] init] ;
    [yearFomatter setDateFormat:@"MM月dd日"];
    
    NSDateFormatter *hourFomatter = [[NSDateFormatter alloc]init];
    [hourFomatter setDateFormat:@"HH:mm"];
    
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger weekday = [componets weekday];
    
    NSArray * weeks = @[@"星期六",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    
    NSString * timeString;
    
    if(simple)
    {
        NSDateFormatter *simpleFormatter = [[NSDateFormatter alloc]init];
        [simpleFormatter setDateFormat:@"yy-MM-dd"];
        
        timeString = [NSString stringWithFormat:@"%@",[simpleFormatter stringFromDate:date]];
    }else{
        timeString = [NSString stringWithFormat:@"%@ %@ %@",[yearFomatter stringFromDate:date],weeks[weekday], [hourFomatter stringFromDate:date]];
    }

    return timeString;
}

+ (NSString*)getSimpleDateByTime:(NSString*)time
{
    NSInteger timer = time.integerValue;
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timer];
    
    NSDateFormatter *yearFomatter = [[NSDateFormatter alloc] init] ;
    [yearFomatter setDateFormat:@"yyyy年MM月"];
    
    
    NSString * timeString = [NSString stringWithFormat:@"%@",[yearFomatter stringFromDate:date]];
    
    return timeString;
}
//添加下划线;
+ (void)addTextBottomLineAtButton:(UIButton*)button andText:(NSString*)string andTextColor:(UIColor*)color
{
    NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange strRange = {0,[textString length]};
    [textString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [button setAttributedTitle:textString forState:UIControlStateNormal];
    button.titleLabel.textColor = color;
}

@end
