//
//  PFUser+Additions.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 16/10/14.
//
//

#import "PFUser+Additions.h"

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
