//
//  UIDevice+Additions.m
//  ForeverMapNGX
//
//  Created by Mihai Babici on 11/28/12.
//  Copyright (c) 2012 Skobbler. All rights reserved.
//

#import "UIDevice+Additions.h"
#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

#import <sys/types.h>
#import <sys/sysctl.h>
#include <sys/socket.h> // Per msqr
#include <net/if.h>
#include <net/if_dl.h>

@implementation UIDevice (Additions)

static NSString *deviceModel = nil;

static NSString *deviceUID = @"deviceUID";

+ (BOOL)isiPad {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

+ (BOOL)isRetinaiPad {
    return [[UIScreen mainScreen] scale] == 2.0 && [UIDevice isiPad];
}

+ (BOOL)isWidescreeniPhone {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    return ![UIDevice isiPad] && (screenSize.width >= 568.0 || screenSize.height >= 568.0);
}

+ (NSString *)modelString {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *answer = (char *)malloc(size);
        sysctlbyname("hw.machine", answer, &size, NULL, 0);
        NSString *result = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
        free(answer);
        
        NSDictionary *dictionary = @{
        @"iPhone1,1" : @"iPhone2G",
        @"iPhone1,2" : @"iPhone3G",
        @"iPhone2,1" : @"iPhone3GS",
        @"iPhone3,1" : @"iPhone4G",
        @"iPhone3,3" : @"iPhone4G",
        @"iPhone4,1" : @"iPhone4S",
        @"iPhone5,1" : @"iPhone5G",
        @"iPhone5,2" : @"iPhone5G",
        @"iPhone5,3" : @"iPhone5C",
        @"iPhone5,4" : @"iPhone5C",
        @"iPhone5,5" : @"iPhone5C",
        @"iPhone6,1" : @"iPhone5S",
        @"iPhone6,2" : @"iPhone5S",
        @"iPad1,1" : @"iPad",
        @"iPad2,1" : @"iPad2",
        @"iPad2,2" : @"iPad2",
        @"iPad2,3" : @"iPad2",
        @"iPad2,4" : @"iPad2",
        @"iPad2,5" : @"iPadMini",
        @"iPad2,6" : @"iPadMini",
        @"iPad2,7" : @"iPadMini",
        @"iPad3,1" : @"iPad3",
        @"iPad3,2" : @"iPad3",
        @"iPad3,3" : @"iPad3",
        @"iPad3,4" : @"iPad4",
        @"iPad3,5" : @"iPad4",
        @"iPad3,6" : @"iPad4",
        @"iPad4,1" : @"iPadAir",
        @"iPad4,2" : @"iPadAir",
        @"iPod1,1" : @"iPod1G",
        @"iPod2,1" : @"iPod2G",
        @"iPod3,1" : @"iPod3G",
        @"iPod4,1" : @"iPod4G",
        @"iPod5,1" : @"iPod5G",
        @"86" : @"iPhoneSimulator",
        @"x86_64" : @"iPhoneSimulator"
        };
        
        deviceModel = [dictionary objectForKey:result];
        if (!deviceModel) {
            deviceModel = @"unknown";
        }
    });
    
    return deviceModel;
}

// This will not work above iOS 7.0.2
- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

- (NSString*)uniqueDeviceIdentifier {
    
    static NSString *uuidString;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uuidString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    });
    
    return uuidString;
}

- (NSString*)freeMapDeviceIdentifier {
    
    //check UserDefaults
    NSString *uuidString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uuidString;
}


- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

+ (NSInteger)majorSystemVersion {
    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSArray *versionArray = [version componentsSeparatedByString:@"."];
    
    return [versionArray[0] integerValue];
}

@end
