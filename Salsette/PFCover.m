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

@dynamic url,size;

+(instancetype)objectWithURL:(NSString *)url identifier:(NSString *)identifier{
    
    PFCover *cover = [PFCover object];
    cover.url = url;
    cover.identifier = identifier;
    return cover;
}

+(instancetype)objectWithDictionary:(NSDictionary *)graph {
    
    PFCover *cover = [self object];
    
    for (NSString *key in fbEventGraphKeys) {
        
        id obj = graph[key];
        
        if ([key isEqualToString:@"cover_id"]) {
            
            cover.identifier = obj;
        } else if ([key isEqualToString:@"source"]) {
            
            cover.url = obj;
        }
    }
    
    return cover;
}

+(void)load {
    
    if (!fbEventGraphKeys) {
        fbEventGraphKeys = @[@"cover_id",@"source"];
    }
    
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

@end
