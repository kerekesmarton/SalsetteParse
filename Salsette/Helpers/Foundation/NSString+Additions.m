//
//  NSString+Additions.m
//  ForeverMapNGX
//
//  Created by Mihai Babici on 10/17/12.
//  Copyright (c) 2012 Kerekes Marton. All rights reserved.
//

#import "NSString+Additions.h"
#import <Foundation/Foundation.h>

@implementation NSString (Additions)

- (BOOL)isNotEmptyOrWhiteSpace {
    return ([self stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0);
}

- (BOOL)isEmptyOrWhiteSpace {
    return ([self stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0);
}

- (BOOL)containsAnyTokensFromArray:(NSArray *)strArray {
    NSMutableArray *tokens = [NSMutableArray array];
    for (NSString *token in strArray) {
        if ([token isNotEmptyOrWhiteSpace]) {
            [tokens addObject:token];
        }
    }
    
    NSInteger flags = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch;
    for (NSString *token in tokens) {
        if ([self rangeOfString:token options:flags].location != NSNotFound) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)containsAllTokensFromArray:(NSArray *)strArray {
    NSMutableArray *tokens = [NSMutableArray array];
    for (NSString *token in strArray) {
        if ([token isNotEmptyOrWhiteSpace]) {
            [tokens addObject:token];
        }
    }
    
    NSInteger flags = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch;
    for (NSString *token in tokens) {
        if ([self rangeOfString:token options:flags].location == NSNotFound) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isNumeric {
    NSScanner *sc = [NSScanner scannerWithString: self];
    if ([sc scanFloat:NULL]) {
        return [sc isAtEnd];
    }
    return NO;
}

+ (NSString *)randomStringWithLength:(NSInteger)length {
    NSString *letters = @"abcdef ghijkl mnopqr stuvw xyz ABCDEF GHIJKL MNOPQR STUVW XYZ 0123456789 ";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    
    return randomString;
}

+ (NSString*)stringWithElements:(NSArray*)elements {
    NSCharacterSet *spaces = [NSCharacterSet characterSetWithCharactersInString:@" ,-"];
    NSString *result = [NSString string];
    
    for (id obj in elements) {
        
        if ([obj respondsToSelector:@selector(isNotEmptyOrWhiteSpace)] && [obj isNotEmptyOrWhiteSpace]) {
            result = [result stringByAppendingFormat:@"%@, ", obj];
        }
        
    }
    return [result stringByTrimmingCharactersInSet:spaces];
}

- (NSString*)urlStringWithEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                        (CFStringRef)self,
                                                        NULL,
                                                        (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                        CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (NSString*)urlStringByEncodingReservedCharactersWithEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?#[] \"%-.<>\\^_`{|}~",
                                                                CFStringConvertNSStringEncodingToEncoding(encoding)));
}

+ (CGSize)sizeForString:(NSString *)string thatFitsSize:(CGSize)size {
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:[UIFont systemFontSize]]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    
    
    return rect.size;
}
@end
