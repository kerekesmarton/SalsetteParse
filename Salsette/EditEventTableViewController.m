//
//  EditEventTableViewController.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 29/08/14.
//
//

#import "EditEventTableViewController.h"

#import "ParseManager.h"
#import "DefaultTableViewCell.h"


@interface EditEventTableViewController ()

@end

@implementation EditEventTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (!self.event.objectId) {
        UIBarButtonItem *start = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(startButtonPressed)];
        self.navigationItem.rightBarButtonItem = start;
    } else {
        UIBarButtonItem *start = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(startButtonPressed)];
        self.navigationItem.rightBarButtonItem = start;        
    }
    
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    self.navigationItem.leftBarButtonItem = openItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.event.coverPhoto) {
        __weak EditEventTableViewController *weakSelf = self;
        
        [ParseManager fetchImageWithURL:self.event.coverPhoto Completion:^(UIImage *responseObject) {
        
            CGFloat newHeight = (CGFloat)responseObject.size.height * (CGFloat)weakSelf.view.frameWidth / (CGFloat)responseObject.size.height;
            UIImage *res = [UIImage imageWithImage:responseObject scaledToSize:CGSizeMake(weakSelf.view.frameWidth, newHeight)];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:res];
            weakSelf.tableView.tableHeaderView = imgView;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [self.event.dataSourceCount count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.event.dataSourceCount objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    DefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // Create the cell and add the labels
        cell = [[DefaultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display the data in the table
    cell.titleLabel.text = [self.event keyForIndex:indexPath];
    
    id obj = [self.event objectForIndex:indexPath];
    if ([obj isKindOfClass:[NSString class]]) {
        cell.detailLabel.text = obj;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        cell.detailLabel.text = [obj stringValue];
    }
    if ([obj isKindOfClass:[NSDate class]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        cell.detailLabel.text = [formatter stringFromDate:obj];
    }
    if ([obj isKindOfClass:[MyPFObject class]]) {
        cell.detailLabel.text = [obj shortDesc];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/


- (void)openButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)startButtonPressed {
    
    PFEvent *event = self.event;
    
    event.pfUser = [PFUser currentUser];
   
    __weak EditEventTableViewController *weakSelf = self;
    
    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        @try {
            if (error) {
                NSLog(@"%@",[error userInfo]);
            }
            if (succeeded) {
                
                UIBarButtonItem *start = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(startButtonPressed)];
                weakSelf.navigationItem.rightBarButtonItem = start;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@",[exception userInfo]);
        }
        
    }];
    
}

@end
