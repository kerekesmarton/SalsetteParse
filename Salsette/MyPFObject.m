//
//  MyPFObject.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 01/09/14.
//
//

#import "MyPFObject.h"
#import <Parse/PFObject+Subclass.h>

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

@end
