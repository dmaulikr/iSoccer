//
//  RecordTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/1/6.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "NetDataNameConfig.h"
#import "Global.h"
#import "CanPageUpView.h"
#import <UIImageView+WebCache.h>

#define PHOTO_TAG 200

#define PHOTO_WH 90

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation RecordTableViewCell
{
    UILabel * leftLabel;
    UITextField * rightLabel;
    NSMutableArray * _photoData;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andHeight:(CGFloat)height photo:(NSMutableArray*)photoData{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        [Global getInstance].isDeleting = NO;
        _photoData = photoData;
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(size.width * 0.19 * 0.26, 0, size.width * 0.24, height)];
        
        leftLabel.textColor = [UIColor blackColor];
        leftLabel.font = [UIFont systemFontOfSize:16];
        
        [self.contentView addSubview:leftLabel];
        
        
        rightLabel = [[UITextField alloc]initWithFrame:CGRectMake(leftLabel.frame.origin.x * 2 + leftLabel.frame.size.width, 0, size.width * 0.57, height)];
        
        rightLabel.textAlignment = NSTextAlignmentRight;
        
        rightLabel.textColor = [UIColor lightGrayColor];
        rightLabel.font = [UIFont systemFontOfSize:14];
        
        [rightLabel setEnabled:NO];
        
        rightLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [self.contentView addSubview:rightLabel];
        
        _arrowIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
        if(photoData == nil)
        {
            _arrowIcon.frame = CGRectMake(0, 0, leftLabel.frame.size.width * 0.16 - 8, leftLabel.frame.size.width * 0.16);
            _arrowIcon.center = CGPointMake(rightLabel.frame.origin.x + rightLabel.frame.size.width + _arrowIcon.frame.size.width/2 + 10, height/2);
            
            [self.contentView addSubview:_arrowIcon];
        }else{
            
            if(photoData.count == 0)
            {
                CGFloat gap = 6;
                
                CGFloat leftAndRight = (size.width - (PHOTO_WH * 3 + gap * 2))/2;
                _uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
                _uploadButton.frame = CGRectMake(leftAndRight, 4, PHOTO_WH, PHOTO_WH);
                [_uploadButton setBackgroundImage:[UIImage imageNamed:@"upload_photo.png"] forState:UIControlStateNormal];
                
                [_uploadButton addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
                
                _uploadButton.layer.borderWidth = 1.0f;
                _uploadButton.layer.borderColor = UIColorFromRGB(0xd9d9d9).CGColor;
                
                [self.contentView addSubview:_uploadButton];
            }
            
            
            for(NSInteger i = 0;i < photoData.count;i++)
            {
                NSMutableDictionary * data = photoData[i];
                NSString * photoURL = [data objectForKey:PIC_URL];
                
                CGFloat gap = 6;
                
                CGFloat leftAndRight = (size.width - (PHOTO_WH * 3 + gap * 2))/2;
                
                NSInteger row = i % 3;
                
                NSInteger col = i / 3.0;
  
                UIImageView * photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(leftAndRight + row * PHOTO_WH + row * gap, 4 + gap *col + col * PHOTO_WH, PHOTO_WH, PHOTO_WH)];
                [Global loadImageFadeIn:photoImage andUrl:photoURL isLoadRepeat:YES];
                photoImage.tag = PHOTO_TAG + i;
                
                photoImage.contentMode = UIViewContentModeScaleAspectFill;
                
                photoImage.autoresizingMask = UIViewAutoresizingNone;
                photoImage.clipsToBounds  = YES;
                
                photoImage.layer.masksToBounds = YES;
                
                photoImage.userInteractionEnabled = YES;
                
                photoImage.layer.borderWidth = 1.0f;
                
                photoImage.layer.borderColor = UIColorFromRGB(0xd9d9d9).CGColor;
                
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImage:)];
                [photoImage addGestureRecognizer: tap];
                
                UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImage:)];
                
                [photoImage addGestureRecognizer:longPress];
                
                [self.contentView addSubview:photoImage];
                
                if(photoData.count < 9 && photoData.count - 1 == i)
                {
                    NSInteger addIndex = i + 1;
                    
                    row = addIndex % 3;
                    
                    col = addIndex / 3.0;
                   
                    _uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    _uploadButton.frame = CGRectMake(leftAndRight + row * PHOTO_WH + row * gap, 4 + gap *col + col * PHOTO_WH, PHOTO_WH, PHOTO_WH);
                    [_uploadButton setBackgroundImage:[UIImage imageNamed:@"upload_photo.png"] forState:UIControlStateNormal];
                    
                    _uploadButton.layer.borderWidth = 1.0f;
                    _uploadButton.layer.borderColor = UIColorFromRGB(0xd9d9d9).CGColor;
                    
                    [_uploadButton addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.contentView addSubview:_uploadButton];
                    
                }
                
            }
        }
    }
    return self;
    
}

- (void)uploadImage:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UPLOAD_PHOTO object:nil];
}

- (void)deleteImage:(UITapGestureRecognizer*)gesture{
    
    if(_uploadButton.hidden == YES)
    {
        return;
    }
    
    NSLog(@"%zd",gesture.view.tag);
    
    if([Global getInstance].isDeleting == YES)
    {
      return;
    }
    [Global getInstance].isDeleting = YES;
    
    NSInteger index = gesture.view.tag - PHOTO_TAG;
    
    NSMutableDictionary * currentPhoto = _photoData[index];
    
    NSString * photoId = [currentPhoto objectForKey:@"pictureId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DELETE_PHOTO object:photoId];
    
    
    
}

- (void)showImage:(UITapGestureRecognizer*)gesture{
    NSInteger index =  gesture.view.tag - PHOTO_TAG;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIView * container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    
    CanPageUpView * pageUpView = [[CanPageUpView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height) andCurrentIndex:index andImages:_photoData];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [container addGestureRecognizer: tap];
    
    [container addSubview:pageUpView];
    
    container.backgroundColor = [UIColor blackColor];
    
    container.userInteractionEnabled = YES;
    
    [[[UIApplication sharedApplication]keyWindow]addSubview:container];
    
    container.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        container.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hideImage:(UITapGestureRecognizer*)gesture{
    
    UIMenuController * mCtrl = [Global getInstance].mCtrl;
    
    if(mCtrl != NULL)
    {
        [mCtrl setMenuVisible:NO animated:YES];
    }
    
    UIView * view = gesture.view;
    
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}


- (void)setLeftString:(NSString*)string
{
    leftLabel.text = string;
}

- (void)setRightString:(NSString*)string
{
    rightLabel.text = string;
}

@end
