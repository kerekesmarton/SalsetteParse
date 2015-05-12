//
//  PFClassList.h
//  Salsette
//
//  Created by Kerekes, Marton on 03/04/15.
//
//

#import "MyPFObject.h"

@interface PFClassList : MyPFObject

@property (nonatomic, strong) NSArray *rooms;
@property (nonatomic, strong) NSArray *days;
@property (nonatomic, strong) NSDictionary *schedule;

+(instancetype)objectWithIdentifier:(NSString *)identifier;

@end
