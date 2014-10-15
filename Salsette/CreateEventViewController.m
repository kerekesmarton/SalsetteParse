//
//  CreateEventViewController.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 29/08/14.
//
//

#import "CreateEventViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TWTSideMenuViewController.h"
#import "EditEventTableViewController.h"
#import "PFEvent.h"
#import "UIViewController+ActivityIndicator.h"

@interface CreateEventViewController ()

@property (strong, nonatomic) IBOutlet UIButton     *fetchEventButton;
@property (strong, nonatomic) IBOutlet UITextField  *eventLinkTextField;
@end

@implementation CreateEventViewController

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
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    self.navigationItem.leftBarButtonItem = openItem;
}

- (void)openButtonPressed
{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goButtonPressed:(id)sender {
    
    if (!self.eventLinkTextField.text) {
        return;
    }
    
    NSArray *parts = [self.eventLinkTextField.text componentsSeparatedByString:@"/"];
    
    __block BOOL foundEvents = NO;
    __block BOOL foundNumbers = NO;
    __block NSString *eventID = nil;
    [parts enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj rangeOfString:@"events"].length >0 ) {
            
            foundEvents = YES;
        }
        if (foundEvents) {
            if ([obj rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].length > 0) {
                foundNumbers = YES;
            }
        }
       
        if (foundNumbers) {
            eventID = [NSString stringWithString:obj];
            *stop = YES;
        }
    }];
    
    if (eventID) {
        
        self.HUD.mode = MBProgressHUDModeIndeterminate;
        [self.HUD show:YES];
        __weak CreateEventViewController *weakSelf = self;
        [FBRequestConnection startWithGraphPath:eventID
                                     parameters:nil
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection *connection,FBGraphObject *result,NSError *error) {
                                  
                                  if (error) {
                                      NSLog(@"%@",[error.userInfo description]);
                                  } else if (result) {
                                      
                                      PFEvent *event = [PFEvent eventWithGraphObject:result];
                                      [PFEvent queryForID:event.identifier completion:^(PFEvent *fetchedEvent, NSError *error) {
                                          
                                          [weakSelf.HUD hide:YES];
                                          EditEventTableViewController *edit = [[EditEventTableViewController alloc] initWithNibName:NSStringFromClass([EditEventTableViewController class]) bundle:nil];
                                          if (fetchedEvent && [fetchedEvent.ACL getWriteAccessForUser:[PFUser currentUser]]) {
                                              edit.event = fetchedEvent;
                                          } else {
                                              event.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                                              [event.ACL setPublicReadAccess:YES];
                                              edit.event = event;
                                              
                                          }                                          
                                          
                                          [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:edit] animated:YES completion:^{ }];
                                      }];
                                  }
                              }];
    }
}

@end
