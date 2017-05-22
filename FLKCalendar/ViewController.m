//
//  ViewController.m
//  FLKCalendar
//
//  Created by 刘江 on 2017/5/19.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "ViewController.h"
#import "FLKCalendarView.h"

@interface ViewController ()<FLKCalendarViewDelegate>
@property (strong,nonatomic) FLKCalendarView *calendarView;
@property (strong,nonatomic) UILabel *monthLabel;

@end

@implementation ViewController

- (FLKCalendarView *)calendarView{
    if (!_calendarView) {
        _calendarView = [[FLKCalendarView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.view.bounds), 380)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

- (UILabel *)monthLabel{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 100, 40)];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.font = [UIFont systemFontOfSize:20];
        _monthLabel.text = @"test";
    }
    return _monthLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.monthLabel];
    [self.view addSubview:self.calendarView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentedDateDoUpdate:(NSDate *)date{
    self.monthLabel.text = [date descriptionWithLocale:@"zh_Hant_HK"];
    [self.monthLabel sizeToFit];
}

@end
