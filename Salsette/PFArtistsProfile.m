//
//  PFArtistsProfile.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 04/09/14.
//
//

#import "PFArtistsProfile.h"
#import "PFCover.h"
#import "PFDanceStyle.h"

static NSArray *fbEventGraphKeys;

static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;

@implementation PFArtistsProfile {
    BOOL didComplete;
}

@dynamic name,shortBio,coverPhoto,primaryStyle,secondaryStyle;

@dynamic coverPhotoID,primaryStyleID,secondaryStyleID;

+(instancetype)objectWithIdentifier:(NSString *)identifier {
    
    PFArtistsProfile *object = [PFArtistsProfile object];
    object.identifier = identifier;
    
    return object;
}

+(void)load {
    
    if (!pfProperties) {
        pfProperties = @[@"name", @"shortBio", @"coverPhoto", @"primaryStyle",@"secondaryStyle"];
    }
    
    if (!pfLocalisedDescriptions) {
        pfLocalisedDescriptions = @[@"Name", @"Bio", @"Cover Photo", @"Main Style", @"Second Style"];
    }
    
    [self registerSubclass];
}

-(NSString *)shortDesc {
    return self.name;
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
                
                PFArtistsProfile *object = [objects firstObject];
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
