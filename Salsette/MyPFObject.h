//
//  MyPFObject.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 01/09/14.
//
//

#import <Parse/Parse.h>

@interface MyPFObject : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString  *identifier;       //id

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;
- (NSString *)shortDesc;
+ (void)queryForID:(NSString *)id completion:(void (^)(id,NSError *))block;

- (id)objectForIndex:(NSIndexPath *)indexPath;
- (NSString *)keyForIndex:(NSIndexPath *)indexPath;
- (NSArray *)dataSourceCount;
- (NSArray *)descriptionDataSourceCount;
@end
