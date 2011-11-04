//
//  AWBTransformableArrow.h
//  Collage Maker
//
//  Created by Adam Buckley on 30/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBTransformableView.h"

enum AWBArrowType {
    kAWBArrowTypeNone = 0,	
    kAWBArrowTypeSingleHeaded = 1,		
    kAWBArrowTypeDoubleHeaded = 2
};
typedef enum AWBArrowType AWBArrowType;

enum AWBArrowHeadType {
    kAWBArrowHeadTypeFilledTriangle = 0,
    kAWBArrowHeadTypeEmptyTriangle = 1,
    kAWBArrowHeadTypeLined = 2,
    kAWBArrowHeadTypeFilledArrow = 3,
    kAWBArrowHeadTypeEmptyArrow = 4
};
typedef enum AWBArrowHeadType AWBArrowHeadType;

enum AWBArrowLineShapeType {
    kAWBArrowLineShapeTypeNotSpecified = -1,
    kAWBArrowLineShapeTypeStraightLine = 0,
    kAWBArrowLineShapeTypeQuarterCircle = 1,
    kAWBArrowLineShapeTypeHalfCircle = 2,
    kAWBArrowLineShapeTypeBezierCurve = 3
};
typedef enum AWBArrowLineShapeType AWBArrowLineShapeType;

enum AWBArrowLineStrokeType {
    kAWBArrowLineStrokeTypeSolid = 0,
    kAWBArrowLineStrokeTypeDashed = 1,
    kAWBArrowLineStrokeTypeDotted = 2
};
typedef enum AWBArrowLineStrokeType AWBArrowLineStrokeType;

enum AWBArrowThicknessType {
    kAWBArrowThicknessTypeThin = 0,
    kAWBArrowThicknessTypeMedium = 1,
    kAWBArrowThicknessTypeThick = 2
};
typedef enum AWBArrowThicknessType AWBArrowThicknessType;

@class AWBTransformableArrowView;

@protocol AWBTransformableArrowViewDelegate

- (void)awbTransformableArrowViewClicked:(AWBTransformableArrowView *)arrowView;

@end

@interface AWBTransformableArrowView : UIView <AWBTransformableView> 
{
    CGFloat totalLength;
    UIColor *arrowColor;
    AWBArrowThicknessType arrowThicknessType;
    AWBArrowType arrowType;
    AWBArrowHeadType arrowHeadType;
    AWBArrowLineShapeType arrowLineShapeType;
    AWBArrowLineStrokeType arrowLineStrokeType;
    id arrowViewDelegate;
    CGFloat minScale;
    CGFloat maxScale;   
    CGFloat initialHeight;
    BOOL rotationAndScaleCurrentlyQuantised;
    CGFloat currentQuantisedScale;
    CGFloat currentQuantisedRotation;
}

@property (nonatomic, assign) CGFloat totalLength;
@property (nonatomic, retain) UIColor *arrowColor;
@property (nonatomic, assign) AWBArrowType arrowType;
@property (nonatomic, assign) AWBArrowThicknessType arrowThicknessType;
@property (nonatomic, assign) AWBArrowHeadType arrowHeadType;
@property (nonatomic, assign) AWBArrowLineShapeType arrowLineShapeType;
@property (nonatomic, assign) AWBArrowLineStrokeType arrowLineStrokeType;
@property (nonatomic, assign) id arrowViewDelegate;

- (id)initWithLength:(CGFloat)length color:(UIColor *)color type:(AWBArrowType)type thickness:(AWBArrowThicknessType)thicknessType arrowHead:(AWBArrowHeadType)headType arrowLineShape:(AWBArrowLineShapeType)lineShapeType arrowLineStroke:(AWBArrowLineStrokeType)lineStroke; 
- (void)adjustFrame;
- (void)arrowViewClicked:(id)sender;

@end
