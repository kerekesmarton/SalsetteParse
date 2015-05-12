//
//  PFClassRomm.m
//  Salsette
//
//  Created by Kerekes, Marton on 03/04/15.
//
//

#import "PFClassRoom.h"

NSString * const UNNAMED_ROOM = @"UNNAMED_ROOM";

static NSArray *fbEventGraphKeys;

static NSArray *fbProperties;
static NSArray *fbLocalisedDescriptions;
static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;


@implementation PFClassRoom

@dynamic name,venue,order;

+(instancetype)object {
    
    PFClassRoom *room = [super object];
    room.name = UNNAMED_ROOM;
    
    return room;
}

-(NSArray *)dataSourceCount {
    
    return @[pfProperties];
}

-(NSArray *)descriptionDataSourceCount {
    
    return @[pfLocalisedDescriptions];
}

+ (void)load {
    
    if (!fbEventGraphKeys) {
        fbEventGraphKeys = [NSArray array];
    }
    
    if (!fbProperties) {
        fbProperties = [NSArray array];
    }
    if (!fbLocalisedDescriptions) {
        fbLocalisedDescriptions = [NSArray array];
    }
    if (!pfProperties) {
        pfProperties = @[@"name",@"venue"];
    }
    if (!pfLocalisedDescriptions) {
        pfLocalisedDescriptions = @[@"Name",@"Venue"];
    }
    
    [super load];
}

- (NSString *)shortDesc {
    return [NSString stringWithFormat:@"%@",self.name];
}



@end
