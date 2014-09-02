//
//  AccountDetailsTableViewController.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 14/08/14.
//
//

#import "AccountDetailsTableViewController.h"
#import <Parse/Parse.h>


@interface AccountDetailsTableViewController ()

@property (nonatomic, strong) NSMutableArray *rowDataArray;
@property (nonatomic, strong) id selectedItem;


@end

@implementation AccountDetailsTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
        // Set default values for the table row data
        self.rowDataArray = [@[@"Dancer", @"Artist", @"Organiser"] mutableCopy];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([[PFUser currentUser] objectForKey:@"account_details"][@"type"]) {
            self.selectedItem = [[PFUser currentUser] objectForKey:@"account_details"][@"type"];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.rowDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = (NSString *)[self.rowDataArray objectAtIndex:indexPath.row];
    
    if (self.selectedItem && (indexPath.row == [self.selectedItem intValue])) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedItem = @(indexPath.row);
    
    NSMutableDictionary *accountDetails = [NSMutableDictionary dictionaryWithDictionary:[[PFUser currentUser] objectForKey:@"account_details"]];
    
    accountDetails[@"type"] = @(indexPath.row);
    
    [[PFUser currentUser] setObject:accountDetails forKey:@"account_details"];
    [[PFUser currentUser] saveInBackground];
    
    [self.tableView reloadData];
}

@end
