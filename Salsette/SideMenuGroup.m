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

+(NSArray *)itemsWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) block update:(void (^)(SideMenuItem *))update {
    
    NSMutableArray *res = [NSMutableArray array];
    [res addObject:[self mainGroupWithUser:user completion:block update:update]];
    [res addObject:[self extrasGroupWithUser:user completion:block update:update]];
    [res addObject:[self savedItemGroupWithUser:user completion:block update:update]];
    [res addObject:[self userGroupWithUser:user completion:block update:update]];
    
    return [NSArray arrayWithArray:res];
}

+(NSArray *)mainGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) block update:(void (^)(SideMenuItem *item))update{
    
    return @[[SideMenuItem mapItem:user update:update],
             [SideMenuItem calendarItem:user update:update]];
}


+ (NSArray *)extrasGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) block update:(void (^)(SideMenuItem *item))update{

    if (!user) {
        return [NSArray array];
    }
    
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
                SideMenuItem *item = [SideMenuItem fetchedEventItem:user update:update];
                item.itemObject = event;
                item.indexPath = [NSIndexPath indexPathForItem:idx+1 inSection:1];
                block(item);
            }];
        }];
    }];
    
    SideMenuItem *createItem = [SideMenuItem createEventItem:user update:update];
    
    return @[createItem];
}

+ (NSArray *)savedItemGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) block update:(void (^)(SideMenuItem *item))update{
    
    return [NSArray array];
}

+ (NSArray *)userGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) block update:(void (^)(SideMenuItem *item))update{

    return @[[SideMenuItem userItem:user update:update]];
}
@end
