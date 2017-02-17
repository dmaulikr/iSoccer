//
//  ApplyTableViewCell.m
//  iSoccer
//
//  Created by pfg on 16/5/20.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "ApplyTableViewCell.h"
#import "NetDataNameConfig.h"

#define V_GAP 8
#define H_GAP 8

@implementation ApplyTableViewCell
{
    CGFloat _height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andHeight:(CGFloat)height isUpload:(BOOL)upload{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _height = height;
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        if(upload)
        {
            //上传栏;
            UILabel * uplabel = [[UILabel alloc]initWithFrame:CGRectMake(0, V_GAP * 2, size.width, 14)];
            uplabel.text = @"上传真实有效的身份证信息,用于赛前运动员检录";
            
            uplabel.textColor = [UIColor grayColor];
            uplabel.font = [UIFont systemFontOfSize:14];
            uplabel.textAlignment = NSTextAlignmentCenter;
            
            [self.contentView addSubview:uplabel];
            
            
            UIView * leftUpView = [self createUpView:@"正面照片"];
            
            leftUpView.center = CGPointMake(size.width / 2 - leftUpView.frame.size.width/2 - H_GAP, uplabel.frame.origin.y + uplabel.frame.size.height + leftUpView.frame.size.height/2 + V_GAP * 2);
            
            leftUpView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer * tapLeft = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLeftHandler:)];
            
            [leftUpView addGestureRecognizer:tapLeft];
            
            [self.contentView addSubview:leftUpView];
            
            _frontIdCardImage = [[UIImageView alloc]initWithFrame:leftUpView.frame];
            
            [self.contentView addSubview:_frontIdCardImage];
            
            
            UIView * rightUpView = [self createUpView:@"反面照片"];
            
            rightUpView.center = CGPointMake(size.width / 2 + rightUpView.frame.size.width/2 + H_GAP, leftUpView.center.y);
            
            rightUpView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer * tapRight = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRightHandler:)];
            
            [rightUpView addGestureRecognizer:tapRight];
            
            [self.contentView addSubview:rightUpView];
            
            _backIdCardImage = [[UIImageView alloc]initWithFrame:rightUpView.frame];
            
            [self.contentView addSubview:_backIdCardImage];
            
            
        }else{
            //填写普通栏;
            
            
            
            _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(size.width * 0.19 * 0.26, 0, size.width * 0.24, height)];
            
            _leftLabel.textColor = [UIColor blackColor];
            _leftLabel.font = [UIFont systemFontOfSize:15];
            
            [self.contentView addSubview:_leftLabel];
            
            
            _rightLabel = [[UITextField alloc]initWithFrame:CGRectMake(_leftLabel.frame.origin.x * 2 + _leftLabel.frame.size.width, 0, size.width * 0.57, height)];
            
            _rightLabel.textAlignment = NSTextAlignmentRight;
            
            _rightLabel.textColor = [UIColor lightGrayColor];
            _rightLabel.font = [UIFont systemFontOfSize:14];
            
            [_rightLabel setEnabled:NO];
            
            _rightLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [self.contentView addSubview:_rightLabel];
            
            _arrowIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
            
            _arrowIcon.frame = CGRectMake(0, 0, _leftLabel.frame.size.width * 0.16 - 8, _leftLabel.frame.size.width * 0.16);
            _arrowIcon.center = CGPointMake(_rightLabel.frame.origin.x + _rightLabel.frame.size.width + _arrowIcon.frame.size.width/2 + 10, height/2);
            
            [self.contentView addSubview:_arrowIcon];
            
        }
    }
    
    return self;
}

- (void)tapLeftHandler:(UITapGestureRecognizer*)gesture{
    //点击上传正面;
    //NSLog(@"111");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UPLOAD_IDCARD_FRONT object:nil];
    
}
- (void)tapRightHandler:(UITapGestureRecognizer*)gesture{
    //点击上传反面;
    //NSLog(@"222");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UPLOAD_IDCARD_BACK object:nil];
}

- (UIView*)createUpView:(NSString*)string{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    CGFloat viewHeight = _height * 0.56;
    CGFloat viewWidth = size.width * 0.39;
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    [self addShapeByPreView:view startPoint:CGPointMake(0, 0) endPoint:CGPointMake(view.frame.size.width, 0)];
    [self addShapeByPreView:view startPoint:CGPointMake(view.frame.size.width, 0) endPoint:CGPointMake(view.frame.size.width, view.frame.size.height)];
    [self addShapeByPreView:view startPoint:CGPointMake(view.frame.size.width, view.frame.size.height) endPoint:CGPointMake(0, view.frame.size.height)];
    [self addShapeByPreView:view startPoint:CGPointMake(0, view.frame.size.height) endPoint:CGPointMake(0, 0)];
    
    UIImageView * addImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewHeight *  0.4, viewHeight * 0.4)];
    
    addImage.image = [UIImage imageNamed:@"upload_photo.png"];
    
    addImage.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2 - V_GAP);
    
    [view addSubview:addImage];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 20)];
    
    titleLabel.text = string;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.center = CGPointMake(view.frame.size.width/2, addImage.center.y + addImage.frame.size.height/2 + V_GAP);
    
    [view addSubview:titleLabel];
    
    
    return view;
}

//画虚线;
- (void)addShapeByPreView:(UIView*)view startPoint:(CGPoint)sPoint endPoint:(CGPoint)ePoint{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:6],
      [NSNumber numberWithInt:3],nil]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, sPoint.x, sPoint.y);
    CGPathAddLineToPoint(path, NULL, ePoint.x,ePoint.y);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [view.layer addSublayer:shapeLayer];
}

@end
