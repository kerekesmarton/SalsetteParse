//
//  PFArtistList.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 17/10/14.
//
//

#import "MyPFObject.h"

@class PFArtistProfile;

@interface PFArtistList : MyPFObject

@property (nonatomic, strong) NSArray *artists;

+(instancetype)objectWithArtists:(NSArray *)artists identifier:(NSString *)identifier;

-(void)addArtistsObject:(PFArtistProfile *)object;
-(void)removeArtistsObject:(PFArtistProfile *)object;

@end
