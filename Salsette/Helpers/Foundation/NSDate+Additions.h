//
//  NSDate+Additions.h
//  ForeverMapNGX
//
//  Created by Mihai Babici on 10/30/12.
//  Copyright (c) 2012 Skobbler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

+ (int)daysUntilNowFromDate:(NSDate *)date;
+ (NSDate *)dateFromZTimeString:(NSString *)string usingFormat:(NSString *)format;

- (NSDate *)dateByAdding24h;

- (int)numberOfDaysUntilDate:(NSDate *)date;

- (NSDate *)zeroHourNormalized;
- (NSDate *)midnightHourNormalized;
- (NSString *)zTimeStringUsingFormat:(NSString *)stringFormat;

- (NSArray *)lastWeekDays;
- (int)daysToPresent;
- (int)weeksToPresent;
- (int)monthsToPresent;
- (int)yearsToPresent;

- (NSString*)stringFromDateUsingTimeZone:(NSTimeZone*)timeZone;

- (BOOL)isBetweenDate:(NSDate *)earlierDate andDate:(NSDate *)laterDate;

@end
