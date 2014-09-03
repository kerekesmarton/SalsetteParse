//
//  CoverEditViewController.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 03/09/14.
//
//

#import "EditCoverViewController.h"
#import <Parse/PFFile.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PFCover.h"

#import "ParseManager.h"

#import "UIViewController+ActivityIndicator.h"

@interface EditCoverViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation EditCoverViewController

@synthesize object = _object;

-(void)setCover:(PFCover *)cover {
    
    _cover = cover;
    _object = cover;
}

-(void)setObject:(MyPFObject *)object {
    _cover = (PFCover *)object;
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
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self selectImage];
}

- (void)selectImage {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.editing = YES;
    imagePicker.allowsEditing = NO;
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    if ([UIDevice isiPad]) {
        [[self popoverWithContent:imagePicker] presentPopoverFromRect:CGRectInset(self.view.frame, 100, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGFloat newHeight = (CGFloat)image.size.height * (CGFloat)self.view.frameWidth / (CGFloat)image.size.height;
        CGSize  newSize   = CGSizeMake(self.view.frameWidth, newHeight);
        // Resize image
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Upload image
        NSData *imageData = UIImageJPEGRepresentation(smallImage, 100);
        [self uploadImage:imageData];
        
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([UIDevice isiPad]) {
        [[self popoverWithContent:picker] dismissPopoverAnimated:YES];
    } else {
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
}

-(UIPopoverController *)popoverWithContent:(UIViewController *)contentViewController {
    
    UIPopoverController *controller = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
    [controller setContentViewController:contentViewController];
    
    return controller;
}

- (void)loadImage {
    
    PFCover *cover = self.cover;
    [self.HUD show:YES];
    if (self.fetchedImage) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:self.fetchedImage];
        self.tableView.tableHeaderView = imgView;
    } else if (cover && cover.url) {
        __weak EditCoverViewController *weakSelf = self;
        
        [ParseManager fetchImageWithURL:cover.url Completion:^(UIImage *responseObject) {
            
           
            UIImageView *imgView = [[UIImageView alloc] initWithImage:responseObject];
            weakSelf.tableView.tableHeaderView = imgView;
            
            weakSelf.fetchedImage = responseObject;
            [self.HUD hide:YES];
        }];
    }
}

- (void)uploadImage:(NSData *)imageData {
    [self.HUD show:YES];
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    PFCover *cover = self.cover;
    //HUD creation here (see example for code)
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code
            [self.HUD hide:YES];
            
            cover.url = [imageFile url];
            
            cover.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            [cover saveInBackground];
            
            self.fetchedImage = nil;
            [self loadImage];
        }
        else{
            [self.HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        self.HUD.progress = (float)percentDone/100;
    }];
}

@end
