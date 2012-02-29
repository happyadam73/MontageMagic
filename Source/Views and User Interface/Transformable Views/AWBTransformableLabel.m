//
//  AWBTransformableLabel.m
//  CollageMaker
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBTransformableLabel.h"
#import "AWBTransforms.h"
#import "UIView+Animation.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"
#import "AWBCollageFont.h"

#define BORDER_HEIGHT_RATIO 24.0
#define SHADOW_OFFSET_HEIGHT_RATIO 8.0
#define QUANTISED_ROTATION (M_PI_4/2.0)
#define DEFAULT_FONT_POINT_SIZE 28.0

@implementation AWBTransformableLabel

@synthesize rotationAngleInRadians, currentScale, pendingRotationAngleInRadians, horizontalFlip;
@synthesize roundedBorder, viewBorderColor, viewShadowColor, addShadow, addBorder;
@synthesize labelView, isZFontLabel, myFontFilename;
@synthesize roundedCornerSize, shadowOffsetRatio;

- (void)initialiseLayerRotation:(CGFloat)rotation scale:(CGFloat)scale  
{
//    CATiledLayer *layerForView = (CATiledLayer *)self.layer;
//    layerForView.levelsOfDetailBias = 4;
    //layerForView.levelsOfDetail = 4;
    
    rotationCurrentlyQuantised = NO;
    scaleCurrentlyQuantised = NO;
    rotationAngleInRadians = rotation;
    pendingRotationAngleInRadians = 0.0;
    currentScale = scale;
    horizontalFlip = NO;  
    
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;    
    CGFloat minLength = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat maxLength = MAX(self.frame.size.width, self.frame.size.height);
    
    minScale = MAX((48.0/maxLength),((DEVICE_IS_IPAD ? 32.0 : 24.0)/minLength));    
    maxScale = (MAX(screenSize.width, screenSize.height))/maxLength;
    
    [self setUserInteractionEnabled:YES];
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    
    self.viewBorderColor = [UIColor blackColor];
    self.viewShadowColor = [UIColor blackColor];
    self.roundedBorder = YES;
    self.shadowOffsetRatio = 1.0;
    self.labelView.numberOfLines = 0;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSString *labelText = [aDecoder decodeObjectForKey:@"labelText"];
    NSString *labelFontName = [aDecoder decodeObjectForKey:@"labelFontName"];
    CGFloat labelFontSize = [aDecoder decodeFloatForKey:@"labelFontSize"];
    UIColor *labelColor = [aDecoder decodeObjectForKey:@"labelColor"];
    UITextAlignment alignment = UITextAlignmentCenter;
    if ([aDecoder containsValueForKey:@"labelTextAlignment"]) {
        alignment = [aDecoder decodeIntegerForKey:@"labelTextAlignment"];
    }
    CGFloat labelOffsetX = [aDecoder decodeFloatForKey:@"labelOffsetX"];
    CGFloat labelOffsetY = [aDecoder decodeFloatForKey:@"labelOffsetY"];
    CGFloat labelRotation = [aDecoder decodeFloatForKey:@"labelRotation"];
    
    //AWB, 29/2/2012 - Possible Inf or NaN value in scale; first assign to double and check
    CGFloat labelScale = 1.0;
    double scaleValue = [aDecoder decodeDoubleForKey:@"labelScale"];
    if ((isinf(scaleValue)) || (isnan(scaleValue))) {
        NSLog(@"Scale is Inf or NaN - scale remains 1.0");
    } else {
        labelScale = [aDecoder decodeFloatForKey:@"labelScale"];
    }    
    
    BOOL labelHFlip = [aDecoder decodeBoolForKey:@"labelHFlip"];        
    CGPoint offset = CGPointMake(labelOffsetX, labelOffsetY);
        
    self = [self initWithTextLines:[labelText componentsSeparatedByString:@"\r\n"] fontName:labelFontName fontSize:labelFontSize offset:offset rotation:labelRotation scale:labelScale horizontalFlip:labelHFlip color:labelColor alignment:alignment];
    
    [self setCenter:offset];
    return  self;
}

- (id)initWithText:(NSString *)text offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale
{
    return [self initWithText:text fontName:@"Helvetica" fontSize:28.0 offset:point rotation:rotation scale:scale horizontalFlip:NO color:[UIColor blackColor] alignment:UITextAlignmentCenter];
}

- (id)initWithText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment
{
    return [self initWithTextLines:[NSArray arrayWithObject:text] fontName:fontName fontSize:fontSize offset:point rotation:rotation scale:scale horizontalFlip:flip color:color alignment:alignment];
}

- (id)initWithTextLines:(NSArray *)lines fontName:(NSString *)fontName fontSize:(CGFloat)fontSize offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment
{
    BOOL isMyFont = [AWBCollageFont isFontNameMyFontFilename:fontName];
    if (isMyFont && (![AWBCollageFont myFontDoesExistWithFilename:fontName])) {
        isMyFont = NO;
        fontName = @"Helvetica";
    }
    BOOL isZFont = [AWBCollageFont isZFont:fontName];
    
    if (isZFont || isMyFont) {
        ZFont *zFont = nil;
        NSString *fontFilename = nil;
        if (isMyFont) {
            fontFilename = fontName;
            zFont = [[FontManager sharedManager] zFontWithURL:[AWBCollageFont myFontUrlFromFontFilename:fontName] pointSize:fontSize];
        } else {
            zFont = [[FontManager sharedManager] zFontWithName:fontName pointSize:fontSize];
        }
        //AWB, 26/1/2012 - zFont could be nil; if so set to Graffiti to prevent a crash
        if (zFont == nil) {
            zFont = [[FontManager sharedManager] zFontWithName:@"Most Wasted" pointSize:fontSize];
            fontFilename = nil;
        }
        return [self initWithTextLines:lines zFont:zFont offset:point rotation:rotation scale:scale horizontalFlip:flip color:color alignment:alignment myFontFilename:fontFilename];
    } else {
        UIFont *iOSFont = [UIFont fontWithName:fontName size:fontSize];
        return [self initWithTextLines:lines iOSFont:iOSFont offset:point rotation:rotation scale:scale horizontalFlip:flip color:color alignment:alignment];
    }
}

- (id)initWithTextLines:(NSArray *)lines zFont:(ZFont *)font offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment myFontFilename:(NSString *)fontFilename
{
    ZFont *textFont = font;
    if (!textFont) {
        textFont = [ZFont fontWithUIFont:[UIFont systemFontOfSize:DEFAULT_FONT_POINT_SIZE]];
    }
    if (!color) {
        color = [UIColor darkGrayColor];
    }
    
    [self updateTextDimensionsWithLines:lines zFont:textFont];
    
    CGFloat frameWidth = (1.2 * maxWidth) + (0.25 * maxHeight);
    CGFloat frameHeight = (1.3 * totalHeight) + 10.0;
    
    self = [super initWithFrame:CGRectMake(point.x, point.y, frameWidth, frameHeight)];
    if (self) { 
        self.myFontFilename = fontFilename;
        isZFontLabel = YES;
        initialHeight = frameHeight;
        FontLabel *label = [[FontLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frameWidth, frameHeight) zFont:textFont];                
        label.layer.masksToBounds = YES;
        self.labelView = label;
        [label release];
        [self addSubview:self.labelView];
        
        CGFloat minLabelLength = MIN(frameWidth, frameHeight);
        borderThickness = (minLabelLength/BORDER_HEIGHT_RATIO);
        if (borderThickness < 2.0) {
            borderThickness = 2.0;
        }        
        [self initialiseLayerRotation:rotation scale:scale];
        [self setHorizontalFlip:flip];
        [self.labelView setTextColor:color];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.labelView setBackgroundColor:[UIColor clearColor]];
        [self.labelView setTextAlignment:alignment];
        [self.labelView setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [self.labelView setText:[lines componentsJoinedByString:@"\r\n"]];
        [self rotateAndScale];
    }
    return self;
}

- (id)initWithTextLines:(NSArray *)lines iOSFont:(UIFont *)font offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment
{
    UIFont *textFont = font;
    if (!textFont) {
        textFont = [UIFont systemFontOfSize:DEFAULT_FONT_POINT_SIZE];
    }
    if (!color) {
        color = [UIColor darkGrayColor];
    }
    
    [self updateTextDimensionsWithLines:lines iOSFont:textFont];
    
    CGFloat frameWidth = (1.2 * maxWidth) + (0.25 * maxHeight);
    CGFloat frameHeight = (1.1 * totalHeight) + 10.0;
    
    self = [super initWithFrame:CGRectMake(point.x, point.y, frameWidth, frameHeight)];
    if (self) { 
        self.myFontFilename = nil;
        isZFontLabel = NO;
        initialHeight = frameHeight;
        
        AWBLabel *label = [[AWBLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frameWidth, frameHeight)];
        label.layer.masksToBounds = YES;
        self.labelView = label;
        [label release];
        [self addSubview:self.labelView];
        
        CGFloat minLabelLength = MIN(frameWidth, frameHeight);
        borderThickness = (minLabelLength/BORDER_HEIGHT_RATIO);
        if (borderThickness < 2.0) {
            borderThickness = 2.0;
        }        
        [self initialiseLayerRotation:rotation scale:scale];
        [self setHorizontalFlip:flip];
        [self.labelView setFont:textFont];
        [self.labelView setTextColor:color];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.labelView setBackgroundColor:[UIColor clearColor]];
        [self.labelView setTextAlignment:alignment];
        [self.labelView setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [self.labelView setText:[lines componentsJoinedByString:@"\r\n"]];
        [self rotateAndScale];
    }
    return self;
}

- (void)updateTextDimensionsWithLines:(NSArray *)lines zFont:(ZFont *)font
{
    CGSize textLineSize;
    maxWidth = 0;
    maxHeight = 0;
    totalHeight = 0;
    
    for (NSString *textLine in lines) {
        textLineSize = [textLine sizeWithZFont:font];  
        if (textLineSize.width > maxWidth) {
            maxWidth = textLineSize.width;
        }
        if (textLineSize.height > maxHeight) {
            maxHeight = textLineSize.height;
        }        
        totalHeight += textLineSize.height;
    } 
    
    CGRect fontRect = CGFontGetFontBBox(font.cgFont);
    CGFloat fontRectHeight = (fontRect.size.height - fontRect.origin.y) * font.ratio;
    CGFloat diffRatio = (fontRectHeight - font.leading)/font.leading;
    
    if (diffRatio > 1.5) {
        if ([lines count] > 1) {
            totalHeight = totalHeight * 1.3;
        } else {
            totalHeight = totalHeight * 1.6;
        }
    }    
}

- (void)updateTextDimensionsWithLines:(NSArray *)lines iOSFont:(UIFont *)font
{
    CGSize textLineSize;
    maxWidth = 0;
    maxHeight = 0;
    totalHeight = 0;
    
    for (NSString *textLine in lines) {
        textLineSize = [textLine sizeWithFont:font];  
        if (textLineSize.width > maxWidth) {
            maxWidth = textLineSize.width;
        }
        if (textLineSize.height > maxHeight) {
            maxHeight = textLineSize.height;
        }        
        totalHeight += textLineSize.height;
    } 
}

- (void)updateLabelTextLines:(NSArray *)lines withFontName:(NSString *)fontName fontSize:(CGFloat)fontSize 
{   
    BOOL isMyFont = [AWBCollageFont isFontNameMyFontFilename:fontName];
    if (isMyFont && (![AWBCollageFont myFontDoesExistWithFilename:fontName])) {
        isMyFont = NO;
        fontName = @"Helvetica";
    }
    BOOL isZFont = [AWBCollageFont isZFont:fontName];
    
    if (isZFont || isMyFont) {
        ZFont *zFont = nil;
        NSString *fontFilename = nil;
        if (isMyFont) {
            fontFilename = fontName;
            zFont = [[FontManager sharedManager] zFontWithURL:[AWBCollageFont myFontUrlFromFontFilename:fontName] pointSize:fontSize];
        } else {
            zFont = [[FontManager sharedManager] zFontWithName:fontName pointSize:fontSize];
        }   
        //AWB, 26/1/2012 - zFont could be nil; if so set to Most Wasted to prevent a crash
        if (zFont == nil) {
            zFont = [[FontManager sharedManager] zFontWithName:@"Most Wasted" pointSize:fontSize];
        }
        [self updateLabelTextLines:lines withZFont:zFont myFontFilename:fontFilename];
    } else {
        UIFont *iOSFont = [UIFont fontWithName:fontName size:fontSize];
        [self updateLabelTextLines:lines withiOSFont:iOSFont];
    }    
}

- (void)updateLabelTextLines:(NSArray *)lines withZFont:(ZFont *)font myFontFilename:(NSString *)fontFilename
{    
    //before removing the iOS label, we need to get the alignment and color values
    UITextAlignment alignment = self.labelView.textAlignment;
    CGColorRef colorRef = [self.labelView.textColor  CGColor];
    [self.labelView removeFromSuperview];
    FontLabel *label = [[FontLabel alloc] initWithFrame:CGRectZero];
    label.layer.masksToBounds = YES;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    label.textAlignment = alignment;
    label.textColor = [UIColor colorWithCGColor:colorRef];
    self.labelView = label;
    [label release];
    [self addSubview:self.labelView];
    isZFontLabel = YES;
    self.myFontFilename = fontFilename;
    
    [self updateTextDimensionsWithLines:lines zFont:font];
    CGRect newBounds = CGRectMake(0.0, 0.0, (1.2 * maxWidth) + (0.25 * maxHeight), (1.3 * totalHeight) + 10.0);
    [(FontLabel *)self.labelView setZFont:font];
    [self.labelView setText:[lines componentsJoinedByString:@"\r\n"]];
    [self setBounds:newBounds];
    [self.labelView setBounds:newBounds];
    self.labelView.center = CGPointMake((newBounds.size.width/2.0), (newBounds.size.height/2.0));
    [(FontLabel *)self.labelView setLevelsOfDetail];
    
    CGFloat minLabelLength = MIN(newBounds.size.width, newBounds.size.height);
    CGFloat maxLabelLength = MAX(newBounds.size.width, newBounds.size.height);
    initialHeight = newBounds.size.height;    
    
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;    
    minScale = MAX((48.0/maxLabelLength),((DEVICE_IS_IPAD ? 32.0 : 24.0)/minLabelLength));    
    maxScale = (MAX(screenSize.width, screenSize.height))/maxLabelLength;
    
    [self setCurrentScale:currentScale];
    borderThickness = (minLabelLength/BORDER_HEIGHT_RATIO);
    if (borderThickness < 2.0) {
        borderThickness = 2.0;
    }
    
    if (addBorder) {
        [self addViewBorder];
    }
    
    [self rotateAndScale];
}

- (void)updateLabelTextLines:(NSArray *)lines withiOSFont:(UIFont *)font
{    
    //OK, we're expecting an iOS label - if it's not currently then we need to remove the ZFont label and create a new iOSFont label
    if (isZFontLabel) {
        //before removing the iOS label, we need to get the alignment and color values
        UITextAlignment alignment = self.labelView.textAlignment;
        CGColorRef colorRef = [self.labelView.textColor  CGColor];
        [self.labelView removeFromSuperview];
        AWBLabel *label = [[AWBLabel alloc] initWithFrame:CGRectZero];
        label.layer.masksToBounds = YES;
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor clearColor];
        label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        label.textAlignment = alignment;
        label.textColor = [UIColor colorWithCGColor:colorRef];
        self.labelView = label;
        [label release];
        [self addSubview:self.labelView];
        isZFontLabel = NO;
        self.myFontFilename = nil;
    }
    
    [self updateTextDimensionsWithLines:lines iOSFont:font];
    CGRect newBounds = CGRectMake(0.0, 0.0, (1.2 * maxWidth) + (0.25 * maxHeight), (1.1 * totalHeight) + 10.0);
    [self.labelView setFont:font];
    [self.labelView setText:[lines componentsJoinedByString:@"\r\n"]];
    [self setBounds:newBounds];
    [self.labelView setBounds:newBounds];
    self.labelView.center = CGPointMake((newBounds.size.width/2.0), (newBounds.size.height/2.0));
    
    CGFloat minLabelLength = MIN(newBounds.size.width, newBounds.size.height);
    CGFloat maxLabelLength = MAX(newBounds.size.width, newBounds.size.height);
    initialHeight = newBounds.size.height;    
    
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;    
    minScale = MAX((48.0/maxLabelLength),((DEVICE_IS_IPAD ? 32.0 : 24.0)/minLabelLength));    
    maxScale = (MAX(screenSize.width, screenSize.height))/maxLabelLength;
    
    [self setCurrentScale:currentScale];
    borderThickness = (minLabelLength/BORDER_HEIGHT_RATIO);
    if (borderThickness < 2.0) {
        borderThickness = 2.0;
    }
    
    if (addBorder) {
        [self addViewBorder];
    }
    
    [self rotateAndScale];
}

- (void)updateLabelTextWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize 
{
    BOOL isMyFont = [AWBCollageFont isFontNameMyFontFilename:fontName];
    if (isMyFont && (![AWBCollageFont myFontDoesExistWithFilename:fontName])) {
        isMyFont = NO;
        fontName = @"Helvetica";
    }
    BOOL isZFont = [AWBCollageFont isZFont:fontName];
    
    if (isZFont || isMyFont) {
        ZFont *zFont = nil;
        NSString *fontFilename = nil;
        if (isMyFont) {
            fontFilename = fontName;
            zFont = [[FontManager sharedManager] zFontWithURL:[AWBCollageFont myFontUrlFromFontFilename:fontName] pointSize:fontSize];
        } else {
            zFont = [[FontManager sharedManager] zFontWithName:fontName pointSize:fontSize];
        } 
        //AWB, 26/1/2012 - zFont could be nil; if so set to Most Wasted to prevent a crash
        if (zFont == nil) {
            zFont = [[FontManager sharedManager] zFontWithName:@"Most Wasted" pointSize:fontSize];
        }
        [self updateLabelTextLines:[self.labelView.text componentsSeparatedByString:@"\r\n"] withZFont:zFont myFontFilename:fontFilename];
    } else {
        UIFont *iOSFont = [UIFont fontWithName:fontName size:fontSize];
        [self updateLabelTextLines:[self.labelView.text componentsSeparatedByString:@"\r\n"] withiOSFont:iOSFont];
    }    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self applyPendingRotationToCapturedView];
    [aCoder encodeObject:self.labelView.text forKey:@"labelText"];
    if (self.isZFontLabel) {
        if (self.myFontFilename) {
            [aCoder encodeObject:self.myFontFilename forKey:@"labelFontName"];
        } else {
            [aCoder encodeObject:((FontLabel *)self.labelView).zFont.familyName forKey:@"labelFontName"];
        }
        [aCoder encodeFloat:((FontLabel *)self.labelView).zFont.pointSize forKey:@"labelFontSize"];        
    } else {
        [aCoder encodeObject:self.labelView.font.fontName forKey:@"labelFontName"];
        [aCoder encodeFloat:self.labelView.font.pointSize forKey:@"labelFontSize"];        
    }
    [aCoder encodeObject:self.labelView.textColor forKey:@"labelColor"];
    [aCoder encodeInteger:self.labelView.textAlignment forKey:@"labelTextAlignment"];
    [aCoder encodeFloat:self.center.x forKey:@"labelOffsetX"];
    [aCoder encodeFloat:self.center.y forKey:@"labelOffsetY"];
    [aCoder encodeFloat:self.quantisedRotation forKey:@"labelRotation"];
    [aCoder encodeFloat:self.quantisedScale forKey:@"labelScale"];
    [aCoder encodeBool:self.horizontalFlip forKey:@"labelHFlip"];
}

-(void)setCurrentScale:(CGFloat)scale
{
    if (scale < minScale) {
        currentScale = minScale;
    } else if (scale > maxScale) {
        currentScale = maxScale;
    } else {
        currentScale = scale;
    }
}

- (id)initWithText:(NSString *)text offset:(CGPoint) point;
{
    return [self initWithText:text offset:point rotation:0.0 scale:1.0];    
}

-(void)rotateAndScale
{    
    [self rotateAndScaleWithSnapToGrid:NO gridSize:0.0 snapRotation:NO];
}

- (void)rotateAndScaleWithSnapToGrid:(BOOL)snapToGrid gridSize:(CGFloat)gridSize snapRotation:(BOOL)snapRotation
{
    CGFloat rotation = rotationAngleInRadians+pendingRotationAngleInRadians;
    CGFloat scale = currentScale;
    
    if (snapToGrid && (gridSize > 0.0) && (initialHeight > 0.0)) {
        CGFloat quantisedHeight = AWBQuantizeFloat((scale * initialHeight), gridSize, YES);
        scale = quantisedHeight / initialHeight;
        scaleCurrentlyQuantised = YES;
        currentQuantisedScale = scale;
    } else {
        scaleCurrentlyQuantised = NO;
    }
    
    if (snapRotation) {
        rotation = AWBQuantizeFloat(rotation, QUANTISED_ROTATION, NO);
        rotationCurrentlyQuantised = YES;
        currentQuantisedRotation = rotation;
    } else {
        rotationCurrentlyQuantised = NO;
    }
    
    self.transform = AWBCGAffineTransformMakeRotationAndScale(rotation, scale, horizontalFlip);
}

- (CGFloat)quantisedRotation
{
    if (rotationCurrentlyQuantised) {
        return currentQuantisedRotation;
    } else {
        return rotationAngleInRadians+pendingRotationAngleInRadians;
    }
}

- (CGFloat)quantisedScale
{
    if (scaleCurrentlyQuantised) {
        return currentQuantisedScale;
    } else {
        return currentScale;
    }
}

- (void)applyPendingRotationToCapturedView
{
    self.rotationAngleInRadians += self.pendingRotationAngleInRadians;
    self.pendingRotationAngleInRadians = 0.0;
}

- (void)setAddBorder:(BOOL)addBorderValue
{
    addBorder = addBorderValue;
    if (addBorder) {
        [self addViewBorder];
    } else {
        [self removeViewBorder];
    }
}

- (void)setAddShadow:(BOOL)addShadowValue
{
    addShadow = addShadowValue;
    if (addShadow) {
        [self addViewShadow];
    } else {
        [self removeViewShadow];
    }    
}

- (void)setRoundedBorder:(BOOL)roundedBorderValue
{
    roundedBorder = roundedBorderValue;
}

- (void)setTextBackgroundColor:(UIColor *)backgroundColor
{
    if (backgroundColor) {
        [self.labelView setBackgroundColor:backgroundColor];        
    }
}

- (void)addViewShadow
{
    self.layer.shadowOffset = CGSizeMake((shadowOffsetRatio * 10), (shadowOffsetRatio * 10));
    self.layer.shadowRadius = ((shadowOffsetRatio * 10)/3.0);
    self.layer.shadowOpacity = 0.3; 
    self.layer.shadowColor = [self.viewShadowColor CGColor];
}

- (void)removeViewShadow
{
    self.layer.shadowOffset = CGSizeMake(0.0, -3.0);
    self.layer.shadowRadius = 3.0;    
    self.layer.shadowOpacity = 0.0;    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
}

- (void)addViewBorder
{    
    self.labelView.layer.borderWidth = borderThickness;
    self.labelView.layer.cornerRadius = (self.roundedBorder ? (3.0 * borderThickness) : 0.0); 
    self.labelView.layer.borderColor = [self.viewBorderColor CGColor];
}

- (void)removeViewBorder
{
    self.labelView.layer.borderWidth = 0.0;
    self.labelView.layer.cornerRadius = 0.0;
    self.labelView.layer.borderColor = [[UIColor blackColor] CGColor];
}

+ (Class)layerClass {
    return [CATiledLayer class]; 
}

- (void)dealloc
{
    [labelView release];
    [viewBorderColor release];
    [viewShadowColor release];
    [myFontFilename release];
    [super dealloc];
}

@end
