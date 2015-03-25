//
//  PFArtistList.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 17/10/14.
//
//

#import "PFArtistList.h"

#import "PFArtistProfile.h"

static NSArray *fbEventGraphKeys;

static NSArray *fbProperties;
static NSArray *fbLocalisedDescriptions;

static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;

@implementation PFArtistList {
    int completeCount;
}


@dynamic artists;

+(instancetype)objectWithArtists:(NSArray *)artists identifier:(NSString *)identifier {
    
    PFArtistList *list = [self object];
    list.identifier = identifier;
    list.artists = artists;
    
    return list;
}

+(void)load {
    
    if (!pfProperties) {
        pfProperties = @[@"artists"];
    }
    
    if (!pfLocalisedDescriptions) {
        pfLocalisedDescriptions = @[@"Artists"];
    }
    
    [self registerSubclass];
}

-(NSString *)shortDesc {
    
    NSMutableString *list = [NSMutableString string];
    for (PFArtistProfile *obj in self.artists) {
        
        if ([list isNotEmptyOrWhiteSpace]) {
            [list appendString:@", "];
        }
        if ([obj isDataAvailable]) {
            [list appendString:obj.shortDesc];
        }
        
    }
    
    return [NSString stringWithFormat:@"ArtistList with identifiers: %@", list];
}

-(NSArray *)dataSourceCount {
    
    return @[pfProperties];
}

-(NSArray *)descriptionDataSourceCount {
    
    return @[pfLocalisedDescriptions];
}

-(void)addArtistsObject:(PFArtistProfile *)object {
    
    NSMutableArray *objects = [NSMutableArray arrayWithArray:self.artists];
    [objects addObject:object];
    self.artists = [objects copy];
}

-(void)removeArtistsObject:(PFArtistProfile *)object {
    
    NSMutableArray *objects = [NSMutableArray arrayWithArray:self.artists];
    [objects removeObject:object];
    self.artists = [objects copy];
}

@end
