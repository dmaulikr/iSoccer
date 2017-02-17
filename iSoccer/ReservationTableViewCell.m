//
//  ReservationTableViewCell.m
//  iSoccer
//
//  Created by Linus on 16/8/4.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "ReservationTableViewCell.h"
#import "Global.h"
#import "NetDataNameConfig.h"


#define FIELD_TAG 200


@implementation ReservationTableViewCell
{
    NSMutableArray * dataSource;
    
    NSMutableArray * fieldsData;
    
    NSMutableDictionary * shopData;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIColor *grayColor = [UIColor colorWithRed:232.0/255.0 green:230.0/255.0 blue:234.0/255.0 alpha:1.0];
        
        
        UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, 0.5)];
        
        topLine.backgroundColor = grayColor;
        
        [self.contentView addSubview:topLine];
        
        
        UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, size.height * 0.6 - 0.5, size.width, 0.5)];
        bottomLine.backgroundColor = grayColor;
        
        [self.contentView addSubview:bottomLine];
        
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //标题;
        _titleName = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, size.width, 0.05 * size.height)];
        
        _titleName.font = [UIFont systemFontOfSize:18];
        
        _titleName.textColor = [UIColor blackColor];
        
        _titleName.textAlignment = NSTextAlignmentCenter;
        
        _titleName.text = @"球场名字";
        
        _titleName.center = CGPointMake(size.width/2, _titleName.frame.size.height/2 + 4);
        
        [self.contentView addSubview:_titleName];
        //球场主要图片;
        
        _titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _titleName.frame.origin.y + _titleName.frame.size.height + 4, size.width, size.height * 0.3)];
        
        
        [_titleImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _titleImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _titleImageView.autoresizingMask = UIViewAutoresizingNone;
        _titleImageView.clipsToBounds  = YES;
        
        [self.contentView addSubview:_titleImageView];
        _titleImageView.userInteractionEnabled = YES;
        
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageEnterShopIndex:)];
        [_titleImageView addGestureRecognizer:tapGesture];
        
        
        _fieldsScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _titleImageView.frame.origin.y + _titleImageView.frame.size.height, size.width, 0.23 * size.height)];
        
        _fieldsScrollView.contentSize = CGSizeMake(_fieldsScrollView.frame.size.width, _fieldsScrollView.frame.size.height);
        
        
        [self.contentView addSubview:_fieldsScrollView];
        
        
    }
    
    return self;
}

- (void)setShopData:(NSMutableDictionary*)data{
    shopData = data;
}

- (void)setFieldScrollData:(NSMutableArray*)datas{
    
    fieldsData = datas;
    
    for(NSInteger i = 0; i < datas.count;i ++)
    {
        UIView * view = [self createFieldByData:datas[i]];
        
        view.center = CGPointMake(view.frame.size.width/2 + view.frame.size.width * i, view.frame.size.height/2);

        view.userInteractionEnabled = YES;
        
        view.tag = FIELD_TAG + i;
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFieldHandler:)];
        [view addGestureRecognizer:tapGesture];
        
        [_fieldsScrollView addSubview:view];
    }
    
}


- (UIView*)createFieldByData:(NSMutableDictionary*)data{
    
   // NSLog(@"%@",data);
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width / 3, size.height* 0.23 )];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView  * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, view.frame.size.width - 12, view.frame.size.height * 0.63)];
    
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingNone;
    imageView.clipsToBounds  = YES;
    
    NSString * imgUrl = [data objectForKey:@"fieldImage"];
    
    [Global loadImageFadeIn:imageView andUrl:imgUrl isLoadRepeat:YES];
    
    [view addSubview:imageView];
    
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + imageView.frame.size.height + 6, imageView.frame.size.width, view.frame.size.height * 0.1)];
    
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor blackColor];
    
    nameLabel.textAlignment = NSTextAlignmentLeft;
    
    NSString * fieldName = [data objectForKey:@"fieldName"];
    
    nameLabel.text = fieldName;
    
    [view addSubview:nameLabel];
    
    
    UILabel * costLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 4, imageView.frame.size.width, view.frame.size.height * 0.1)];
    
    
    costLabel.font = [UIFont systemFontOfSize:14];
    
    costLabel.textAlignment = NSTextAlignmentLeft;
    
    costLabel.textColor = [UIColor orangeColor];
    
    NSNumber * minPrice = [data objectForKey:@"minPrice"];
    
    NSNumber * maxPrice = [data objectForKey:@"maxPrice"];
    
    costLabel.text = [NSString stringWithFormat:@"%zd - %zd元/场",minPrice.integerValue,maxPrice.integerValue];
    
    [view addSubview:costLabel];
    
    return view;
    
}

- (void)tapFieldHandler:(UITapGestureRecognizer*)gesture{
    
    NSInteger index = gesture.view.tag - FIELD_TAG;
    
    
    NSMutableDictionary * currentData = fieldsData[index];
    
    [currentData setValue:_titleName.text forKey:@"shopName"];
    
    NSString * address = [shopData objectForKey:@"shopAddress"];
    
    [currentData setValue:address forKey:@"shopAddress"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_SHOW_FIELD_DETAIL object:currentData];
    
}

- (void)tapImageEnterShopIndex:(UITapGestureRecognizer*)gesture{
    [shopData setObject:fieldsData forKey:@"fieldList"];
    
    [shopData setObject:_titleName.text forKey:@"shopName"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:EVENT_SHOW_FIELD_INDEX object:shopData];
    
}

@end
