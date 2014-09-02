//
//  NSDateHelper.m
//  NetworkRequest
//
//  Created by Jozsef-Marton Kerekes on 5/30/13.
//  Copyright (c) 2013 Jozsef-Marton Kerekes. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+(NSDate *)begginingOfDay:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *beginningOfDay = nil;
    BOOL ok = [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&beginningOfDay interval:NULL forDate: date];
    if (ok) {
        NSDateComponents *hours = [[NSDateComponents alloc] init];
        hours.hour = 11;
        beginningOfDay = [gregorian dateByAddingComponents:hours toDate:beginningOfDay options:0];
        return beginningOfDay;
    } else {
        return date;
    }    
}

+(NSDate *)endOfDay:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];

    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    return [cal dateFromComponents:components];
    
}

@end
