//
//  NEEventCalendar.h
//  MeMe
//
//  Created by Client on 2018/4/5.
//  Copyright © 2018年 sip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NEEventCalendarItem.h"
@interface NEEventCalendar : NSObject
+ (void)createEventsWithItems:(NSArray <NEEventCalendarItem *> *)items
                      success:(void(^)(void))success
             permissionDenied:(void(^)(void))permissionDenied
                      failure:(void(^)(void))failure;

// 检测日历权限
+ (void)checkPermission:(void(^)(BOOL))didHavePermission;
+ (BOOL)checkPermission;

// 是否插入过事件s
+ (void)didInsertedEventItems:(NSArray <NEEventCalendarItem *>*)items
                       result:(void(^)(bool))result;
@end
