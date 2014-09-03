//
//  PFCover.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 03/09/14.
//
//

#import "MyPFObject.h"

@interface PFCover : MyPFObject

@property (nonatomic, strong) NSString *url;

+(instancetype)objectWithURL:(NSString *)url identifier:(NSString *)identifier;

@end
