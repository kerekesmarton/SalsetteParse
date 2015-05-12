//
//  PFClass.h
//  Salsette
//
//  Created by Kerekes, Marton on 03/04/15.
//
//

#import "MyPFObject.h"

extern NSString * const UNNAMED_CLASS;

@class PFArtistProfile, PFDanceStyle, PFClassRoom;

@interface PFClass : MyPFObject

@property (nonatomic, strong) NSString  *name;          //name

@property (nonatomic, strong) NSDate    *startTime;     //start_time
@property (nonatomic, strong) NSDate    *endTime;       //end_time

@property (nonatomic, strong) PFArtistProfile  *artist;       //artists invited
@property (nonatomic, strong) PFDanceStyle  *style;     //main dance style
@property (nonatomic, strong) PFClassRoom *room;

@end
