//
//  NEEventCalendar.m
//  MeMe
//
//  Created by Client on 2018/4/5.
//  Copyright © 2018年 sip. All rights reserved.
//

#import "NEEventCalendar.h"
#import <EventKit/EventKit.h>

NSString *const kFidUsedCalendar = @"kFidUsedCalendar";

@implementation NEEventCalendar

+ (void)createEventsWithItems:(NSArray <NEEventCalendarItem *> *)items
                      success:(void(^)(void))success
             permissionDenied:(void(^)(void))permissionDenied
                      failure:(void(^)(void))failure {
    __weak typeof(self) weakSelf = self;
    EKEventStore *eventStore = [EKEventStore new];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (error) {
                    if (failure) {
                        failure();
                    }
                } else if (!granted){
                    //  第一次调用如果没有权限，不走回调，否则跟系统会弹两次影响体验
                    if ([userDefault boolForKey:kFidUsedCalendar]) {
                        // 没有权限
                        if (permissionDenied) {
                            permissionDenied();
                        }
                    } else {
                        if (!error) {
                            if (permissionDenied) {
                                permissionDenied();
                            }
                        } else {
                            failure();
                        }
                        [userDefault setBool:YES forKey:kFidUsedCalendar];
                    }
                } else {
                    [userDefault setBool:YES forKey:kFidUsedCalendar];
                    for (NEEventCalendarItem *item in items) {
                        if ([self didInsertedEventWithEventStore:eventStore eventItem:item]) {
                            // 有相同事件跳过
                            continue;
                        }
                        
                        EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                        event.title     = item.title;
                        event.location  = item.location;
                        
                        NSDateFormatter *tempFormatter = [NSDateFormatter new];
                        [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                        
                        event.startDate = item.startDate;
                        event.endDate   = item.endDate;
                        event.allDay    = item.allDay;
                        
                        //添加提醒
                        if (item.alarmArray && item.alarmArray.count > 0) {
                            for (NSString *timeString in item.alarmArray) {
                                [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeString integerValue]]];
                            }
                        }
                        
                        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                        NSError *err;
                        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    }
                    
                    if (success) {
                        success();
                    }
                }
            });
        }];
    }
}

// 是否插入过事件s
+ (void)didInsertedEventItems:(NSArray <NEEventCalendarItem *>*)items
                       result:(void(^)(bool))result {
    if (result) {
        if (items.count == 0) {
            result(NO);
            return;
        }
        
        EKEventStore *eventStore = [EKEventStore new];
        if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!granted) {
                        result(NO);
                    } else {
                        for (NEEventCalendarItem *item in items) {
                            if (![self didInsertedEventWithEventStore:eventStore eventItem:item]) {
                                result(NO);
                                return;
                            }
                        }
                        result(YES);
                    }
                });
            }];
        }
    }
}
// 是否插入过事件
+ (BOOL)didInsertedEventWithEventStore:(EKEventStore *)eventStore
                             eventItem:(NEEventCalendarItem *)item {
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:item.startDate endDate:item.endDate calendars:nil];
    if(predicate) {
        //根据谓词条件筛选已插入日历的事件
        NSArray *eventsArray = [eventStore eventsMatchingPredicate:predicate];
        if (eventsArray.count) {
            for (EKEvent *item in eventsArray) {
                //根据事件的某个唯一性，如果已插入日历就不再插入
                if([item.title isEqualToString:item.title] &&
                   [item.startDate isEqualToDate:item.startDate] &&
                   [item.endDate isEqualToDate:item.endDate]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}


+ (void)checkPermission:(void(^)(BOOL))didHavePermission {
    EKEventStore *eventStore = [EKEventStore new];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent
                               completion:^(BOOL granted, NSError *error) {
                                   if (error) {
                                       // 日历出现了错误
                                       didHavePermission(NO);
                                       return;
                                   }
                                   if (granted) {
                                       // 用户同意授权日历
                                       didHavePermission(YES);
                                   } else {
                                       // 用户拒绝授权日历
                                       didHavePermission(NO);
                                   }
                               }];
    
}

+ (BOOL)checkPermission {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status) {
        case  EKAuthorizationStatusNotDetermined:
            return NO;
        case EKAuthorizationStatusRestricted:
            return NO;
        case EKAuthorizationStatusDenied:
            return NO;
        case EKAuthorizationStatusAuthorized:
            return YES;
        default:
            return NO;
    }
}
@end
