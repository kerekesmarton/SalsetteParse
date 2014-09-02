//
//  EventObject.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 29/08/14.
//
//

#import "MyPFObject.h"

@class FBGraphObject;
@class PFOwner,PFVenue;

@interface PFEvent : MyPFObject

+(PFEvent *)eventWithGraphObject:(FBGraphObject *)graph;

//tags from facebook
@property (nonatomic, strong) NSString  *name;          //name
@property (nonatomic, strong) NSString  *longDesc;      //description
@property (nonatomic, strong) NSString  *coverPhoto;    //cover/source


@property (nonatomic, strong) PFVenue   *venue;         //venue
@property (nonatomic, strong) NSString  *location;      //location
@property (nonatomic, strong) PFOwner   *owner;          //owner
@property (nonatomic, strong) NSDate    *startTime;     //start_time
@property (nonatomic, strong) NSDate    *endTime;       //end_time
@property (nonatomic, strong) NSString  *timeZone;      //timezone

@property (nonatomic, strong) NSNumber  *attending;     //attending_count
@property (nonatomic, strong) NSNumber  *maybe;         //maybe_count

@property (nonatomic, strong) NSString  *ticketURI;      //ticket_uri


//parse properties
@property (nonatomic, strong) NSArray   *artists;       //artists invited
@property (nonatomic, strong) NSNumber  *mainStyle;     //main dance style
@property (nonatomic, strong) NSNumber  *secondaryStyle;//secondary dance style


//references//parse only
@property (nonatomic, strong) PFUser    *pfUser;        // relationship to fetch for
@property (nonatomic, strong) NSNumber  *venueID;
@property (nonatomic, strong) NSNumber  *ownerID;

- (void)fetchEventDetailsWithBlock:(void (^)(id,NSError *))block;

@end
