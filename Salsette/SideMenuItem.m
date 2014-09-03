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
-(void)cancelLoading {
    
}

-(void)load:(void (^)(void))loader {
    
    dispatch_async(self.queue, ^{
        loader();
        self.itemEvent(nil,nil);
    });
}

+(SideMenuItem *)mapItem:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) completion{
    
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    item.itemTitle = @"map";
    item.itemImage = [UIImage imageNamed:@"world"];
    item.status = ItemStatusBasic;
    item.viewControllerClass = [TWTMainViewController class];
    item.itemEvent = completion;
    
    [item load:^{
        
        //check for location services.
        
        // if not, set item image to smth default
        
        // else get the user's current city zoomed and generate a small map image
        
        // fetch parties nearby and populate image w small icons
    }];
    
    return item;
}

+(SideMenuItem *)calendarItem:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) completion {
    
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    item.itemTitle = @"Calendar";
    item.itemImage = [UIImage imageNamed:@"calendar"];
    item.status = ItemStatusBasic;
    item.viewControllerClass = [TWTMainViewController class];
    item.itemEvent = completion;
    
    [item load:^{
        
        //get today
        //generate image w bg        
    }];
    
    return item;
}

+ (SideMenuItem *)createEventItem:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) completion {
    
    if (!user) {
        return nil;
    }
    
    if ([[PFUser currentUser] objectForKey:@"account_details"][@"type"]) {
        
        NSNumber *type = [[PFUser currentUser] objectForKey:@"account_details"][@"type"];
        if (!type) {
            return nil;
        }
        if ([type intValue] != 2) {
            return nil;
        }
    }
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    item.itemTitle = @"Create Event";
    item.itemImage = [UIImage imageNamed:@"favourite_place"];
    item.status = ItemStatusBasic;
    item.viewControllerClass = [CreateEventViewController class];
    item.itemEvent = completion;
    
    [item load:^{
        
    }];
    
    return item;
}

+ (SideMenuItem *)fetchedEventItem:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) completion {
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    item.itemTitle = @"Event";
    item.itemImage = [UIImage imageNamed:@"database"];
    item.status = ItemStatusBasic;
    item.viewControllerClass = [EditEventTableViewController class];
    item.itemEvent = completion;
    
    return item;
}

+ (SideMenuItem *)userItem:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) completion {
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    item.itemTitle = @"User";
    item.itemImage = [UIImage imageNamed:@"user_male-128"];
    item.status = ItemStatusBasic;
    item.viewControllerClass = [UserDetailsViewController class];
    item.itemEvent = completion;
    
    [item load:^{
        
    }];
    
    return item;
}

@end
