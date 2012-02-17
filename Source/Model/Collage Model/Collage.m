//
//  Collage.m
//  Collage Maker
//
//  Created by Adam Buckley on 31/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "Collage.h"
#import "AWBSettings.h"
#import "AWBTransformableLabel.h"
#import "AWBTransformableImageView.h"
#import "CollageMakerViewController.h"
#import "AWBTransformableArrowView.h"
#import "UIColor+Texture.h"

@implementation Collage

@synthesize exportSize, addImageShadows, addTextShadows, addImageBorders, addTextBorders, imageRoundedBorders, textRoundedBorders, addTextBackground; 
@synthesize collageViews, collageBackgroundColor, imageShadowColor, textShadowColor, imageBorderColor, textBorderColor, textBackgroundColor;
@synthesize labelTextFont, labelTextColor, labelTextLine1, labelTextLine2, labelTextLine3, symbolColor;
@synthesize totalImageSubviews, totalSymbolSubviews, totalLabelSubviews, totalImageMemoryBytes;
@synthesize luckyDipAmountIndex, luckyDipSourceIndex, luckyDipContactTypeIndex, luckyDipContactIncludePhoneNumber, selectedAssetsGroupName;
@synthesize addCollageBorder, collageBorderColor, useBackgroundTexture, backgroundTexture;
@synthesize collageObjectLocator;
@synthesize labelMyFont, labelTextAlignment, useMyFonts;
@synthesize exportFormatSelectedIndex, pngExportTransparentBackground, jpgExportQualityValue;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.collageViews = [aDecoder decodeObjectForKey:kAWBInfoKeyCollageViews];
    self.exportSize = [aDecoder decodeFloatForKey:kAWBInfoKeyExportSizeValue];
    self.addImageShadows = [aDecoder decodeBoolForKey:kAWBInfoKeyImageShadows];
    self.addTextShadows = [aDecoder decodeBoolForKey:kAWBInfoKeyTextShadows];
    self.addImageBorders = [aDecoder decodeBoolForKey:kAWBInfoKeyImageBorders];
    self.addTextBorders = [aDecoder decodeBoolForKey:kAWBInfoKeyTextBorders];
    self.imageRoundedBorders = [aDecoder decodeBoolForKey:kAWBInfoKeyImageRoundedBorders];
    self.textRoundedBorders = [aDecoder decodeBoolForKey:kAWBInfoKeyTextRoundedBorders];
    self.addTextBackground = [aDecoder decodeBoolForKey:kAWBInfoKeyTextBackground];
    self.imageShadowColor = [aDecoder decodeObjectForKey:kAWBInfoKeyImageShadowColor];
    self.textShadowColor = [aDecoder decodeObjectForKey:kAWBInfoKeyTextShadowColor];
    self.imageBorderColor = [aDecoder decodeObjectForKey:kAWBInfoKeyImageBorderColor];
    self.textBorderColor = [aDecoder decodeObjectForKey:kAWBInfoKeyTextBorderColor];
    self.textBackgroundColor = [aDecoder decodeObjectForKey:kAWBInfoKeyTextBackgroundColor];
    self.labelTextColor = [aDecoder decodeObjectForKey:kAWBInfoKeyTextColor];
    self.labelTextFont = [aDecoder decodeObjectForKey:kAWBInfoKeyTextFontName];
    self.labelTextLine1 = [aDecoder decodeObjectForKey:kAWBInfoKeyLabelTextLine1];
    self.labelTextLine2 = [aDecoder decodeObjectForKey:kAWBInfoKeyLabelTextLine2];
    self.labelTextLine3 = [aDecoder decodeObjectForKey:kAWBInfoKeyLabelTextLine3];
    self.symbolColor = [aDecoder decodeObjectForKey:kAWBInfoKeySymbolColor];
    self.addCollageBorder = [aDecoder decodeBoolForKey:kAWBInfoKeyCollageBorder];
    self.collageBorderColor = [aDecoder decodeObjectForKey:kAWBInfoKeyCollageBorderColor];
    self.useBackgroundTexture = [aDecoder decodeBoolForKey:kAWBInfoKeyCollageUseBackgroundTexture];
    self.backgroundTexture = [aDecoder decodeObjectForKey:kAWBInfoKeyCollageBackgroundTexture];
    self.collageBackgroundColor = [aDecoder decodeObjectForKey:kAWBInfoKeyCollageBackgroundColor];
    self.luckyDipContactIncludePhoneNumber = [aDecoder decodeBoolForKey:kAWBInfoKeyLuckyDipContactIncludePhoneNumber];
    self.luckyDipContactTypeIndex = [aDecoder decodeIntegerForKey:kAWBInfoKeyLuckyDipContactTypeSelectedIndex];
    self.luckyDipAmountIndex = [aDecoder decodeIntegerForKey:kAWBInfoKeyLuckyDipAmountSelectedIndex];
    self.luckyDipSourceIndex = [aDecoder decodeIntegerForKey:kAWBInfoKeyLuckyDipSourceSelectedIndex];
    self.selectedAssetsGroupName = [aDecoder decodeObjectForKey:kAWBInfoKeySelectedAssetGroupName];
    self.collageObjectLocator = [aDecoder decodeObjectForKey:kAWBInfoKeyCollageObjectLocator];
    if ([aDecoder containsValueForKey:kAWBInfoKeyMyFontName]) {
        self.labelMyFont = [aDecoder decodeObjectForKey:kAWBInfoKeyMyFontName];
    } else {
        self.labelMyFont = nil;
    }
    if ([aDecoder containsValueForKey:kAWBInfoKeyUseMyFonts]) {
        self.useMyFonts = [aDecoder decodeBoolForKey:kAWBInfoKeyUseMyFonts];
    } else {
        self.useMyFonts = NO;
    }
    if ([aDecoder containsValueForKey:kAWBInfoKeyTextAlignment]) {
        self.labelTextAlignment = [aDecoder decodeIntegerForKey:kAWBInfoKeyTextAlignment];
    } else {
        self.labelTextAlignment = UITextAlignmentCenter;
    }
    if ([aDecoder containsValueForKey:kAWBInfoKeyExportFormatSelectedIndex]) {
        self.exportFormatSelectedIndex = [aDecoder decodeIntegerForKey:kAWBInfoKeyExportFormatSelectedIndex];        
    } else {
        self.exportFormatSelectedIndex = kAWBExportFormatIndexJPEG;
    }
    if ([aDecoder containsValueForKey:kAWBInfoKeyPNGExportTransparentBackground]) {
        self.pngExportTransparentBackground = [aDecoder decodeBoolForKey:kAWBInfoKeyPNGExportTransparentBackground];
    } else {
        self.pngExportTransparentBackground = NO;
    }
    if ([aDecoder containsValueForKey:kAWBInfoKeyJPGExportQualityValue]) {
        self.jpgExportQualityValue = [aDecoder decodeFloatForKey:kAWBInfoKeyJPGExportQualityValue];
    } else {
        self.jpgExportQualityValue = 0.7;
    } 

    return  self;   
}

- (void)applyCollageBackgroundToView:(UIView *)backgroundView
{
    if (backgroundView) {
        if (self.useBackgroundTexture && self.backgroundTexture) {
            [backgroundView setBackgroundColor:[UIColor textureColorWithDescription:self.backgroundTexture]];
        } else {
            if (self.collageBackgroundColor) {
                [backgroundView setBackgroundColor:self.collageBackgroundColor];
            }            
        }        
    }    
}

- (void)addCollageObjectsToView:(UIView *)collageView
{
    if (collageView) {
        
//        if (self.useBackgroundTexture && self.backgroundTexture) {
//            [collageView setBackgroundColor:[UIColor textureColorWithDescription:self.backgroundTexture]];
//        } else {
//            if (self.collageBackgroundColor) {
//                [collageView setBackgroundColor:self.collageBackgroundColor];
//            }            
//        }
        
        if (self.addCollageBorder && self.collageBorderColor) {
            collageView.layer.borderColor = [self.collageBorderColor CGColor];
            CGFloat borderThickness = 4.0;
            if (DEVICE_IS_IPAD) {
                borderThickness = 6.0;
            }
            collageView.layer.borderWidth = borderThickness;
        } else {
            collageView.layer.borderColor = [[UIColor blackColor] CGColor];
            collageView.layer.borderWidth = 0.0;            
        }
        
        totalImageSubviews = 0;
        totalLabelSubviews = 0;
        totalSymbolSubviews = 0;
        
        if (self.collageViews) {
            for(UIView <AWBTransformableView> *view in self.collageViews) {
                [collageView addSubview:view];
                if ([view isKindOfClass:[AWBTransformableLabel class]]) {
                    totalLabelSubviews += 1;
                }
                if ([view isKindOfClass:[AWBTransformableImageView class]]) {
                    totalImageSubviews += 1;
                }     
                if ([view isKindOfClass:[AWBTransformableArrowView class]]) {
                    totalSymbolSubviews += 1;
                }
            }  
            self.collageViews = nil;
        }
    }
}

- (void)initCollageFromView:(UIView *)collageView
{
    if (collageView) {   
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.collageViews = tempArray;
        [tempArray release];
        totalImageSubviews = 0;
        totalLabelSubviews = 0;
        totalSymbolSubviews = 0;
        totalImageMemoryBytes = 0;

        for(UIView <AWBTransformableView> *view in [collageView subviews]) {
            //iterator will still go through every view including non transformable, so ensure conformance to the transformable protocol
            if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
                if (view) {
                    [self.collageViews addObject:view];
                }
                if ([view isKindOfClass:[AWBTransformableArrowView class]]) {
                    totalSymbolSubviews += 1;
                }
                if ([view isKindOfClass:[AWBTransformableLabel class]]) {
                    totalLabelSubviews += 1;
                }
                if ([view isKindOfClass:[AWBTransformableImageView class]]) {
                    totalImageSubviews += 1;
                    AWBTransformableImageView *transformableImageView = (AWBTransformableImageView *)view;
                    totalImageMemoryBytes += (transformableImageView.imageView.image.size.width * transformableImageView.imageView.image.size.height * 4);
                }                
            }            
        }    
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{   
    [aCoder encodeObject:self.collageViews forKey:kAWBInfoKeyCollageViews];
    [aCoder encodeObject:self.collageBackgroundColor forKey:kAWBInfoKeyCollageBackgroundColor];
    [aCoder encodeObject:self.imageShadowColor forKey:kAWBInfoKeyImageShadowColor];
    [aCoder encodeObject:self.textShadowColor forKey:kAWBInfoKeyTextShadowColor];
    [aCoder encodeObject:self.imageBorderColor forKey:kAWBInfoKeyImageBorderColor];
    [aCoder encodeObject:self.textBorderColor forKey:kAWBInfoKeyTextBorderColor];
    [aCoder encodeObject:self.textBackgroundColor forKey:kAWBInfoKeyTextBackgroundColor];
    [aCoder encodeFloat:self.exportSize forKey:kAWBInfoKeyExportSizeValue];
    [aCoder encodeInteger:self.exportFormatSelectedIndex forKey:kAWBInfoKeyExportFormatSelectedIndex]; 
    [aCoder encodeBool:self.pngExportTransparentBackground forKey:kAWBInfoKeyPNGExportTransparentBackground]; 
    [aCoder encodeFloat:self.jpgExportQualityValue forKey:kAWBInfoKeyJPGExportQualityValue]; 
    [aCoder encodeBool:self.addImageShadows forKey:kAWBInfoKeyImageShadows];
    [aCoder encodeBool:self.addTextShadows forKey:kAWBInfoKeyTextShadows];    
    [aCoder encodeBool:self.addImageBorders forKey:kAWBInfoKeyImageBorders];
    [aCoder encodeBool:self.addTextBorders forKey:kAWBInfoKeyTextBorders];
    [aCoder encodeBool:self.imageRoundedBorders forKey:kAWBInfoKeyImageRoundedBorders];
    [aCoder encodeBool:self.textRoundedBorders forKey:kAWBInfoKeyTextRoundedBorders];
    [aCoder encodeBool:self.addTextBackground forKey:kAWBInfoKeyTextBackground];
    [aCoder encodeObject:self.labelTextColor forKey:kAWBInfoKeyTextColor];
    [aCoder encodeObject:self.labelTextFont forKey:kAWBInfoKeyTextFontName];
    [aCoder encodeObject:self.labelTextLine1 forKey:kAWBInfoKeyLabelTextLine1];
    [aCoder encodeObject:self.labelTextLine2 forKey:kAWBInfoKeyLabelTextLine2];
    [aCoder encodeObject:self.labelTextLine3 forKey:kAWBInfoKeyLabelTextLine3];
    [aCoder encodeObject:self.symbolColor forKey:kAWBInfoKeySymbolColor];
    [aCoder encodeBool:self.addCollageBorder forKey:kAWBInfoKeyCollageBorder];
    [aCoder encodeObject:self.collageBorderColor forKey:kAWBInfoKeyCollageBorderColor];
    [aCoder encodeBool:self.useBackgroundTexture forKey:kAWBInfoKeyCollageUseBackgroundTexture];
    [aCoder encodeObject:self.backgroundTexture forKey:kAWBInfoKeyCollageBackgroundTexture];
    [aCoder encodeBool:self.luckyDipContactIncludePhoneNumber forKey:kAWBInfoKeyLuckyDipContactIncludePhoneNumber];
    [aCoder encodeInteger:self.luckyDipContactTypeIndex forKey:kAWBInfoKeyLuckyDipContactTypeSelectedIndex];
    [aCoder encodeInteger:self.luckyDipAmountIndex forKey:kAWBInfoKeyLuckyDipAmountSelectedIndex];
    [aCoder encodeInteger:self.luckyDipSourceIndex forKey:kAWBInfoKeyLuckyDipSourceSelectedIndex];
    [aCoder encodeObject:self.selectedAssetsGroupName forKey:kAWBInfoKeySelectedAssetGroupName];
    [aCoder encodeObject:self.collageObjectLocator forKey:kAWBInfoKeyCollageObjectLocator];
    [aCoder encodeObject:self.labelMyFont forKey:kAWBInfoKeyMyFontName];
    [aCoder encodeBool:self.useMyFonts forKey:kAWBInfoKeyUseMyFonts];
    [aCoder encodeInteger:self.labelTextAlignment forKey:kAWBInfoKeyTextAlignment]; 
}

- (void)dealloc
{
    [collageViews release];
    [collageBackgroundColor release];
    [imageShadowColor release];
    [textShadowColor release];
    [imageBorderColor release];
    [textBorderColor release];
    [textBackgroundColor release];
    [labelTextFont release];
    [labelTextColor release];
    [labelTextLine1 release];
    [labelTextLine2 release];
    [labelTextLine3 release];
    [symbolColor release];
    [collageBorderColor release];
    [backgroundTexture release];
    [selectedAssetsGroupName release];
    [collageObjectLocator release];
    [labelMyFont release];

    [super dealloc];
}

@end
