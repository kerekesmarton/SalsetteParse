//
//  Copyright (c) 2013 Parse. All rights reserved.

#import "UserDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ParseManager.h"
#import "ParseIncludes.h"
#import "AccountDetailsTableViewController.h"
#import "LoginViewController.h"
#import "TWTSideMenuViewController.h"

#import "ImageDataManager.h"

@implementation UserDetailsViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Profile";
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"Open" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    self.navigationItem.leftBarButtonItem = openItem;
    
    // Load table header view from nib
    [[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil];
    self.tableView.tableHeaderView = self.headerView;
    
    // Create array for table row titles
    self.rowTitleArray = @[@"Location", @"Gender", @"Date of Birth",@"Account Type"];
    
    // Set default values for the table row data
    self.rowDataArray = [@[@"N/A", @"N/A", @"N/A",@"Please select ->"] mutableCopy];
    
    // Check if user is cached and linked to Facebook, if so, bypass login
    if (![PFUser currentUser] || ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self loginButtonTouchHandler:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    // If the user is already logged in, display any previously cached values before we get the latest from Facebook.
    if (![PFUser currentUser] || ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        // Add logout navigation bar button
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonTouchHandler:)];
        self.navigationItem.rightBarButtonItem = logoutButton;
    } else {
        // Add logout navigation bar button
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonTouchHandler:)];
        self.navigationItem.rightBarButtonItem = logoutButton;
    }
    
    if ([PFUser currentUser]) {
        [self updateProfile];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.rowTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // Create the cell and add the labels
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 120.0f, 44.0f)];
        titleLabel.tag = 1; // We use the tag to set it later
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        
        UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake( 130.0f, 0.0f, 165.0f, 44.0f)];
        dataLabel.tag = 2; // We use the tag to set it later
        dataLabel.font = [UIFont systemFontOfSize:15.0f];
        dataLabel.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:dataLabel];
    }
    
    if (indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Cannot select these cells
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Access labels in the cell using the tag #
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *dataLabel = (UILabel *)[cell viewWithTag:2];
    
    // Display the data in the table
    titleLabel.text = [self.rowTitleArray objectAtIndex:indexPath.row];
    dataLabel.text = [self.rowDataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3) {
        AccountDetailsTableViewController *vc = [[AccountDetailsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - ()

- (void)loginButtonTouchHandler:(id)sender {
    LoginViewController *login = [[LoginViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{
        //
    }];
}

- (void)logoutButtonTouchHandler:(id)sender {
    // Logout user, this automatically clears the cache
    [PFUser logOut];
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:MenuShouldReloadNotification object:[PFUser currentUser]]];
    
    // Return to login view controller
    LoginViewController *login = [[LoginViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^{

    }];
}

// Set received values if they are not nil and reload the table
- (void)updateProfile {
    if ([[PFUser currentUser] objectForKey:@"profile"][@"location"]) {
        [self.rowDataArray replaceObjectAtIndex:0 withObject:[[PFUser currentUser] objectForKey:@"profile"][@"location"]];
    }
    
    if ([[PFUser currentUser] objectForKey:@"profile"][@"gender"]) {
        [self.rowDataArray replaceObjectAtIndex:1 withObject:[[PFUser currentUser] objectForKey:@"profile"][@"gender"]];
    }
    
    if ([[PFUser currentUser] objectForKey:@"profile"][@"birthday"]) {
        [self.rowDataArray replaceObjectAtIndex:2 withObject:[[PFUser currentUser] objectForKey:@"profile"][@"birthday"]];
    }
    
    if ([[PFUser currentUser] objectForKey:@"account_details"][@"type"]) {
        
        AccountType type = [[PFUser currentUser] highestAccountType];
        
        [self.rowDataArray replaceObjectAtIndex:3 withObject:[PFUser userReadableAccountTypeForValue:type]];
    }
    
    [self.tableView reloadData];
    
    // Set the name in the header view label
    if ([[PFUser currentUser] objectForKey:@"profile"][@"name"]) {
        self.headerNameLabel.text = [[PFUser currentUser] objectForKey:@"profile"][@"name"];
    }
    
    [[ImageDataManager sharedInstance] userImageFromFacebookWithCompletion:^(UIImage *responseObject) {

        self.headerImageView.image = responseObject;
        // Add a nice corner radius to the image
        self.headerImageView.layer.cornerRadius = 8.0f;
        self.headerImageView.layer.masksToBounds = YES;
    }];
}

- (void)openButtonPressed
{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

@end
