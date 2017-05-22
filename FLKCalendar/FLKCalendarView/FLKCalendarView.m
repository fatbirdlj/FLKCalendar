//
//  FLKCalendarView.m
//  FLKCalendar
//
//  Created by 刘江 on 2017/5/19.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "FLKCalendarView.h"
#import "FLKDayView.h"
#import "NSDate+FLKCalendar.h"

typedef NS_ENUM(NSInteger,MonthViewIdentifier){
    Previous = 0,
    Present,
    Next
};

typedef NS_ENUM(NSInteger,ScrollDirection){
    None = 0,
    Right,
    Left
};


@interface FLKCalendarView()<UIScrollViewDelegate>

@property (strong,nonatomic) FLKDayView *selectedDayView;

@property (strong,nonatomic) UILabel *monthLabel;
@property (strong,nonatomic) UIView *weekDayTitlesView;
@property (strong,nonatomic) NSMutableDictionary *monthViews;
@property (strong,nonatomic) UIScrollView *monthScrollView;

@property (strong,nonatomic) NSArray *weekDayTitles;
@property (strong,nonatomic) NSDate *presentedDate;
@property (strong,nonatomic) NSCalendar *calendar;

@property (assign,nonatomic) ScrollDirection scrollDirection;
@property (assign,nonatomic) NSInteger currentPage;

@end


@implementation FLKCalendarView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.weekDayTitlesView];
        [self addSubview:self.monthScrollView];
    }
    return  self;
}

#pragma mark - Properties

- (NSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSArray *)weekDayTitles{
    if (!_weekDayTitles) {
        _weekDayTitles = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    }
    return _weekDayTitles;
}

- (void)setPresentedDate:(NSDate *)presentedDate{
    if (!_presentedDate || [presentedDate compare:_presentedDate] != 0) {
        _presentedDate = presentedDate;
        
        if (self.selectedDayView) {
            self.selectedDayView.selected = NO;
        }
        
        UIView *presentedMonthView = self.monthViews[@(Present)];
        for (FLKDayView *dayView in presentedMonthView.subviews) {
            if ([dayView.date compareDate:presentedDate] == 0) {
                dayView.selected = YES;
                self.selectedDayView = dayView;
            }
        }
        
        [self.delegate presentedDateDoUpdate:presentedDate];
    }
}

- (UIView *)weekDayTitlesView{
    if (!_weekDayTitlesView) {
        _weekDayTitlesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/7)];
        CGFloat labelWidth = CGRectGetWidth(_weekDayTitlesView.frame)/7;
        CGFloat labelHeight = CGRectGetHeight(_weekDayTitlesView.frame);
        for (int i = 0; i < [self.weekDayTitles count]; i++) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*labelWidth, 0, labelWidth, labelHeight)];
            titleLabel.text = self.weekDayTitles[i];
            titleLabel.font = [UIFont systemFontOfSize:18];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [_weekDayTitlesView addSubview:titleLabel];
        }
    }
    return _weekDayTitlesView;
}

- (UIScrollView *)monthScrollView{
    if (!_monthScrollView) {
        _monthScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)/7, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/7*6)];
        _monthScrollView.showsVerticalScrollIndicator = false;
        _monthScrollView.showsHorizontalScrollIndicator = false;
        _monthScrollView.delegate = self;
        _monthScrollView.pagingEnabled = YES;
        _monthScrollView.contentSize =  CGSizeMake(3*CGRectGetWidth(self.bounds), CGRectGetHeight(_monthScrollView.frame));
        [self.monthViews enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [_monthScrollView addSubview:obj];
        }];
        [_monthScrollView setContentOffset:CGPointMake(CGRectGetWidth(_monthScrollView.frame), 0)];
        self.currentPage = 1;
        self.presentedDate = [NSDate date];
    }
    return _monthScrollView;
}

- (NSMutableDictionary *)monthViews{
    if (!_monthViews) {
        _monthViews = [[NSMutableDictionary alloc] init];
        [self.monthViews setObject:[self monthViewWithDate:[self getPreviousMonthDate:[NSDate date]] identifier:Previous] forKey:@(Previous)];
        [self.monthViews setObject:[self monthViewWithDate:[NSDate date] identifier:Present] forKey:@(Present)];
        [self.monthViews setObject:[self monthViewWithDate:[self getNextMonthDate:[NSDate date]] identifier:Next] forKey:@(Next)];
    }
    return _monthViews;
}

#pragma mark - Get Previous/NextMonth

- (NSDate *)getPreviousMonthDate:(NSDate *)date{
    NSDateComponents *oneNegativeMonth = [[NSDateComponents alloc] init];
    [oneNegativeMonth setMonth:-1];
    return [self.calendar dateByAddingComponents:oneNegativeMonth toDate:date options:0];
}

- (NSDate *)getNextMonthDate:(NSDate *)date{
    NSDateComponents *oneMonth = [[NSDateComponents alloc] init];
    [oneMonth setMonth:1];
    return [self.calendar dateByAddingComponents:oneMonth toDate:date options:0];
}

- (NSDate *)getFirstMonthDateByYearMonthTag:(NSInteger)tag{
    NSInteger year = tag / 100;
    NSInteger month = tag % 100;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = 1;
    NSDate *date = [self.calendar dateFromComponents:components];
    return date;
}

- (NSDate *)getNextMonthDateByMonthView:(UIView *)currentMonthView{
    NSInteger yearMonthTag = currentMonthView.tag;
    NSDate *currentMonthDate = [self getFirstMonthDateByYearMonthTag:yearMonthTag];
    NSDate *nextMonthDate = [self getNextMonthDate:currentMonthDate];
    return nextMonthDate;
}

- (NSDate *)getPreviousMonthDateByMonthView:(UIView *)currentMonthView{
    NSInteger yearMonthTag = currentMonthView.tag;
    NSDate *currentMonthDate = [self getFirstMonthDateByYearMonthTag:yearMonthTag];
    NSDate *preViousMonthDate = [self getPreviousMonthDate:currentMonthDate];
    return preViousMonthDate;
}


#pragma mark - Init/Replace MonthView

- (UIView *)monthViewWithDate:(NSDate *)date identifier:(MonthViewIdentifier)identifier{
    UIView *monthView = [[UIView alloc] initWithFrame:CGRectMake(identifier*CGRectGetWidth(self.monthScrollView.frame), 0, CGRectGetWidth(self.monthScrollView.frame), CGRectGetHeight(self.monthScrollView.frame))];
    
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    monthView.tag = components.year*100 + components.month;
    
    NSArray *monthDates = [self getMonthDateRangeByOneDate:date];
    
    CGFloat dayViewWidth = CGRectGetWidth(monthView.frame)/7;
    CGFloat dayViewHeight = CGRectGetHeight(monthView.frame)/6;
    for (int i = 0; i < [monthDates count]; i++) {
        FLKDayView *dayView = [[FLKDayView alloc] initWithFrame:CGRectMake((i%7)*dayViewWidth, (i/7)*dayViewHeight, dayViewWidth, dayViewHeight) date:monthDates[i]];
        if (dayView.tag/100 == monthView.tag) {
            dayView.isOut = false;
        } else {
            dayView.isOut = true;
        }
        [monthView addSubview:dayView];
    }
    return monthView;
}

- (NSArray *)getMonthDateRangeByOneDate:(NSDate *)date{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    [components setDay:1];
    NSDate *firstDayOfMonth = [self.calendar dateFromComponents:components];
    
    NSDateComponents *oneMonth = [[NSDateComponents alloc] init];
    [oneMonth setMonth:1];
    NSDate *firstDayOfNextMonth = [self.calendar dateByAddingComponents:oneMonth toDate:firstDayOfMonth options:0];
    
    NSDateComponents *oneNegativeDay = [[NSDateComponents alloc] init];
    [oneNegativeDay setDay:-1];
    NSDate *endDayOfMonth = [self.calendar dateByAddingComponents:oneNegativeDay toDate:firstDayOfNextMonth options:0];
    
    NSDate *startOfWeekForFirstDay;
    NSDate *startOfWeekForLastDay;
    NSDate *endOfWeekForLastDay;
    [self.calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&startOfWeekForFirstDay interval:nil forDate:firstDayOfMonth];
    [self.calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&startOfWeekForLastDay interval:nil forDate:endDayOfMonth];
    
    NSDateComponents *sixDays = [[NSDateComponents alloc] init];
    [sixDays setDay:6];
    endOfWeekForLastDay = [self.calendar dateByAddingComponents:sixDays toDate:startOfWeekForLastDay options:0];
    
    NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    [oneDay setDay:1];
    
    int i = 0;
    NSDate *dateItem;
    for (dateItem = startOfWeekForFirstDay; [dateItem compare:endOfWeekForLastDay] <=0; dateItem = [self.calendar dateByAddingComponents:oneDay toDate:dateItem options:0]){
        [dates addObject:dateItem];
        i++;
    }
    
    if (i == 35) {
        for (; i < 42; i++,dateItem = [self.calendar dateByAddingComponents:oneDay toDate:dateItem options:0]) {
            [dates addObject:dateItem];
        }
    }
    
    return dates;
}

- (void)replaceMonthView:(UIView *)monthView identifier:(MonthViewIdentifier)identifier animated:(BOOL)animated{
    CGRect originFrame = monthView.frame;
    originFrame.origin = CGPointMake(identifier*CGRectGetWidth(self.monthScrollView.frame), 0);
    monthView.frame = originFrame;
    
    self.monthViews[@(identifier)] = monthView;
    if (animated) {
        [self.monthScrollView scrollRectToVisible:originFrame animated:NO];
    }
}

- (void)insertMonthView:(NSDate *)date identifier:(MonthViewIdentifier)identifier{
    UIView *monthView = [self monthViewWithDate:date identifier:identifier];
    [self.monthViews setObject:monthView forKey:@(identifier)];
    [self.monthScrollView addSubview:monthView];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y != 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
    
    CGFloat scrollWidth = CGRectGetWidth(scrollView.frame);
    NSInteger page = floor((scrollView.contentOffset.x - scrollWidth/2)/scrollWidth) + 1;
    if (self.currentPage != page) {
        self.currentPage = page;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"%d",decelerate);
    if (decelerate) {
        if (scrollView.contentOffset.x <= CGRectGetWidth(scrollView.frame)) {
            self.scrollDirection = Right;
        } else {
            self.scrollDirection = Left;
        }
    }
    NSLog(@"%f",scrollView.contentOffset.x);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"d:%ld",(long)self.scrollDirection);
    if (self.currentPage != 1) {
        switch (self.scrollDirection) {
            case Right:
            {
                [self.monthViews[@(Next)] removeFromSuperview];
                [self replaceMonthView:self.monthViews[@(Present)] identifier:Next animated:NO];
                [self replaceMonthView:self.monthViews[@(Previous)] identifier:Present animated:YES];
                
                UIView *presentView = self.monthViews[@(Present)];
                NSDate *previousMonthDate = [self getPreviousMonthDateByMonthView:presentView];
                [self insertMonthView:previousMonthDate identifier:Previous];
                
                self.presentedDate = [self getFirstMonthDateByYearMonthTag:presentView.tag];
                
                break;
            }
                
            case Left:
            {
                [self.monthViews[@(Previous)] removeFromSuperview];
                [self replaceMonthView:self.monthViews[@(Present)] identifier:Previous animated:NO];
                [self replaceMonthView:self.monthViews[@(Next)] identifier:Present animated:YES];
                
                UIView *presentView = self.monthViews[@(Present)];
                NSDate *nextMonthDate = [self getNextMonthDateByMonthView:presentView];
                [self insertMonthView:nextMonthDate identifier:Next];
                
                self.presentedDate = [self getFirstMonthDateByYearMonthTag:presentView.tag];
                
                break;
            }
            default:
                break;
        }
    }
    self.scrollDirection = None;
}

@end
