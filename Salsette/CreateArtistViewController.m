//
//  PFArtistCreateViewController.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 05/09/14.
//
//

#import "CreateArtistViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TWTSideMenuViewController.h"
#import "UIViewController+ActivityIndicator.h"
#import "EditArtistViewController.h"
#import "PFArtistProfile.h"
#import "PFArtistGroupProfile.h"

@interface CreateArtistViewController () <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *goButton;

@end

@implementation CreateArtistViewController

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

- (IBAction)goButtonPressed:(id)sender {
    
    if (!self.textField.text) {
        return;
    }
    
    NSArray *parts = [self.textField.text componentsSeparatedByString:@"?"];
    NSString *link = [parts firstObject];
    if (!link || [link rangeOfString:@"facebook.com"].length == 0) {
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"This is a page for" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Me",@"My group", nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        return;
    }
    
    __weak CreateArtistViewController *weakSelf = self;
    if (buttonIndex == 0) {
        //single
        [self startRequestWithCompletionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
            if (error) {
                [self alert:error];
            } else if (result) {
                
                PFArtistProfile *artist = [PFArtistProfile objectWithDictionary:result];
                [PFArtistProfile queryForID:artist.identifier completion:^(PFArtistProfile *fetchedArtist, NSError *error) {
                    
                    if (fetchedArtist && [fetchedArtist.ACL getWriteAccessForUser:[PFUser currentUser]]) {
                        [weakSelf presentArtistViewControllerWithObject:fetchedArtist];
                    } else {
                        artist.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                        [artist.ACL setPublicReadAccess:YES];
                        [weakSelf presentArtistViewControllerWithObject:artist];
                    }
                }];
            }
        }];
    }
    
    if (buttonIndex == 1) {
        
        //group
        [self startRequestWithCompletionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
            if (error) {
                [self alert:error];
            } else if (result) {
                
                PFArtistGroupProfile *artist = [PFArtistGroupProfile objectWithDictionary:result];
                [PFArtistGroupProfile queryForID:artist.identifier completion:^(PFArtistGroupProfile *fetchedArtist, NSError *error) {
                    
                    if (fetchedArtist && [fetchedArtist.ACL getWriteAccessForUser:[PFUser currentUser]]) {
                        [weakSelf presentArtistViewControllerWithObject:fetchedArtist];
                    } else {
                        artist.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                        [artist.ACL setPublicReadAccess:YES];
                        [weakSelf presentArtistViewControllerWithObject:artist];
                    }
                }];
            }
        }];
    
    }
}

- (void)startRequestWithCompletionHandler:(void (^)(FBRequestConnection *connection,FBGraphObject *result,NSError *error))handler {
    NSArray *parts = [self.textField.text componentsSeparatedByString:@"?"];
    NSString *link = [parts firstObject];
    
    parts = [link componentsSeparatedByString:@"/"];
    
    __block BOOL foundFacebook = NO;
    __block NSString *pageName = nil;
    [parts enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj rangeOfString:@"facebook.com"].length > 0 ) {
            
            foundFacebook = YES;
        } else if (foundFacebook) {
            pageName = obj;
            *stop = YES;
        }
    }];
    
    if (pageName) {
        
        self.HUD.mode = MBProgressHUDModeIndeterminate;
        [self.HUD show:YES];
        [FBRequestConnection startWithGraphPath:pageName
                                     parameters:nil
                                     HTTPMethod:@"GET"
                              completionHandler:handler];
    }
}

- (void)presentArtistViewControllerWithObject:(MyPFObject *)object {
    
    [self.HUD hide:YES];
    EditArtistViewController *edit = [[EditArtistViewController alloc] initWithNibName:NSStringFromClass([EditArtistViewController class]) bundle:nil];
    edit.object = object;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:edit] animated:YES completion:^{ }];
}

- (void)alert:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[error userInfo] description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

@end
