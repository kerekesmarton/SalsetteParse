//
//  EditEventTableViewController.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 29/08/14.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PFEvent.h"

@interface EditEventTableViewController : UITableViewController

@property (nonatomic, strong) PFEvent *event;

@end
