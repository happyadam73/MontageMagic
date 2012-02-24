//
//  AWBCollageFonts.m
//  Collage Maker
//
//  Created by Adam Buckley on 06/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBCollageFont.h"
#import "FontManager.h"
#import "FileHelpers.h"

@implementation AWBCollageFont

@synthesize fontType;

- (id)initWithFontType:(AWBCollageFontType)aFontType
{
    self = [super init];
    if (self) {
        fontType = aFontType;
    }
    return self;
}

- (BOOL)isZFont
{
    switch (fontType) {
        case AWBCollageFontTypeAmericanTypewriter:
            return NO;
        case AWBCollageFontTypeAppleGothic:
            return NO;
        case AWBCollageFontTypeArialRoundedMTBold:
            return NO;
        case AWBCollageFontTypeHelvetica:
            return NO;
        case AWBCollageFontTypeMarkerFeltThin:
            return NO;
        case AWBCollageFontTypeSnellRoundhand:
            return NO;
        case AWBCollageFontTypeTrebuchetMSItalic:
            return NO;
        case AWBCollageFontTypeZapfino:
            return NO;
        case AWBCollageFontTypeChalkduster:
            return NO;
        case AWBCollageFontTypeAcademyEngravedLetPlain:
            return NO;
        case AWBCollageFontTypeBradleyHandITCTTBold:
            return NO;
        case AWBCollageFontTypePapyrus:
            return NO;
        case AWBCollageFontTypePartyLetPlain:
            return NO;
        case AWBCollageFontTypeGraffiti:
            return YES;
        case AWBCollageFontTypeJennaSue:
            return YES;
        case AWBCollageFontTypeGillSans:
            return NO;
        default:
            return NO;
    }
}


- (NSString *)fontFamilyName
{
    switch (fontType) {
        case AWBCollageFontTypeAmericanTypewriter:
            return @"AmericanTypewriter";
        case AWBCollageFontTypeAppleGothic:
            return @"AppleGothic";
        case AWBCollageFontTypeArialRoundedMTBold:
            return @"ArialRoundedMTBold";
        case AWBCollageFontTypeHelvetica:
            return @"Helvetica";
        case AWBCollageFontTypeMarkerFeltThin:
            return @"MarkerFelt-Thin";
        case AWBCollageFontTypeSnellRoundhand:
            return @"SnellRoundhand";
        case AWBCollageFontTypeTrebuchetMSItalic:
            return @"TrebuchetMS-Italic";
        case AWBCollageFontTypeZapfino:
            return @"Zapfino";
        case AWBCollageFontTypeChalkduster:
            return @"Chalkduster";
        case AWBCollageFontTypeAcademyEngravedLetPlain:
            return @"AcademyEngravedLetPlain";
        case AWBCollageFontTypeBradleyHandITCTTBold:
            return @"BradleyHandITCTT-Bold";
        case AWBCollageFontTypePapyrus:
            return @"Papyrus";
        case AWBCollageFontTypePartyLetPlain:
            return @"PartyLetPlain";
        case AWBCollageFontTypeGraffiti:
            return @"Most Wasted";
        case AWBCollageFontTypeJennaSue:
            return @"Jenna Sue";
        case AWBCollageFontTypeGillSans:
            return @"GillSans";            
        default:
            return @"Helvetica";
    }
}

- (NSString *)fontDescription
{
    switch (fontType) {
        case AWBCollageFontTypeAmericanTypewriter:
            return @"Typewriter";
        case AWBCollageFontTypeAppleGothic:
            return @"Gothic";
        case AWBCollageFontTypeArialRoundedMTBold:
            return @"Arial Bold";
        case AWBCollageFontTypeHelvetica:
            return @"Helvetica";
        case AWBCollageFontTypeMarkerFeltThin:
            return @"Marker Pen";
        case AWBCollageFontTypeSnellRoundhand:
            return @"Roundhand";
        case AWBCollageFontTypeTrebuchetMSItalic:
            return @"Trebuchet Italic";
        case AWBCollageFontTypeZapfino:
            return @"Zapfino";
        case AWBCollageFontTypeChalkduster:
            return @"Chalkduster";
        case AWBCollageFontTypeAcademyEngravedLetPlain:
            return @"Engraved";
        case AWBCollageFontTypeBradleyHandITCTTBold:
            return @"Handwriting";
        case AWBCollageFontTypePapyrus:
            return @"Papyrus";
        case AWBCollageFontTypePartyLetPlain:
            return @"Party";
        case AWBCollageFontTypeGraffiti:
            return @"Graffiti";
        case AWBCollageFontTypeJennaSue:
            return @"Cute Handwriting ^";
        case AWBCollageFontTypeGillSans:
            return @"Gill Sans";            
        default:
            return @"Helvetica";
    }
}

- (UIFont *)fontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:[self fontFamilyName] size:size];
}

- (ZFont *)zFontWithSize:(CGFloat)size
{
    if (!self.isZFont) {
        return nil;
    }
    return [[FontManager sharedManager] zFontWithName:[self fontFamilyName] pointSize:size];
}

+ (BOOL)isZFont:(NSString *)fontName
{
    if ([fontName isEqualToString:@"Most Wasted"]) {
        return YES;
    } else if ([fontName isEqualToString:@"Jenna Sue"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isFontNameMyFontURL:(NSString *)fontName
{
    NSURL *fileUrl = [NSURL URLWithString:fontName];
    if (fileUrl) {
        if ([fileUrl isFileURL]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

+ (BOOL)isFontNameMyFontFilename:(NSString *)fontName
{
    if ([fontName hasPrefix:@"mf"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSURL *)myFontUrlFromFontFilename:(NSString *)fontFilename
{
    NSString *filepath = AWBPathInMyFontsDocumentsSubdirectory(fontFilename);
    return [NSURL fileURLWithPath:filepath];
}

+ (BOOL)myFontDoesExistWithFilename:(NSString *)fontFilename
{
    NSString *filepath = AWBPathInMyFontsDocumentsSubdirectory(fontFilename);
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

@end
