//
//  EditEventTableViewController.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 29/08/14.
//
//

#import "TWTSideMenuViewController.h"

#import "EditEventTableViewController.h"
#import "EditCoverViewController.h"
#import "EditDanceStyleViewController.h"
#import "ArtistsListTableViewController.h"

#import "UIViewController+ActivityIndicator.h"
#import "UIViewController+Navigation.h"
#import "UIViewController+CoverImage.h"
#import "DefaultTableViewCell.h"

#import "ImageDataManager.h"

#import "ParseIncludes.h"

@interface EditEventTableViewController ()

@end

@implementation EditEventTableViewController

@synthesize object = _object;

-(void)setObject:(MyPFObject *)object {
    
    _object = object;
    _event = (PFEvent *)object;
}

-(void)setEvent:(PFEvent *)event {
    
    _event = event;
    _object = event;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self refreshBackButton];
    
    [self refreshSaveButtonTarget:self sel:@selector(startButtonPressed)];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self loadImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


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

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    [(MyPFObject *)self.event fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        id loadedObject = [(MyPFObject *)object objectForIndex:indexPath];
        
        if ([loadedObject isKindOfClass:[PFCover class]] && [self.event identifier]) {
            EditCoverViewController *detailViewController = [[EditCoverViewController alloc] initWithNibName: NSStringFromClass([PFObjectTableViewController class]) bundle:nil];
            detailViewController.cover = loadedObject;
            [self.navigationController pushViewController:detailViewController animated:YES];
            
        } else if ([loadedObject isKindOfClass:[PFDanceStyle class]]) {
            EditDanceStyleViewController *detailViewController = [[EditDanceStyleViewController alloc] initWithNibName: NSStringFromClass([PFObjectTableViewController class]) bundle:nil];
            detailViewController.style = loadedObject;
            [self.navigationController pushViewController:detailViewController animated:YES];
            
        } else if ([loadedObject isKindOfClass:[PFArtistList class]]) {
            ArtistsListTableViewController *artistList = [[ArtistsListTableViewController alloc] initWithNibName:NSStringFromClass([PFObjectTableViewController class]) bundle:nil];
            artistList.object = loadedObject;
            [self.navigationController pushViewController:artistList animated:YES];
        } else if ([loadedObject isKindOfClass:[MyPFObject class]]) {
            PFObjectTableViewController *detailViewController = [[PFObjectTableViewController alloc] initWithNibName:NSStringFromClass([PFObjectTableViewController class]) bundle:nil];
            detailViewController.object = loadedObject;
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scaleImageView:scrollView];
}

- (void)startButtonPressed {
    
    [[PFUser currentUser] addEvent:self.event.identifier];
    
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.HUD show:YES];
    
    __weak EditEventTableViewController *weakSelf = self;
    
    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.HUD hide:YES];
        if (error) {
            NSLog(@"%@",[error userInfo]);
        }
        if (succeeded) {
            
            [self refreshBackButton];
            [self refreshSaveButtonTarget:weakSelf sel:@selector(startButtonPressed)];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:MenuShouldAddObject object:weakSelf.event]];
        }
    }];
    
}

- (void)loadImage {
    __weak EditEventTableViewController *weakSelf = self;
    [PFCover queryForID:self.event.coverID completion:^(PFCover *cover, NSError *error) {
        [[ImageDataManager sharedInstance] imageForIdentifier:cover.identifier url:cover.url completion:^(UIImage *responseObject) {
            
            self.imageView = [[UIImageView alloc] initWithImage:responseObject];
            self.imageView.contentMode = UIViewContentModeScaleToFill;
            weakSelf.tableView.tableHeaderView = self.imageView;
        }];
    }];
}

@end
