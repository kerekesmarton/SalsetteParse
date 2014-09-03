//
//  VenueTableViewController.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 02/09/14.
//
//

#import <UIKit/UIKit.h>

@class DefaultTableViewCell;
@class MyPFObject;

@interface PFObjectTableViewController : UITableViewController

@property (nonatomic, strong) MyPFObject *object;

- (void)configureCell:(DefaultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
