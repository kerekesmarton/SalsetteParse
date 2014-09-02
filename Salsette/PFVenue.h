//
//  PFVenue.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 30/08/14.
//
//

#import "MyPFObject.h"
#import <Parse/PFGeoPoint.h>
@class PFEvent;
@interface PFVenue : MyPFObject

@property (nonatomic, strong) NSString  *city;
@property (nonatomic, strong) NSString  *country;
@property (nonatomic, strong) PFGeoPoint *geoPoint;
@property (nonatomic, strong) NSString  *street;
@property (nonatomic, strong) NSString  *zip;



@end
