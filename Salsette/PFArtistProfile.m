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

+(PFQuery *)primaryQueryWithDanceStyle:(PFDanceStyle *)style name:(NSString *)name {
    
    PFQuery *danceStyleQuery = [PFDanceStyle query];
    [danceStyleQuery whereKey:@"danceStyle" equalTo:@(style.danceStyle)];
    
    PFQuery *primaryQuery = [self query];
    [primaryQuery whereKey:@"primaryStyle" matchesQuery:danceStyleQuery];
    [primaryQuery whereKey:@"name" containsString:name];
    
    return primaryQuery;
}

+(PFQuery *)secondaryQueryWithDanceStyle:(PFDanceStyle *)searchStyle name:(NSString *)name  {
    
    PFQuery *danceStyleQuery = [PFDanceStyle query];
    [danceStyleQuery whereKey:@"danceStyle" equalTo:@(searchStyle.danceStyle)];
    
    PFQuery *secondaryQuery = [self query];
    [secondaryQuery whereKey:@"secondaryStyle" matchesQuery:danceStyleQuery];
    [secondaryQuery whereKey:@"name" containsString:name];
    
    return secondaryQuery;
}

+ (void)searchWithQuery:(PFQuery *)query partial:(void (^)(id, NSError *, NSInteger))block completion:(void (^)(id, NSError *))completion {
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            if (objects.count > 0) {
                
                for (PFArtistProfile *object in objects) {
                    PFQuery *query = [PFArtistProfile query];
                    [query whereKey:@"identifier" equalTo:object.identifier];
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        block(object,nil,[objects indexOfObject:object]);
                    }];
                }
                completion(objects,nil);
                
            } else {
                completion(nil,nil);
            }
            
        } else {
            completion(nil,error);
        }
    }];
}
@end
