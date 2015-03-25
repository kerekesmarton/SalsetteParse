//
//  PFOwner.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 01/09/14.
//
//

#import "PFOwner.h"

@implementation PFOwner

static NSArray *fbEventGraphKeys;

static NSArray *fbProperties;
static NSArray *fbLocalisedDescriptions;
static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;

@dynamic name;

+(instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    
    PFOwner *owner = [super objectWithDictionary:dictionary];
    
    for (NSString *key in fbEventGraphKeys) {
        id obj = dictionary[key];
        
        if ([key isEqualToString:@"name"]) {
            owner.name = obj;
        } else if ([key isEqualToString:@"id"]) {
            owner.identifier = obj;
        }
    }
    
    return owner;
}

+(void)load {
    if (!fbEventGraphKeys) {
        fbEventGraphKeys = @[@"id",@"name"];
    }
    if (!fbProperties) {
        fbProperties = @[@"name"];
    }
    if (!fbLocalisedDescriptions) {
        fbLocalisedDescriptions = @[@"Name"];
    }
    [super load];
}

- (NSString *)shortDesc {
    
    return self.name;
}

-(NSArray *)dataSourceCount {
    
    return @[fbProperties];
}

-(NSArray *)descriptionDataSourceCount {
    
    return @[fbLocalisedDescriptions];
}

@end
