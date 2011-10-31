//
//  CollageTheme.m
//  Collage Maker
//
//  Created by Adam Buckley on 15/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageTheme.h"
#import "AWBSettings.h"
#import "UIColor+SignColors.h"

@implementation CollageTheme

@synthesize themeName, themeType, thumbnailFilename, addImageShadows, addTextShadows, addImageBorders, addTextBorders;
@synthesize imageRoundedBorders, textRoundedBorders, addTextBackground, collageBackgroundColor, imageShadowColor, textShadowColor;
@synthesize imageBorderColor, textBorderColor, textBackgroundColor, symbolColor, labelTextFont, labelTextColor;
@synthesize deviceAvailability, isAvailableOnCurrentDevice;
@synthesize addCollageBorder, collageBorderColor, useBackgroundTexture, backgroundTexture;
@synthesize snapToGrid, objectLocatorType, autoMemoryReduction, randomPickCount;

- (void)dealloc
{
    [collageBorderColor release];
    [backgroundTexture release];
    [themeName release];
    [thumbnailFilename release];
    [collageBackgroundColor release];
    [imageShadowColor release];
    [textShadowColor release];
    [imageBorderColor release];
    [textBorderColor release];
    [textBackgroundColor release];
    [labelTextFont release];
    [labelTextColor release];
    [symbolColor release];
    
    [super dealloc];
}

+ (id)themeWithThemeType:(CollageThemeType)themeType
{
    switch (themeType) {
        case kAWBCollageThemeTypePlain:
            return [CollageTheme plainTheme];
        case kAWBCollageThemeTypeBlueAndGreenSign:
            return [CollageTheme blueAndGreenSignTheme];
        case kAWBCollageThemeTypeBlueContrastItalic:
            return [CollageTheme blueContrastItalicTheme];
        case kAWBCollageThemeTypeChalkboard:
            return [CollageTheme chalkboardTheme];
        case kAWBCollageThemeTypeElegant:
            return [CollageTheme elegantTheme];
        case kAWBCollageThemeTypeGreenAndRedSign:
            return [CollageTheme greenAndRedSignTheme];
        case kAWBCollageThemeTypeYellowSign:
            return [CollageTheme yellowSignTheme];
        case kAWBCollageThemeTypeHoliday:
            return [CollageTheme holidayTheme];
        case kAWBCollageThemeTypeHolidayPhone:
            return [CollageTheme holidayThemePhone];
        case kAWBCollageThemeTypeCardboard:
            return [CollageTheme cardboardTheme];
        case kAWBCollageThemeTypePhotoModernBlack:
            return [CollageTheme photoModernBlackTheme];
        case kAWBCollageThemeTypePhotoModernWhite:
            return [CollageTheme photoModernWhiteTheme];
        case kAWBCollageThemeTypeRedAndBlackSign:
            return [CollageTheme redAndBlackSignTheme];
        case kAWBCollageThemeTypeHandwritten:
            return [CollageTheme handwrittenTheme];
        case kAWBCollageThemeTypeBlackboard:
            return [CollageTheme blackboardTheme];
        case kAWBCollageThemeTypeTypewriter:
            return [CollageTheme typewriterTheme];
        case kAWBCollageThemeTypeNoticeBoard:
            return [CollageTheme noticeBoardTheme];
        case kAWBCollageThemeTypePhotoMosaicSmallImagesBlack:
            return [CollageTheme photoMosaicSmallImagesBlackTheme];
        case kAWBCollageThemeTypePhotoMosaicSmallImagesWhite:
            return [CollageTheme photoMosaicSmallImagesWhiteTheme];
        case kAWBCollageThemeTypePhotoMosaicLargeImagesBlack:
            return [CollageTheme photoMosaicLargeImagesBlackTheme];
        case kAWBCollageThemeTypePhotoMosaicLargeImagesWhite:
            return [CollageTheme photoMosaicLargeImagesWhiteTheme];
        case kAWBCollageThemeTypePhotoMosaicMicroImagesBlack:
            return [CollageTheme photoMosaicMicroImagesBlackTheme];
        default:
            return [CollageTheme plainTheme];
    }    
}

+ (id)plainTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypePlain;
    theme.themeName = @"Plain";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"PlainTheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = NO;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = NO;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor whiteColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor blackColor];
    theme.textBorderColor = [UIColor blackColor];
    theme.textBackgroundColor = [UIColor whiteColor];
    theme.labelTextColor = [UIColor blackColor];
    theme.labelTextFont = @"Helvetica";
    theme.symbolColor = [UIColor blackColor];
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Noticeboard";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 1;
    
    return [theme autorelease];        
}

+ (id)blueAndGreenSignTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeBlueAndGreenSign;
    theme.themeName = @"Blue & Green Sign";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"BlueAndGreenSignTheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = YES;
    theme.imageRoundedBorders = YES;
    theme.textRoundedBorders = YES;
    theme.addTextBackground = YES;
    theme.collageBackgroundColor = [UIColor blueSignBackgroundColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor whiteColor];
    theme.textBorderColor = [UIColor whiteColor];
    theme.textBackgroundColor = [UIColor darkGreenSignBackgroundColor];
    theme.labelTextColor = [UIColor whiteColor];
    theme.labelTextFont = @"ArialRoundedMTBold";
    theme.symbolColor = [UIColor whiteColor];
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Brick";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor whiteColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 1;
    
    return [theme autorelease];        
}

+ (id)greenAndRedSignTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeGreenAndRedSign;
    theme.themeName = @"Green & Red Sign";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"GreenAndRedSignTheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = YES;
    theme.imageRoundedBorders = YES;
    theme.textRoundedBorders = YES;
    theme.addTextBackground = YES;
    theme.collageBackgroundColor = [UIColor darkGreenSignBackgroundColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor whiteColor];
    theme.textBorderColor = [UIColor whiteColor];
    theme.textBackgroundColor = [UIColor redSignBackgroundColor];
    theme.labelTextColor = [UIColor whiteColor];
    theme.labelTextFont = @"ArialRoundedMTBold";
    theme.symbolColor = [UIColor whiteColor];
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Brick";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor whiteColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 1;
    
    return [theme autorelease];        
}

+ (id)blueContrastItalicTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeBlueContrastItalic;
    theme.themeName = @"Blue Contrast Italic";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"BlueContrastItalicTheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = YES;
    theme.imageRoundedBorders = YES;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = YES;
    theme.collageBackgroundColor = [UIColor blueSignBackgroundColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor blackColor];
    theme.textBorderColor = [UIColor yellowSignBackgroundColor];
    theme.textBackgroundColor = [UIColor blackColor];
    theme.labelTextColor = [UIColor whiteColor];
    theme.labelTextFont = @"TrebuchetMS-Italic";
    theme.symbolColor = [UIColor blackColor];
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Cardboard";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 1;
    
    return [theme autorelease];        
}

+ (id)chalkboardTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeChalkboard;
    theme.themeName = @"Chalkboard";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityiPadOnly;
    theme.thumbnailFilename = @"ChalkboardTheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = YES;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor darkGrayColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor whiteColor];
    theme.textBorderColor = [UIColor whiteColor];
    theme.textBackgroundColor = [UIColor blackColor];
    theme.labelTextColor = [UIColor whiteColor];
    theme.labelTextFont = @"Chalkduster";
    theme.symbolColor = [UIColor whiteColor];
    theme.useBackgroundTexture = YES;
    theme.backgroundTexture = @"Blackboard";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor whiteColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 2;
    
    return [theme autorelease];        
}

+ (id)elegantTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeElegant;
    theme.themeName = @"Elegant";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"ElegantTheme100.jpg";
    theme.addImageShadows = YES;
    theme.addTextShadows = YES;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = NO;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor whiteColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor blackColor];
    theme.textBorderColor = [UIColor blackColor];
    theme.textBackgroundColor = [UIColor whiteColor];
    theme.labelTextColor = [UIColor blackColor];
    theme.labelTextFont = @"SnellRoundhand";
    theme.symbolColor = [UIColor blackColor]; 
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Sand";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 1;
    
    return [theme autorelease];        
}

+ (id)holidayTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeHoliday;
    theme.themeName = @"Holiday";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityiPadOnly;
    theme.thumbnailFilename = @"HolidayTheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = YES;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = YES;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor orangeSignBackgroundColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor blackColor];
    theme.textBorderColor = [UIColor blackColor];
    theme.textBackgroundColor = [UIColor whiteColor];
    theme.labelTextColor = [UIColor blackColor];
    theme.labelTextFont = @"Papyrus";
    theme.symbolColor = [UIColor blackColor];
    theme.useBackgroundTexture = YES;
    theme.backgroundTexture = @"Sand";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 2;
    
    return [theme autorelease];        
}

+ (id)holidayThemePhone
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeHolidayPhone;
    theme.themeName = @"Holiday";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityiPhoneOnly;
    theme.thumbnailFilename = @"HolidayPhoneTheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = YES;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = YES;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor orangeSignBackgroundColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor blackColor];
    theme.textBorderColor = [UIColor blackColor];
    theme.textBackgroundColor = [UIColor whiteColor];
    theme.labelTextColor = [UIColor blackColor];
    theme.labelTextFont = @"MarkerFelt-Thin";
    theme.symbolColor = [UIColor blackColor];
    theme.useBackgroundTexture = YES;
    theme.backgroundTexture = @"Sand";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 2;
    
    return [theme autorelease];        
}

+ (id)cardboardTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeCardboard;
    theme.themeName = @"Cardboard";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"CardboardTheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = YES;
    theme.imageRoundedBorders = YES;
    theme.textRoundedBorders = YES;
    theme.addTextBackground = YES;
    theme.collageBackgroundColor = [UIColor brownSignBackgroundColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor blackColor];
    theme.textBorderColor = [UIColor blackColor];
    theme.textBackgroundColor = [UIColor blackColor];
    theme.labelTextColor = [UIColor whiteColor];
    theme.labelTextFont = @"ArialRoundedMTBold";
    theme.symbolColor = [UIColor blackColor];
    theme.useBackgroundTexture = YES;
    theme.backgroundTexture = @"Cardboard";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 2;
    
    return [theme autorelease];        
}

+ (id)yellowSignTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeYellowSign;
    theme.themeName = @"Yellow Sign";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"YellowSignTheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = YES;
    theme.textRoundedBorders = YES;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor yellowSignBackgroundColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor whiteColor];
    theme.textBorderColor = [UIColor whiteColor];
    theme.textBackgroundColor = [UIColor whiteColor];
    theme.labelTextColor = [UIColor blackColor];
    theme.labelTextFont = @"ArialRoundedMTBold";
    theme.symbolColor = [UIColor blackColor];
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Brick";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 1;
    
    return [theme autorelease];        
}

+ (id)photoModernBlackTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypePhotoModernBlack;
    theme.themeName = @"Postcard Black";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"PhotoModernBlackTheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = NO;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor blackColor];
    theme.imageShadowColor = [UIColor whiteColor];
    theme.textShadowColor = [UIColor whiteColor];
    theme.imageBorderColor = [UIColor whiteColor];
    theme.textBorderColor = [UIColor whiteColor];
    theme.textBackgroundColor = [UIColor blackColor];
    theme.labelTextColor = [UIColor whiteColor];
    theme.labelTextFont = @"TrebuchetMS-Italic";
    theme.symbolColor = [UIColor whiteColor]; 
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Blackboard";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor whiteColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 3;
    
    return [theme autorelease];        
}

+ (id)photoModernWhiteTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypePhotoModernWhite;
    theme.themeName = @"Postcard White";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"PhotoModernWhiteTheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = YES;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = NO;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor whiteColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor blackColor];
    theme.textBorderColor = [UIColor blackColor];
    theme.textBackgroundColor = [UIColor whiteColor];
    theme.labelTextColor = [UIColor blackColor];
    theme.labelTextFont = @"TrebuchetMS-Italic";
    theme.symbolColor = [UIColor blackColor];
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Paper";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 2;
    
    return [theme autorelease];        
}

+ (id)redAndBlackSignTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeRedAndBlackSign;
    theme.themeName = @"Red & Black Sign";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"RedAndBlackSignTheme100.jpg";
    theme.addImageShadows = YES;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = YES;
    theme.imageRoundedBorders = YES;
    theme.textRoundedBorders = YES;
    theme.addTextBackground = YES;
    theme.collageBackgroundColor = [UIColor redSignBackgroundColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor blackColor];
    theme.textBorderColor = [UIColor blackColor];
    theme.textBackgroundColor = [UIColor blackColor];
    theme.labelTextColor = [UIColor whiteColor];
    theme.labelTextFont = @"ArialRoundedMTBold";
    theme.symbolColor = [UIColor blackColor];
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Brick";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 1;
    
    return [theme autorelease];        
}

+ (id)handwrittenTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeHandwritten;
    theme.themeName = @"Handwritten";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityiPadOnly;
    theme.thumbnailFilename = @"HandwrittenTheme100.jpg";
    theme.addImageShadows = YES;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = NO;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor whiteColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor blackColor];
    theme.textBorderColor = [UIColor blackColor];
    theme.textBackgroundColor = [UIColor yellowSignBackgroundColor];
    theme.labelTextColor = [UIColor blackColor];
    theme.labelTextFont = @"BradleyHandITCTT-Bold";
    theme.symbolColor = [UIColor blackColor]; 
    theme.useBackgroundTexture = YES;
    theme.backgroundTexture = @"Paper";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 2;
    
    return [theme autorelease];        
}

+ (id)blackboardTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeBlackboard;
    theme.themeName = @"Blackboard";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityiPhoneOnly;
    theme.thumbnailFilename = @"BlackboardTheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = YES;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor darkGrayColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor whiteColor];
    theme.textBorderColor = [UIColor whiteColor];
    theme.textBackgroundColor = [UIColor blackColor];
    theme.labelTextColor = [UIColor whiteColor];
    theme.labelTextFont = @"MarkerFelt-Thin";
    theme.symbolColor = [UIColor whiteColor];
    theme.useBackgroundTexture = YES;
    theme.backgroundTexture = @"Blackboard";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor whiteColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 2;
    
    return [theme autorelease];        
}

+ (id)typewriterTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeTypewriter;
    theme.themeName = @"Typewriter";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityiPhoneOnly;
    theme.thumbnailFilename = @"TypewriterTheme100.jpg";
    theme.addImageShadows = YES;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = NO;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor whiteColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor blackColor];
    theme.textBorderColor = [UIColor blackColor];
    theme.textBackgroundColor = [UIColor yellowSignBackgroundColor];
    theme.labelTextColor = [UIColor blackColor];
    theme.labelTextFont = @"AmericanTypewriter";
    theme.symbolColor = [UIColor blackColor]; 
    theme.useBackgroundTexture = YES;
    theme.backgroundTexture = @"Paper";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 2;
    
    return [theme autorelease];        
}

+ (id)noticeBoardTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypeNoticeBoard;
    theme.themeName = @"Notice Board";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"NoticeboardTheme100.jpg";
    theme.addImageShadows = YES;
    theme.addTextShadows = YES;
    theme.addImageBorders = YES;
    theme.addTextBorders = YES;
    theme.imageRoundedBorders = NO;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = YES;
    theme.collageBackgroundColor = [UIColor brownSignBackgroundColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor whiteColor];
    theme.textBorderColor = [UIColor blackColor];
    theme.textBackgroundColor = [UIColor yellowSignBackgroundColor];
    theme.labelTextColor = [UIColor blackColor];
    theme.labelTextFont = @"TrebuchetMS-Italic";
    theme.symbolColor = [UIColor blackColor]; 
    theme.useBackgroundTexture = YES;
    theme.backgroundTexture = @"Noticeboard";
    theme.addCollageBorder = NO;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = NO;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeScatter;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 2;
    
    return [theme autorelease];        
}

+ (id)photoMosaicSmallImagesBlackTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypePhotoMosaicSmallImagesBlack;
    theme.themeName = @"Photo Mosaic Black (Small Photos)";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"mosaicblack6rowtheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = NO;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor blackColor];
    theme.imageShadowColor = [UIColor whiteColor];
    theme.textShadowColor = [UIColor whiteColor];
    theme.imageBorderColor = [UIColor blackColor];
    theme.textBorderColor = [UIColor whiteColor];
    theme.textBackgroundColor = [UIColor blackColor];
    theme.labelTextColor = [UIColor whiteColor];
    theme.labelTextFont = @"TrebuchetMS-Italic";
    theme.symbolColor = [UIColor whiteColor]; 
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Blackboard";
    theme.addCollageBorder = YES;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = YES;
    theme.objectLocatorType = (DEVICE_IS_IPAD ? kAWBCollageObjectLocatorTypeMosaicSmallImages : kAWBCollageObjectLocatorTypeMosaicTinyImages);
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 2;
    
    return [theme autorelease];        
}

+ (id)photoMosaicSmallImagesWhiteTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypePhotoMosaicSmallImagesWhite;
    theme.themeName = @"Photo Mosaic White (Small Photos)";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"mosaicwhite6rowtheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = NO;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor whiteColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor whiteColor];
    theme.textBorderColor = [UIColor blackColor];
    theme.textBackgroundColor = [UIColor whiteColor];
    theme.labelTextColor = [UIColor blackColor];
    theme.labelTextFont = @"TrebuchetMS-Italic";
    theme.symbolColor = [UIColor blackColor];
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Paper";
    theme.addCollageBorder = YES;
    theme.collageBorderColor = [UIColor whiteColor];
    theme.snapToGrid = YES;
    theme.objectLocatorType = (DEVICE_IS_IPAD ? kAWBCollageObjectLocatorTypeMosaicSmallImages : kAWBCollageObjectLocatorTypeMosaicTinyImages);
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 2;
    
    return [theme autorelease];        
}

+ (id)photoMosaicLargeImagesBlackTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypePhotoMosaicLargeImagesBlack;
    theme.themeName = @"Photo Mosaic Black (Large Photos)";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"mosaicblack4rowtheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = NO;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor blackColor];
    theme.imageShadowColor = [UIColor whiteColor];
    theme.textShadowColor = [UIColor whiteColor];
    theme.imageBorderColor = [UIColor blackColor];
    theme.textBorderColor = [UIColor whiteColor];
    theme.textBackgroundColor = [UIColor blackColor];
    theme.labelTextColor = [UIColor whiteColor];
    theme.labelTextFont = @"TrebuchetMS-Italic";
    theme.symbolColor = [UIColor whiteColor]; 
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Blackboard";
    theme.addCollageBorder = YES;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = YES;
    theme.objectLocatorType = (DEVICE_IS_IPAD ? kAWBCollageObjectLocatorTypeMosaicLargeImages : kAWBCollageObjectLocatorTypeMosaicMediumImages);
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 3;
    
    return [theme autorelease];        
}

+ (id)photoMosaicLargeImagesWhiteTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypePhotoMosaicLargeImagesWhite;
    theme.themeName = @"Photo Mosaic White (Large Photos)";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityAllDevices;
    theme.thumbnailFilename = @"mosaicwhite4rowtheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = NO;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor whiteColor];
    theme.imageShadowColor = [UIColor blackColor];
    theme.textShadowColor = [UIColor blackColor];
    theme.imageBorderColor = [UIColor whiteColor];
    theme.textBorderColor = [UIColor blackColor];
    theme.textBackgroundColor = [UIColor whiteColor];
    theme.labelTextColor = [UIColor blackColor];
    theme.labelTextFont = @"TrebuchetMS-Italic";
    theme.symbolColor = [UIColor blackColor];
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Paper";
    theme.addCollageBorder = YES;
    theme.collageBorderColor = [UIColor whiteColor];
    theme.snapToGrid = YES;
    theme.objectLocatorType = (DEVICE_IS_IPAD ? kAWBCollageObjectLocatorTypeMosaicLargeImages : kAWBCollageObjectLocatorTypeMosaicMediumImages);
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 2;
    
    return [theme autorelease];        
}

+ (id)photoMosaicMicroImagesBlackTheme
{
    CollageTheme *theme = [[CollageTheme alloc] init];
    theme.themeType = kAWBCollageThemeTypePhotoMosaicMicroImagesBlack;
    theme.themeName = @"Photo Mosaic (Lots of Photos!)";
    theme.deviceAvailability = kAWBCollageThemeDeviceAvailabilityiPadOnly;
    theme.thumbnailFilename = @"mosaic9rowtheme100.jpg";
    theme.addImageShadows = NO;
    theme.addTextShadows = NO;
    theme.addImageBorders = YES;
    theme.addTextBorders = NO;
    theme.imageRoundedBorders = NO;
    theme.textRoundedBorders = NO;
    theme.addTextBackground = NO;
    theme.collageBackgroundColor = [UIColor blackColor];
    theme.imageShadowColor = [UIColor whiteColor];
    theme.textShadowColor = [UIColor whiteColor];
    theme.imageBorderColor = [UIColor blackColor];
    theme.textBorderColor = [UIColor whiteColor];
    theme.textBackgroundColor = [UIColor blackColor];
    theme.labelTextColor = [UIColor whiteColor];
    theme.labelTextFont = @"TrebuchetMS-Italic";
    theme.symbolColor = [UIColor whiteColor]; 
    theme.useBackgroundTexture = NO;
    theme.backgroundTexture = @"Blackboard";
    theme.addCollageBorder = YES;
    theme.collageBorderColor = [UIColor blackColor];
    theme.snapToGrid = YES;
    theme.objectLocatorType = kAWBCollageObjectLocatorTypeMosaicMicroImages;
    theme.autoMemoryReduction = YES;
    theme.randomPickCount = 1;
    
    return [theme autorelease];        
}

+ (NSArray *)allCollageThemes
{
    return [NSMutableArray arrayWithObjects:[CollageTheme plainTheme], [CollageTheme photoModernBlackTheme], [CollageTheme photoModernWhiteTheme], [CollageTheme noticeBoardTheme], [CollageTheme chalkboardTheme], [CollageTheme handwrittenTheme], [CollageTheme cardboardTheme], [CollageTheme holidayTheme], [CollageTheme blackboardTheme], [CollageTheme typewriterTheme], [CollageTheme photoMosaicLargeImagesBlackTheme], [CollageTheme photoMosaicLargeImagesWhiteTheme], [CollageTheme photoMosaicSmallImagesBlackTheme], [CollageTheme photoMosaicSmallImagesWhiteTheme], [CollageTheme photoMosaicMicroImagesBlackTheme], [CollageTheme blueContrastItalicTheme], [CollageTheme greenAndRedSignTheme], [CollageTheme blueAndGreenSignTheme], [CollageTheme yellowSignTheme], [CollageTheme redAndBlackSignTheme], [CollageTheme elegantTheme], nil];
}

+ (id)randomCollageTheme
{
    NSArray *allThemes = [CollageTheme allCollageThemes];
    NSMutableArray *randomThemeTypes = [[NSMutableArray alloc] initWithCapacity:[allThemes count]];
    
    for (CollageTheme *theme in allThemes) {
        if (theme.isAvailableOnCurrentDevice) {
            for (NSUInteger randomPickIndex = 0; randomPickIndex < theme.randomPickCount; randomPickIndex++) {
                [randomThemeTypes addObject:[NSNumber numberWithInteger:theme.themeType]];
            }
        }
    }
    
    NSUInteger randomIndex = AWBRandomIntInRange(0, [randomThemeTypes count]-1);
    CollageThemeType chosenThemeType = [[randomThemeTypes objectAtIndex:randomIndex] integerValue];
    [randomThemeTypes release];
    
    return [CollageTheme themeWithThemeType:chosenThemeType];
}

- (BOOL)isAvailableOnCurrentDevice
{
    switch (deviceAvailability) {
        case kAWBCollageThemeDeviceAvailabilityAllDevices:
            return YES;
        case kAWBCollageThemeDeviceAvailabilityiPadOnly:
            return DEVICE_IS_IPAD;
        case kAWBCollageThemeDeviceAvailabilityiPhoneOnly:
            return DEVICE_IS_IPHONE;
        default:
            return NO;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", themeName];
}

- (NSUInteger)hash
{
    return themeName.hash;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[CollageTheme class]]) {
        NSString *compareThemeName = [(CollageTheme *)object themeName];
        return [themeName isEqualToString:compareThemeName];
    } else {
        return NO;
    }
}

@end
