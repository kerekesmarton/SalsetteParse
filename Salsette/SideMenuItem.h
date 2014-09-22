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
@property (nonatomic, strong) void          (^itemEvent)(id);
@property (nonatomic, assign) ItemStatus    status;
@property (nonatomic, assign) NSInteger     section;

-(void)load:(UIImageView *)imageView;

+ (SideMenuItem *)mapItem:(PFUser *)user update:(void (^)(SideMenuItem *item)) update;
+ (SideMenuItem *)calendarItem:(PFUser *)user update:(void (^)(SideMenuItem *item)) update;

+ (SideMenuItem *)createEventItem:(PFUser *)user update:(void (^)(SideMenuItem *item)) update;
+ (SideMenuItem *)fetchedEventItem:(PFUser *)user update:(void (^)(SideMenuItem *item)) update;
+ (SideMenuItem *)eventItemWithEvent:(MyPFObject *)event;

+ (SideMenuItem *)userItem:(PFUser *)user update:(void (^)(SideMenuItem *item)) update;
+ (SideMenuItem *)fetchedArtistProfile:(PFUser *)user update:(void (^)(SideMenuItem *item)) update;
+ (SideMenuItem *)createArtistItem:(PFUser *)user update:(void (^)(SideMenuItem *item)) update;

@end
