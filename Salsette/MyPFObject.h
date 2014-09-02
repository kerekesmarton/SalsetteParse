//
//  MyPFObject.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 01/09/14.
//
//

#import <Parse/Parse.h>

@interface MyPFObject : PFObject <PFSubclassing>

@property (nonatomic, strong) NSNumber  *identifier;       //id

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;
- (NSString *)shortDesc;
+ (void)queryForID:(NSNumber *)id completion:(void (^)(id,NSError *))block;
@end
