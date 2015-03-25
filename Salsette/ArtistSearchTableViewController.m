//
//  ArtistSearchTableViewController.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 17/10/14.
//
//

#import "ArtistSearchTableViewController.h"
#import "ParseIncludes.h"
#import "UIViewController+ActivityIndicator.h"

@interface ArtistSearchTableViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) PFDanceStyle      *style;
@property (nonatomic, strong) PFQuery           *primaryQuery;
@property (nonatomic, strong) PFQuery           *secondaryQuery;
@property (nonatomic, strong) NSMutableArray    *dataSource;

@end

@implementation ArtistSearchTableViewController

static NSString *reuseIdentifier = @"artistCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.style = [PFDanceStyle objectWithStyle:DanceStyleUndefined identifier:@"1"];
    self.dataSource = [NSMutableArray array];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *styleButton = [[UIBarButtonItem alloc] initWithTitle:[PFDanceStyle stringForStyle:self.style.danceStyle] style:UIBarButtonItemStylePlain target:self action:@selector(pickDanceStyle)];
    self.navigationItem.rightBarButtonItem = styleButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.searchBar;  // The property you wired up in IB
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44; // The height of the search bar
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    PFArtistProfile *artist = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = artist.name;
    cell.detailTextLabel.text = artist.shortDesc;
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFArtistProfile *artist = [self.dataSource objectAtIndex:indexPath.row];
    self.didSelectArtistBlock(artist);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - searchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (self.style.danceStyle == DanceStyleUndefined) {
        
        [self pickDanceStyle];
        return NO;
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (self.primaryQuery) {
        [self.primaryQuery cancel];
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(searchWithText:) withObject:searchText afterDelay:0.];
}// called when text changes (including clear)

- (void)searchWithText:(NSString *)searchText {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    self.primaryQuery = [PFArtistProfile primaryQueryWithDanceStyle:self.style name:searchText];
    
    [PFArtistProfile searchWithQuery:self.primaryQuery partial:^(PFArtistProfile *artist, NSError *e, NSInteger index) {
        
//        [self.dataSource addObject:artist];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
//        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } completion:^(NSArray *objects , NSError *e) {
        
        [self.dataSource addObjectsFromArray:objects];
        [self.tableView reloadData];
        self.HUD.hidden = YES;
        [self.searchBar becomeFirstResponder];
    }];
    
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.HUD show:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}// called when keyboard search button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    
}// called when cancel button pressed
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    
}// called when search results button pressed

#pragma mark - Private Methods

-(void)pickDanceStyle {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick a dance style" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[PFDanceStyle stringForStyle:DanceStyleUndefined],
                                  [PFDanceStyle stringForStyle:DanceStyleLineSalsa],
                                  [PFDanceStyle stringForStyle:DanceStyleCubanSalsa],
                                  [PFDanceStyle stringForStyle:DanceStyleColombianSalsa],
                                  [PFDanceStyle stringForStyle:DanceStyleBachata],
                                  [PFDanceStyle stringForStyle:DanceStyleZouk],
                                  [PFDanceStyle stringForStyle:DanceStyleKizomba],
                                  nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    self.style.danceStyle = (DanceStyle)buttonIndex;
    UIBarButtonItem *styleButton = [[UIBarButtonItem alloc] initWithTitle:[PFDanceStyle stringForStyle:self.style.danceStyle] style:UIBarButtonItemStylePlain target:self action:@selector(pickDanceStyle)];
    self.navigationItem.rightBarButtonItem = styleButton;
}
@end
