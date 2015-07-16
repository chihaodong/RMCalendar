//
//  ViewController.m
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/1.
//  Copyright (c) 2015年 迟浩东. All rights reserved.
//

#import "ViewController.h"
#import "RMCalendarController.h"
#import "MJExtension.h"
#import "TicketModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClick {
    // CalendarShowTypeMultiple 显示多月
    // CalendarShowTypeSingle   显示单月
    RMCalendarController *c = [RMCalendarController calendarWithDays:365 showType:CalendarShowTypeMultiple];
    
    // 此处用到MJ大神开发的框架，根据自己需求调整是否需要
    c.modelArr = [TicketModel objectArrayWithKeyValuesArray:@[@{@"year":@2015, @"month":@7, @"day":@22,
                                                                @"ticketCount":@194, @"ticketPrice":@283},
                                                              @{@"year":@2015, @"month":@7, @"day":@17,
                                                                @"ticketCount":@91, @"ticketPrice":@223},
                                                              @{@"year":@2015, @"month":@10, @"day":@4,
                                                                @"ticketCount":@91, @"ticketPrice":@23},
                                                              @{@"year":@2015, @"month":@7, @"day":@8,
                                                                @"ticketCount":@2, @"ticketPrice":@203},
                                                              @{@"year":@2015, @"month":@7, @"day":@28,
                                                                @"ticketCount":@2, @"ticketPrice":@103},
                                                              @{@"year":@2015, @"month":@7, @"day":@18,
                                                                @"ticketCount":@0, @"ticketPrice":@153}]]; //最后一条数据ticketCount 为0时不显示
    // 是否展现农历
    c.isDisplayChineseCalendar = YES;
    
    // YES 没有价格的日期可点击
    // NO  没有价格的日期不可点击
    c.isEnable = YES;
    c.title = @"单价日历 软曼网";
    c.calendarBlock = ^(RMCalendarModel *model) {
        if (model.ticketModel.ticketCount) {
            NSLog(@"%lu-%lu-%lu-票价%.1f",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day, model.ticketModel.ticketPrice);
        } else {
            NSLog(@"%lu-%lu-%lu",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day);
        }
    };
    [self.navigationController pushViewController:c animated:YES];
}

@end
