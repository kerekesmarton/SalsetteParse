//
//  EventObject.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 29/08/14.
//
//

#import "MyPFObject.h"

@class FBGraphObject;
@class PFOwner,PFVenue,PFCover,PFDanceStyle,PFArtistList,PFClassList;

@interface PFEvent : MyPFObject

+(PFEvent *)eventWithGraphObject:(FBGraphObject *)graph;

//tags from facebook
@property (nonatomic, strong) NSString  *name;          //name
@property (nonatomic, strong) NSString  *longDesc;      //description
@property (nonatomic, strong) PFCover   *coverPhoto;


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
@property (nonatomic, strong) PFArtistList  *artists;       //artists invited
@property (nonatomic, strong) PFDanceStyle  *mainStyle;     //main dance style
@property (nonatomic, strong) PFDanceStyle  *secondaryStyle;//secondary dance style
@property (nonatomic, strong) PFClassList   *classes;       //list of the classes

//references, parse only
@property (nonatomic, strong) PFUser    *pfUser;        // relationship to fetch for
@property (nonatomic, strong) NSString  *venueID;
@property (nonatomic, strong) NSString  *ownerID;
@property (nonatomic, strong) NSString  *coverID;
@property (nonatomic, strong) NSString  *mainStyleID;
@property (nonatomic, strong) NSString  *secondStyleID;

@end
