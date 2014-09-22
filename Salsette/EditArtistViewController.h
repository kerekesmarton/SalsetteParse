//
//  EditArtistViewController.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 19/09/14.
//
//

#import "PFObjectTableViewController.h"


@class MyPFObject;
@interface EditArtistViewController : PFObjectTableViewController

@property (nonatomic, strong) MyPFObject *object;

@end
