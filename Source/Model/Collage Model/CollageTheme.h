//
//  CollageTheme.h
//  Collage Maker
//
//  Created by Adam Buckley on 15/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBCollageObjectLocator.h"

typedef enum {
    kAWBCollageThemeTypePlain,
    kAWBCollageThemeTypeBlueAndGreenSign,              
    kAWBCollageThemeTypeBlueContrastItalic,
    kAWBCollageThemeTypeChalkboard,
    kAWBCollageThemeTypeElegant,
    kAWBCollageThemeTypeGreenAndRedSign,
    kAWBCollageThemeTypeHoliday,
    kAWBCollageThemeTypeHolidayPhone,
    kAWBCollageThemeTypeCardboard,    
    kAWBCollageThemeTypePhotoModernBlack,
    kAWBCollageThemeTypePhotoModernWhite,
    kAWBCollageThemeTypeYellowSign,
    kAWBCollageThemeTypeRedAndBlackSign,
    kAWBCollageThemeTypeHandwritten,
    kAWBCollageThemeTypeBlackboard,
    kAWBCollageThemeTypeTypewriter,
    kAWBCollageThemeTypeNoticeBoard,
    kAWBCollageThemeTypePhotoMosaicSmallImagesBlack,
    kAWBCollageThemeTypePhotoMosaicSmallImagesWhite,
    kAWBCollageThemeTypePhotoMosaicLargeImagesBlack,
    kAWBCollageThemeTypePhotoMosaicLargeImagesWhite,
    kAWBCollageThemeTypePhotoMosaicMicroImagesBlack,
    kAWBCollageThemeTypeSpringtime,
    kAWBCollageThemeTypeSummertime,
    kAWBCollageThemeTypeTechnical
} CollageThemeType;

typedef enum {
    kAWBCollageThemeDeviceAvailabilityAllDevices,
    kAWBCollageThemeDeviceAvailabilityiPhoneOnly,              
    kAWBCollageThemeDeviceAvailabilityiPadOnly
} CollageThemeDeviceAvailability;

@interface CollageTheme : NSObject {
    NSString *themeName;
    CollageThemeType themeType;
    NSString *thumbnailFilename;
    BOOL addImageShadows;
    BOOL addTextShadows;
    BOOL addImageBorders;
    BOOL addTextBorders;
    BOOL imageRoundedBorders;
    AWBImageRoundedCornerSize imageRoundedCornerSize;
    AWBShadowOffsetSize imageShadowOffsetSize;
    AWBShadowOffsetSize textShadowOffsetSize;
    BOOL textRoundedBorders;
    BOOL addTextBackground;
    UIColor *collageBackgroundColor;
    UIColor *imageShadowColor;
    UIColor *textShadowColor;
    UIColor *imageBorderColor;
    UIColor *textBorderColor;
    UIColor *textBackgroundColor;
    UIColor *labelTextColor;
    UIColor *symbolColor;
    NSString *labelTextFont;
    CollageThemeDeviceAvailability deviceAvailability;
    BOOL isAvailableOnCurrentDevice;
    BOOL addCollageBorder;
    UIColor *collageBorderColor;
    BOOL useBackgroundTexture;
    NSString *backgroundTexture;
    BOOL snapToGrid;
    BOOL snapRotation;
    AWBCollageObjectLocatorType objectLocatorType;
    BOOL autoMemoryReduction;
    NSUInteger randomPickCount;
    BOOL useMyFonts;
    NSString *labelMyFont;
    UITextAlignment labelTextAlignment;
}

@property (nonatomic, retain) NSString *themeName;
@property (nonatomic, assign) CollageThemeType themeType;
@property (nonatomic, retain) NSString *thumbnailFilename;
@property (nonatomic, assign) BOOL addImageShadows;
@property (nonatomic, assign) BOOL addImageBorders;
@property (nonatomic, assign) BOOL addTextShadows;
@property (nonatomic, assign) BOOL addTextBorders;
@property (nonatomic, assign) BOOL imageRoundedBorders;
@property (nonatomic, assign) AWBImageRoundedCornerSize imageRoundedCornerSize;
@property (nonatomic, assign) AWBShadowOffsetSize imageShadowOffsetSize;
@property (nonatomic, assign) AWBShadowOffsetSize textShadowOffsetSize;
@property (nonatomic, assign) BOOL textRoundedBorders;
@property (nonatomic, assign) BOOL addTextBackground;
@property (nonatomic, retain) UIColor *collageBackgroundColor;
@property (nonatomic, retain) UIColor *imageShadowColor;
@property (nonatomic, retain) UIColor *textShadowColor;
@property (nonatomic, retain) UIColor *imageBorderColor;
@property (nonatomic, retain) UIColor *textBorderColor;
@property (nonatomic, retain) UIColor *textBackgroundColor;
@property (nonatomic, retain) UIColor *labelTextColor;
@property (nonatomic, retain) UIColor *symbolColor;
@property (nonatomic, retain) NSString *labelTextFont;
@property (nonatomic, assign) CollageThemeDeviceAvailability deviceAvailability;
@property (nonatomic, readonly) BOOL isAvailableOnCurrentDevice;
@property (nonatomic, assign) BOOL addCollageBorder;
@property (nonatomic, retain) UIColor *collageBorderColor;
@property (nonatomic, assign) BOOL useBackgroundTexture;
@property (nonatomic, retain) NSString *backgroundTexture;
@property (nonatomic, assign) BOOL snapToGrid;
@property (nonatomic, assign) BOOL snapRotation;
@property (nonatomic, assign) AWBCollageObjectLocatorType objectLocatorType;
@property (nonatomic, assign) BOOL autoMemoryReduction;
@property (nonatomic, assign) NSUInteger randomPickCount;
@property (nonatomic, assign) BOOL useMyFonts;
@property (nonatomic, retain) NSString *labelMyFont;
@property (nonatomic, assign) UITextAlignment labelTextAlignment;

+ (id)themeWithThemeType:(CollageThemeType)themeType;
+ (id)plainTheme;
+ (id)blueAndGreenSignTheme;
+ (id)blueContrastItalicTheme;
+ (id)chalkboardTheme;
+ (id)elegantTheme;
+ (id)greenAndRedSignTheme;
+ (id)yellowSignTheme;
+ (id)holidayTheme;
+ (id)holidayThemePhone;
+ (id)cardboardTheme;
+ (id)photoModernBlackTheme;
+ (id)photoModernWhiteTheme;
+ (id)redAndBlackSignTheme;
+ (id)handwrittenTheme;
+ (id)blackboardTheme;
+ (id)typewriterTheme;
+ (id)noticeBoardTheme;
+ (id)photoMosaicSmallImagesBlackTheme;
+ (id)photoMosaicSmallImagesWhiteTheme;
+ (id)photoMosaicLargeImagesBlackTheme;
+ (id)photoMosaicLargeImagesWhiteTheme;
+ (id)photoMosaicMicroImagesBlackTheme;
+ (id)springTimeTheme;
+ (id)summerTimeTheme;
+ (id)technicalTheme;
+ (id)randomCollageTheme;

+ (NSArray *)allCollageThemes;

@end
