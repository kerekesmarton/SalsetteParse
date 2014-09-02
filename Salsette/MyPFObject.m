//
//  MyPFObject.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 01/09/14.
//
//

#import "MyPFObject.h"
#import <Parse/PFObject+Subclass.h>

static NSArray *fbEventGraphKeys;

static NSArray *fbProperties;
static NSArray *fbLocalisedDescriptions;
static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;

@implementation MyPFObject

@dynamic identifier;

+(instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    
    MyPFObject *emptyObject = [self object];
    
    return emptyObject;
}

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

-(NSString *)shortDesc {
    return [NSString stringWithFormat:@"empty %@",NSStringFromClass([self class])];
}

+(void)queryForID:(NSNumber *)id completion:(void (^)(id obj, NSError *err))block {
    
    block (nil,nil);
}

- (id)objectForIndex:(NSIndexPath *)indexPath {
    
    NSArray *data = [self dataSourceCount];
    
    NSArray *section = data[indexPath.section];
    
    id obj = section[indexPath.row];
    
    return self[obj];
}

- (NSString *)keyForIndex:(NSIndexPath *)indexPath {
    
    NSArray *data = [self descriptionDataSourceCount];
    
    NSArray *section = data[indexPath.section];
    
    id obj = section[indexPath.row];
    
    return obj;
}

-(NSArray *)dataSourceCount {
    
    return [NSArray array];
}

-(NSArray *)descriptionDataSourceCount {
    return [NSArray array];
}

@end
