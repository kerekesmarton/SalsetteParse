//
//  NSDate+Additions.m
//  ForeverMapNGX
//
//  Created by Mihai Babici on 10/30/12.
//  Copyright (c) 2012 Skobbler. All rights reserved.
//

#import "NSDate+Additions.h"

int const kFMTimeHoursInADay        = 24;
int const kFMTimeMinutesInAnHour    = 60;
int const kFMTimeSecondsInAnHour    = 3600;
int const kFMTimeSecondsInADay      = 86400;

@implementation NSDate (Additions)

+ (int)daysUntilNowFromDate:(NSDate *)date {
    NSDate *nowDate = [NSDate date];
    
    return [date numberOfDaysUntilDate:nowDate];
}

+ (NSDate *)dateFromZTimeString:(NSString *)string usingFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *date = nil;
    NSString *error = nil;
    [formatter getObjectValue:&date forString:string errorDescription:&error];
    
    return date;
}

- (NSDate *)dateByAdding24h {
    return [self dateByAddingTimeInterval:(24 * 60 * 60)];
}

- (int)numberOfDaysUntilDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:self toDate:[date zeroHourNormalized] options:0];
    
    return [components day];
}

- (NSArray *)lastWeekDays {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSMutableArray *array = [NSMutableArray array];
    
    CGFloat secondsInADay = (CGFloat)kFMTimeSecondsInADay;
    for (int i = 1; i < 7; i++) {
        NSDate *date = [self dateByAddingTimeInterval:-secondsInADay * i];
        NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:date];
        [array addObject:[NSNumber numberWithInt:components.weekday]];
    }
    
    return array;
}

- (NSDate *)midnightHourNormalized {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    CGFloat time = components.hour * (CGFloat)kFMTimeSecondsInAnHour + components.minute * (CGFloat)kFMTimeMinutesInAnHour + components.second;
    
    return [self dateByAddingTimeInterval:kFMTimeSecondsInADay - time];
}

- (NSDate *)zeroHourNormalized {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    CGFloat time = components.hour * (CGFloat)kFMTimeSecondsInAnHour + components.minute * (CGFloat)kFMTimeMinutesInAnHour + components.second;
    
    return [self dateByAddingTimeInterval:-time];
}

- (NSDateComponents *)dateComponentsToPresent:(int)components {
    NSDate *nowDate = [[NSDate date] midnightHourNormalized];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    return [calendar components:components fromDate:self toDate:nowDate options:0];
}

- (NSString *)zTimeStringUsingFormat:(NSString *)stringFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = stringFormat;
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *string = [formatter stringFromDate:self];
    
    return string;
}

- (int)daysToPresent {
    return [[self dateComponentsToPresent:NSDayCalendarUnit] day];
}

- (int)weeksToPresent {
    return [[self dateComponentsToPresent:NSWeekCalendarUnit] weekOfMonth];
}

- (int)monthsToPresent {
    return [[self dateComponentsToPresent:NSMonthCalendarUnit] month];
}

- (int)yearsToPresent {
    return [[self dateComponentsToPresent:NSYearCalendarUnit] year];
}

- (NSString*)stringFromDateUsingTimeZone:(NSTimeZone*)timeZone {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:self];
}

- (BOOL)isBetweenDate:(NSDate *)earlierDate andDate:(NSDate *)laterDate
{
    // first check that we are later than the earlierDate.
    if ([self compare:earlierDate] == NSOrderedDescending) {
        
        // next check that we are earlier than the laterData
        if ( [self compare:laterDate] == NSOrderedAscending ) {
            return YES;
        }
    }
    
    // otherwise we are not
    return NO;
}

@end
