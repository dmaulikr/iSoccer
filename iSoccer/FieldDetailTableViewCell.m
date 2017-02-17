//
//  FieldDetailTableViewCell.m
//  iSoccer
//
//  Created by Linus on 16/8/8.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "FieldDetailTableViewCell.h"
#import "Global.h"
#import "NetDataNameConfig.h"

#define DEFAULT_HEIGHT 44


@implementation FieldDetailTableViewCell
{
    NSString * _fieldId;
    NSString * _shopId;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}


- (void)setFieldNameFunction:(NSString*)name{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    CGFloat gap = size.width * 0.05;
    
    UILabel * titleNameText = [[UILabel alloc]initWithFrame:CGRectMake(gap, 0, size.width - (gap * 2), DEFAULT_HEIGHT)];
    
    titleNameText.textColor = [UIColor blackColor];
    titleNameText.font = [UIFont systemFontOfSize:16];
    
    titleNameText.text = name;
    
    [self.contentView addSubview:titleNameText];
}

- (void)setFieldPictureFunction:(NSMutableArray*)picList andShopId:(NSString*)shopId{
    
    if(picList == nil || picList.count == 0)
        return;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat gapX = size.width * 0.05;
    CGFloat gapY = size.width * 0.03;
    
    
    CGFloat initY = size.width * 0.03;
    
    
    CGFloat picHeight = size.height * 0.3;
    
    for (NSInteger i = 0; i < picList.count; i++)
    {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(gapX, picHeight * i + gapY * i + initY, size.width - (gapX * 2), picHeight)];
        
        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageView.contentMode =  UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingNone;
        imageView.clipsToBounds  = YES;
        
        
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1].CGColor;
        
        NSMutableDictionary * dic = picList[i];
        
        NSString * url = [dic objectForKey:@"fieldImgUrl"];
        
        [Global loadImageFadeIn:imageView andUrl:url isLoadRepeat:YES];
        
        [self.contentView addSubview:imageView];
    }
    
    NSMutableDictionary * lastDic = picList[picList.count - 1];
    
    _fieldId = [lastDic objectForKey:@"fieldId"];
    
    _shopId = shopId;
    
}


@end
