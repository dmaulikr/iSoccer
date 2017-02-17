//
//  DWFParticleView.m
//  iSoccer
//
//  Created by pfg on 15/10/30.
//  Copyright © 2015年 iSoccer. All rights reserved.
//

#import "ParticleView.h"

@implementation ParticleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        
        //显示边框;
        //emitterLayer.borderWidth = 1.0f;
        
        //给定尺寸;
        emitterLayer.frame = frame;
        
        //发射点;
        emitterLayer.emitterPosition = CGPointMake(frame.size.width/2, -frame.size.height);
        
        //发射源尺寸大小
        emitterLayer.emitterSize = CGSizeMake(frame.size.width, 20);
        
        
        //发射模式;
        emitterLayer.emitterMode = kCAEmitterLayerSurface;
        
        
        //发射形状;
        emitterLayer.emitterShape = kCAEmitterLayerLine;
        
        [self.layer addSublayer:emitterLayer];
        
        
        CAEmitterCell * cell = [CAEmitterCell emitterCell];
        
        cell.scale = 0.4;
        
        cell.spin = 0;
        //自转范围;
        cell.spinRange = 3 * M_PI;
        
        cell.alphaRange = 10.f;
        
        //粒子产生率;
        cell.birthRate = 5.f;
        //生命周期;
        cell.lifetime = 120.f;
        //速度
        cell.velocity = 10;
        //速度微调值；
        cell.velocityRange = 3;
        
        //Y轴速度值;
        cell.yAcceleration = 3.f;
        
        
        //发射角度;
        cell.emissionRange = 10 * M_1_PI;
        
        
        
        //设置图片 需要桥接；
        cell.contents = (__bridge id)([UIImage imageNamed:@"DazFlake.png"].CGImage);
        
        emitterLayer.emitterCells = @[cell];
        
        
    }
    return self;
}

@end
