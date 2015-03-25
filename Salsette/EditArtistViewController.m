//
//  EditArtistViewController.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 19/09/14.
//
//

#import "EditArtistViewController.h"
#import "TWTSideMenuViewController.h"
#import "EditCoverViewController.h"
#import "EditDanceStyleViewController.h"

#import "UIViewController+ActivityIndicator.h"
#import "UIViewController+Navigation.h"
#import "UIViewController+CoverImage.h"
#import "DefaultTableViewCell.h"
#import "ImageDataManager.h"
#import "ParseIncludes.h"

@interface EditArtistViewController ()

@end

@implementation EditArtistViewController

@synthesize object = _object;

-(void)setObject:(MyPFObject *)object {
    
    _object = object;
    _artist = (PFArtistProfile *)object;
}

-(void)setArtist:(PFArtistProfile *)artist {
    
    _artist = artist;
    _object = artist;
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

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    id obj = [self.artist objectForIndex:indexPath];
    
    if ([obj isKindOfClass:[PFCover class]] && [self.artist identifier]) {
        EditCoverViewController *detailViewController = [[EditCoverViewController alloc] initWithNibName: NSStringFromClass([PFObjectTableViewController class]) bundle:nil];
        detailViewController.cover = obj;
        [self.navigationController pushViewController:detailViewController animated:YES];
        
    } else if ([obj isKindOfClass:[PFDanceStyle class]]) {
        EditDanceStyleViewController *detailViewController = [[EditDanceStyleViewController alloc] initWithNibName: NSStringFromClass([PFObjectTableViewController class]) bundle:nil];
        detailViewController.style = obj;
        [self.navigationController pushViewController:detailViewController animated:YES];
        
    } else if ([obj isKindOfClass:[MyPFObject class]]) {
        PFObjectTableViewController *detailViewController = [[PFObjectTableViewController alloc] initWithNibName:NSStringFromClass([PFObjectTableViewController class]) bundle:nil];
        detailViewController.object = obj;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scaleImageView:scrollView];
}

- (void)startButtonPressed {
    
    [[PFUser currentUser] addArtistProfile:self.artist.identifier];
    
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.HUD show:YES];
    
    __weak EditArtistViewController *weakSelf = self;
    
    [self.artist saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.HUD hide:YES];
        if (error) {
            NSLog(@"%@",[error userInfo]);
        }
        if (succeeded) {
            [self refreshBackButton];
            [self refreshSaveButtonTarget:self sel:@selector(startButtonPressed)];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:MenuShouldAddObject object:weakSelf.artist]];
        }
    }];
}

- (void)loadImage {
    __weak EditArtistViewController *weakSelf = self;
    [PFCover queryForID:self.artist.coverPhotoID completion:^(PFCover *cover, NSError *error) {
        
        [[ImageDataManager sharedInstance] imageForIdentifier:cover.identifier url:cover.url completion:^(UIImage *responseObject) {
            self.imageView = [[UIImageView alloc] initWithImage:responseObject];
            self.imageView.contentMode = UIViewContentModeScaleToFill;
            weakSelf.tableView.tableHeaderView = self.imageView;
        }];
    }];
}

@end
