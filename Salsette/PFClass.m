//
//  PFClass.m
//  Salsette
//
//  Created by Kerekes, Marton on 03/04/15.
//
//

#import "PFClass.h"

NSString * const UNNAMED_CLASS = @"UNNAMED_CLASS";

static NSArray *fbEventGraphKeys;

static NSArray *fbProperties;
static NSArray *fbLocalisedDescriptions;
static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;


@implementation PFClass

@dynamic style,artist,name,startTime,endTime,room;

+(instancetype)object {
    
    PFClass *class = [super object];
    class.name = UNNAMED_CLASS;
    
    return class;
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
        pfProperties = @[@"artist", @"style", @"name", @"room",@"startTime",@"endTime"];
    }
    if (!pfLocalisedDescriptions) {
        pfLocalisedDescriptions = @[@"Artist", @"Style", @"Room", @"Location",@"Starts at",@"Ends at"];
    }
    
    [super load];
}

- (NSString *)shortDesc {
    return [NSString stringWithFormat:@"%@: %@",self.artist, self.name];
}

@end
