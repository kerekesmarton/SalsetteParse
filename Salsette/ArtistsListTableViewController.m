//
//  ArtistsListTableViewController.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 17/10/14.
//
//

#import "ArtistsListTableViewController.h"
#import "ArtistSearchTableViewController.h"
#import "ParseIncludes.h"
#import "DefaultTableViewCell.h"
#import "PFArtistList.h"

@interface ArtistsListTableViewController ()

@property (nonatomic, strong) PFArtistList *artists;

@end

@implementation ArtistsListTableViewController

@synthesize object = _object;

-(void)setObject:(MyPFObject *)object {
    
    _artists = (PFArtistList *)object;
    _object = object;
}

-(void)setArtists:(PFArtistList *)artists {
    
    _object = artists;
    _artists = artists;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addArtist)],
                                                self.editButtonItem
                                                ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.artists.artists count];
}

-(void)configureCell:(DefaultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    // Display the data in the table
    PFArtistProfile *artist = [self.artists.artists objectAtIndex:indexPath.row];
   [artist fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
       cell.titleLabel.text = artist.name;
       [artist.primaryStyle fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
           cell.detailLabel.text = [PFDanceStyle stringForStyle:artist.primaryStyle.danceStyle];
       }];
   }];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.editing) {
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFArtistProfile *obj = [self.artists.artists objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.artists removeArtistsObject:obj];
        [self.artists saveInBackground];
        [self.tableView reloadData];
    }
}

- (void)addArtist {
    
    __weak ArtistsListTableViewController *weakSelf = self;
    ArtistSearchTableViewController *search = [[ArtistSearchTableViewController alloc] initWithNibName:NSStringFromClass([ArtistSearchTableViewController class]) bundle:nil];
    [search setDidSelectArtistBlock:^(PFArtistProfile *artist) {
        [weakSelf.artists addArtistsObject:artist];
        [weakSelf.artists saveInBackground];
    }];
    [self.navigationController pushViewController:search animated:YES];
}

@end
