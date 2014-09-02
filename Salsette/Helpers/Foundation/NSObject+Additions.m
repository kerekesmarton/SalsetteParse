//
//  NSObject+Additions.m
//  ForeverMapNGX
//
//  Created by Mihai Costea on 12/3/13.
//  Copyright (c) 2013 Skobbler. All rights reserved.
//

#import "NSObject+Additions.h"

static NSString* const kIpadSuffix = @"IPad";

@implementation NSObject (Additions)

+ (Class)deviceSpecificClass {
    if ([UIDevice isiPad]) {
        NSString *classString = [NSString stringWithFormat:@"%@%@", NSStringFromClass([self class]), kIpadSuffix];
        return NSClassFromString(classString);
    }
    
    return [self class];
}

@end
