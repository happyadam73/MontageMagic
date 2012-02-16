//
//  AWBTransformableLabel.h
//  CollageMaker
//
//  Created by Adam Buckley on 10/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AWBTransformableView.h"
#import "AWBLabel.h"
#import "FontLabel.h"
#import "ZFont.h"

@interface AWBTransformableLabel : UIView <AWBTransformableView> 
{
    CGFloat minScale;
    CGFloat maxScale;   
    CGFloat borderThickness;
    CGFloat maxWidth;
    CGFloat maxHeight;
    CGFloat totalHeight;
    UILabel *labelView;
    CGFloat initialHeight;
    BOOL rotationAndScaleCurrentlyQuantised;
    CGFloat currentQuantisedScale;
    CGFloat currentQuantisedRotation;
    BOOL isZFontLabel;
    NSString *myFontFilename;
}

@property (nonatomic, retain) UILabel *labelView;
@property (nonatomic, assign) BOOL isZFontLabel;
@property (nonatomic, retain) NSString *myFontFilename;

- (void)initialiseLayerRotation:(CGFloat)rotation scale:(CGFloat)scale;

//- (id)initWithText:(NSString *)text offset:(CGPoint) point;
//- (id)initWithText:(NSString *)text offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale;
//- (id)initWithText:(NSString *)text font:(UIFont *)font offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color;
//- (id)initWithTextLines:(NSArray *)lines font:(UIFont *)font offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color;

- (id)initWithText:(NSString *)text offset:(CGPoint)point;
- (id)initWithText:(NSString *)text offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale;
- (id)initWithText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment;
- (id)initWithTextLines:(NSArray *)lines fontName:(NSString *)fontName fontSize:(CGFloat)fontSize offset:(CGPoint) point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment;
- (id)initWithTextLines:(NSArray *)lines zFont:(ZFont *)font offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment myFontFilename:(NSString *)fontFilename;
- (id)initWithTextLines:(NSArray *)lines iOSFont:(UIFont *)font offset:(CGPoint)point rotation:(CGFloat)rotation scale:(CGFloat)scale horizontalFlip:(BOOL)flip color:(UIColor *)color alignment:(UITextAlignment)alignment;

- (void)setTextBackgroundColor:(UIColor *)backgroundColor;
- (void)addViewShadow;
- (void)removeViewShadow;
- (void)addViewBorder;
- (void)removeViewBorder;

//- (void)updateTextDimensionsWithLines:(NSArray *)lines font:(UIFont *)font;
//- (void)updateLabelTextLines:(NSArray *)lines withFont:(UIFont *)font;
//- (void)updateLabelTextWithFont:(UIFont *)font;

- (void)updateTextDimensionsWithLines:(NSArray *)lines zFont:(ZFont *)font;
- (void)updateTextDimensionsWithLines:(NSArray *)lines iOSFont:(UIFont *)font;
- (void)updateLabelTextLines:(NSArray *)lines withFontName:(NSString *)fontName fontSize:(CGFloat)fontSize;
- (void)updateLabelTextLines:(NSArray *)lines withZFont:(ZFont *)font  myFontFilename:(NSString *)fontFilename;
- (void)updateLabelTextLines:(NSArray *)lines withiOSFont:(UIFont *)font;
- (void)updateLabelTextWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize;

@end
