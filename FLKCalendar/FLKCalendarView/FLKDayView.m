//
//  FLKDayView.m
//  FLKCalendar
//
//  Created by 刘江 on 2017/5/19.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "FLKDayView.h"
#import "NSDate+FLKCalendar.h"
#import "FLKCircleView.h"

@interface FLKDayView()
@property (strong,nonatomic) UILabel *dayLabel;
@property (strong,nonatomic) UIView *dotMarker;
@property (strong,nonatomic) NSCalendar *calendar;
@property (assign,nonatomic) BOOL isToday;
@property (strong,nonatomic) FLKCircleView *topCircleView;
@property (strong,nonatomic,readwrite) NSDate *date;
@property (strong,nonatomic) CALayer *topMarker;
@property (strong,nonatomic) FLKCircleView *dotMarkerView;
@end

@implementation FLKDayView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date{
    if (self = [super initWithFrame:frame]) {
        self.date = date;
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.date];
        self.tag = components.year*10000 + components.month*100 + components.day;
        
        [self.layer addSublayer:self.topMarker];
        
        [self addSubview:self.dayLabel];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - Properties

- (CALayer *)topMarker{
    if (!_topMarker) {
        CGFloat height = 0.5;
        _topMarker = [[CALayer alloc] init];
        _topMarker.frame = CGRectMake(2, 0, CGRectGetWidth(self.bounds)-2, height);
        _topMarker.borderColor = [[UIColor grayColor] CGColor];
        _topMarker.borderWidth = height;
    }
    return _topMarker;
}

- (UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:self.bounds];
        
        _dayLabel.text = [NSString stringWithFormat:@"%ld",(long)self.tag%100];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont systemFontOfSize:18];
    }
    return _dayLabel;
}

- (FLKCircleView *)topCircleView{
    if (!_topCircleView) {
        _topCircleView = [[FLKCircleView alloc] initWithFrame:self.bounds];
    }
    return _topCircleView;
}

- (FLKCircleView *)dotMarkerView{
    if (!_dotMarkerView) {
        CGFloat yOffset = CGRectGetHeight(self.bounds)/4;
        _dotMarkerView = [[FLKCircleView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
        _dotMarkerView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)+yOffset);
    }
    return _dotMarkerView;
}

- (BOOL)isToday{
    return [self.date compareDate:[NSDate date]] == 0;
}

- (void)setIsOut:(BOOL)isOut{
    _isOut = isOut;
    if (self.isToday) {
        self.dayLabel.textColor = [UIColor redColor];
        return;
    }
    if (isOut) {
        self.dayLabel.textColor = [UIColor grayColor];
    } else {
        self.dayLabel.textColor = [UIColor blackColor];
    }
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if (selected) {
        if (self.isToday) {
            self.dayLabel.textColor = [UIColor whiteColor];
            self.topCircleView.fillColor = [UIColor redColor];
        } else {
            self.dayLabel.textColor = [UIColor whiteColor];
            self.topCircleView.fillColor = [UIColor blueColor];
        }
        [self insertSubview:self.topCircleView atIndex:0];
        if (self.hasDotMarker) {
            [self.dotMarkerView removeFromSuperview];
        }
        
    } else {
        if (self.isToday) {
            self.dayLabel.textColor = [UIColor redColor];
        } else {
            if (self.isOut) {
                self.dayLabel.textColor = [UIColor grayColor];
            } else {
                self.dayLabel.textColor = [UIColor blackColor];
            }
        }
        if (self.hasDotMarker) {
            self.hasDotMarker = true;
        }
        [self.topCircleView removeFromSuperview];
    }
}

- (void)setHasDotMarker:(BOOL)hasDotMarker{
    _hasDotMarker = hasDotMarker;
    if (hasDotMarker) {
        if (self.isOut) {
            self.dotMarkerView.fillColor = [UIColor grayColor];
        } else {
            self.dotMarkerView.fillColor = [UIColor redColor];
        }
        [self insertSubview:self.dotMarkerView atIndex:0];
    } else {
        [self.dotMarkerView removeFromSuperview];
    }
}

- (NSString *)description{
    return [self.date description];
}

@end
