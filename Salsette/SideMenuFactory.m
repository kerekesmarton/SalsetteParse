//
//  SideMenuObjectsFactory.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 28/08/14.
//
//

#import "SideMenuFactory.h"
#import "SideMenuGroup.h"
//#import "SideMenuObject.h"

@implementation SideMenuFactory

+ (NSArray *)menuItemsWithUser:(PFUser *)user event:(void (^)(SideMenuItem *))event{
    
    return [SideMenuGroup itemsWithUser:user completion:event];
}
@end
