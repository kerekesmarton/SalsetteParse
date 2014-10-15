//
//  PFArtistsProfile.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 04/09/14.
//
//

#import "PFArtistProfile.h"
#import "PFCover.h"
#import "PFDanceStyle.h"

static NSArray *fbEventGraphKeys;

static NSArray *fbProperties;
static NSArray *fbLocalisedDescriptions;

static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;

@implementation PFArtistProfile {
    BOOL didComplete;
}

@dynamic name,shortBio,about,hometown,coverPhoto,primaryStyle,secondaryStyle;

@dynamic pfUser,coverPhotoID,primaryStyleID,secondaryStyleID;

+(instancetype)objectWithDictionary:(NSDictionary *)graph {
    
    PFArtistProfile *artistProfile = [self object];
    
    for (NSString *key in fbEventGraphKeys) {
        
        id obj = graph[key];
        
        if ([key isEqualToString:@"id"]) {
            
            artistProfile.identifier = obj;
        } else if ([key isEqualToString:@"cover"]) {
            
            artistProfile.coverPhoto = [PFCover objectWithDictionary:obj];
            artistProfile.coverPhotoID = artistProfile.coverPhoto.identifier;
        }
        else if ([key isEqualToString:@"description"]) {
            artistProfile.shortBio = obj;
            
        }
        else if ([key isEqualToString:@"about"]) {
            artistProfile.about = obj;
            
        }
        else if ([key isEqualToString:@"name"]) {
            artistProfile.name = obj;
            
        }
        else if ([key isEqualToString:@"hometown"]) {
            artistProfile.hometown = obj;
            
        }
        
    }
    
    NSString *mainID = [NSString stringWithFormat:@"m_%@",artistProfile.identifier];
    artistProfile.primaryStyle = [PFDanceStyle objectWithStyle:DanceStyleUndefined identifier:mainID];
    artistProfile.primaryStyleID = mainID;
    
    NSString *secondID = [NSString stringWithFormat:@"s_%@",artistProfile.identifier];
    artistProfile.secondaryStyle = [PFDanceStyle objectWithStyle:DanceStyleUndefined identifier:secondID];
    artistProfile.secondaryStyleID = secondID;
    
    return artistProfile;
}

+(void)load {
    
    if (!fbEventGraphKeys) {
        fbEventGraphKeys = @[@"id",@"about",@"cover", @"description", @"hometown", @"name"];
    }
    
    if (!fbProperties) {
        fbProperties = @[@"name",@"about", @"shortBio", @"hometown"];
    }
    
    if (!fbLocalisedDescriptions) {
        fbLocalisedDescriptions = @[@"Name",@"About", @"Bio", @"Home Town"];
    }
    
    if (!pfProperties) {
        pfProperties = @[@"coverPhoto", @"primaryStyle",@"secondaryStyle"];
    }
    
    if (!pfLocalisedDescriptions) {
        pfLocalisedDescriptions = @[@"Cover Photo", @"Main Style", @"Second Style"];
    }
    
    [self registerSubclass];
}

-(NSString *)shortDesc {
    return self.name;
}

-(NSArray *)dataSourceCount {
    
    return @[fbProperties,pfProperties];
}

-(NSArray *)descriptionDataSourceCount {
    
    return @[fbLocalisedDescriptions,pfLocalisedDescriptions];
}

+ (void)queryForID:(NSString *)identifier completion:(void (^)(id, NSError *))block {
    
    PFQuery *query = [self query];
    [query whereKey:@"identifier" equalTo:identifier];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            if (objects.count > 0) {
                
                PFArtistProfile *object = [objects firstObject];
                [object fetchEventDetailsWithBlock:^(id object, NSError *error) {
                    block(object,nil);
                }];
                
            } else {
                block(nil,nil);
            }
            
        } else {
            block(nil,error);
        }
    }];
}

- (void)fetchEventDetailsWithBlock:(void (^)(id,NSError *))block {
    
    didComplete = NO;
    [PFCover queryForID:self.coverPhotoID completion:^(PFCover *object, NSError *error) {
        if (error) {
            NSLog(@"%s\n%@",__PRETTY_FUNCTION__,[error userInfo]);
        } else {
            self.coverPhoto = object;
            [self tryCompleteBlock:block];
        }
    }];
    
    [PFDanceStyle queryForID:self.primaryStyleID completion:^(PFDanceStyle *style, NSError *error) {
        if (error) {
            NSLog(@"%s\n%@",__PRETTY_FUNCTION__,[error userInfo]);
        } else {
            self.primaryStyle = style;
            [self tryCompleteBlock:block];
        }
    }];
    
    [PFDanceStyle queryForID:self.secondaryStyleID completion:^(PFDanceStyle *style, NSError *error) {
        if (error) {
            NSLog(@"%s\n%@",__PRETTY_FUNCTION__,[error userInfo]);
        } else {
            self.secondaryStyle = style;
            [self tryCompleteBlock:block];
        }
    }];
    
}

- (void)tryCompleteBlock:(void (^)(id,NSError *))block {
    
    BOOL isReady = YES;
    
    if (![self.coverPhoto isDataAvailable]) {
        isReady = NO;
    }
    
    if (![self.primaryStyle isDataAvailable]) {
        isReady = NO;
    }
    
    if (![self.secondaryStyle isDataAvailable]) {
        isReady = NO;
    }
    
    if (!didComplete && isReady) {
        didComplete = YES;
        block (self,nil);
    }
}

@end
