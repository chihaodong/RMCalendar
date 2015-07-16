//
//  RMCollectionCell.m
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import "RMCollectionCell.h"
#import "UIView+CustomFrame.h"
#import "RMCalendarModel.h"

#import "TicketModel.h"

#define kFont(x) [UIFont systemFontOfSize:x]
#define COLOR_HIGHLIGHT ([UIColor redColor])
#define COLOR_NOAML ([UIColor colorWithRed:26/256.0  green:168/256.0 blue:186/256.0 alpha:1])

@interface RMCollectionCell()

/**
 *  显示日期
 */
@property (nonatomic, weak) UILabel *dayLabel;
/**
 *  显示农历
 */
@property (nonatomic, weak) UILabel *chineseCalendar;
/**
 *  选中的背景图片
 */
@property (nonatomic, weak) UIImageView *selectImageView;
/**
 *  票价   此处可根据项目需求自行修改
 */
@property (nonatomic, weak) UILabel *price;


@end

@implementation RMCollectionCell

- (nonnull instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self initCellView];
    return self;
}

- (void)initCellView {
    
    //选中时显示的图片
    UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    selectImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarSelectedDate"]];
    self.selectImageView = selectImageView;
    [self addSubview:selectImageView];
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.bounds.size.width * 0.5, self.bounds.size.width * 0.5)];
    dayLabel.font = kFont(14);
    self.dayLabel = dayLabel;
    [self addSubview:dayLabel];
    
    UILabel *chineseCalendar = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width * 0.5, 0, dayLabel.width, dayLabel.height)];
    chineseCalendar.font = kFont(9);
    chineseCalendar.textAlignment = NSTextAlignmentCenter;
    self.chineseCalendar = chineseCalendar;
    [self addSubview:chineseCalendar];
    
#warning 价格Label 可根据需求修改
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, dayLabel.height, self.bounds.size.width, dayLabel.height)];
    price.font = kFont(9);
    price.textAlignment = NSTextAlignmentCenter;
    self.price = price;
    [self addSubview:price];
}

- (void)setModel:(RMCalendarModel *)model {
    _model = model;
    //没有剩余票数
    if (!model.ticketModel.ticketCount || model.style == CellDayTypePast) {
        self.price.hidden = YES;
        model.isEnable ? model.style : model.style != CellDayTypeEmpty ? model.style = CellDayTypePast : model.style;
    } else {
        self.price.hidden = NO;
        self.price.textColor = [UIColor orangeColor];
        self.price.text = [NSString stringWithFormat:@"￥%.1f",model.ticketModel.ticketPrice];
    }
    self.chineseCalendar.text = model.Chinese_calendar;
    self.chineseCalendar.hidden = NO;
    /**
     *  如果不展示农历，则日期居中
     */
    if (!model.isChineseCalendar) {
        self.dayLabel.x = 0;
        self.dayLabel.width = self.bounds.size.width;
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    switch (model.style) {
        case CellDayTypeEmpty:
            self.selectImageView.hidden = YES;
            self.dayLabel.hidden = YES;
            self.backgroundColor = [UIColor whiteColor];
            self.chineseCalendar.hidden = YES;
            break;
        case CellDayTypePast:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = YES;
            if (model.holiday) {
                self.dayLabel.text = model.holiday;
                self.dayLabel.width = self.bounds.size.width;
                self.chineseCalendar.hidden = YES;
            } else {
                self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            }
            self.chineseCalendar.textColor = [UIColor lightGrayColor];
            self.dayLabel.textColor = [UIColor lightGrayColor];
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarDisableDate"]];
            break;
            
        case CellDayTypeWeek:
            // 以下内容暂时无用  将来可以设置 周六 日 特殊颜色时 可用
//            self.dayLabel.hidden = NO;
//            self.selectImageView.hidden = YES;
//            if (model.holiday) {
//                self.dayLabel.text = model.holiday;
//                self.dayLabel.textColor = COLOR_HIGHLIGHT;
//            } else {
//                self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
//                self.dayLabel.textColor = COLOR_NOAML;
//            }
//            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarNormalDate"]];
//            self.chineseCalendar.textColor = [UIColor blackColor];
//            break;
            
        case CellDayTypeFutur:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = YES;
            if (model.holiday) {
                self.dayLabel.text = model.holiday;
                self.dayLabel.width = self.bounds.size.width;
                self.chineseCalendar.hidden = YES;
                self.dayLabel.textColor = COLOR_HIGHLIGHT;
            } else {
                self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
                self.dayLabel.textColor = COLOR_NOAML;
            }
            self.chineseCalendar.textColor = [UIColor blackColor];
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarNormalDate"]];
            break;
            
        case CellDayTypeClick:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = NO;
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarNormalDate"]];
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = [UIColor whiteColor];
            self.price.textColor = [UIColor whiteColor];
            self.chineseCalendar.textColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
    
}

@end
