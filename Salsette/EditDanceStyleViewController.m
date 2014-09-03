//
//  EditDanceStyleViewController.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 03/09/14.
//
//

#import "EditDanceStyleViewController.h"
#import "PFDanceStyle.h"
#import "DefaultTableViewCell.h"
@interface EditDanceStyleViewController () <UIActionSheetDelegate>

@end

@implementation EditDanceStyleViewController

@synthesize object = _object;

-(void)setStyle:(PFDanceStyle *)style {
    
    _style = style;
    _object = (MyPFObject *)style;
}

-(void)setObject:(MyPFObject *)object {
    
    _style = (PFDanceStyle *)object;
    _object = object;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureCell:(DefaultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.titleLabel.text = [self.object keyForIndex:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    id obj = [self.object objectForIndex:indexPath];
    if (!obj) {
        return;
    }
    cell.detailLabel.text = [PFDanceStyle stringForStyle:[obj intValue]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    [self.style saveInBackground];
    [self.tableView reloadData];
}

@end
