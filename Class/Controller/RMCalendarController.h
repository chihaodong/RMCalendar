//
//  RMCalendarController.h
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCalendarLogic.h"
/**
 *  选中日起，回掉结果
 *
 *  @param model 返回模型
 */
typedef void (^CalendarBlock)(RMCalendarModel *model);


/**
 *  起始页面
 */
@interface RMCalendarController : UIViewController

/**
 *  UICollectionView 对象，用于显示布局，类似UITableView
 */
@property(nonatomic ,strong) UICollectionView* collectionView;
/**
 *  用于存放日期模型数组
 */
@property(nonatomic ,strong) NSMutableArray *calendarMonth;
/**
 *  逻辑处理
 */
@property(nonatomic ,strong) RMCalendarLogic *calendarLogic;
/**
 *  回调
 */
@property(nonatomic, copy) CalendarBlock calendarBlock;
/**
 *  天数
 */
@property(nonatomic, assign) int days;
/**
 *  展示类型
 */
@property(nonatomic, assign) CalendarShowType type;
/**
 *  用于存放价格模型数组
 */
@property(nonatomic, retain) NSMutableArray *modelArr;
/**
 *  无价格的日期是否可点击  默认为NO
 */
@property(nonatomic, assign) BOOL isEnable;
/**
 *  是否展示农历  默认为NO
 */
@property(nonatomic, assign) BOOL isDisplayChineseCalendar;

/**
 *  初始化对象
 *
 *  @param days 显示总天数，默认365天
 *  @param type 显示类型，详细请见 枚举的定义
 *
 *  @return 当前对象
 */
- (instancetype)initWithDays:(int)days showType:(CalendarShowType)type;

- (instancetype)initWithDays:(int)days showType:(CalendarShowType)type modelArrar:(NSMutableArray *)modelArr;

+ (instancetype)calendarWithDays:(int)days showType:(CalendarShowType)type;

+ (instancetype)calendarWithDays:(int)days showType:(CalendarShowType)type modelArrar:(NSMutableArray *)modelArr;


@end
