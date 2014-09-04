//
//  ArtistImageDataSource.h
//  SAFapp
//
//  Created by Kerekes Marton on 2/20/13.
//  Copyright (c) 2013 Jozsef-Marton Kerekes. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ DownloadBlock)(NSData*);

@interface ImageDataManager : NSObject

+ (ImageDataManager *)sharedInstance;

-(void)setObject:(id)object forKey:(NSString *)key;
-(NSData*)objectForKey:(NSString*)key;
-(void)save;

-(void)imageForIdentifier:(NSString*)identifier url:(NSString *)url completion:(void (^)(UIImage *responseObject))success;
-(void)userImageFromFacebookWithCompletion:(void (^)(UIImage *responseObject))success;

@end
