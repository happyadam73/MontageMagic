//
//  Collage.h
//  Collage Maker
//
//  Created by Adam Buckley on 31/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBCollageObjectLocator.h"

static NSString *const kAWBInfoKeyCollageViews = @"CollageViews";
static NSString *const kAWBInfoKeyCollageObjectLocator = @"CollageObjectLocator";

enum {
    kAWBExportFormatIndexPNG = 0,
    kAWBExportFormatIndexJPEG = 1
};

@interface Collage : NSObject {
    CGFloat exportSize;
    NSUInteger exportFormatSelectedIndex;
    BOOL pngExportTransparentBackground;
    CGFloat jpgExportQualityValue;
    BOOL addImageShadows;
    BOOL addTextShadows;
    BOOL addImageBorders;
    BOOL addTextBorders;
    BOOL imageRoundedBorders;
    BOOL textRoundedBorders;
    BOOL addTextBackground;
    NSMutableArray *collageViews;
    UIColor *collageBackgroundColor;
    UIColor *imageShadowColor;
    UIColor *textShadowColor;
    UIColor *imageBorderColor;
    UIColor *textBorderColor;
    UIColor *textBackgroundColor;
    NSString *labelTextLine1;
    NSString *labelTextLine2;
    NSString *labelTextLine3;
    UIColor *labelTextColor;
    NSString *labelTextFont;
    UIColor *symbolColor;    
    BOOL addCollageBorder;
    UIColor *collageBorderColor;
    BOOL useBackgroundTexture;
    NSString *backgroundTexture;
    NSUInteger totalLabelSubviews;
    NSUInteger totalImageSubviews;
    NSUInteger totalSymbolSubviews;
    NSUInteger totalImageMemoryBytes;
    NSString *selectedAssetsGroupName;
    NSInteger luckyDipSourceIndex;
    NSInteger luckyDipAmountIndex;
    NSInteger luckyDipContactTypeIndex;
    BOOL luckyDipContactIncludePhoneNumber;
    AWBCollageObjectLocator *collageObjectLocator;
    BOOL useMyFonts;
    NSString *labelMyFont;
    UITextAlignment labelTextAlignment;
}

@property (nonatomic, assign) CGFloat exportSize;
@property (nonatomic, assign) NSUInteger exportFormatSelectedIndex;
@property (nonatomic, assign) BOOL pngExportTransparentBackground;
@property (nonatomic, assign) CGFloat jpgExportQualityValue;
@property (nonatomic, assign) BOOL addImageShadows;
@property (nonatomic, assign) BOOL addImageBorders;
@property (nonatomic, assign) BOOL addTextShadows;
@property (nonatomic, assign) BOOL addTextBorders;
@property (nonatomic, assign) BOOL imageRoundedBorders;
@property (nonatomic, assign) BOOL textRoundedBorders;
@property (nonatomic, assign) BOOL addTextBackground;
@property (nonatomic, retain) NSMutableArray *collageViews;
@property (nonatomic, retain) UIColor *collageBackgroundColor;
@property (nonatomic, retain) UIColor *imageShadowColor;
@property (nonatomic, retain) UIColor *textShadowColor;
@property (nonatomic, retain) UIColor *imageBorderColor;
@property (nonatomic, retain) UIColor *textBorderColor;
@property (nonatomic, retain) UIColor *textBackgroundColor;
@property (nonatomic, retain) NSString *labelTextLine1;
@property (nonatomic, retain) NSString *labelTextLine2;
@property (nonatomic, retain) NSString *labelTextLine3;
@property (nonatomic, retain) UIColor *labelTextColor;
@property (nonatomic, retain) NSString *labelTextFont;
@property (nonatomic, retain)  UIColor *symbolColor;
@property (nonatomic, assign) BOOL addCollageBorder;
@property (nonatomic, retain) UIColor *collageBorderColor;
@property (nonatomic, assign) BOOL useBackgroundTexture;
@property (nonatomic, retain) NSString *backgroundTexture;
@property (nonatomic, readonly) NSUInteger totalLabelSubviews;
@property (nonatomic, readonly) NSUInteger totalSymbolSubviews;
@property (nonatomic, readonly) NSUInteger totalImageSubviews;
@property (nonatomic, readonly) NSUInteger totalImageMemoryBytes;
@property (nonatomic, retain) NSString *selectedAssetsGroupName;
@property (nonatomic, assign) NSInteger luckyDipSourceIndex;
@property (nonatomic, assign) NSInteger luckyDipAmountIndex;
@property (nonatomic, assign) NSInteger luckyDipContactTypeIndex;
@property (nonatomic, assign) BOOL luckyDipContactIncludePhoneNumber;
@property (nonatomic, retain) AWBCollageObjectLocator *collageObjectLocator;
@property (nonatomic, assign) BOOL useMyFonts;
@property (nonatomic, retain) NSString *labelMyFont;
@property (nonatomic, assign) UITextAlignment labelTextAlignment;

- (void)applyCollageBackgroundToView:(UIView *)backgroundView;
- (void)addCollageObjectsToView:(UIView *)collageView;
- (void)initCollageFromView:(UIView *)collageView;

@end
