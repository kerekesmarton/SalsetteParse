//
//  SideMenuGroup.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 28/08/14.
//
//

#import "SideMenuGroup.h"
#import "SideMenuItem.h"
#import "PFEvent.h"

@implementation SideMenuGroup

+(NSArray *)itemsWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) block{
    
    NSMutableArray *res = [NSMutableArray array];
    [res addObject:[self mainGroupWithUser:user completion:block]];
    [res addObject:[self extrasGroupWithUser:user completion:block]];
    [res addObject:[self savedItemGroupWithUser:user completion:block]];
    [res addObject:[self userGroupWithUser:user completion:block]];
    
    return [NSArray arrayWithArray:res];
}

+(NSArray *)mainGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) block{
    
//    SideMenuGroup *group = [[SideMenuGroup alloc] init];
//    group.groupTitle = @"main";
//    group.groupItems = [NSMutableArray arrayWithArray:@[[SideMenuItem mapItem:user completion:block],
//                                                        [SideMenuItem calendarItem:user completion:block]]];
    
    return @[[SideMenuItem mapItem:user completion:block],
             [SideMenuItem calendarItem:user completion:block]];
}


+ (NSArray *)extrasGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) block{
//    SideMenuGroup *group = [[SideMenuGroup alloc] init];
//    group.groupTitle = @"extras";
    
//
//    group.groupItems = createItem? [NSMutableArray arrayWithArray:@[createItem]]  : nil;
    
    PFQuery *query = [PFEvent query];
    [query whereKey:@"pfUser" containedIn:@[[PFUser currentUser]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *queryError) {
        if (queryError) {
            NSLog(@"%@",[queryError userInfo].description);
        }
        [objects enumerateObjectsUsingBlock:^(PFEvent *event, NSUInteger idx, BOOL *stop) {
            [event fetchEventDetailsWithBlock:^(id event, NSError *eventError) {
                if (eventError) {
                    NSLog(@"%@",[eventError userInfo].description);
                }
                [SideMenuItem fetchedEventItem:user completion:^(SideMenuItem *item, NSIndexPath *indexPath) {
                    item.itemObject = event;
                    indexPath = [NSIndexPath indexPathForItem:idx+1 inSection:1];
                    block(item,indexPath);
                }];
            }];
        }];
    }];
    SideMenuItem *createItem = [SideMenuItem createEventItem:user completion:block];
    return @[createItem];
}

+ (NSArray *)savedItemGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) block{
    SideMenuGroup *group = [[SideMenuGroup alloc] init];
    group.groupTitle = @"saved";
    group.groupItems = nil;
    
    return [NSArray array];
}

+ (NSArray *)userGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item, NSIndexPath *indexPath)) block{
//    SideMenuGroup *group = [[SideMenuGroup alloc] init];
//    group.groupTitle = @"user";
//    group.groupItems = [NSMutableArray arrayWithArray:@[[SideMenuItem userItem:user completion:block]]];
    
    return @[[SideMenuItem userItem:user completion:block]];
}
@end
