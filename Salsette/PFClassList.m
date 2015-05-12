//
//  PFClassList.m
//  Salsette
//
//  Created by Kerekes, Marton on 03/04/15.
//
//

#import "PFClassList.h"

static NSArray *fbEventGraphKeys;

static NSArray *fbProperties;
static NSArray *fbLocalisedDescriptions;
static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;


@implementation PFClassList

@dynamic schedule,rooms,days;

+(instancetype)objectWithIdentifier:(NSString *)identifier {
    
    PFClassList *list = [self object];
    list.identifier = identifier;
    
    return list;
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
        pfProperties = @[@"schedule"];
    }
    if (!pfLocalisedDescriptions) {
        pfLocalisedDescriptions = @[@"Schedule"];
    }
    
    [super load];
}

- (NSString *)shortDesc {
    return nil;
}

@end
