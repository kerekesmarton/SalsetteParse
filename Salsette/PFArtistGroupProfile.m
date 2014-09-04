//
//  PFArtistGroupProfile.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 04/09/14.
//
//

#import "PFArtistGroupProfile.h"
#import "PFCover.h"
#import "PFDanceStyle.h"
#import "PFArtistsProfile.h"

static NSArray *fbEventGraphKeys;

static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;

@implementation PFArtistGroupProfile {
    BOOL didComplete;
}

@dynamic groupName,members,admins,shortBio,coverPhoto,primaryStyle,secondaryStyle;

@dynamic coverPhotoID,primaryStyleID,secondaryStyleID,memberIDs;


+(instancetype)objectWithIdentifier:(NSString *)identifier {
    
    PFArtistGroupProfile *object = [PFArtistGroupProfile object];
    object.identifier = identifier;
    
    return object;
}

+(void)load {
    
    if (!pfProperties) {
        pfProperties = @[@"groupName", @"members",@"shortBio", @"coverPhoto", @"primaryStyle",@"secondaryStyle"];
    }
    
    if (!pfLocalisedDescriptions) {
        pfLocalisedDescriptions = @[@"Name", @"Members",@"Bio", @"Cover Photo", @"Main Style", @"Second Style"];
    }
    
    [self registerSubclass];
}

-(NSString *)shortDesc {
    return self.groupName;
}

-(NSArray *)dataSourceCount {
    
    return @[pfProperties];
}

-(NSArray *)descriptionDataSourceCount {
    
    return @[pfLocalisedDescriptions];
}

+ (void)queryForID:(NSString *)identifier completion:(void (^)(id, NSError *))block {
    
    PFQuery *query = [self query];
    [query whereKey:@"identifier" equalTo:identifier];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            if (objects.count > 0) {
                
                PFArtistGroupProfile *object = [objects firstObject];
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
    
    for (NSString *identifier in self.memberIDs) {
        [PFArtistsProfile queryForID:identifier completion:^(id object, NSError *e) {
            if (e) {
                NSLog(@"%s\n%@",__PRETTY_FUNCTION__,[e userInfo]);
            } else {
                [self.members setObject:object forKey:identifier];
                [self tryCompleteBlock:block];
            }
        }];
    }
    
    for (NSString *identifier in self.adminIDs) {
        [PFArtistsProfile queryForID:identifier completion:^(id object, NSError *e) {
            if (e) {
                NSLog(@"%s\n%@",__PRETTY_FUNCTION__,[e userInfo]);
            } else {
                [self.admins setObject:object forKey:identifier];
                [self tryCompleteBlock:block];
            }
        }];
    }
    
}

- (void)tryCompleteBlock:(void (^)(id,NSError *))block {
    
    __block BOOL isReady = YES;
    
    if (![self.coverPhoto isDataAvailable]) {
        isReady = NO;
    }
    
    if (![self.primaryStyle isDataAvailable]) {
        isReady = NO;
    }
    
    if (![self.secondaryStyle isDataAvailable]) {
        isReady = NO;
    }
    
    [self.members enumerateKeysAndObjectsUsingBlock:^(NSString *key, PFArtistsProfile *obj, BOOL *stop) {
        
        if (![obj isDataAvailable]) {
            isReady = NO;
            *stop = YES;
        }
    }];
    
    [self.admins enumerateKeysAndObjectsUsingBlock:^(NSString *key, PFArtistsProfile *obj, BOOL *stop) {
        
        if (![obj isDataAvailable]) {
            isReady = NO;
            *stop = YES;
        }
    }];
    
    if (!didComplete && isReady) {
        didComplete = YES;
        block (self,nil);
    }
}

@end
