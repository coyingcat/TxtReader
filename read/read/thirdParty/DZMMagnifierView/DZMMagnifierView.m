//
//  DZMMagnifierView.m
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/30.
//  Copyright © 2019年 DZM. All rights reserved.
//

/// 动画时间
#define MV_AD_TIME 0.08

/// 放大比例
#define MV_SCALE 1.3

/// 放大区域
#define MV_WH 120

#import "DZMMagnifierView.h"

@interface DZMMagnifierView ()


@property (nonatomic, weak) CALayer *contentLayer;


@end


@implementation DZMMagnifierView



- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0, 0, MV_WH, MV_WH);
        self.layer.cornerRadius = MV_WH / 2;
        self.layer.masksToBounds = YES;
        self.windowLevel = UIWindowLevelAlert;
        
        CALayer *contentLayer = [CALayer layer];
        contentLayer.frame = self.bounds;
        contentLayer.delegate = self;
        contentLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:contentLayer];
        self.contentLayer = contentLayer;
        
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    
    return self;
}



- (void)setTargetWindow:(UIView *)targetWindow {
    
    _targetWindow = targetWindow;
    
    [self makeKeyAndVisible];
    
    [UIView animateWithDuration:MV_AD_TIME animations:^{
        
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)setTargetPoint:(CGPoint)targetPoint {
    
    _targetPoint = targetPoint;
    
    if (self.targetWindow) {
        
        CGPoint center = CGPointMake(targetPoint.x, self.center.y);
        
        if (targetPoint.y > CGRectGetHeight(self.bounds) * 0.5) {
            
            center.y = targetPoint.y -  CGRectGetHeight(self.bounds) / 2;
        }
        
        CGPoint offsetPoint = CGPointMake(0, -40);
        self.center = CGPointMake(center.x + offsetPoint.x, center.y + offsetPoint.y);
        
        [self.contentLayer setNeedsDisplay];
    }
}

- (void)remove:(void (^)(void))complete {
    
    [UIView animateWithDuration:MV_AD_TIME animations:^{
        self.alpha = 0;
        
        self.transform = CGAffineTransformMakeScale(0.2, 0.2);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        if (complete != nil) { complete(); }
    }];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextTranslateCTM(ctx, MV_WH / 2, MV_WH / 2);
 
    CGContextScaleCTM(ctx, MV_SCALE, MV_SCALE);
    
    CGContextTranslateCTM(ctx, -1 * self.targetPoint.x, -1 * self.targetPoint.y);
    
    [self.targetWindow.layer renderInContext:ctx];
}


@end
 
