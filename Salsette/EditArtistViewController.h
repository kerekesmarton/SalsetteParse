//
//  EditArtistViewController.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 19/09/14.
//
//

#import "PFObjectTableViewController.h"

@class PFArtistProfile;
@class MyPFObject;
@interface EditArtistViewController : PFObjectTableViewController

@property (nonatomic, strong) PFArtistProfile *artist;

@end
