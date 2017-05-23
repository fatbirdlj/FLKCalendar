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
@property (strong,nonatomic) UIButton *todayButton;

@end

@implementation ViewController

- (FLKCalendarView *)calendarView{
    if (!_calendarView) {
        _calendarView = [[FLKCalendarView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.view.bounds), 380) initialDate:[NSDate date]];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

- (UILabel *)monthLabel{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 100, 20)];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.font = [UIFont systemFontOfSize:20];
        _monthLabel.text = @"test";
    }
    return _monthLabel;
}

- (UIButton *)todayButton{
    if (!_todayButton) {
        _todayButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _todayButton.frame = CGRectMake(0, 20, 40, 20);
        [_todayButton setTitle:@"Today" forState:UIControlStateNormal];
        [_todayButton sizeToFit];
        [_todayButton addTarget:self action:@selector(todayClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _todayButton;
}

- (void)todayClick{
    self.calendarView.presentedDate = [NSDate date];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.monthLabel];
    [self.view addSubview:self.calendarView];
    [self.view addSubview:self.todayButton];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentedDateDoUpdate:(NSDate *)date{
    self.monthLabel.text = [date descriptionWithLocale:@"zh_Hant_HK"];
    [self.monthLabel sizeToFit];
}

- (BOOL)shouldShowDotMarker:(NSDate *)date{
    return true;
}

@end
