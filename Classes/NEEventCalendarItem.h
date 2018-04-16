//
//  NEEventCalendarItem.h
//  MeMe
//
//  Created by Client on 2018/4/5.
//  Copyright © 2018年 sip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NEEventCalendarItem : NSObject
@property (nonatomic ,copy)   NSString *title;      //事件标题
@property (nonatomic ,copy)   NSString *location;   //事件地点
@property (nonatomic ,strong) NSDate   *startDate;  //开始时间
@property (nonatomic ,strong) NSDate   *endDate;    //结束时间
@property (nonatomic ,assign) BOOL     allDay;      //是否是全天
@property (nonatomic ,strong) NSArray  *alarmArray; //闹钟时间时间偏移数组，用字符串方式传递  -5 * 60就是提前5分钟 ，5 * 60就是5分钟后

@end
