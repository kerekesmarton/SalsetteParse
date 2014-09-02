//
//  UIApplication+Additions.m
//  ForeverMapNGX
//
//  Created by Mihai Babici on 11/28/12.
//  Copyright (c) 2012 Skobbler. All rights reserved.
//

#import "UIApplication+Additions.h"

@implementation UIApplication (Additions)

static AppDelegate *appDelegate = nil;

+ (AppDelegate *)appDelegate {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    });
    
    return appDelegate;
}

+ (int)currentMajorBundleVersion {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *majorVersion = [currentVersion componentsSeparatedByString:@"."][0];
    
    return [majorVersion intValue];
}

@end
