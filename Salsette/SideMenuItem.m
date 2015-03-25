//
//  SideMenuObject.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 28/08/14.
//
//

#import "SideMenuItem.h"
#import "LoginViewController.h"
#import "UserDetailsViewController.h"
#import "CreateEventViewController.h"
#import "TWTMainViewController.h"
#import "EditEventTableViewController.h"
#import "CreateArtistViewController.h"
#import "EditArtistViewController.h"
#import "ParseIncludes.h"
#import "ImageDataManager.h"

@interface SideMenuItem ()

@property (nonatomic, readonly) dispatch_queue_t queue;

@end

@implementation SideMenuItem

-(dispatch_queue_t)queue{
    
    static dispatch_queue_t staticQueue;
    if (!staticQueue) {
        staticQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return staticQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setItemEvent:^(SideMenuItem *item) {}];
    }
    return self;
}

-(void)load:(UIImageView *)imageView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        self.itemEvent(imageView);
    });
}

+(SideMenuItem *)mapItem:(PFUser *)user update:(void (^)(SideMenuItem *item)) update{
    
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    item.itemTitle = @"map";
    item.itemImage = [UIImage imageNamed:@"world"];
    item.status = ItemStatusBasic;
    item.viewControllerClass = [TWTMainViewController class];
    [item setItemEvent:^(SideMenuItem *item) {
        
        //check for location services.
        
        // if not, set item image to smth default
        
        // else get the user's current city zoomed and generate a small map image
        
        // fetch parties nearby and populate image w small icons
    }];
    
    return item;
}

+(SideMenuItem *)calendarItem:(PFUser *)user update:(void (^)(SideMenuItem *item)) update {
    
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    item.itemTitle = @"Calendar";
    item.itemImage = [UIImage imageNamed:@"calendar"];
    item.status = ItemStatusBasic;
    item.viewControllerClass = [TWTMainViewController class];
    
    return item;
}

+ (SideMenuItem *)createEventItem:(PFUser *)user update:(void (^)(SideMenuItem *item)) update {
    
    if (![user userAccountTypeIncludes:AccountTypeOrganiser]) {
        return nil;
    }
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    item.itemTitle = @"Create Event";
    item.itemImage = [UIImage imageNamed:@"favourite_place"];
    item.status = ItemStatusBasic;
    item.viewControllerClass = [CreateEventViewController class];
    
    return item;
}

+ (SideMenuItem *)fetchedEventItem:(PFUser *)user update:(void (^)(SideMenuItem *item)) update {
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    item.itemTitle = @"Event";
    item.itemImage = [UIImage imageNamed:@"database"];
    item.status = ItemStatusBasic;
    item.viewControllerClass = [EditEventTableViewController class];
    __weak SideMenuItem *weakItem = item;
    [item setItemEvent:^(UIImageView *imageView) {
        SideMenuItem *strongItem = weakItem;
        PFEvent *event = (PFEvent *)strongItem.itemObject;
        [PFCover queryForID:event.coverID completion:^(PFCover *cover, NSError *error) {
            if (error) {
                NSLog(@"%@",error.userInfo.description);
            } else if (cover) {
                [[ImageDataManager sharedInstance] imageForIdentifier:cover.identifier url:cover.url completion:^(UIImage *responseObject) {
                    
                    CGSize size = imageView.image.size;
                    UIImage *scaledImaged = [UIImage imageWithImage:responseObject scaledToSize:size];
                    imageView.image = scaledImaged;
                    imageView.layer.cornerRadius = 8.0f;
                    imageView.layer.masksToBounds = YES;
                }];
            }
        }];

    }];
    
    return item;
}

+ (SideMenuItem *)userItem:(PFUser *)user update:(void (^)(SideMenuItem *item)) update {
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    item.itemTitle = @"User";
    item.itemImage = [UIImage imageNamed:@"user_male-128"];
    item.status = ItemStatusBasic;
    item.viewControllerClass = [UserDetailsViewController class];
    
    [item setItemEvent:^(UIImageView *imageView) {

        [[ImageDataManager sharedInstance] userImageFromFacebookWithCompletion:^(UIImage *responseObject) {
            CGSize size = imageView.image.size;
            UIImage *scaledImaged = [UIImage imageWithImage:responseObject scaledToSize:size];
            imageView.image = scaledImaged;
            imageView.layer.cornerRadius = 8.0f;
            imageView.layer.masksToBounds = YES;
        }];
    }];
    
    return item;
}

+(SideMenuItem *)fetchedArtistProfile:(PFUser *)user update:(void (^)(SideMenuItem *))update {
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    item.itemTitle = @"Artist";
    item.itemImage = [UIImage imageNamed:@"user_male-128"];
    item.status = ItemStatusBasic;
    item.viewControllerClass = [EditArtistViewController class];
    
    __weak SideMenuItem *weakItem = item;
    [item setItemEvent:^(UIImageView *imageView) {
        SideMenuItem *strongItem = weakItem;
        PFArtistProfile *event = (PFArtistProfile *)strongItem.itemObject;
        [PFCover queryForID:event.coverPhotoID completion:^(PFCover *cover, NSError *error) {
            if (error) {
                NSLog(@"%@",error.userInfo.description);
            } else if (cover) {
                [[ImageDataManager sharedInstance] imageForIdentifier:cover.identifier url:cover.url completion:^(UIImage *responseObject) {
                    
                    CGSize size = imageView.image.size;
                    UIImage *scaledImaged = [UIImage imageWithImage:responseObject scaledToSize:size];
                    imageView.image = scaledImaged;
                    imageView.layer.cornerRadius = 8.0f;
                    imageView.layer.masksToBounds = YES;
                }];
            }            
        }];
    }];
    
    return item;
}

+ (SideMenuItem *)createArtistItem:(PFUser *)user update:(void (^)(SideMenuItem *item)) update {
    
    if (![user userAccountTypeIncludes:AccountTypeArtist]) {
        return nil;
    }
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    item.itemTitle = @"Create Artist Page";
    item.itemImage = [UIImage imageNamed:@"user_male-128"];
    item.status = ItemStatusBasic;
    item.viewControllerClass = [CreateArtistViewController class];
    
    return item;
}

+ (SideMenuItem *)itemWithObject:(MyPFObject *)object {
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    item.itemTitle = [object shortDesc];
    item.itemImage = [UIImage imageNamed:@"database"];
    item.status = ItemStatusBasic;
    item.viewControllerClass = [PFObjectTableViewController class];
    item.itemObject = object;
    
    if ([object isKindOfClass:[PFEvent class]]) {
        item.viewControllerClass = [EditEventTableViewController class];
        item.section = 1;
        [item setItemEvent:^(UIImageView *imageView) {
            
            PFEvent *event = (PFEvent *)object;
            PFCover *cover = event.coverPhoto;
            
            [[ImageDataManager sharedInstance] imageForIdentifier:cover.identifier url:cover.url completion:^(UIImage *responseObject) {
                
                CGSize size = imageView.image.size;
                UIImage *scaledImaged = [UIImage imageWithImage:responseObject scaledToSize:size];
                imageView.image = scaledImaged;
                imageView.layer.cornerRadius = 8.0f;
                imageView.layer.masksToBounds = YES;
            }];
            
        }];
    } else
    if ([object isKindOfClass:[PFArtistProfile class]]) {
        item.viewControllerClass = [EditArtistViewController class];
        item.section = 3;
        [item setItemEvent:^(UIImageView *imageView) {
            
            PFArtistProfile *artist = (PFArtistProfile *)object;
            PFCover *cover = artist.coverPhoto;
            
            [[ImageDataManager sharedInstance] imageForIdentifier:cover.identifier url:cover.url completion:^(UIImage *responseObject) {
                
                CGSize size = imageView.image.size;
                UIImage *scaledImaged = [UIImage imageWithImage:responseObject scaledToSize:size];
                imageView.image = scaledImaged;
                imageView.layer.cornerRadius = 8.0f;
                imageView.layer.masksToBounds = YES;
            }];
            
        }];
    }
    
    return item;
}

-(NSString *)description {
    return self.itemTitle;
}

-(BOOL)isEqual:(id)object {
    
    if ([object isKindOfClass:[SideMenuItem class]]) {
        SideMenuItem *item = (SideMenuItem *)object;
        MyPFObject *itemObject = item.itemObject;
        
        if (![itemObject isKindOfClass:[self.itemObject class]]) {
            return NO;
        }
                
        if (itemObject && self.itemObject) {
            
            return [itemObject.identifier isEqual:self.itemObject.identifier];
            
        } else return NO;
    } else {
        return [super isEqual:object];
    }
}
@end
