//
//  SideMenuObject.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 28/08/14.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef enum ItemStatus {
    
    ItemStatusBasic,
    ItemStatusLoading,
    ItemStatusReady
} ItemStatus;

@class MyPFObject;

@interface SideMenuItem : NSObject

@property (nonatomic, strong) NSString      *itemTitle;
@property (nonatomic, strong) UIImage       *itemImage;
@property (nonatomic, strong) MyPFObject    *itemObject;
@property (nonatomic, strong) Class         viewControllerClass;
@property (nonatomic, strong) void          (^itemEvent)(SideMenuItem *, NSIndexPath *);
@property (nonatomic, assign) ItemStatus    status;

-(void)cancelLoading;

+ (SideMenuItem *)mapItem:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) completion;
+ (SideMenuItem *)calendarItem:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) completion;

+ (SideMenuItem *)createEventItem:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) completion;
+ (SideMenuItem *)fetchedEventItem:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) completion;

+ (SideMenuItem *)userItem:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) completion;
@end
