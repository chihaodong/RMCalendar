//
//  RMCalendarModel.m
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import "RMCalendarModel.h"
#import "NSDate+RMCalendarLogic.h"

@implementation RMCalendarModel

- (instancetype)initWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day {
    self = [super init];
    if (!self) return nil;
    self.year = year;
    self.month = month;
    self.day = day;
    return self;
}

+ (instancetype)calendarWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day {
    return [[self alloc] initWithYear:year month:month day:day];
}

//返回当前天的NSDate对象
- (NSDate *)date
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.year = self.year;
    c.month = self.month;
    c.day = self.day;
    return [[NSCalendar currentCalendar] dateFromComponents:c];
}

//返回当前天的NSString对象
- (NSString *)toString
{
    NSDate *date = [self date];
    NSString *string = [date stringFromDate:date];
    return string;
}


//返回星期
- (NSString *)getWeek
{
    
    NSDate *date = [self date];
    
    NSString *week_str = [date compareIfTodayWithDate];
    
    return week_str;
}

////判断是不是同一天
//- (BOOL)isEqualTo:(CalendarDayModel *)day
//{
//    BOOL isEqual = (self.year == day.year) && (self.month == day.month) && (self.day == day.day);
//    return isEqual;
//}
@end
