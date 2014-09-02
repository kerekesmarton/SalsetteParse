//
//  SideMenuGroup.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 28/08/14.
//
//

#import <Foundation/Foundation.h>
@class PFUser;
@class SideMenuItem;
typedef enum GroupEvent {
    
    GroupEventBasic,
    GroupEventLoading,
    GroupEventReady
} GroupEvent;


@class SideMenuGroup;
//typedef void (^groupEvent)(SideMenuGroup *);


@interface SideMenuGroup : NSObject

@property (nonatomic, strong) NSString  *groupTitle;
@property (nonatomic, strong) NSArray   *groupItems;

+(NSArray *)itemsWithUser:(PFUser *)user completion:(void (^)(SideMenuItem *item)) completion;

/*
 - main group
 calendar
 map
 
 - user extras group
 (org)manage events
 ()
 
 - saved items group (+user)
 festivals
 schools
 parties
 
 - account group
 user details
 
 */

@end
