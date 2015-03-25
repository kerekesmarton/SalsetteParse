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
#import "PFArtistProfile.h"

static NSArray *fbEventGraphKeys;

static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;

@implementation PFArtistGroupProfile {
    BOOL didComplete;
}

@dynamic groupName,members,admins,shortBio,coverPhoto,primaryStyle,secondaryStyle;

@dynamic coverPhotoID,primaryStyleID,secondaryStyleID,memberIDs,adminIDs;


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

@end
