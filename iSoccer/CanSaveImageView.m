//
//  CanSaveImageView.m
//  iSoccer
//
//  Created by pfg on 16/4/18.
//  Copyright © 2016年 iSoccer. All rights reserved.
//

#import "CanSaveImageView.h"
#import "Global.h"
#import "ProgressHUD.h"

@implementation CanSaveImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        // 新增添加长按手势
        
        self.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)];
        [self addGestureRecognizer:longTap];
        
        // 缩放手势
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        [self addGestureRecognizer:pinchGestureRecognizer];
        
        //滑动手势;
        UISwipeGestureRecognizer * leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftHandler:)];
        
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        
        UISwipeGestureRecognizer * rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightHandler:)];
        
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self addGestureRecognizer:leftSwipe];
        [self addGestureRecognizer:rightSwipe];
    }
    return self;
}

- (void)leftHandler:(UISwipeGestureRecognizer*)gesture
{
    NSLog(@"left");
}

- (void)rightHandler:(UISwipeGestureRecognizer*)gesture
{
    NSLog(@"right");
}

// 新增添加长按手势
- (void)longTap:(UILongPressGestureRecognizer *)reco
{
    if ([reco state]==UIGestureRecognizerStateBegan) {
        [[reco view]becomeFirstResponder];
        CGPoint loc = [reco locationInView:reco.view];
        
        
        
        
        UIMenuController * mCtrl = [Global getInstance].mCtrl;
        
        if(mCtrl == NULL)
        {
            [Global getInstance].mCtrl = [UIMenuController sharedMenuController];
            mCtrl = [Global getInstance].mCtrl;
            UIMenuItem *item = [[UIMenuItem alloc]initWithTitle:@"保存到相册" action:@selector(saveClick:)];
            [mCtrl setMenuItems:[NSArray arrayWithObject:item]];
        }
        // 这儿有问题！！！！
        //        CGPoint loc = reco.
        
        [mCtrl setTargetRect:CGRectMake(loc.x, loc.y, 0, 0) inView:[reco view] ];
        [mCtrl setMenuVisible:YES animated:YES];
    }
}
// 必须实现
- (BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL) canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(saveClick:) ) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}
// 新增添加长按手势
- (void)saveClick:(id)sender
{
    if (self.image) {
        UIImageWriteToSavedPhotosAlbum(self.image, self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
}
// 写到文件的完成时执行
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [ProgressHUD showSuccess:@"保存成功"];
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    
    if(pinchGestureRecognizer.state == UIGestureRecognizerStateEnded){
        
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
        pinchGestureRecognizer.scale = 1;
    }
}


@end
