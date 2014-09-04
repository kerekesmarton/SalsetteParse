//
//  SideMenuObjectsFactory.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 28/08/14.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SideMenuGroup.h"
#import "SideMenuItem.h"

@interface SideMenuFactory : NSObject

+ (NSArray *)menuItemsWithUser:(PFUser *)user event:(void (^)(SideMenuItem *item)) event update:(void (^)(SideMenuItem *item))update;

@end
