//
//  TicketModel.h
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/6.
//  Copyright (c) 2015年 迟浩东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketModel : NSObject
/**
 *  年
 */
@property (nonatomic, assign) NSInteger year;
/**
 *  月
 */
@property (nonatomic, assign) NSInteger month;
/**
 *  日
 */
@property (nonatomic, assign) NSInteger day;
/**
 *  剩余数量
 */
@property (nonatomic, assign) NSInteger ticketCount;
/**
 *  单价
 */
@property (nonatomic, assign) float ticketPrice;

@end
