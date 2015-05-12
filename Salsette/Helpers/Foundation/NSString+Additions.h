//
//  NSString+Additions.h
//  ForeverMapNGX
//
//  Created by Mihai Babici on 10/17/12.
//  Copyright (c) 2012 Kerekes Marton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

#define safeString(obj)         (obj != nil ? obj : @"")

- (BOOL)isNotEmptyOrWhiteSpace;
- (BOOL)isEmptyOrWhiteSpace;
- (BOOL)containsAnyTokensFromArray:(NSArray *)strArray;
- (BOOL)containsAllTokensFromArray:(NSArray *)strArray;
- (BOOL)isNumeric;

//used to encode a string so it can be used in an url
- (NSString*)urlStringWithEncoding:(NSStringEncoding)encoding;
- (NSString*)urlStringByEncodingReservedCharactersWithEncoding:(NSStringEncoding)encoding;

+ (NSString *)randomStringWithLength:(NSInteger)length;
+ (NSString*)stringWithElements:(NSArray*)elements;
+ (CGSize)sizeForString:(NSString *)string thatFitsSize:(CGSize)size;

@end
