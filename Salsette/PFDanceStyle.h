//
//  PFDanceStyle.h
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 03/09/14.
//
//

#import "MyPFObject.h"

typedef enum DanceStyle{
    
    DanceStyleUndefined,
    DanceStyleLineSalsa,
    DanceStyleCubanSalsa,
    DanceStyleColombianSalsa,
    DanceStyleBachata,
    DanceStyleZouk,
    DanceStyleKizomba,
    DanceStyleCount,
    
} DanceStyle;

@interface PFDanceStyle : MyPFObject

@property (nonatomic, assign) DanceStyle danceStyle;

+(instancetype)objectWithStyle:(DanceStyle )style identifier:(NSString *)identifier;

+ (NSString *)stringForStyle:(DanceStyle)style;

@end
