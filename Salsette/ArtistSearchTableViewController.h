//
//  ArtistSearchTableViewController.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 17/10/14.
//
//

#import <UIKit/UIKit.h>

@class PFArtistProfile;

@interface ArtistSearchTableViewController : UITableViewController

@property (nonatomic, copy) void (^didSelectArtistBlock)(PFArtistProfile *) ;

@end
