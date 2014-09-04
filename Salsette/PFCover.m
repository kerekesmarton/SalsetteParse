//
//  PFCover.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 03/09/14.
//
//

#import "PFCover.h"

static NSArray *fbEventGraphKeys;

static NSArray *pfProperties;
static NSArray *pfLocalisedDescriptions;

@implementation PFCover

@dynamic url;

+(instancetype)objectWithURL:(NSString *)url identifier:(NSString *)identifier{
    
    PFCover *cover = [PFCover object];
    cover.url = url;
    cover.identifier = identifier;
    return cover;
}

+(void)load {
    
    if (!pfProperties) {
        pfProperties = @[@"url"];
    }
    
    if (!pfLocalisedDescriptions) {
        pfLocalisedDescriptions = @[@"URL"];
    }
    
    [self registerSubclass];
}

-(NSString *)shortDesc {
    return self.url;
}

-(NSArray *)dataSourceCount {
    
    return @[pfProperties];
}

-(NSArray *)descriptionDataSourceCount {
    
    return @[pfLocalisedDescriptions];
}

+ (void)queryForID:(NSString *)identifier completion:(void (^)(id, NSError *))block {
    
    PFQuery *query = [self query];
    [query whereKey:@"identifier" equalTo:identifier];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            if (objects.count > 0) {
                
                PFCover *cover = [objects firstObject];
                [cover fetchIfNeeded];
                block(cover,nil);
            } else {
                block(nil,nil);
            }
            
        } else {
            block(nil,error);
        }
    }];
}

@end
