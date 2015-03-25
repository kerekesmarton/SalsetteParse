//
//  PFUser+Additions.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 16/10/14.
//
//

#import <Parse/Parse.h>

typedef enum AccountType {
    
    AccountTypeDancer       = 1,
    AccountTypeArtist       = 1<<1,
    AccountTypeOrganiser    = 1<<2,
    
} AccountType;

@interface PFUser (Additions)

@property (nonatomic, readwrite) int accountType;
- (AccountType) highestAccountType;
- (BOOL) userAccountTypeIncludes:(AccountType)accountType;
- (void) toggleAccountType:(AccountType)accountType;

@property (nonatomic, readwrite) NSArray *events;
-(void)addEvent:(NSString *)event;

@property (nonatomic, readwrite) NSArray *artistProfiles;
-(void)addArtistProfile:(NSString *)artistProfile;

@property (nonatomic, readwrite) NSArray *groupProfiles;
-(void)addGroupProfile:(NSString *)groupProfile;



+ (NSString *) userReadableAccountTypeForValue:(AccountType)accountType;
+ (NSArray *) allAccountTypes;
+ (AccountType) accountTypeForIndex:(NSInteger)index;
@end
