//
//  EventObject.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 29/08/14.
//
//

#import "PFEvent.h"
#import <FacebookSDK/FacebookSDK.h>

#import "PFEvent.h"
#import "PFOwner.h"
#import "PFVenue.h"

static NSArray *fbEventGraphKeys;

static NSArray *fbProperties;
static NSArray *fbLocalisedDescriptions;
static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;

@implementation PFEvent

@dynamic name,longDesc,coverPhoto,venue,location,owner,startTime,endTime,timeZone,attending,maybe,ticketURI;

@dynamic artists,mainStyle,secondaryStyle;

@dynamic pfUser,venueID,ownerID;

+(PFEvent *)eventWithGraphObject:(FBGraphObject *)graph {
    
    PFEvent *event = [super objectWithDictionary:graph];
    
    for (NSString *key in fbEventGraphKeys) {
        
        id obj = graph[key];
        
        if ([key isEqualToString:@"id"]) {
            
            event.identifier = @([obj intValue]);
        } else if ([key isEqualToString:@"cover"]) {
            
            event.coverPhoto = obj;
        }
        else if ([key isEqualToString:@"description"]) {
            event.longDesc = obj;
            
        }
        else if ([key isEqualToString:@"name"]) {
            event.name = obj;
            
        }
        else if ([key isEqualToString:@"venue"]) {
            event.venue = [PFVenue objectWithDictionary:obj];
            event.venueID = event.venue.identifier;
            
        }
        else if ([key isEqualToString:@"location"]) {
            event.location = obj;
            
        }
        else if ([key isEqualToString:@"owner"]) {
            event.owner = [PFOwner objectWithDictionary:obj];
            event.ownerID = event.owner.identifier;
        }
        else if ([key isEqualToString:@"start_time"]) {
            NSString *time = obj;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZ'"];
            event.startTime = [formatter dateFromString:time];
            
        }
        else if ([key isEqualToString:@"end_time"]) {
            NSString *time = obj;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZ'"];
            event.endTime = [formatter dateFromString:time];
            
        }
        else if ([key isEqualToString:@"timezone"]) {
            event.timeZone = obj;
            
        }
        else if ([key isEqualToString:@"attending_count"]) {
            event.attending = @([obj intValue]);
            
        }
        else if ([key isEqualToString:@"maybe_count"]) {
            event.maybe = @([obj intValue]);
            
        }
        else if ([key isEqualToString:@"ticket_uri"]) {
            event.ticketURI = obj;
            
        }
    }
    
    return event;
}

#pragma mark - Human readable strings, parsing, managing indexes

-(NSArray *)dataSourceCount {
    
    return @[fbProperties,pfProperties];
}

-(NSArray *)descriptionDataSourceCount {
    
    return @[fbLocalisedDescriptions,pfLocalisedDescriptions];
}

+ (void)load {
    
    if (!fbEventGraphKeys) {
        fbEventGraphKeys = @[@"id", @"cover", @"source", @"description", @"name", @"venue", @"location", @"owner", @"start_time", @"end_time", @"timezone", @"attending_count", @"maybe_count", @"ticket_uri"];
    }
    
    if (!fbProperties) {
        fbProperties = @[@"name", @"longDesc", @"location", @"venue", @"startTime", @"endTime", @"ticketsURI"];
    }
    if (!fbLocalisedDescriptions) {
        fbLocalisedDescriptions = @[@"Name", @"Description", @"Location",@"Venue",@"Starts at",@"Ends at", @"Tickets"];
    }
    if (!pfProperties) {
        pfProperties = @[@"artists", @"mainStyle", @"secondaryStyle", @"coverPhoto"];
    }
    if (!pfLocalisedDescriptions) {
        pfLocalisedDescriptions = @[@"Artists",@"Main Dance Style",@"Second Dance Style", @"Cover Photo"];
    }
    
    [super load];
}

- (NSString *)shortDesc {
    return self.name;
}

+(void)queryForID:(NSNumber *)identifier completion:(void (^)(id,NSError *))block {
    
    PFQuery *query = [self query];
    [query whereKey:@"identifier" equalTo:identifier];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            if (objects.count > 0) {
                
                
                PFEvent *event = [objects firstObject];
                [event fetchEventDetailsWithBlock:block];
            }
            else {
                block(nil,nil);
            }
            
        } else {
            // Log details of the failure
            NSLog(@"%s\n%@", __PRETTY_FUNCTION__, [error userInfo]);
            block(nil,error);
        }
    }];
}
- (void)fetchEventDetailsWithBlock:(void (^)(id,NSError *))block {
    self.owner = nil;
    self.venue = nil;
    [PFVenue queryForID:self.venueID completion:^(PFVenue *venue, NSError *error) {
        if (error) {
            NSLog(@"%s\n%@",__PRETTY_FUNCTION__,[error userInfo]);
        }
        if (venue) {
            self.venue = venue;
        }
        
        if (self.owner) {
            block (self, error);
        }
    }];
    
    [PFOwner queryForID:self.ownerID completion:^(PFOwner *owner, NSError *error) {
        if (error) {
            NSLog(@"%s\n%@",__PRETTY_FUNCTION__,[error userInfo]);
        }
        if (owner) {
            self.owner = owner;
        }
        
        if (self.venue) {
            block (self,nil);
        }
    }];
}

@end
