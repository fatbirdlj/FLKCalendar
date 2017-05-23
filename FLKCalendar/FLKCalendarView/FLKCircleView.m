//
//  FLKCircleView.m
//  FLKCalendar
//
//  Created by 刘江 on 2017/5/22.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "FLKCircleView.h"

@implementation FLKCircleView

- (void)setStrokeColor:(UIColor *)strokeColor{
    if (_strokeColor != strokeColor) {
        _strokeColor = strokeColor;
        [self setNeedsDisplay];
    }
}

- (void)setFillColor:(UIColor *)fillColor{
    if (_fillColor != fillColor) {
        _fillColor = fillColor;
        [self setNeedsDisplay];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.strokeColor = [UIColor clearColor];
        self.fillColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.8;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGPoint arcCenter = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    CGFloat radius = (MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))-8)/2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:0 endAngle:2*M_PI clockwise:true];
    
    [self.strokeColor setStroke];
    [self.fillColor setFill];
    
    path.lineWidth = 1;
    [path stroke];
    [path fill];
}

- (void)didMoveToSuperview{
    [self setNeedsDisplay];
}

@end
