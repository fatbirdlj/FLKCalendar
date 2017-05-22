//
//  FLKDayView.h
//  FLKCalendar
//
//  Created by 刘江 on 2017/5/19.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLKDayView : UIView

@property (assign,nonatomic) BOOL hasDotMarker;

@property (assign,nonatomic) BOOL isOut;

@property (assign,nonatomic) BOOL selected;

@property (strong,nonatomic,readonly) NSDate *date;

- (instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date;

@end
