//
//  PFDanceStyle.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 03/09/14.
//
//

#import "PFDanceStyle.h"

static NSArray *danceStyleIdentifiers;

static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;

@implementation PFDanceStyle

@dynamic danceStyle;

+(instancetype)objectWithStyle:(DanceStyle)style identifier:(NSString *)identifier {
    
    PFDanceStyle *object = [PFDanceStyle object];
    object.danceStyle = style;
    object.identifier = identifier;
    
    return object;
}

+(void)load {
    
    if (!danceStyleIdentifiers) {
        danceStyleIdentifiers = @[@"Undefined", @"Line Salsa", @"Cuban Salsa", @"Colombian Salsa", @"Bachata", @"Zouk",@"Kizomba"];
    }
    
    if (!pfProperties) {
        pfProperties = @[@"danceStyle"];
    }
    
    if (!pfLocalisedDescriptions) {
        pfLocalisedDescriptions = @[@"Style"];
    }
    
    [self registerSubclass];
}

-(NSString *)shortDesc {
    return [PFDanceStyle stringForStyle:self.danceStyle];
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
                
                PFDanceStyle *object = [objects firstObject];
                block(object,nil);
            } else {
                block(nil,nil);
            }
            
        } else {
            block(nil,error);
        }
    }];
}

+(NSString *)stringForStyle:(DanceStyle)style {
    return [danceStyleIdentifiers objectAtIndex:style];
}

@end
