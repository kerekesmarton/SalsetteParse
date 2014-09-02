//
//  Copyright (c) 2013 Parse. All rights reserved.

#import <Parse/Parse.h>

@interface UserDetailsViewController : UITableViewController

// UITableView header view properties
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *headerNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *headerImageView;

// UITableView row data properties
@property (nonatomic, strong) NSArray *rowTitleArray;
@property (nonatomic, strong) NSMutableArray *rowDataArray;

// UINavigationBar button touch handler
- (void)logoutButtonTouchHandler:(id)sender;

@end
