//
//  VenueTableViewController.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 02/09/14.
//
//

#import <UIKit/UIKit.h>

#import "PFVenue.h"

@interface VenueTableViewController : UITableViewController

@property (nonatomic, strong) PFVenue *venue;

@end
