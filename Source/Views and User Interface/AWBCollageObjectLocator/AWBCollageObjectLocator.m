//
//  AWBCollageObjectLocator.m
//  Collage Maker
//
//  Created by Adam Buckley on 18/10/2011.
//  Copyright (c) 2011 Callcredit. All rights reserved.
//

#import "AWBCollageObjectLocator.h"

#define QUANTISED_ROTATION (M_PI_4/2.0)

@implementation AWBCollageObjectLocator

@synthesize objectLocatorType, lockCollage, snapToGrid, snapToGridSize, objectPosition, objectScale, objectRotation, objectWidth, objectHeight, collageFull, mosaicRowHeights, autoMemoryReduction;

- (void)initialise
{
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;    
    screenLength = MAX(screenSize.height, screenSize.width);
    screenHeight = MIN(screenSize.height, screenSize.width);
    objectPosition = CGPointZero;
    objectRotation = 0.0;
    objectScale = 1.0;
    snapToGrid = NO;
    lockCollage = NO;  
    autoMemoryReduction = YES;

    if (DEVICE_IS_IPAD) {
        scatterGridNumColumns = 6;
        scatterGridNumRows = 4;
        snapToGridSize = 24.0;
    } else {
        scatterGridNumColumns = 5;
        scatterGridNumRows = 3;
        snapToGridSize = 16.0;            
    }   
}

- (void)dealloc
{
    [mosaicRowHeights release];
    [super dealloc];
}

- (id)initWithLocationType:(AWBCollageObjectLocatorType)locatorType  
{
    self = [super init];
    if (self) {
        [self initialise];
        objectCount = 0;
        currentMosaicRow = 0;
        currentMosaicOffset = CGPointZero;
        collageFull = NO;
        self.objectLocatorType = locatorType;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        [self initialise];
        objectCount = [decoder decodeIntegerForKey:kAWBInfoKeyObjectLocatorObjectCount];
        self.objectLocatorType = [decoder decodeIntegerForKey:kAWBInfoKeyObjectLocatorType];
        snapToGrid = [decoder decodeBoolForKey:kAWBInfoKeyObjectLocatorSnapToGrid];
        snapToGridSize = [decoder decodeFloatForKey:kAWBInfoKeyObjectLocatorSnapToGridSize];
        lockCollage = [decoder decodeBoolForKey:kAWBInfoKeyObjectLocatorLockCollage];
        objectScale = [decoder decodeFloatForKey:kAWBInfoKeyObjectLocatorObjectScale];
        objectWidth = [decoder decodeFloatForKey:kAWBInfoKeyObjectLocatorObjectWidth];
        objectHeight = [decoder decodeFloatForKey:kAWBInfoKeyObjectLocatorObjectHeight];
        currentMosaicRow = [decoder decodeIntegerForKey:kAWBInfoKeyObjectLocatorCurrentMosaicRow];
        currentMosaicOffset.x = [decoder decodeFloatForKey:kAWBInfoKeyObjectLocatorCurrentMosaicOffsetX];
        currentMosaicOffset.y = [decoder decodeFloatForKey:kAWBInfoKeyObjectLocatorCurrentMosaicOffsetY];
        collageFull = [decoder decodeBoolForKey:kAWBInfoKeyObjectLocatorCollageFull];
        autoMemoryReduction = [decoder decodeBoolForKey:kAWBInfoKeyObjectLocatorAutoMemoryReduction];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:objectCount forKey:kAWBInfoKeyObjectLocatorObjectCount];
    [encoder encodeInteger:objectLocatorType forKey:kAWBInfoKeyObjectLocatorType];
    [encoder encodeBool:snapToGrid forKey:kAWBInfoKeyObjectLocatorSnapToGrid];
    [encoder encodeFloat:snapToGridSize forKey:kAWBInfoKeyObjectLocatorSnapToGridSize];
    [encoder encodeBool:lockCollage forKey:kAWBInfoKeyObjectLocatorLockCollage];
    [encoder encodeFloat:objectScale forKey:kAWBInfoKeyObjectLocatorObjectScale];
    [encoder encodeFloat:objectWidth forKey:kAWBInfoKeyObjectLocatorObjectWidth];
    [encoder encodeFloat:objectHeight forKey:kAWBInfoKeyObjectLocatorObjectHeight];
    [encoder encodeInteger:currentMosaicRow forKey:kAWBInfoKeyObjectLocatorCurrentMosaicRow];
    [encoder encodeFloat:currentMosaicOffset.x forKey:kAWBInfoKeyObjectLocatorCurrentMosaicOffsetX];
    [encoder encodeFloat:currentMosaicOffset.y forKey:kAWBInfoKeyObjectLocatorCurrentMosaicOffsetY];
    [encoder encodeBool:collageFull forKey:kAWBInfoKeyObjectLocatorCollageFull];
    [encoder encodeBool:autoMemoryReduction forKey:kAWBInfoKeyObjectLocatorAutoMemoryReduction];
}

- (void)initialiseMosaicRowHeights
{
    NSArray *rowHeights = nil;
    
    if (DEVICE_IS_IPAD) {
        switch (objectLocatorType) {
            case kAWBCollageObjectLocatorTypeMosaicLargeImages:
                rowHeights = [NSArray arrayWithObjects:[NSNumber numberWithFloat:144.0], [NSNumber numberWithFloat:192.0], [NSNumber numberWithFloat:240.0], [NSNumber numberWithFloat:192.0], nil];
                break;
            case kAWBCollageObjectLocatorTypeMosaicMediumImages:
                rowHeights = [NSArray arrayWithObjects:[NSNumber numberWithFloat:144.0], [NSNumber numberWithFloat:168.0], [NSNumber numberWithFloat:144.0], [NSNumber numberWithFloat:168.0], [NSNumber numberWithFloat:144.0], nil];
                break;
            case kAWBCollageObjectLocatorTypeMosaicSmallImages:
                rowHeights = [NSArray arrayWithObjects:[NSNumber numberWithFloat:120.0], [NSNumber numberWithFloat:144.0], [NSNumber numberWithFloat:120.0], [NSNumber numberWithFloat:144.0], [NSNumber numberWithFloat:120.0], [NSNumber numberWithFloat:120.0], nil];
                break;
            case kAWBCollageObjectLocatorTypeMosaicTinyImages:
                rowHeights = [NSArray arrayWithObjects:[NSNumber numberWithFloat:96.0], [NSNumber numberWithFloat:120.0], [NSNumber numberWithFloat:120.0], [NSNumber numberWithFloat:96.0], [NSNumber numberWithFloat:120.0], [NSNumber numberWithFloat:120.0], [NSNumber numberWithFloat:96.0], nil];
                break;
            case kAWBCollageObjectLocatorTypeMosaicMicroImages:
                rowHeights = [NSArray arrayWithObjects:[NSNumber numberWithFloat:72.0], [NSNumber numberWithFloat:96.0], [NSNumber numberWithFloat:72.0], [NSNumber numberWithFloat:96.0], [NSNumber numberWithFloat:96.0], [NSNumber numberWithFloat:96.0], [NSNumber numberWithFloat:72.0], [NSNumber numberWithFloat:96.0], [NSNumber numberWithFloat:72.0], nil];
                break;
            case kAWBCollageObjectLocatorTypeMosaicNanoImages:
                rowHeights = [NSArray arrayWithObjects:[NSNumber numberWithFloat:48.0], [NSNumber numberWithFloat:72.0], [NSNumber numberWithFloat:48.0], [NSNumber numberWithFloat:72.0], [NSNumber numberWithFloat:48.0], [NSNumber numberWithFloat:72.0], [NSNumber numberWithFloat:48.0], [NSNumber numberWithFloat:72.0], [NSNumber numberWithFloat:48.0], [NSNumber numberWithFloat:72.0], [NSNumber numberWithFloat:48.0], [NSNumber numberWithFloat:72.0], [NSNumber numberWithFloat:48.0], nil];
                break;
            default:
                rowHeights = [NSArray arrayWithObjects:[NSNumber numberWithFloat:144.0], [NSNumber numberWithFloat:192.0], [NSNumber numberWithFloat:240.0], [NSNumber numberWithFloat:192.0], nil];
                break;
        }
    } else {
        switch (objectLocatorType) {
            case kAWBCollageObjectLocatorTypeMosaicLargeImages:
                rowHeights = [NSArray arrayWithObjects:[NSNumber numberWithFloat:96.0], [NSNumber numberWithFloat:128.0], [NSNumber numberWithFloat:96.0], nil];
                break;
            case kAWBCollageObjectLocatorTypeMosaicMediumImages:
                rowHeights = [NSArray arrayWithObjects:[NSNumber numberWithFloat:64.0], [NSNumber numberWithFloat:96.0], [NSNumber numberWithFloat:96.0], [NSNumber numberWithFloat:64.0], nil];
                break;
            case kAWBCollageObjectLocatorTypeMosaicSmallImages:
                rowHeights = [NSArray arrayWithObjects:[NSNumber numberWithFloat:48.0], [NSNumber numberWithFloat:64.0], [NSNumber numberWithFloat:80.0], [NSNumber numberWithFloat:64.0], [NSNumber numberWithFloat:64.0], nil];
                break;
            case kAWBCollageObjectLocatorTypeMosaicTinyImages:
            case kAWBCollageObjectLocatorTypeMosaicMicroImages:
            case kAWBCollageObjectLocatorTypeMosaicNanoImages:
                rowHeights = [NSArray arrayWithObjects:[NSNumber numberWithFloat:48.0], [NSNumber numberWithFloat:64.0], [NSNumber numberWithFloat:48.0], [NSNumber numberWithFloat:48.0], [NSNumber numberWithFloat:64.0], [NSNumber numberWithFloat:48.0], nil];
                break;
            default:
                rowHeights = [NSArray arrayWithObjects:[NSNumber numberWithFloat:96.0], [NSNumber numberWithFloat:128.0], [NSNumber numberWithFloat:96.0], nil];
                break;
        }
    }
        
    self.mosaicRowHeights = rowHeights;
}

- (void)setObjectLocatorType:(AWBCollageObjectLocatorType)locatorType
{
    objectLocatorType = locatorType;
    [self initialiseMosaicRowHeights];
}

- (CGFloat)currentMosaicRowHeight
{
    return [[self.mosaicRowHeights objectAtIndex:currentMosaicRow] floatValue];
}

- (void)pushPhotoObjectForScatterLayout:(UIImage *)image isContactPhoto:(BOOL)isContactPhoto
{
    objectPosition = [self randomPointInAreaWithIndex:objectCount totalAreasWide:scatterGridNumColumns totalAreasHigh:scatterGridNumRows screenMarginPercentage:0.03 areaMarginPercentage:0.4 adjustMidPointsOnIndexOverflow:YES];
    
    if (objectCount >= (scatterGridNumRows * scatterGridNumColumns)) {
        collageFull = YES;
    }
    
    CGFloat minPhotoScale = 1.0;
    CGFloat maxPhotoScale = 1.0;
    
    if (DEVICE_IS_IPAD) {
        if (isContactPhoto) {
            objectPosition.y -= 30;
            minPhotoScale = 0.09;
            maxPhotoScale = 0.11;
        } else {
            objectPosition.y -= 25;
            minPhotoScale = 0.14;
            maxPhotoScale = 0.18;
        }
    } else {
        if (isContactPhoto) {
            objectPosition.y -= 20;
            minPhotoScale = 0.11;
            maxPhotoScale = 0.14;
        } else {
            objectPosition.y -= 15;
            minPhotoScale = 0.17;
            maxPhotoScale = 0.21;
        }    
    }

    objectScale = AWBCGSizeRandomScaleFromMinMaxLength(image.size, (minPhotoScale * screenLength), (maxPhotoScale * screenLength));
    objectRotation = AWBRandomRotationFromMinMaxRadians((-M_PI_4/2.0), (M_PI_4/2.0));   
    
    if (self.snapToGrid && (snapToGridSize > 0.0) && (objectHeight > 0.0)) {
        CGFloat quantisedHeight = AWBQuantizeFloat((objectScale * objectHeight), self.snapToGridSize, YES);
        objectScale = quantisedHeight / objectHeight;
        objectRotation = AWBQuantizeFloat(AWBRandomRotationFromMinMaxRadians(-QUANTISED_ROTATION, ((2 * QUANTISED_ROTATION) - 0.001)), QUANTISED_ROTATION, NO);
        objectPosition.x = AWBQuantizeFloat(objectPosition.x, (self.snapToGridSize/2.0), NO);
        objectPosition.y = AWBQuantizeFloat(objectPosition.y, (self.snapToGridSize/2.0), NO);                
    }
}

- (void)pushPhotoObjectForMosaicLayout:(UIImage *)image isContactPhoto:(BOOL)isContactPhoto
{
    CGFloat requiredHeight = [[self.mosaicRowHeights objectAtIndex:currentMosaicRow] floatValue];
    objectRotation = 0.0;    
    objectScale = requiredHeight/objectHeight;
    CGFloat scaledWidth = (objectWidth * objectScale);
    CGFloat scaledHeight = (objectHeight * objectScale);
    
    if (isContactPhoto) {
        if ((currentMosaicOffset.x + scaledWidth) >= (screenLength + (scaledWidth/2.0))) {
            currentMosaicOffset.x = 0.0;
            currentMosaicOffset.y += requiredHeight;
            currentMosaicRow += 1;
            if (currentMosaicRow >= [self.mosaicRowHeights count]) {
                currentMosaicRow = 0;
                currentMosaicOffset = CGPointZero;
                collageFull = YES;
            }
            requiredHeight = [[self.mosaicRowHeights objectAtIndex:currentMosaicRow] floatValue];
            objectScale = requiredHeight/objectHeight;
            scaledWidth = (objectWidth * objectScale);
            scaledHeight = (objectHeight * objectScale);
        } 
    }
    
    objectPosition = CGPointMake(currentMosaicOffset.x + (scaledWidth/2.0), currentMosaicOffset.y + (scaledHeight/2.0));
    
    if ((currentMosaicOffset.x + scaledWidth) >= (screenLength - 5.0)) {
        currentMosaicOffset.x = 0.0;
        currentMosaicOffset.y += requiredHeight;
        currentMosaicRow += 1;
        if (currentMosaicRow >= [self.mosaicRowHeights count]) {
            currentMosaicRow = 0;
            currentMosaicOffset = CGPointZero;
            collageFull = YES;
        }
    } else {
        currentMosaicOffset.x += scaledWidth;
    }
}

- (void)pushPhotoObject:(UIImage *)image isContactPhoto:(BOOL)isContactPhoto
{
    if (image) {
        objectCount += 1;
        objectWidth = image.size.width;
        objectHeight = image.size.height;
        switch (objectLocatorType) {
            case kAWBCollageObjectLocatorTypeScatter:
                [self pushPhotoObjectForScatterLayout:image isContactPhoto:isContactPhoto];
                break;
            case kAWBCollageObjectLocatorTypeMosaicNanoImages:
            case kAWBCollageObjectLocatorTypeMosaicMicroImages:
            case kAWBCollageObjectLocatorTypeMosaicTinyImages:
            case kAWBCollageObjectLocatorTypeMosaicSmallImages:
            case kAWBCollageObjectLocatorTypeMosaicMediumImages:
            case kAWBCollageObjectLocatorTypeMosaicLargeImages:
                if (objectHeight > 0.0 && ([mosaicRowHeights count] > 0)) {
                    [self pushPhotoObjectForMosaicLayout:image isContactPhoto:isContactPhoto];                                        
                }
                break;
            default:
                [self pushPhotoObjectForScatterLayout:image isContactPhoto:isContactPhoto];
                break;
        } 
    }
}

- (void)pushContactLabelBelowCurrentObject:(BOOL)belowCurrentObject includesPhoneNumber:(BOOL)includesPhoneNumber
{
    if (!belowCurrentObject) {
        objectCount += 1;        
    }
    switch (objectLocatorType) {
        case kAWBCollageObjectLocatorTypeScatter:
            [self pushContactLabelForScatterLayoutBelowCurrentObject:belowCurrentObject includesPhoneNumber:includesPhoneNumber];
            break;
        case kAWBCollageObjectLocatorTypeMosaicNanoImages:
        case kAWBCollageObjectLocatorTypeMosaicMicroImages:
        case kAWBCollageObjectLocatorTypeMosaicTinyImages:
        case kAWBCollageObjectLocatorTypeMosaicSmallImages:
        case kAWBCollageObjectLocatorTypeMosaicMediumImages:
        case kAWBCollageObjectLocatorTypeMosaicLargeImages:
            [self pushContactLabelForMosaicLayoutBelowCurrentObject:belowCurrentObject includesPhoneNumber:includesPhoneNumber];
            break;
        default:
            [self pushContactLabelForScatterLayoutBelowCurrentObject:belowCurrentObject includesPhoneNumber:includesPhoneNumber];
            break;
    }            
}

- (void)pushContactLabelForScatterLayoutBelowCurrentObject:(BOOL)belowCurrentObject includesPhoneNumber:(BOOL)includesPhoneNumber
{    
    if (!belowCurrentObject) {
        objectPosition = [self randomPointInAreaWithIndex:objectCount totalAreasWide:scatterGridNumColumns totalAreasHigh:scatterGridNumRows screenMarginPercentage:0.03 areaMarginPercentage:0.4 adjustMidPointsOnIndexOverflow:YES];
        if (DEVICE_IS_IPAD) {
            objectPosition.y -= 30.0;
        } else {
            objectPosition.y -= 20.0;            
        }
        if (objectCount >= (scatterGridNumRows * scatterGridNumColumns)) {
            collageFull = YES;
        }
    } else {
        objectPosition.y += (objectHeight / (2.0 * cosf(objectRotation))) * objectScale;
    }
        
    objectRotation = 0.0;
    objectScale = 0.5;
    if (DEVICE_IS_IPAD) {
        objectScale = 0.7;
    }
    
    if (includesPhoneNumber) {
        objectScale *= 0.85;
    }
        
    if (self.snapToGrid && (snapToGridSize > 0.0)) {
        objectPosition.x = AWBQuantizeFloat(objectPosition.x, (self.snapToGridSize/2.0), NO);
        objectPosition.y = AWBQuantizeFloat(objectPosition.y, (self.snapToGridSize/2.0), NO);                
    }
    
}

- (void)pushContactLabelForMosaicLayoutBelowCurrentObject:(BOOL)belowCurrentObject includesPhoneNumber:(BOOL)includesPhoneNumber
{    
    if (!belowCurrentObject) {
        CGFloat requiredHeight = [[self.mosaicRowHeights objectAtIndex:currentMosaicRow] floatValue];
        if ((currentMosaicOffset.x + requiredHeight) >= (screenLength + (requiredHeight/2.0))) {
            currentMosaicOffset.x = 0.0;
            currentMosaicOffset.y += requiredHeight;
            currentMosaicRow += 1;
            if (currentMosaicRow >= [self.mosaicRowHeights count]) {
                currentMosaicRow = 0;
                currentMosaicOffset = CGPointZero;
                collageFull = YES;
            }
            requiredHeight = [[self.mosaicRowHeights objectAtIndex:currentMosaicRow] floatValue];
        } 
        
        objectPosition = CGPointMake(currentMosaicOffset.x + (requiredHeight/2.0), currentMosaicOffset.y + requiredHeight);
        
        if ((currentMosaicOffset.x + requiredHeight) >= (screenLength - 5.0)) {
            currentMosaicOffset.x = 0.0;
            currentMosaicOffset.y += requiredHeight;
            currentMosaicRow += 1;
            if (currentMosaicRow >= [self.mosaicRowHeights count]) {
                currentMosaicRow = 0;
                currentMosaicOffset = CGPointZero;
                collageFull = YES;
            }
        } else {
            currentMosaicOffset.x += requiredHeight;
        }
    } else {
        objectPosition.y += (objectHeight/2.0) * objectScale;
    }
    
    objectRotation = 0.0;
    objectScale = 0.5;
    if (DEVICE_IS_IPAD) {
        if (objectLocatorType >= kAWBCollageObjectLocatorTypeMosaicMicroImages) {
            objectScale = 0.4;
        } else {            
            objectScale = 0.7;
        }
    }
    
    if (includesPhoneNumber) {
        objectScale *= 0.85;
    }
}

- (void)pushSymbol
{
    [self pushSymbolIntoCenter];

//    objectCount += 1;
//    switch (objectLocatorType) {
//        case kAWBCollageObjectLocatorTypeScatter:
//            [self pushSymbolForScatterLayout];
//            break;
//        case kAWBCollageObjectLocatorTypeMosaicNanoImages:
//        case kAWBCollageObjectLocatorTypeMosaicMicroImages:
//        case kAWBCollageObjectLocatorTypeMosaicTinyImages:
//        case kAWBCollageObjectLocatorTypeMosaicSmallImages:
//        case kAWBCollageObjectLocatorTypeMosaicMediumImages:
//        case kAWBCollageObjectLocatorTypeMosaicLargeImages:
//            [self pushSymbolForMosaicLayout];
//            break;
//        default:
//            [self pushSymbolForScatterLayout];
//            break;
//    }
}

- (void)pushSymbolIntoCenter
{
    objectPosition = [self randomCenterPoint];
    objectScale = 1.0;
    objectRotation = 0.0; 
    
    if (self.snapToGrid && (snapToGridSize > 0.0)) {
        objectPosition.x = AWBQuantizeFloat(objectPosition.x, (self.snapToGridSize/2.0), NO);
        objectPosition.y = AWBQuantizeFloat(objectPosition.y, (self.snapToGridSize/2.0), NO);                
    }
}

- (void)pushSymbolForScatterLayout
{
    objectPosition = [self randomPointInAreaWithIndex:objectCount totalAreasWide:scatterGridNumColumns totalAreasHigh:scatterGridNumRows screenMarginPercentage:0.03 areaMarginPercentage:0.4 adjustMidPointsOnIndexOverflow:YES];
    objectScale = 1.0;
    objectRotation = 0.0; 
    if (objectCount >= (scatterGridNumRows * scatterGridNumColumns)) {
        collageFull = YES;
    }

    if (self.snapToGrid && (snapToGridSize > 0.0)) {
        objectPosition.x = AWBQuantizeFloat(objectPosition.x, (self.snapToGridSize/2.0), NO);
        objectPosition.y = AWBQuantizeFloat(objectPosition.y, (self.snapToGridSize/2.0), NO);                
    }
}

- (void)pushSymbolForMosaicLayout
{
    objectScale = 1.0;
    objectRotation = 0.0; 
    
    CGFloat requiredHeight = [[self.mosaicRowHeights objectAtIndex:currentMosaicRow] floatValue];
    if ((currentMosaicOffset.x + requiredHeight) >= (screenLength + requiredHeight)) {
        currentMosaicOffset.x = 0.0;
        currentMosaicOffset.y += requiredHeight;
        currentMosaicRow += 1;
        if (currentMosaicRow >= [self.mosaicRowHeights count]) {
            currentMosaicRow = 0;
            currentMosaicOffset = CGPointZero;
            collageFull = YES;
        }
        requiredHeight = [[self.mosaicRowHeights objectAtIndex:currentMosaicRow] floatValue];
    } 
    
    objectPosition = CGPointMake(currentMosaicOffset.x + (requiredHeight/2.0), currentMosaicOffset.y + (requiredHeight/2.0));
    
    if ((currentMosaicOffset.x + requiredHeight) >= (screenLength - 5.0)) {
        currentMosaicOffset.x = 0.0;
        currentMosaicOffset.y += requiredHeight;
        currentMosaicRow += 1;
        if (currentMosaicRow >= [self.mosaicRowHeights count]) {
            currentMosaicRow = 0;
            currentMosaicOffset = CGPointZero;
            collageFull = YES;
        }
    } else {
        currentMosaicOffset.x += requiredHeight;
    }
}

- (void)pushTextLabel
{
    [self pushTextLabelIntoCenter];
    
//    objectCount += 1;
//    switch (objectLocatorType) {
//        case kAWBCollageObjectLocatorTypeScatter:
//            [self pushTextLabelForScatterLayout];
//            break;
//        case kAWBCollageObjectLocatorTypeMosaicNanoImages:
//        case kAWBCollageObjectLocatorTypeMosaicMicroImages:
//        case kAWBCollageObjectLocatorTypeMosaicTinyImages:
//        case kAWBCollageObjectLocatorTypeMosaicSmallImages:
//        case kAWBCollageObjectLocatorTypeMosaicMediumImages:
//        case kAWBCollageObjectLocatorTypeMosaicLargeImages:
//            [self pushTextLabelForMosaicLayout];
//            break;
//        default:
//            [self pushTextLabelForScatterLayout];
//            break;
//    }
}

- (void)pushTextLabelIntoCenter
{
    objectPosition = [self randomCenterPoint];
    if (DEVICE_IS_IPAD) {
        objectScale = 1.1;
    } else {
        objectScale = 0.7;
    }
    objectRotation = 0.0; 
    
    if (self.snapToGrid && (snapToGridSize > 0.0)) {
        objectPosition.x = AWBQuantizeFloat(objectPosition.x, (self.snapToGridSize/2.0), NO);
        objectPosition.y = AWBQuantizeFloat(objectPosition.y, (self.snapToGridSize/2.0), NO);                
    }
}

- (void)pushTextLabelForScatterLayout
{
    objectPosition = [self randomPointInAreaWithIndex:objectCount totalAreasWide:scatterGridNumColumns totalAreasHigh:scatterGridNumRows screenMarginPercentage:0.03 areaMarginPercentage:0.4 adjustMidPointsOnIndexOverflow:YES];
    if (DEVICE_IS_IPAD) {
        objectScale = 1.1;
    } else {
        objectScale = 0.7;
    }
    objectRotation = 0.0; 
    if (objectCount >= (scatterGridNumRows * scatterGridNumColumns)) {
        collageFull = YES;
    }
    
    if (self.snapToGrid && (snapToGridSize > 0.0)) {
        objectPosition.x = AWBQuantizeFloat(objectPosition.x, (self.snapToGridSize/2.0), NO);
        objectPosition.y = AWBQuantizeFloat(objectPosition.y, (self.snapToGridSize/2.0), NO);                
    }
}

- (void)pushTextLabelForMosaicLayout
{
    if (DEVICE_IS_IPAD) {
        objectScale = 1.1;
    } else {
        objectScale = 0.7;
    }
    objectRotation = 0.0;  
    
    CGFloat requiredHeight = [[self.mosaicRowHeights objectAtIndex:currentMosaicRow] floatValue];
    if ((currentMosaicOffset.x + requiredHeight) >= (screenLength + requiredHeight)) {
        currentMosaicOffset.x = 0.0;
        currentMosaicOffset.y += requiredHeight;
        currentMosaicRow += 1;
        if (currentMosaicRow >= [self.mosaicRowHeights count]) {
            currentMosaicRow = 0;
            currentMosaicOffset = CGPointZero;
            collageFull = YES;
        }
        requiredHeight = [[self.mosaicRowHeights objectAtIndex:currentMosaicRow] floatValue];
    } 
    
    objectPosition = CGPointMake(currentMosaicOffset.x + (requiredHeight/2.0), currentMosaicOffset.y + (requiredHeight/2.0));
    
    if ((currentMosaicOffset.x + requiredHeight) >= (screenLength - 5.0)) {
        currentMosaicOffset.x = 0.0;
        currentMosaicOffset.y += requiredHeight;
        currentMosaicRow += 1;
        if (currentMosaicRow >= [self.mosaicRowHeights count]) {
            currentMosaicRow = 0;
            currentMosaicOffset = CGPointZero;
            collageFull = YES;
        }
    } else {
        currentMosaicOffset.x += requiredHeight;
    }
}

- (void)resetLocator
{
    objectCount = 0;    
    currentMosaicRow = 0;
    currentMosaicOffset = CGPointZero;
    objectPosition = CGPointZero;
    collageFull = NO;
}

- (CGPoint)randomPointInAreaWithIndex:(NSUInteger)areaIndex totalAreasWide:(NSUInteger)areasWide totalAreasHigh:(NSUInteger)areasHigh screenMarginPercentage:(CGFloat)screenMarginPerc areaMarginPercentage:(CGFloat)areaMarginPerc adjustMidPointsOnIndexOverflow:(BOOL)adjustMidPoints
{
//    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
//    CGFloat screenWidth = (screenSize.height > screenSize.width ? screenSize.height : screenSize.width);
//    CGFloat screenHeight = (screenSize.height > screenSize.width ? screenSize.width : screenSize.height);
    CGFloat screenOffsetX = screenLength * screenMarginPerc;
    CGFloat screenOffsetY = screenHeight * screenMarginPerc;
    CGFloat areaWidth = ((1.0 - (2.0*screenMarginPerc))*screenLength)/areasWide;
    CGFloat areaHeight = ((1.0 - (2.0*screenMarginPerc))*screenHeight)/areasHigh;
    CGFloat areaWidthRange = ((1.0 - (2.0*areaMarginPerc))*areaWidth);
    CGFloat areaHeightRange = ((1.0 - (2.0*areaMarginPerc))*areaHeight);
    CGFloat minAreaX = areaMarginPerc * areaWidth;
    CGFloat maxAreaX = minAreaX + areaWidthRange;
    CGFloat minAreaY = areaMarginPerc * areaHeight;
    CGFloat maxAreaY = minAreaY + areaHeightRange;
    
    CGFloat randomX = (CGFloat)AWBRandomIntInRange((int)minAreaX, (int)maxAreaX);
    CGFloat randomY = (CGFloat)AWBRandomIntInRange((int)minAreaY, (int)maxAreaY);
    
    //now work out from index, which box we are in
    NSUInteger areaXIndex = ((areaIndex-1) % areasWide)+1;
    NSUInteger areaYIndex = (((areaIndex-1)/areasWide) % areasHigh)+1;
    
    CGFloat pointX = screenOffsetX + ((areaXIndex-1)*areaWidth) + randomX;
    CGFloat pointY = screenOffsetY + ((areaYIndex-1)*areaHeight) + randomY;
    
    if (adjustMidPoints) {
        NSUInteger overflowIndex = (((areaIndex - 1) / (areasWide * areasHigh)) % 3);
        if (overflowIndex == 1) {
            pointX += (areaWidth/3.0);
            pointY += (areaHeight/2.0);
        } else if (overflowIndex == 2) {
            pointX += ((2.0 * areaWidth)/3.0);
            pointY += ((2.0 * areaHeight)/4.0);            
        }
    }
    
    if (pointX > (screenLength - screenOffsetX)) {
        pointX = (screenLength - screenOffsetX);
    } else if (pointX < screenOffsetX) {
        pointX = screenOffsetX;
    }
    
    if (pointY > (screenHeight - screenOffsetY)) {
        pointY = (screenHeight - screenOffsetY);
    } else if (pointY < screenOffsetY) {
        pointY = screenOffsetY;
    }    
    
    return CGPointMake(pointX, pointY);
}

- (BOOL)collageIsFullForContactLabelBelowCurrentObject:(BOOL)belowCurrentObject
{
    if (belowCurrentObject) {
        return NO;
    } else {
        if (self.collageFull) {
            return YES;
        } else {
            if (self.objectLocatorType == kAWBCollageObjectLocatorTypeScatter) {
                return NO;
            } else {
                CGFloat requiredHeight = [[self.mosaicRowHeights objectAtIndex:currentMosaicRow] floatValue];
                if ((currentMosaicOffset.x + requiredHeight) >= (screenLength + (requiredHeight/2.0))) {
                    if ((currentMosaicRow + 1) >= [self.mosaicRowHeights count]) {
                        return YES;
                    } else {
                        return NO;
                    }
                } else {
                    return NO;
                }
            }
        }
    }
}

- (BOOL)collageIsFullForContactImageOfSize:(CGSize)imageSize
{
    if (self.collageFull) {
        return YES;
    } else {
        if (self.objectLocatorType == kAWBCollageObjectLocatorTypeScatter) {
            return NO;
        } else {
            CGFloat imageHeight = imageSize.height;
            CGFloat imageWidth = imageSize.width;
            
            if (imageHeight > 0.0) {
                CGFloat requiredHeight = [[self.mosaicRowHeights objectAtIndex:currentMosaicRow] floatValue];
                CGFloat scale = requiredHeight/imageHeight;
                CGFloat scaledWidth = (imageWidth * scale);
                
                if ((currentMosaicOffset.x + scaledWidth) >= (screenLength + (scaledWidth/2.0))) {
                    if ((currentMosaicRow + 1) >= [self.mosaicRowHeights count]) {
                        return YES;
                    } else {
                        return NO;
                    }
                } else {
                    return NO;
                }
            } else {
                return NO;
            }            
        }
    }
}

- (CGPoint)randomCenterPoint
{    
    CGFloat minX = 0.45 * screenLength;
    CGFloat maxX = 0.55 * screenLength;
    CGFloat minY = 0.45 * screenHeight;
    CGFloat maxY = 0.55 * screenHeight;
    
    return CGPointMake(AWBRandomIntInRange(minX, maxX), AWBRandomIntInRange(minY, maxY));
}

@end
