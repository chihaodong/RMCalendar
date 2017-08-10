//
//  RMCalendarLogic.m
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import "RMCalendarLogic.h"
#import "NSDate+RMCalendarLogic.h"
#import "TicketModel.h"

@interface RMCalendarLogic()

/**
 *  今天的日期
 */
@property (nonatomic, strong) NSDate *today;
/**
 *  之后的日期
 */
@property (nonatomic, strong) NSDate *before;
/**
 *  选中的日期
 */
@property (nonatomic, strong) NSDate *select;
/**
 *  日期模型
 */
@property (nonatomic, strong) RMCalendarModel *model;
/**
 *  价格模型数组
 */
@property (nonatomic, strong) NSArray *priceModelArr;

@property (nonatomic, assign) BOOL isEnable;

@property (nonatomic, assign) BOOL isDisplayChineseCalender;

@end

@implementation RMCalendarLogic

#warning 初始化 模型数组，可根据功能进行修改
- (NSArray *)priceModelArr {
    if (!_priceModelArr) {
        _priceModelArr = [NSArray array];
    }
    return _priceModelArr;
}

-(NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate needDays:(int)days showType:(CalendarShowType)type isEnable:(BOOL)isEnable priceModelArr:(NSArray *)arr isChineseCalendar:(BOOL)isChineseCalendar {
    self.isDisplayChineseCalender = isChineseCalendar;
    return [self reloadCalendarView:date selectDate:selectDate needDays:days showType:type isEnable:isEnable priceModelArr:arr];
}

-(NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate needDays:(int)days showType:(CalendarShowType)type isEnable:(BOOL)isEnable priceModelArr:(NSArray *)arr {
    self.isEnable = isEnable;
    return [self reloadCalendarView:date selectDate:selectDate needDays:days showType:type priceModelArr:arr];
}

-(NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate needDays:(int)days showType:(CalendarShowType)type priceModelArr:(NSArray *)arr {
#warning 此处根据自己需求可修改
    // 存放价格模型
    self.priceModelArr = arr;
    return [self reloadCalendarView:date selectDate:selectDate needDays:days showType:type];
}

- (NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate needDays:(int)days showType:(CalendarShowType)type {
    //如果为空就从当天的日期开始
    if(date == nil){
        date = [NSDate date];
    }
    
    //默认选择中的时间
    if (selectDate == nil) {
        selectDate = date;
    }
    
    self.today = date;//起始日期
    
    self.before = [date dayInTheFollowingDay:days];//计算它days天以后的时间
    
    self.select = selectDate;//选择的日期
    
    NSDateComponents *todayDC= [self.today YMDComponents];
    
    NSDateComponents *beforeDC= [self.before YMDComponents];
    
    NSInteger todayYear = todayDC.year;
    
    NSInteger todayMonth = todayDC.month;
    
    NSInteger beforeYear = beforeDC.year;
    
    NSInteger beforeMonth = beforeDC.month;
    
    NSInteger months = (beforeYear-todayYear) * 12 + (beforeMonth - todayMonth);
    
    NSMutableArray *calendarMonth = [[NSMutableArray alloc]init];//每个月的dayModel数组
    
    if (type == CalendarShowTypeSingle) {
        months = 0;
    }
    
    for (int i = 0; i <= months; i++) {
        
        NSDate *month = [self.today dayInTheFollowingMonth:i];
        NSMutableArray *calendarDays = [[NSMutableArray alloc]init];
        [self calculateDaysInPreviousMonthWithDate:month andArray:calendarDays];
        [self calculateDaysInCurrentMonthWithDate:month andArray:calendarDays];
        if (type == CalendarShowTypeMultiple) {
            [self calculateDaysInFollowingMonthWithDate:month andArray:calendarDays];//计算下月份的天数
        }
        
//        [self calculateDaysIsWeekendandArray:calendarDays];
        
        [calendarMonth insertObject:calendarDays atIndex:i];
    }
    
    return calendarMonth;
}

//计算上月份的天数

- (NSMutableArray *)calculateDaysInPreviousMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date firstDayOfCurrentMonth] weeklyOrdinality];//计算这个的第一天是礼拜几,并转为int型
    NSDate *dayInThePreviousMonth = [date dayInThePreviousMonth];//上一个月的NSDate对象
    int daysCount = (int)[dayInThePreviousMonth numberOfDaysInCurrentMonth];//计算上个月有多少天
    int partialDaysCount = (int)weeklyOrdinality - 1;//获取上月在这个月的日历上显示的天数
    NSDateComponents *components = [dayInThePreviousMonth YMDComponents];//获取年月日对象
    
    for (int i = daysCount - partialDaysCount + 1; i < daysCount + 1; ++i) {
        
        RMCalendarModel *calendarDay = [RMCalendarModel calendarWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeEmpty;//不显示
        calendarDay.isChineseCalendar = self.isDisplayChineseCalender;   //此处需要赋值 农历是否展现 否则点击时产生错位
        [array addObject:calendarDay];
    }
    
    
    return NULL;
}



//计算下月份的天数

- (void)calculateDaysInFollowingMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date lastDayOfCurrentMonth] weeklyOrdinality];
    if (weeklyOrdinality == 7) return ;
    
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSDateComponents *components = [[date dayInTheFollowingMonth] YMDComponents];
    
    for (int i = 1; i < partialDaysCount + 1; ++i) {
        RMCalendarModel *calendarDay = [RMCalendarModel calendarWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeEmpty;
        calendarDay.isChineseCalendar = self.isDisplayChineseCalender;  //此处需要赋值 农历是否展现 否则点击时产生错位
        [array addObject:calendarDay];
    }
}


//计算当月的天数

- (void)calculateDaysInCurrentMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    
    NSUInteger daysCount = [date numberOfDaysInCurrentMonth];//计算这个月有多少天
    NSDateComponents *components = [date YMDComponents];//今天日期的年月日
    
    for (int i = 1; i < daysCount + 1; ++i) {
        RMCalendarModel *calendarDay = [RMCalendarModel calendarWithYear:components.year month:components.month day:i];
        calendarDay.week = [[calendarDay date]getWeekIntValueWithDate];
        calendarDay.isChineseCalendar = self.isDisplayChineseCalender;  //此处需要赋值 农历是否展现 否则点击时产生错位
        if (self.isDisplayChineseCalender) {
            calendarDay.Chinese_calendar = [self LunarForSolarYear:components.year Month:components.month Day:i];
            [self LunarForSolarYear:calendarDay];
        }
        [self changStyle:calendarDay];
        [array addObject:calendarDay];
    }
}




- (void)changStyle:(RMCalendarModel *)model
{
    
    NSDateComponents *calendarToDay  = [self.today YMDComponents];//今天
    NSDateComponents *calendarbefore = [self.before YMDComponents];//最后一天
    NSDateComponents *calendarSelect = [self.select YMDComponents];//默认选择的那一天
    model.isEnable = self.isEnable;
    
    //被点击选中
    if(calendarSelect.year == model.year &
       calendarSelect.month == model.month &
       calendarSelect.day == model.day){
        
        model.style = CellDayTypeClick;
        self.model = model;
    //没被点击选中
    }else{
        
        //昨天乃至过去的时间设置一个灰度
        if (calendarToDay.year >= model.year &
            calendarToDay.month >= model.month &
            calendarToDay.day > model.day) {
            
            model.style = CellDayTypePast;
            
            //之后的时间时间段
        }else if (calendarbefore.year <= model.year &
                  calendarbefore.month <= model.month &
                  calendarbefore.day <= model.day) {
            
            model.style = CellDayTypePast;
            
            //需要正常显示的时间段
        }else{
            
            //周末
            if (model.week == 1 || model.week == 7){
                model.style = CellDayTypeWeek;
                
                //工作日
            }else{
                model.style = CellDayTypeFutur;
            }
        }
    }
#warning for进行模型日期匹配,将价格和日期关联，此处可根据项目需求进行修改
    for (int i = 0; i < self.priceModelArr.count; i++) {
        TicketModel *tModel = self.priceModelArr[i];
        if (tModel.year == model.year &
            tModel.month == model.month &
            tModel.day == model.day) {
            model.ticketModel = tModel;
        }
    }
    
    
    //===================================
    //这里来判断节日
    //今天
    if (calendarToDay.year == model.year &&
        calendarToDay.month == model.month &&
        calendarToDay.day == model.day) {
        model.holiday = @"今天";
//明天
//    }else if(calendarToDay.year == calendarDay.year &&
//             calendarToDay.month == calendarDay.month &&
//             calendarToDay.day - calendarDay.day == -1){
//        calendarDay.holiday = @"明天";
//
//        //后天
//    }else if(calendarToDay.year == calendarDay.year &&
//             calendarToDay.month == calendarDay.month &&
//             calendarToDay.day - calendarDay.day == -2){
//        calendarDay.holiday = @"后天";
        //1.1元旦
    }else if (model.month == 1 &&
              model.day == 1){
        model.holiday = @"元旦";
        
        //2.14情人节
    }else if (model.month == 2 &&
              model.day == 14){
        model.holiday = @"情人节";
        
        //3.8妇女节
    }else if (model.month == 3 &&
              model.day == 8){
        model.holiday = @"妇女节";
        
        //5.1劳动节
    }else if (model.month == 5 &&
              model.day == 1){
        model.holiday = @"劳动节";
        
        //6.1儿童节
    }else if (model.month == 6 &&
              model.day == 1){
        model.holiday = @"儿童节";
        
        //8.1建军节
    }else if (model.month == 8 &&
              model.day == 1){
        model.holiday = @"建军节";
        
        //9.10教师节
    }else if (model.month == 9 &&
              model.day == 10){
        model.holiday = @"教师节";
        
        //10.1国庆节
    }else if (model.month == 10 &&
              model.day == 1){
        model.holiday = @"国庆节";
        
        //11.1植树节
    }else if (model.month == 11 &&
              model.day == 1){
        model.holiday = @"植树节";
        
        //11.11光棍节
    }else if (model.month == 11 &&
              model.day == 11){
        model.holiday = @"光棍节";
        
    }else{
            
        //            这里写其它的节日
        
    }
    
}

#pragma mark - 农历转换函数

-(void)LunarForSolarYear:(RMCalendarModel *)calendarDay{
    
    NSString *solarYear = [self LunarForSolarYear:calendarDay.year Month:calendarDay.month Day:calendarDay.day];
    
    NSArray *solarYear_arr= [solarYear componentsSeparatedByString:@"-"];
    
    if([solarYear_arr[0]isEqualToString:@"正月"] &&
       [solarYear_arr[1]isEqualToString:@"初一"]){
        
        //正月初一：春节
        calendarDay.holiday = @"春节";
        
    }else if([solarYear_arr[0]isEqualToString:@"正月"] &&
             [solarYear_arr[1]isEqualToString:@"十五"]){
        
        
        //正月十五：元宵节
        calendarDay.holiday = @"元宵节";
        
    }else if([solarYear_arr[0]isEqualToString:@"二月"] &&
             [solarYear_arr[1]isEqualToString:@"初二"]){
        
        //二月初二：春龙节(龙抬头)
        calendarDay.holiday = @"龙抬头";
        
    }else if([solarYear_arr[0]isEqualToString:@"五月"] &&
             [solarYear_arr[1]isEqualToString:@"初五"]){
        
        //五月初五：端午节
        calendarDay.holiday = @"端午节";
        
    }else if([solarYear_arr[0]isEqualToString:@"七月"] &&
             [solarYear_arr[1]isEqualToString:@"初七"]){
        
        //七月初七：七夕情人节
        calendarDay.holiday = @"七夕节";
        
    }else if([solarYear_arr[0]isEqualToString:@"八月"] &&
             [solarYear_arr[1]isEqualToString:@"十五"]){
        
        //八月十五：中秋节
        calendarDay.holiday = @"中秋节";
        
    }else if([solarYear_arr[0]isEqualToString:@"九月"] &&
             [solarYear_arr[1]isEqualToString:@"初九"]){
        
        //九月初九：重阳节、中国老年节（义务助老活动日）
        calendarDay.holiday = @"重阳节";
        
    }else if([solarYear_arr[0]isEqualToString:@"腊月"] &&
             [solarYear_arr[1]isEqualToString:@"初八"]){
        
        //腊月初八：腊八节
        calendarDay.holiday = @"腊八节";
        
    }else if([solarYear_arr[0]isEqualToString:@"腊月"] &&
             [solarYear_arr[1]isEqualToString:@"二十四"]){
        
        
        //腊月二十四 小年
        calendarDay.holiday = @"小年";
        
    }else if([solarYear_arr[0]isEqualToString:@"腊月"] &&
             [solarYear_arr[1]isEqualToString:@"三十"]){
        
        //腊月三十（小月二十九）：除夕
        calendarDay.holiday = @"除夕";
        
    }
    
    if ([solarYear_arr[1] isEqualToString:@"初一"])
    {
        calendarDay.Chinese_calendar = solarYear_arr[0];
    } else {
        calendarDay.Chinese_calendar = solarYear_arr[1];
    }
    
    
    
}

-(NSString *)LunarForSolarYear:(NSUInteger)wCurYear Month:(NSInteger)wCurMonth Day:(NSUInteger)wCurDay{
    
    
    
    //农历日期名
    NSArray *cDayName =  [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                          @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                          @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName =  [NSArray arrayWithObjects:@"*",@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"腊月",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (int)((wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38);
    
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    
    
    //生成农历月
    NSString *szNongliMonth;
    if (wCurMonth < 1){
        szNongliMonth = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    }else{
        szNongliMonth = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
    //生成农历日
    NSString *szNongliDay = [cDayName objectAtIndex:wCurDay];
    
    //合并
    NSString *lunarDate = [NSString stringWithFormat:@"%@-%@",szNongliMonth,szNongliDay];
    
    return lunarDate;
}




- (void)selectLogic:(RMCalendarModel *)dayModel
{
    
    if (dayModel.style == CellDayTypeClick) {
        return;
    }
    
    dayModel.style = CellDayTypeClick;
    //周末
    if (self.model.week == 1 || self.model.week == 7){
        self.model.style = CellDayTypeWeek;
        
        //工作日
    }else{
        self.model.style = CellDayTypeFutur;
    }
    self.model = dayModel;
}


@end
