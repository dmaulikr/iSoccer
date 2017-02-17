//
//  EmptyTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/1/22.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "EmptyTableViewCell.h"
#import "CreateTeamNavigationViewController.h"
#import "Global.h"
#define BG_H (size.height * 0.17)

@implementation EmptyTableViewCell
{
    UIImageView * bg;
    CGSize size;
    UIButton * createButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        size = [UIScreen mainScreen].bounds.size;
        
        bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width - size.width * 0.05, size.height - BG_H)];
        
        bg.image = [UIImage imageNamed:@"empty_match_bg.png"];
        
        self.backgroundColor = [UIColor clearColor];
        
        
        [self.contentView addSubview:bg];
        
        createButton = [UIButton buttonWithType:UIButtonTypeSystem];
        createButton.frame = CGRectMake(0, 0, size.width - 30, 48);
        
        [createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [createButton setTitle:@"创建比赛" forState:UIControlStateNormal];
        createButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [createButton addTarget:self action:@selector(tapedCreateHandler:) forControlEvents:UIControlEventTouchUpInside];
        createButton.backgroundColor = [UIColor blackColor];
        createButton.layer.masksToBounds = YES;
        createButton.layer.cornerRadius = 4;
        
        createButton.center = CGPointMake(bg.frame.size.width/2,bg.frame.size.height - createButton.frame.size.height - 10);
        
        [self.contentView addSubview:createButton];
        
    }

    return self;
}

- (void)tapedCreateHandler:(UIButton*)sender{
    
    UIStoryboard *createMatch = [UIStoryboard storyboardWithName:@"CreateTeamAndMatch" bundle:nil];
    CreateTeamNavigationViewController * teamCreateNav = createMatch.instantiateInitialViewController;
    UIViewController * mainVC = [Global getInstance].mainVC;
    [mainVC presentViewController:teamCreateNav animated:YES completion:nil];
}
- (void)setCreateButtonVisible:(BOOL)visible
{
    createButton.hidden = visible;
}

@end
