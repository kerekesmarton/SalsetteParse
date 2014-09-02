//
//  SideMenuGroup.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 28/08/14.
//
//

#import "SideMenuGroup.h"
#import "SideMenuItem.h"

@implementation SideMenuGroup

+(NSArray *)itemsWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) block{
    
    NSMutableArray *res = [NSMutableArray array];
    [res addObject:[self mainGroupWithUser:user completion:block]];
    [res addObject:[self extrasGroupWithUser:user completion:block]];
    [res addObject:[self savedItemGroupWithUser:user completion:block]];
    [res addObject:[self userGroupWithUser:user completion:block]];
    
    return [NSArray arrayWithArray:res];
}

+(SideMenuGroup *)mainGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) block{
    
    SideMenuGroup *group = [[SideMenuGroup alloc] init];
    group.groupTitle = @"main";
    group.groupItems = @[[SideMenuItem mapItem:user completion:block],
                         [SideMenuItem calendarItem:user completion:block]];
    
    return group;
}


+ (SideMenuGroup *)extrasGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) block{
    SideMenuGroup *group = [[SideMenuGroup alloc] init];
    group.groupTitle = @"extras";
    SideMenuItem *createItem = [SideMenuItem createEventItem:user completion:block];
    
    group.groupItems = createItem? @[createItem] : nil;
    
    return group;
}

+ (SideMenuGroup *)savedItemGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) block{
    SideMenuGroup *group = [[SideMenuGroup alloc] init];
    group.groupTitle = @"saved";
    group.groupItems = nil;
    
    return group;
}

+ (SideMenuGroup *)userGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) block{
    SideMenuGroup *group = [[SideMenuGroup alloc] init];
    group.groupTitle = @"user";
    group.groupItems = @[[SideMenuItem userItem:user completion:block]];
    
    return group;
}
@end
