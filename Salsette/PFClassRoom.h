//
//  PFClassRomm.h
//  Salsette
//
//  Created by Kerekes, Marton on 03/04/15.
//
//

#import "MyPFObject.h"


extern NSString * const UNNAMED_ROOM;
@class PFVenue;

@interface PFClassRoom : MyPFObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFVenue *venue;
@property (nonatomic, strong) NSNumber *order;

@end
