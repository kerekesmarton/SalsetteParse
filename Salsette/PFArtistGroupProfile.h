//
//  PFArtistGroupProfile.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 04/09/14.
//
//

#import "MyPFObject.h"

@class PFDanceStyle,PFCover;

@interface PFArtistGroupProfile : MyPFObject

+(instancetype)objectWithIdentifier:(NSString *)identifier;

@property (nonatomic, strong) NSString          *groupName;
@property (nonatomic, strong) NSString          *shortBio;

@property (nonatomic, strong) PFCover           *coverPhoto;
@property (nonatomic, strong) PFDanceStyle      *primaryStyle;
@property (nonatomic, strong) PFDanceStyle      *secondaryStyle;
@property (nonatomic, strong) NSMutableDictionary   *members;
@property (nonatomic, strong) NSMutableDictionary   *admins;

@property (nonatomic, strong) NSString          *coverPhotoID;
@property (nonatomic, strong) NSString          *primaryStyleID;
@property (nonatomic, strong) NSString          *secondaryStyleID;
@property (nonatomic, strong) NSMutableArray    *memberIDs;
@property (nonatomic, strong) NSMutableArray    *adminIDs;

@end
