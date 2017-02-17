//
//  CanPageUpView.m
//  iSoccer
//
//  Created by Linus on 2016/11/3.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "CanPageUpView.h"
#import "CanSaveImageView.h"
#import "Global.h"
#import <UIImageView+WebCache.h>

@implementation CanPageUpView

- (instancetype)initWithFrame:(CGRect)frame andCurrentIndex:(NSInteger)index andImages:(NSArray*)images
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        scrollView.contentSize = CGSizeMake(size.width * images.count, size.height);
        
        scrollView.showsHorizontalScrollIndicator = NO;
        
        scrollView.pagingEnabled = YES;
        
        for(NSInteger i = 0;i < images.count;i++)
        {
            
            NSMutableDictionary * picData = images[i];
            
            NSString * url =  [picData objectForKey:@"pictureName"];
            
            CanSaveImageView * bigImage = [[CanSaveImageView alloc]initWithFrame:CGRectMake(size.width * i, 0 , size.width, size.height)];
            
            [scrollView addSubview:bigImage];
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [bigImage addSubview:activityIndicator];
            
            activityIndicator.center = CGPointMake(size.width/2, size.height/2);
            [activityIndicator startAnimating];
            
            
            [bigImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                bigImage.frame = CGRectMake(size.width * i, 0, image.size.width , image.size.height);
                
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                
                CGFloat scale = size.width / image.size.width;
                
                bigImage.frame = CGRectMake(bigImage.frame.origin.x, bigImage.frame.origin.y, size.width, image.size.height * scale);
                
                
                bigImage.center = CGPointMake(bigImage.center.x, size.height/2);
                
                bigImage.alpha = 0.0;
                [UIView animateWithDuration:0.6
                                 animations:^{
                                     bigImage.alpha = 1.0;
                                 }];
                
            }];
            bigImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
            [bigImage addGestureRecognizer: tap];
            
        }
        
        scrollView.contentOffset = CGPointMake(index * size.width, scrollView.contentOffset.y);
        
        [self addSubview:scrollView];
        
        
    }
    return self;
}


- (void)hideImage:(UITapGestureRecognizer*)gesture{
    
    UIMenuController * mCtrl = [Global getInstance].mCtrl;
    
    if(mCtrl != NULL)
    {
        [mCtrl setMenuVisible:NO animated:YES];
    }
    
    UIView * view = gesture.view.superview.superview.superview;
    
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

@end
