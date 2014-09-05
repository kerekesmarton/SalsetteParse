//
//  ParseManager.m
//  salsette
//
//  Created by Kerekes Jozsef-Marton on 26/06/14.
//  Copyright (c) 2014 Kerekes Jozsef-Marton. All rights reserved.
//

#import "ParseManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"

#import "ParseIncludes.h"

@implementation ParseManager



+ (AFHTTPRequestOperationManager *)session {
    
    static AFHTTPRequestOperationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
    });
    return manager;
}

+ (void)registerAppWithLauncOptions:(NSDictionary *)launchOptions {
    
    [PFEvent load];
    [PFOwner load];
    [PFVenue load];
    [PFCover load];
    [PFDanceStyle load];
    
    [Parse setApplicationId:@"jmtHBjv2Fkz6gDrq63ntDz22bhccJy7aWVv3ulyN" clientKey:@"juDQE9HtWBOZkMOeKQpiboVo9wuflH7McJWtO0gM"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

+(void)requestFacebookUserdataAndUpdateProfileWithCompletion:(void (^)(void))block {
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionary];
            
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
            }
            
            if (userData[@"name"]) {
                userProfile[@"name"] = userData[@"name"];
            }
            
            if (userData[@"location"][@"name"]) {
                userProfile[@"location"] = userData[@"location"][@"name"];
            }
            
            if (userData[@"gender"]) {
                userProfile[@"gender"] = userData[@"gender"];
            }
            
            if (userData[@"birthday"]) {
                userProfile[@"birthday"] = userData[@"birthday"];
            }
            
            if ([pictureURL absoluteString]) {
                userProfile[@"pictureURL"] = [pictureURL absoluteString];
            }
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            
            block();
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

+ (void)fetchImageWithURL:(NSString *)ulrString completion:(void (^)(UIImage *responseObject))success {
    NSURL *url = [NSURL URLWithString:ulrString];
    if (!url) {
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    
    [[self session].operationQueue addOperation:requestOperation];
}


@end
