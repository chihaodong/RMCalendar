# RMCalendar 单价日历

实现功能：

2015年7月16日更新

添加农历功能，对细节优化修复

主要是在日历上显示 当日对应的单价，类似携程、同城、去哪等旅游APP的日历，可以展现当日的票价等功能。

![image](https://github.com/chihaodong/RMCalendar/blob/master/Preview/preview-2@2x.jpg)    
![image](https://github.com/chihaodong/RMCalendar/blob/master/Preview/preview-3@2x.jpg)    
![image](https://github.com/chihaodong/RMCalendar/blob/master/Preview/preview-4@2x.jpg) 
![image](https://github.com/chihaodong/RMCalendar/blob/master/Preview/preview-5@2x.jpg)

# 使用方法    

将项目下的Class文件夹复制到项目中
导入对应头文件  #import "RMCalendarController.h" 入口

创建对象   (有多种方法，具体看代码）
```
RMCalendarController *c = [RMCalendarController calendarWithDays:365 showType:CalendarShowTypeMultiple];
c.isDisplayChineseCalendar = YES; // 增加农历展现功能 默认不展现
c.isEnable = YES;   // 设置是否显示 无价格时可点击
c.modelArr = "TicketModel模型数组";  //具体属性需看 TicketModel.h 文件 传入格式请按照 下面例子 
// 返回结果回调
c.calendarBlock = ^(RMCalendarModel *model) {
        if (model.ticketModel.ticketCount) {
            NSLog(@"%lu-%lu-%lu-票价%.1f",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day, model.ticketModel.ticketPrice);
        } else {
            NSLog(@"%lu-%lu-%lu",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day);
        }
    };
```

如：此处用到MJ的第三方框架将字典数组模型转为模型对象，可根据情况是否使用      
```
c.modelArr = [TicketModel objectArrayWithKeyValuesArray:@[@{@"year":@2015, @"month":@7, @"day":@6,  
                                                          @"ticketCount":@194, @"ticketPrice":@283},  
                                                          @{@"year":@2015, @"month":@7, @"day":@7,   
                                                          @"ticketCount":@91, @"ticketPrice":@223},   
                                                          @{@"year":@2015, @"month":@10, @"day":@4,
                                                          @"ticketCount":@91, @"ticketPrice":@23},
                                                          @{@"year":@2015, @"month":@7, @"day":@8,
                                                          @"ticketCount":@2, @"ticketPrice":@203},
                                                          @{@"year":@2015, @"month":@7, @"day":@28,
                                                          @"ticketCount":@2, @"ticketPrice":@103},
                                                          @{@"year":@2015, @"month":@7, @"day":@18,
                                                          @"ticketCount":@0, @"ticketPrice":@153}]]; //最后一条数据ticketCount 为0时不显示

```   

#目录结构   
Category    一些扩展的方法    
Controller  控制器
Logic       业务逻辑    
Model       模型    
Other       资源图片    
View        视图    
#声明 AND 致谢  
1、此处用到MJ的模型转换框架：https://github.com/CoderMJLee/MJExtension    
2、日历源代码是由我爱吃番茄开发，只是在原来基础上增加自己的需求和代码优化工作，实现单价日历效果，再次感谢原作者。http://code4app.com/ios/%E4%B8%80%E6%AC%BE%E7%AE%80%E5%8D%95%E7%9A%84%E6%97%A5%E5%8E%86%E6%8E%A7%E4%BB%B6/53fa8a8b933bf0fe0d8b482b

#版权
1、第三方框架版权归于原作者，MJ大神   
2、日历部分源码属于原作者：我爱吃番茄   
3、二次开发版权归于本人
#网站  
软曼网：http://www.ruanman.net/   提供Windows 10系统下载，iOS 开发技术分享，欢迎大家支持 QQ技术交流群：33415610
