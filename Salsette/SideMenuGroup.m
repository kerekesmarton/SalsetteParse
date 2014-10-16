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
#import "PFArtistGroupProfile.h"
#import "PFArtistProfile.h"
#import "PFUser+Additions.h"

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
    
    //section 0
    
    return @[[SideMenuItem mapItem:user update:update],
             [SideMenuItem calendarItem:user update:update]];
}


+ (NSArray *)extrasGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) block update:(void (^)(SideMenuItem *item))update{

    //section 1
    
    if ([user userAccountTypeIncludes:AccountTypeOrganiser]) {
    
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
                    item.section = 1;
                    block(item);
                }];
            }];
        }];
    }
    
    SideMenuItem *createItem = [SideMenuItem createEventItem:user update:update];
    
    NSMutableArray *res = [NSMutableArray array];
    if (createItem) {
        [res addObject:createItem];
    }
    return [NSArray arrayWithArray:res];
}

+ (NSArray *)savedItemGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) block update:(void (^)(SideMenuItem *item))update{
    
    //section 2
    return [NSArray array];
}

+ (NSArray *)userGroupWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) block update:(void (^)(SideMenuItem *item))update{

    //section 3
    
    if ([user userAccountTypeIncludes:AccountTypeArtist]) {
        
        NSMutableArray *results = [NSMutableArray array];
        
        //find..
        PFQuery *artistquery = [PFArtistProfile query];
        [artistquery whereKey:@"pfUser" containedIn:@[[PFUser currentUser]]];
        [artistquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *queryError) {
            if (queryError) {
                NSLog(@"%@",[queryError userInfo].description);
            } else {
                [results addObjectsFromArray:objects];
            }
            //find next..
            PFQuery *memberQuery = [PFArtistGroupProfile query];
            [memberQuery whereKey:@"members" containsAllObjectsInArray:@[[PFUser currentUser]]];
            [memberQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *queryError) {
                if (queryError) {
                    NSLog(@"%@",[queryError userInfo].description);
                } else {
                    [results addObjectsFromArray:objects];
                }
                // find next..
                PFQuery *groupQuery = [PFArtistGroupProfile query];
                [groupQuery whereKey:@"admins" containsAllObjectsInArray:@[[PFUser currentUser]]];
                [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *queryError) {
                    if (queryError) {
                        NSLog(@"%@",[queryError userInfo].description);
                    } else {
                        [results addObjectsFromArray:objects];
                    }
                    
                    //iterate and return
                    [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        if ([obj isKindOfClass:[PFArtistProfile class]]) {
                            PFArtistProfile *object = obj;
                            [object fetchEventDetailsWithBlock:^(id artist, NSError *error) {
                                if (error) {
                                    NSLog(@"%@",[error userInfo].description);
                                }
                                SideMenuItem *item = [SideMenuItem fetchedArtistProfile:user update:update];
                                item.itemObject = artist;
                                item.section = 3;
                                block(item);
                            }];
                        } else if ([obj isKindOfClass:[PFArtistGroupProfile class]]) {
                            PFArtistGroupProfile *object = obj;
                            [object fetchEventDetailsWithBlock:^(id artist, NSError *error) {
                                if (error) {
                                    NSLog(@"%@",[error userInfo].description);
                                }
                                SideMenuItem *item = [SideMenuItem fetchedArtistProfile:user update:update];
                                item.itemObject = artist;
                                item.section = 3;
                                block(item);
                            }];
                        }
                    }];
                }];
            }];
        }];
    }
    
    SideMenuItem *create = [SideMenuItem createArtistItem:user update:update];
    
    NSMutableArray *res = [NSMutableArray arrayWithObject:[SideMenuItem userItem:user update:update]];
    if (create) {
        [res addObject:create];
    }
    return [NSArray arrayWithArray:res];
}
@end
