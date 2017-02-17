//
//  TitleSelecter.m
//  iSoccer
//
//  Created by pfg on 15/10/29.
//  Copyright © 2015年 iSoccer. All rights reserved.
//

#import "TitleSelecter.h"

#define BUTTON_TAG 200
#define BUTTON_SCALE 0.8
#define BUTTON_ALPHA 0.8
#define GAP_OFFSET 25


@interface TitleSelecter()
{
    NSMutableArray * allButtons;
    NSInteger currentIndex;
    NSArray * locations;
}

@end

@implementation TitleSelecter

- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray*)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        
        allButtons = [NSMutableArray array];
        
        if(titles.count == 2)
        {
            locations = @[@0.5,@0.5];
        }else{
            locations = @[@0,@-1,@1];
        }
        
        currentIndex = 0;
        
        for(NSInteger i = 0;i < titles.count;i++)
        {
            NSString * name = titles[i];
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(0, 0, 50, 40);
            
            [button setTitle:name forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            NSInteger locationIndex = currentIndex - i;
            
            if(locationIndex < 0)
            {
                locationIndex += titles.count;
            }
            //NSLog(@"----%ld",locationIndex);
            
            NSNumber * offset = locations[locationIndex];//计算位置
            
            CGFloat offsetX = offset.floatValue;
            
            button.center = CGPointMake(offsetX * button.frame.size.width/2 + GAP_OFFSET*offsetX + frame.size.width/2, button.frame.size.height/2);
            
            [button setTag:i + BUTTON_TAG];
            
            [button.titleLabel setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightBold]];
            
            [button addTarget:self action:@selector(tapButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
            
            if(i > 0)
            {
                button.transform = CGAffineTransformMakeScale(BUTTON_SCALE, BUTTON_SCALE);
                button.alpha = BUTTON_ALPHA;
            }
            
            [self addSubview:button];
            
            [allButtons addObject:button];
        }
        
        [self currentToFront];
        
    }
    return self;
}

- (void)currentToFront{
    UIButton * currentButton = allButtons[currentIndex];
    
    [self bringSubviewToFront:currentButton];
}

- (void)tapButtonHandler:(UIButton*)sender{
    if(currentIndex == sender.tag - BUTTON_TAG)
    {
        //当前选中页;
        return;
    }
    
    switch (sender.tag - BUTTON_TAG) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
    currentIndex = sender.tag - BUTTON_TAG;
    [self gotoSelecteByIndex:currentIndex];
}

- (void)gotoSelecteByIndex:(NSInteger)page{
    currentIndex = page;
    
    [UIView animateWithDuration:0.4 animations:^{
        for(NSInteger i = 0;i < allButtons.count;i++)
        {
            UIButton * button = allButtons[i];
            
            if(currentIndex == i)
            {
                //如果是选中button
                button.transform = CGAffineTransformMakeScale(1, 1);
                button.alpha = 1;
            }else{
                button.transform = CGAffineTransformMakeScale(BUTTON_SCALE, BUTTON_SCALE);
                button.alpha = BUTTON_ALPHA;
            }
            
            NSInteger locationIndex = currentIndex - i;
            
            if(locationIndex < 0)
            {
                locationIndex += allButtons.count;
            }
            
            NSNumber * offset = locations[locationIndex];//计算位置
            
            CGFloat offsetX = offset.floatValue;
            
            button.center = CGPointMake(offsetX * button.frame.size.width/2 + GAP_OFFSET*offsetX + self.frame.size.width/2, button.center.y);
        }
        
    }];
    
    [self currentToFront];
}

@end
