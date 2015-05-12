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
#import "PFCover.h"
#import "PFDanceStyle.h"
#import "PFArtistList.h"
#import "PFClassList.h"
#import "PFClass.h"
#import "PFClassRoom.h"

static NSArray *fbEventGraphKeys;

static NSArray *fbProperties;
static NSArray *fbLocalisedDescriptions;
static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;

@implementation PFEvent

@dynamic name,longDesc,coverPhoto,venue,location,owner,startTime,endTime,timeZone,attending,maybe,ticketURI;

@dynamic artists,mainStyle,secondaryStyle;

@dynamic pfUser,venueID,ownerID,coverID,mainStyleID,secondStyleID,classes;

+(PFEvent *)eventWithGraphObject:(FBGraphObject *)graph {
    
    PFEvent *event = [super objectWithDictionary:graph];
    
    for (NSString *key in fbEventGraphKeys) {
        
        id obj = graph[key];
        
        if ([key isEqualToString:@"id"]) {
            
            event.identifier = obj;
        } else if ([key isEqualToString:@"cover"]) {
            
            PFCover *cover  = [PFCover objectWithDictionary:obj];
            if (!cover.identifier) {
                cover.identifier = event.identifier;
            }
            event.coverPhoto = cover;
            event.coverID = cover.identifier;
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
    
    event.artists = [PFArtistList objectWithArtists:[NSArray array] identifier:event.identifier];
    
    NSString *mainID = [NSString stringWithFormat:@"m_%@",event.identifier];
    event.mainStyle = [PFDanceStyle objectWithStyle:DanceStyleUndefined identifier:mainID];
    event.mainStyleID = mainID;
    
    NSString *secondID = [NSString stringWithFormat:@"s_%@",event.identifier];
    event.secondaryStyle = [PFDanceStyle objectWithStyle:DanceStyleUndefined identifier:secondID];
    event.secondStyleID = secondID;
    
    event.classes = [PFClassList objectWithIdentifier:event.identifier];
    
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
        pfProperties = @[@"artists", @"classes",@"mainStyle", @"secondaryStyle", @"coverPhoto"];
    }
    if (!pfLocalisedDescriptions) {
        pfLocalisedDescriptions = @[@"Artists", @"Classes",@"Main Dance Style",@"Second Dance Style", @"Cover Photo"];
    }
    
    [super load];
}

- (NSString *)shortDesc {
    return self.name;
}

@end
