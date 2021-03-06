//
//  FLKCalendarView.h
//  FLKCalendar
//
//  Created by 刘江 on 2017/5/19.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLKCalendarViewDelegate <NSObject>

- (void)presentedDateDoUpdate:(NSDate *)date;

- (BOOL)shouldShowDotMarker:(NSDate *)date;

@end

@interface FLKCalendarView : UIView

@property (weak,nonatomic) id<FLKCalendarViewDelegate> delegate;

@property (strong,nonatomic) NSDate *presentedDate;

- (instancetype)initWithFrame:(CGRect)frame initialDate:(NSDate *)initialDate;

@end
