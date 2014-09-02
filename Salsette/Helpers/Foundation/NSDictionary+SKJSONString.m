//
//  NSDictionary+SKJSONString.m
//  ForeverMapNGX
//
//  Created by Mihai Serban on 18/04/14.
//  Copyright (c) 2014 Skobbler. All rights reserved.
//

#import "NSDictionary+SKJSONString.h"

@implementation NSDictionary (SKJSONString)

-(NSString*)JSONStringWithPrettyPrint:(BOOL)prettyPrint
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"JSONStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
