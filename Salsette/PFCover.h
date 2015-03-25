//
//  PFCover.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 03/09/14.
//
//

#import "MyPFObject.h"

@class PFFile;

@interface PFCover : MyPFObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *size;

+(instancetype)objectWithURL:(NSString *)url identifier:(NSString *)identifier;

@end
