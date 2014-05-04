//
//  NSCalendar+IFACategory.m
//  Gusty
//
//  Created by Marcelo Schroeder on 24/11/10.
//  Copyright 2010 InfoAccent Pty Limited. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "IFACommon.h"

static NSUInteger c_firstWeekday = NSNotFound;
static NSUInteger c_minimumDaysInFirstWeek = NSNotFound;

@implementation NSCalendar (IFACategory)

#pragma mark - Public

+(void)IFA_setThreadSafeCalendarFirstWeekday:(NSUInteger)a_firstWeekday{
    @synchronized([NSCalendar class]){
        c_firstWeekday = a_firstWeekday;
    }
}

+(void)IFA_setThreadSafeCalendarMinimumDaysInFirstWeek:(NSUInteger)a_minimumDaysInFirstWeek{
    @synchronized([NSCalendar class]){
        c_minimumDaysInFirstWeek = a_minimumDaysInFirstWeek;
    }
}

+(NSUInteger)IFA_threadSafeCalendarFirstWeekday {
    NSUInteger l_firstWeekday;
    @synchronized([NSCalendar class]){
        l_firstWeekday = c_firstWeekday;
    }
    return l_firstWeekday;
}

+(NSUInteger)IFA_threadSafeCalendarMinimumDaysInFirstWeek {
    NSUInteger l_minimumDaysInFirstWeek;
    @synchronized([NSCalendar class]){
        l_minimumDaysInFirstWeek = c_minimumDaysInFirstWeek;
    }
    return l_minimumDaysInFirstWeek;
}

+ (NSCalendar *)IFA_threadSafeCalendar {
//    NSLog(@"IFA_threadSafeCalendar for thread: %@", [[NSThread currentThread] description]);
    NSMutableDictionary *l_threadDictionary = [[NSThread currentThread] threadDictionary] ;
    NSCalendar *l_calendar = [l_threadDictionary objectForKey:IFA_k_KEY_THREAD_SAFE_CALENDAR] ;
    if (!l_calendar){
//        NSLog(@"   calendar cache miss for thread: %@", [[NSThread currentThread] description]);
        l_calendar = [NSCalendar autoupdatingCurrentCalendar];
        [l_threadDictionary setObject:l_calendar forKey:IFA_k_KEY_THREAD_SAFE_CALENDAR];
//        NSLog(@"   %@", [l_threadDictionary description]);
    }
//    NSLog(@" timeZone: %@", [l_calendar.timeZone description]);
    NSUInteger l_firstWeekday = [self IFA_threadSafeCalendarFirstWeekday];
    if (l_firstWeekday!=NSNotFound) {
        l_calendar.firstWeekday = l_firstWeekday;
    }
    NSUInteger l_minimumDaysInFirstWeek = [self IFA_threadSafeCalendarMinimumDaysInFirstWeek];
    if (l_minimumDaysInFirstWeek!=NSNotFound) {
        l_calendar.minimumDaysInFirstWeek = l_minimumDaysInFirstWeek;
    }
//    NSLog(@"l_calendar: %@", [l_calendar description]);
//    NSLog(@"  firstWeekday: %u", l_calendar.firstWeekday);
//    NSLog(@"  minimumDaysInFirstWeek: %u", l_calendar.minimumDaysInFirstWeek);
    return l_calendar;
}

@end
