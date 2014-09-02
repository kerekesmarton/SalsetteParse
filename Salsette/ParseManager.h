//
//  ParseManager.h
//  salsette
//
//  Created by Kerekes Jozsef-Marton on 26/06/14.
//  Copyright (c) 2014 Kerekes Jozsef-Marton. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PFUserSessionDidChangeNotification;

@interface ParseManager : NSObject

+ (void)registerAppWithLauncOptions:(NSDictionary *)dictionary;
+ (void)requestFacebookUserdataAndUpdateProfileWithCompletion:(void (^)(void))block;

+ (void)fetchUserImageFromFacebookWithCompletion:(void (^)(UIImage *responseObject))success;
+ (void)fetchImageWithURL:(NSString *)ulrString Completion:(void (^)(UIImage *responseObject))success;

@end
