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
            owner.identifier = @([obj intValue]);
        }
    }
    
    return owner;
}

+(void)load {
    if (!fbEventGraphKeys) {
        fbEventGraphKeys = @[@"name", @"id"];
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

+(void)queryForID:(NSNumber *)identifier completion:(void (^)(id, NSError *))block {
    
    PFQuery *query = [self query];
    [query whereKey:@"identifier" equalTo:identifier];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                
                PFOwner *owner = [objects firstObject];
                block(owner,nil);
            } else {
                block(nil,nil);
            }
            
        } else {
            block(nil,error);
        }
    }];
}

@end
