//
//  AWBCollageObjectLocator.h
//  Collage Maker
//
//  Created by Adam Buckley on 18/10/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AWBTransformableView.h"

static NSString *const kAWBInfoKeyObjectLocatorType = @"LocatorType";
static NSString *const kAWBInfoKeyObjectLocatorSnapToGrid = @"SnapToGrid";
static NSString *const kAWBInfoKeyObjectLocatorSnapToGridSize = @"SnapToGridSize";
static NSString *const kAWBInfoKeyObjectLocatorObjectCount = @"ObjectCount";
static NSString *const kAWBInfoKeyObjectLocatorLockCollage = @"LockCollage";
static NSString *const kAWBInfoKeyObjectLocatorObjectRotation = @"ObjectRotation";
static NSString *const kAWBInfoKeyObjectLocatorObjectScale = @"ObjectScale";
static NSString *const kAWBInfoKeyObjectLocatorObjectWidth = @"ObjectWidth";
static NSString *const kAWBInfoKeyObjectLocatorObjectHeight = @"ObjectHeight";
static NSString *const kAWBInfoKeyObjectLocatorCurrentMosaicRow = @"CurrentMosaicRow";
static NSString *const kAWBInfoKeyObjectLocatorCurrentMosaicOffsetX = @"CurrentMosaicOffsetX";
static NSString *const kAWBInfoKeyObjectLocatorCurrentMosaicOffsetY = @"CurrentMosaicOffsetY";
static NSString *const kAWBInfoKeyObjectLocatorCollageFull = @"CollageFull";
static NSString *const kAWBInfoKeyObjectLocatorAutoMemoryReduction = @"AutoMemoryReduction";

typedef enum {
    kAWBCollageObjectLocatorTypeScatter,
    kAWBCollageObjectLocatorTypeMosaicLargeImages,   
    kAWBCollageObjectLocatorTypeMosaicMediumImages,
    kAWBCollageObjectLocatorTypeMosaicSmallImages,
    kAWBCollageObjectLocatorTypeMosaicTinyImages,
    kAWBCollageObjectLocatorTypeMosaicMicroImages,    
    kAWBCollageObjectLocatorTypeMosaicNanoImages,
    kAWBCollageObjectLocatorTypeGrid2x3,
    kAWBCollageObjectLocatorTypeGrid4x6,
    kAWBCollageObjectLocatorTypeGrid2x3iPad    
} AWBCollageObjectLocatorType;

@interface AWBCollageObjectLocator : NSObject
{
    AWBCollageObjectLocatorType objectLocatorType;
    BOOL lockCollage;
    BOOL snapToGrid;
    CGFloat snapToGridSize;
    NSUInteger objectCount;
    CGPoint objectPosition;
    CGFloat objectRotation;
    CGFloat objectScale;
    NSUInteger scatterGridNumColumns;
    NSUInteger scatterGridNumRows;
    CGFloat objectWidth;
    CGFloat objectHeight;
    NSUInteger currentMosaicRow;
    CGPoint currentMosaicOffset;
    BOOL collageFull;
    NSArray *mosaicRowHeights;
    CGFloat screenLength;
    CGFloat screenHeight;
    BOOL autoMemoryReduction;
}

@property (nonatomic, assign) AWBCollageObjectLocatorType objectLocatorType;
@property (nonatomic, assign) BOOL lockCollage;
@property (nonatomic, assign) BOOL snapToGrid;
@property (nonatomic, assign) CGFloat snapToGridSize;
@property (nonatomic, readonly) CGPoint objectPosition;
@property (nonatomic, readonly) CGFloat objectRotation;
@property (nonatomic, readonly) CGFloat objectScale;
@property (nonatomic, readonly) CGFloat objectWidth;
@property (nonatomic, readonly) CGFloat objectHeight;
@property (nonatomic, readonly) BOOL collageFull;
@property (nonatomic, retain) NSArray *mosaicRowHeights;
@property (nonatomic, readonly) CGFloat currentMosaicRowHeight;
@property (nonatomic, assign) BOOL autoMemoryReduction;

- (void)initialise;
- (id)initWithLocationType:(AWBCollageObjectLocatorType)locatorType;  
- (void)initialiseMosaicRowHeights;
- (void)pushPhotoObject:(UIImage *)image isContactPhoto:(BOOL)isContactPhoto;
- (void)pushPhotoObjectForScatterLayout:(UIImage *)image isContactPhoto:(BOOL)isContactPhoto;
- (void)pushPhotoObjectForMosaicLayout:(UIImage *)image isContactPhoto:(BOOL)isContactPhoto;
- (void)pushContactLabelBelowCurrentObject:(BOOL)belowCurrentObject includesPhoneNumber:(BOOL)includesPhoneNumber;
- (void)pushContactLabelForGridLayoutBelowCurrentObject:(BOOL)belowCurrentObject includesPhoneNumber:(BOOL)includesPhoneNumber;
- (void)pushContactLabelForScatterLayoutBelowCurrentObject:(BOOL)belowCurrentObject includesPhoneNumber:(BOOL)includesPhoneNumber;
- (void)pushContactLabelForMosaicLayoutBelowCurrentObject:(BOOL)belowCurrentObject includesPhoneNumber:(BOOL)includesPhoneNumber;
- (void)pushSymbol;
- (void)pushSymbolIntoCenter;
- (void)pushSymbolForScatterLayout;
- (void)pushSymbolForMosaicLayout;
- (void)pushTextLabel;
- (void)pushTextLabelIntoCenter;
- (void)pushTextLabelForScatterLayout;
- (void)pushTextLabelForMosaicLayout;
- (void)resetLocator;
- (CGPoint)randomPointInAreaWithIndex:(NSUInteger)areaIndex totalAreasWide:(NSUInteger)areasWide totalAreasHigh:(NSUInteger)areasHigh screenMarginPercentage:(CGFloat)screenMarginPerc areaMarginPercentage:(CGFloat)areaMarginPerc adjustMidPointsOnIndexOverflow:(BOOL)adjustMidPoints;
- (CGPoint)gridPointInAreaWithIndex:(NSUInteger)areaIndex totalAreasWide:(NSUInteger)areasWide totalAreasHigh:(NSUInteger)areasHigh screenMarginPercentage:(CGFloat)screenMarginPerc areaMarginPercentage:(CGFloat)areaMarginPerc;
- (BOOL)collageIsFullForContactLabelBelowCurrentObject:(BOOL)belowCurrentObject;
- (BOOL)collageIsFullForContactImageOfSize:(CGSize)imageSize;
- (CGPoint)randomCenterPoint;

@end



