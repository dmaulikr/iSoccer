//
//  AlreadyFieldTableViewCell.m
//  iSoccer
//
//  Created by Linus on 16/8/11.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "AlreadyFieldTableViewCell.h"
#import "AlreadyViewCell.h"

@implementation AlreadyFieldTableViewCell
{
    AlreadyViewCell * subView;
    NSMutableDictionary * _data;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andData:(NSMutableDictionary*)data{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"alreadycellview" owner:self options:nil];
        
        subView = (AlreadyViewCell*)[nibViews objectAtIndex:0];
        
        subView.frame = CGRectMake(0, 0, size.width, 250);
        
        _data = data;
        
        [self.contentView addSubview:subView];
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect{
    [subView setViewWithData:_data];
}

@end
