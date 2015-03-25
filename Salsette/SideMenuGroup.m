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
    
        for (NSString *identifier in user.events) {
            PFQuery *query = [PFEvent query];
            [query whereKey:@"identifier" equalTo:identifier];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (error) {
                    NSLog(@"%@",[error userInfo].description);
                }
                else {
                    PFEvent *event = (PFEvent *)object;
                    SideMenuItem *item = [SideMenuItem fetchedEventItem:user update:update];
                    item.itemObject = event;
                    item.section = 1;
                    block(item);
                }
            }];
        }
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
    
    if ([[PFUser currentUser] userAccountTypeIncludes:AccountTypeArtist]) {
        
        //find..
        for (NSString *identifier in [PFUser currentUser].artistProfiles) {
            PFQuery *artistquery = [PFArtistProfile query];
            [artistquery whereKey:@"identifier" equalTo:identifier];
            [artistquery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (error) {
                    NSLog(@"%@",[error userInfo].description);
                } else if(object){
                    SideMenuItem *item = [SideMenuItem fetchedArtistProfile:user update:update];
                    item.itemObject = (PFArtistProfile *)object;
                    item.section = 3;
                    block(item);
                }
                
                for (NSString *groupIdentifier in [PFUser currentUser].groupProfiles) {
                    PFQuery *groupQuery = [PFArtistGroupProfile query];
                    [groupQuery whereKey:@"identifier" equalTo:groupIdentifier];
                    [groupQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        if (error) {
                            NSLog(@"%@",[error userInfo].description);
                        } else {
                            SideMenuItem *item = [SideMenuItem fetchedArtistProfile:user update:update];
                            item.itemObject = (PFArtistGroupProfile *)object;
                            item.section = 3;
                            block(item);
                        }
                    }];
                }
            }];
        }
    }
    
    SideMenuItem *create = [SideMenuItem createArtistItem:user update:update];
    
    NSMutableArray *res = [NSMutableArray arrayWithObject:[SideMenuItem userItem:user update:update]];
    if (create) {
        [res addObject:create];
    }
    return [NSArray arrayWithArray:res];
}

@end
