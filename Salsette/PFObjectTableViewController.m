//
//  VenueTableViewController.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 02/09/14.
//
//

#import "PFObjectTableViewController.h"
#import "DefaultTableViewCell.h"
#import "MyPFObject.h"
#import "UIViewController+Navigation.h"

@interface PFObjectTableViewController ()

@end

@implementation PFObjectTableViewController

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
    
    // Return the number of sections.
    return [self.object.dataSourceCount count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.object.dataSourceCount objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // Create the cell and add the labels
        cell = [[DefaultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    id obj = [self.object objectForIndex:indexPath];
    if (!obj) {
        return DefaultTableViewCellMinHeight;
    }
    
    if ([obj isKindOfClass:[NSString class]])  {
        return MAX([NSString sizeForString:obj thatFitsSize:DefaultTableViewCellDetailRect.size].height, DefaultTableViewCellMinHeight);
    }
    
    if ([obj isKindOfClass:[MyPFObject class]] && [(MyPFObject *)obj isDataAvailable]) {
        return MAX([NSString sizeForString:[(MyPFObject *)obj shortDesc] thatFitsSize:DefaultTableViewCellDetailRect.size].height, DefaultTableViewCellMinHeight);
    }
    return DefaultTableViewCellMinHeight;
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


-(void)configureCell:(DefaultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    // Display the data in the table
    NSString *key = [self.object keyForIndex:indexPath];
    cell.titleLabel.text = key;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    id obj = [self.object objectForIndex:indexPath];
    if (!obj) {
        return;
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        cell.detailLabel.text = obj;
        CGRect frame = DefaultTableViewCellDetailRect;
        frame.size.height = MAX([NSString sizeForString:obj thatFitsSize:DefaultTableViewCellDetailRect.size].height, DefaultTableViewCellMinHeight);
        cell.detailLabel.frame = frame;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        cell.detailLabel.text = [obj stringValue];
    } else if ([obj isKindOfClass:[PFGeoPoint class]]) {
        
        PFGeoPoint *gp = obj;
        cell.detailLabel.text = [NSString stringWithFormat:@"%2.4f, %2.4f",gp.latitude,gp.longitude];
    } else if ([obj isKindOfClass:[NSDate class]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        cell.detailLabel.text = [formatter stringFromDate:obj];
    } else if ([obj isKindOfClass:[MyPFObject class]]) {
                
        [(MyPFObject *)obj fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
            
            cell.detailLabel.text = [obj shortDesc];
            CGRect frame = DefaultTableViewCellDetailRect;
            frame.size.height = MAX([NSString sizeForString:[obj shortDesc] thatFitsSize:DefaultTableViewCellDetailRect.size].height, DefaultTableViewCellMinHeight);
            cell.detailLabel.frame = frame;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }];
    }
}

- (void)refreshSaveButtonTarget:(id)target sel:(SEL)selector {
    if (!self.object.objectId) {
        UIBarButtonItem *start = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:target action:selector];
        self.navigationItem.rightBarButtonItem = start;
    } else {
        UIBarButtonItem *start = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:target action:selector];
        self.navigationItem.rightBarButtonItem = start;
    }
}

@end
