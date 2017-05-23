//
//  NSDate+FLKCalendar.m
//  FLKCalendar
//
//  Created by 刘江 on 2017/5/21.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "NSDate+FLKCalendar.h"

@implementation NSDate (FLKCalendar)

- (NSComparisonResult)compareDate:(NSDate *)targetDate{
    NSDate *startDate1,*startDate2;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&startDate1 interval:NULL forDate:self];
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&startDate2 interval:NULL forDate:targetDate];
    return [startDate1 compare:startDate2];
}

- (NSInteger)dateInterger{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    return components.year*10000 + components.month*100 + components.day;
}

@end
