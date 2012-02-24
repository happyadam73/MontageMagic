//
//  AWBCollageFonts.h
//  Collage Maker
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFont.h"

typedef enum {
    AWBCollageFontTypeHelvetica,
    AWBCollageFontTypeArialRoundedMTBold,              
    AWBCollageFontTypeMarkerFeltThin,
    AWBCollageFontTypeAmericanTypewriter,
    AWBCollageFontTypeSnellRoundhand,
    AWBCollageFontTypeZapfino,
    AWBCollageFontTypeAppleGothic,
    AWBCollageFontTypeTrebuchetMSItalic,
    AWBCollageFontTypeChalkduster,
    AWBCollageFontTypeAcademyEngravedLetPlain,
    AWBCollageFontTypeBradleyHandITCTTBold,
    AWBCollageFontTypePapyrus,
    AWBCollageFontTypePartyLetPlain,
    AWBCollageFontTypeGraffiti,
    AWBCollageFontTypeJennaSue,
    AWBCollageFontTypeGillSans
} AWBCollageFontType;

@interface AWBCollageFont : NSObject {
    AWBCollageFontType fontType;
}

@property (nonatomic, assign) AWBCollageFontType fontType;
@property (nonatomic, readonly) BOOL isZFont;

- (id)initWithFontType:(AWBCollageFontType)aFontType;
- (NSString *)fontFamilyName;
- (NSString *)fontDescription;
- (UIFont *)fontWithSize:(CGFloat)size;
- (ZFont *)zFontWithSize:(CGFloat)size;
+ (BOOL)isZFont:(NSString *)fontName;
+ (BOOL)isFontNameMyFontURL:(NSString *)fontName;
+ (BOOL)isFontNameMyFontFilename:(NSString *)fontName;
+ (NSURL *)myFontUrlFromFontFilename:(NSString *)fontFilename;
+ (BOOL)myFontDoesExistWithFilename:(NSString *)fontFilename;

@end
