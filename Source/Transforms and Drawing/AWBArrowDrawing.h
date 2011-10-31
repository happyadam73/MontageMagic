//
//  AWBArrowDrawing.h
//  Collage Maker
//
//  Created by Adam Buckley on 30/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AWBTransformableView.h"
#import <stdlib.h>
#import "AWBTransformableArrowView.h"

struct AWBCGMargin {
    CGFloat xLeft;
    CGFloat xRight;
    CGFloat yTop;
    CGFloat yBottom;
};
typedef struct AWBCGMargin AWBCGMargin;

CGSize AWBCGArrowSuggestedSize(CGFloat length, AWBArrowThicknessType thicknessType, AWBArrowType arrowType, AWBArrowHeadType arrowHeadType, AWBArrowLineShapeType arrowLineShapeType);
CGFloat AWBArrowHeadLineThickness(CGFloat length, AWBArrowThicknessType thicknessType, AWBArrowHeadType arrowHeadType);
CGFloat AWBArrowLineThickness(CGFloat length, AWBArrowThicknessType thicknessType, AWBArrowLineShapeType arrowLineShapeType);
CGFloat AWBArrowHeadWidth(CGFloat length, AWBArrowThicknessType thicknessType, AWBArrowHeadType arrowHeadType, AWBArrowLineShapeType arrowLineShapeType);
CGFloat AWBArrowHeadHeight(CGFloat length, AWBArrowThicknessType thicknessType, AWBArrowHeadType arrowHeadType, AWBArrowLineShapeType arrowLineShapeType);
AWBCGMargin AWBArrowMarginOffset(CGFloat arrowHeadWidth, CGFloat arrowHeadHeight, CGFloat lineThickness, AWBArrowType arrowType, AWBArrowThicknessType thicknessType, AWBArrowHeadType arrowHeadType, AWBArrowLineShapeType arrowLineShapeType);
void AWBCGAddArrowToPoint(CGContextRef context, CGFloat x, CGFloat y, CGFloat length, AWBArrowThicknessType thicknessType, AWBArrowType arrowType, AWBArrowHeadType arrowHeadType, AWBArrowLineShapeType arrowLineShapeType, AWBArrowLineStrokeType arrowLineStrokeType);
void AWBCGAddArrowHeadToPoint(CGContextRef context, CGFloat x, CGFloat y, CGFloat arrowHeadWidth, CGFloat arrowHeadHeight, AWBArrowHeadType arrowHeadType, BOOL leftSided, BOOL verticalOrientation, CGFloat lineThickness);
void AWBCGAddArrowLineToPoint(CGContextRef context, CGFloat x, CGFloat y, CGFloat arrowLength, CGFloat lineThickness, AWBArrowLineShapeType arrowLineShapeType, AWBArrowLineStrokeType arrowLineStrokeType, CGFloat xCurveEnd, CGFloat yCurveEnd);
