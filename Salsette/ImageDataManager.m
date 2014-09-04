//
//  ArtistImageDataSource.m
//  SAFapp
//
//  Created by Kerekes Marton on 2/20/13.
//  Copyright (c) 2013 Jozsef-Marton Kerekes. All rights reserved.
//

#import "ImageDataManager.h"
#import "ParseManager.h"
#import <Parse/PFUser.h>

@implementation ImageDataManager {
    
    NSMutableDictionary *imageDataDictionary;
}

static int kPlaceHolderImageWidth = 60;

+ (ImageDataManager *)sharedInstance {
    static ImageDataManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ImageDataManager alloc] init];
    });
    
    return _sharedClient;
}

-(id)init {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    NSURL *documentsURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"images"];
    NSString *filename = [documentsURL relativePath];
    
    if (![[NSFileManager defaultManager]  fileExistsAtPath:filename]) {
        [[NSFileManager defaultManager] createFileAtPath:filename contents:nil attributes:nil];
    }
    
    imageDataDictionary = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:filename]];
    
    return self;
}

-(void)save{
    
    NSURL *documentsURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"images"];
    NSString *filename = [documentsURL relativePath];
    
    [NSKeyedArchiver archiveRootObject:imageDataDictionary toFile:filename];
}

-(void)setObject:(id)object forKey:(NSString *)key{
    
    if (!object) {
        [imageDataDictionary removeObjectForKey:key];
    } else {
        [imageDataDictionary setObject:object forKey:key];
    }
}

-(NSData*)objectForKey:(NSString*)key {
    
    return [imageDataDictionary objectForKey:key];
}

-(void)imageForIdentifier:(NSString*)identifier url:(NSString *)url completion:(void (^)(UIImage *responseObject))success {
    NSData *imgData = [self objectForKey:[NSString stringWithFormat:@"%@",identifier]];
    if (imgData) {
        
        success([UIImage imageWithData:imgData]);
    } else {
        
        [ParseManager fetchImageWithURL:url completion:^(UIImage *responseObject) {
            if (responseObject) {
                NSData *imageData = UIImageJPEGRepresentation(responseObject, 100);
                [[ImageDataManager sharedInstance] setObject:imageData forKey:[NSString stringWithFormat:@"%@",identifier]];
                success(responseObject);
            } else {
                success(nil);
            }
        }];
    
    }
}

-(void)userImageFromFacebookWithCompletion:(void (^)(UIImage *responseObject))success {
    
    NSData *imgData = [self objectForKey:[NSString stringWithFormat:@"%@",@"userImage"]];
    if (imgData) {
        
        success([UIImage imageWithData:imgData]);
    } else {
        
        if ([[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]) {
            
            NSString *pictureURL = [[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"];
            
            [ParseManager fetchImageWithURL:pictureURL completion:^(UIImage *responseObject) {
                
                if (responseObject) {
                    NSData *imageData = UIImageJPEGRepresentation(responseObject, 100);
                    [[ImageDataManager sharedInstance] setObject:imageData forKey:[NSString stringWithFormat:@"%@",@"userImage"]];
                    success(responseObject);
                } else {
                    success(nil);
                }
            }];
        }
    }
}


-(UIImage*)scaledImageWithData:(NSData*)data {
    UIImage *img = [UIImage imageWithData:data];
    float widthRatio = img.size.width / kPlaceHolderImageWidth;
    float requiredHeight = img.size.height / widthRatio;
    return [UIImage imageWithImage:img scaledToSize:CGSizeMake(60, requiredHeight)];
}

@end
