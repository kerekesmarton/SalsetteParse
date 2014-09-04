//
//  CoverEditViewController.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 03/09/14.
//
//

#import "PFObjectTableViewController.h"

@class PFCover;

@interface EditCoverViewController : PFObjectTableViewController

@property (nonatomic, strong) PFCover *cover;

@end
