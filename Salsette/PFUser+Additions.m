//
//  PFUser+Additions.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 16/10/14.
//
//

#import "PFUser+Additions.h"

#import "PFEvent.h"
#import "PFArtistProfile.h"
#import "PFArtistGroupProfile.h"

@implementation PFUser (Additions)

-(int)accountType {
    NSNumber *res = [[PFUser currentUser] objectForKey:@"account_details"][@"type"];
    if (res) {
        return [res intValue];
    } else {
    
        [self setAccountType:AccountTypeDancer];
        
        return AccountTypeDancer;
    }
}

-(void)setAccountType:(int)accountType {
    
    NSMutableDictionary *accountDetails = [NSMutableDictionary dictionaryWithDictionary:[[PFUser currentUser] objectForKey:@"account_details"]];
    accountDetails[@"type"] = @(accountType);
    
    [[PFUser currentUser] setObject:accountDetails forKey:@"account_details"];
    [[PFUser currentUser] saveInBackground];
}

-(NSArray *)events {
 
    return [NSArray arrayWithArray:[[PFUser currentUser] objectForKey:NSStringFromClass([PFEvent class])]];
}

-(void)setEvents:(NSArray *)events {
    
    [[PFUser currentUser] setObject:events forKey:NSStringFromClass([PFEvent class])];
    [[PFUser currentUser] saveInBackground];
}

-(void)addEvent:(NSString *)event {
    [[PFUser currentUser] addUniqueObject:event forKey:NSStringFromClass([PFEvent class])];
    [[PFUser currentUser] saveInBackground];
}

-(NSArray *)artistProfiles {
    return [NSArray arrayWithArray:[[PFUser currentUser] objectForKey:NSStringFromClass([PFArtistProfile class])]];
}

-(void)setArtistProfiles:(NSArray *)artistProfiles {
    [[PFUser currentUser] setObject:artistProfiles forKey:NSStringFromClass([PFArtistProfile class])];
    [[PFUser currentUser] saveInBackground];
}

-(void)addArtistProfile:(NSString *)artistProfile {
    [[PFUser currentUser] addUniqueObject:artistProfile forKey:NSStringFromClass([PFArtistProfile class])];
    [[PFUser currentUser] saveInBackground];
}

-(NSArray *)groupProfiles{
    return [NSArray arrayWithArray:[[PFUser currentUser] objectForKey:NSStringFromClass([PFArtistGroupProfile class])]];
}

-(void)setGroupProfiles:(NSArray *)groupProfiles {
    [[PFUser currentUser] setObject:groupProfiles forKey:NSStringFromClass([PFArtistGroupProfile class])];
    [[PFUser currentUser] saveInBackground];
}

-(void)addGroupProfile:(NSString *)groupProfile {
    [[PFUser currentUser] addUniqueObject:groupProfile forKey:NSStringFromClass([PFArtistGroupProfile class])];
    [[PFUser currentUser] saveInBackground];
}

-(BOOL)userAccountTypeIncludes:(AccountType)accountType {
    
    if (([self accountType] & accountType) != 0) {
        return YES;
    }
    return NO;
}

-(AccountType)highestAccountType {
    
    if ([self userAccountTypeIncludes:AccountTypeOrganiser]) {
        return AccountTypeOrganiser;
    }
    if ([self userAccountTypeIncludes:AccountTypeArtist]) {
        return AccountTypeArtist;
    }
    return AccountTypeDancer;
}

-(void)toggleAccountType:(AccountType)accountType {
    
    int userAccountType = [[PFUser currentUser] accountType];
    
    if ([self userAccountTypeIncludes:accountType]) {
        //remove option
        if ((accountType & AccountTypeDancer) == 0) {
            userAccountType = userAccountType ^ accountType;
        }
    } else {
        //add option
        userAccountType = userAccountType | accountType;
    }
    
    [[PFUser currentUser] setAccountType:userAccountType];
}

+(NSString *)userReadableAccountTypeForValue:(AccountType)accountType {
    
    switch (accountType) {
        case AccountTypeDancer:
            return @"Dancer";
            break;
        case AccountTypeArtist:
            return @"Artist";
            break;
        case AccountTypeOrganiser:
            return @"Organiser";
            break;
        default:
            break;
    };
}

+ (NSArray *)allAccountTypes {
    
    return @[[PFUser userReadableAccountTypeForValue:AccountTypeDancer],
             [PFUser userReadableAccountTypeForValue:AccountTypeArtist],
             [PFUser userReadableAccountTypeForValue:AccountTypeOrganiser]];
}

+ (AccountType)accountTypeForIndex:(NSInteger)index {
    
    if(index == 0) {
        return AccountTypeDancer;
    } else if (index == 1) {
        return AccountTypeArtist;
    }
    return AccountTypeOrganiser;
}




@end
