//
//  PFVenue.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 30/08/14.
//
//

#import "PFVenue.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/PFObject+Subclass.h>

static NSArray *fbEventGraphKeys;

static NSArray *fbProperties;
static NSArray *fbLocalisedDescriptions;
static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;


@implementation PFVenue

@dynamic city,country,street,zip,geoPoint;

+(instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    
    PFVenue *venue = [super objectWithDictionary:dictionary];
    NSNumber *lat;
    NSNumber *lon;
    for (NSString *key in fbEventGraphKeys) {
        id obj = dictionary[key];
        
        
        if ([key isEqualToString:@"city"]) {
            venue.city = obj;
        } else if ([key isEqualToString:@"country"]) {
            venue.country = obj;
        } else if ([key isEqualToString:@"id"]) {
            venue.identifier = obj;
        } else if ([key isEqualToString:@"latitude"]) {
            lat = @([obj doubleValue]);
        } else if ([key isEqualToString:@"longitude"]) {
            lon = @([obj doubleValue]);
        } else if ([key isEqualToString:@"street"]) {
            venue.street = obj;
        } else if ([key isEqualToString:@"zip"]) {
            venue.zip = obj;
        }
    }
    if (lat && lon) {
        venue.geoPoint = [PFGeoPoint geoPointWithLatitude:[lat doubleValue] longitude:[lon doubleValue]];
    }
    
    return venue;
}

+(void)load {
    
    if (!fbEventGraphKeys) {
        fbEventGraphKeys = @[@"id",@"city", @"country", @"latitude", @"longitude", @"street", @"zip"];
    }
    if (!fbProperties) {
        fbProperties = @[@"city", @"country", @"street", @"zip"];
    }
    if (!fbLocalisedDescriptions) {
        fbLocalisedDescriptions = @[@"City", @"Country", @"Street",@"Zip"];
    }
    if (!pfProperties) {
        pfProperties = @[@"geoPoint"];
    }
    if (!pfLocalisedDescriptions) {
        pfLocalisedDescriptions = @[@"Coords"];
    }
    [super load];
}

- (NSString *)shortDesc {
    
    NSMutableString *result = [NSMutableString string];
    
    if (self.zip) {
        [result appendString:self.zip];
    }
    
    if (self.city) {
        if ([result isNotEmptyOrWhiteSpace]) {
            [result appendString:@" "];
        }
        [result appendString:self.city];
    }
    
    if (self.street) {
        if ([result isNotEmptyOrWhiteSpace]) {
            [result appendString:@", "];
        }
        [result appendString:self.street];
    }
 
    return [NSString stringWithString:result];
}

-(NSArray *)dataSourceCount {
    
    return @[fbProperties,pfProperties];
}

-(NSArray *)descriptionDataSourceCount {
    
    return @[fbLocalisedDescriptions,pfLocalisedDescriptions];
}

+(void)queryForID:(NSString *)identifier completion:(void (^)(id,NSError *))block {
    
    PFQuery *query = [self query];
    [query whereKey:@"identifier" equalTo:identifier];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                
                PFVenue *venue = [objects firstObject];
                block(venue,nil);
            } else {
                block(nil,nil);
            }
            
        } else {
            block(nil,error);
        }
    }];
}



@end
