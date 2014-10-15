//
//  PFArtistsProfile.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 04/09/14.
//
//

#import "MyPFObject.h"

@class PFDanceStyle,PFCover;

@interface PFArtistProfile : MyPFObject

@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSString      *about;
@property (nonatomic, strong) NSString      *shortBio;
@property (nonatomic, strong) NSString      *hometown;
@property (nonatomic, strong) PFCover       *coverPhoto;
@property (nonatomic, strong) PFDanceStyle  *primaryStyle;
@property (nonatomic, strong) PFDanceStyle  *secondaryStyle;

@property (nonatomic, strong) NSString      *coverPhotoID;
@property (nonatomic, strong) NSString      *primaryStyleID;
@property (nonatomic, strong) NSString      *secondaryStyleID;

@property (nonatomic, strong) PFUser    *pfUser;        // relationship to fetch for

- (void)fetchEventDetailsWithBlock:(void (^)(id,NSError *))block;

@end
