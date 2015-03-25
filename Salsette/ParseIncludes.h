//
//  ParseIncludes.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 01/09/14.
//
//

#import <Foundation/Foundation.h>

#import <Parse/Parse.h>
#import "PFEvent.h"
#import "PFVenue.h"
#import "PFOwner.h"
#import "PFCover.h"
#import "PFDanceStyle.h"
#import "PFArtistProfile.h"
#import "PFArtistGroupProfile.h"
#import "PFArtistList.h"

#import "PFUser+Additions.h"



extern NSString * const MenuShouldReloadNotification;
extern NSString * const MenuShouldAddObject;
extern NSString * const MenuShouldRemoveObject;

@interface ParseIncludes : NSObject

@end
