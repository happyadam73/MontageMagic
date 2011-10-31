//
//  AWBArrowDrawing.m
//  Collage Maker
//
//  Created by Adam Buckley on 30/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBArrowDrawing.h"



CGSize AWBCGArrowSuggestedSize(CGFloat length, AWBArrowThicknessType thicknessType, AWBArrowType arrowType, AWBArrowHeadType arrowHeadType, AWBArrowLineShapeType arrowLineShapeType)
{
    CGSize suggestedSize = CGSizeMake(length, length);
    
    CGFloat arrowLineThickness = AWBArrowLineThickness(length, thicknessType, arrowLineShapeType);
    CGFloat arrowHeadWidth = AWBArrowHeadWidth(length, thicknessType, arrowHeadType, arrowLineShapeType);
    CGFloat arrowHeadHeight = AWBArrowHeadHeight(length, thicknessType, arrowHeadType, arrowLineShapeType);
    AWBCGMargin marginOffset = AWBArrowMarginOffset(arrowHeadWidth, arrowHeadHeight, arrowLineThickness, arrowType, thicknessType, arrowHeadType, arrowLineShapeType);

    switch (arrowLineShapeType) {
        case kAWBArrowLineShapeTypeStraightLine:
            suggestedSize.height = arrowHeadHeight + marginOffset.yTop + marginOffset.yBottom;
            break;
        case kAWBArrowLineShapeTypeQuarterCircle:
            break;
        case kAWBArrowLineShapeTypeHalfCircle:
            suggestedSize.height = ((length - (marginOffset.xLeft + marginOffset.xRight))/2.0) + (arrowLineThickness/2.0) + marginOffset.yTop + 1.0;
            break;            
        case kAWBArrowLineShapeTypeBezierCurve:
            suggestedSize.height = (length/2.0) + marginOffset.yTop + marginOffset.yBottom + 1.0;
            break;
        default:
            break;
    }
    
    return suggestedSize;
}

CGFloat AWBArrowHeadLineThickness(CGFloat length, AWBArrowThicknessType thicknessType, AWBArrowHeadType arrowHeadType)
{
    CGFloat arrowHeadLineThickness;
    CGFloat lineThickness;
    
    switch (thicknessType) {
        case kAWBArrowThicknessTypeThin:
            arrowHeadLineThickness = 2.0;
            break;
        case kAWBArrowThicknessTypeMedium:
            arrowHeadLineThickness = 2.0;
            lineThickness = (length/15.0);
            if (arrowHeadType == kAWBArrowHeadTypeLined) {
                arrowHeadLineThickness = (lineThickness/2.0);
            }            
            break;
        case kAWBArrowThicknessTypeThick:
            arrowHeadLineThickness = 2.0;
            lineThickness = (length/7.0);
            if (arrowHeadType == kAWBArrowHeadTypeLined) {
                arrowHeadLineThickness = (lineThickness/2.0);
            }            
            break;
    }  
    
    return arrowHeadLineThickness;
}

CGFloat AWBArrowLineThickness(CGFloat length, AWBArrowThicknessType thicknessType, AWBArrowLineShapeType arrowLineShapeType)
{
    CGFloat arrowLineThickness;
    
    switch (thicknessType) {
        case kAWBArrowThicknessTypeThin:
            arrowLineThickness = 2.0;
            break;
        case kAWBArrowThicknessTypeMedium:
            if (arrowLineShapeType == kAWBArrowLineShapeTypeBezierCurve) {
                arrowLineThickness = (length/25.0);
            } else if (arrowLineShapeType == kAWBArrowLineShapeTypeHalfCircle) {
                arrowLineThickness = (length/20.0);
            } else {
                arrowLineThickness = (length/15.0);
            }
            break;
        case kAWBArrowThicknessTypeThick:
            if (arrowLineShapeType == kAWBArrowLineShapeTypeBezierCurve) {
                arrowLineThickness = (length/14.0);
            } else if (arrowLineShapeType == kAWBArrowLineShapeTypeHalfCircle) {
                arrowLineThickness = (length/10.0);
            } else {
                arrowLineThickness = (length/7.0);
            }
            break;
    }  
    
    return arrowLineThickness;
}

CGFloat AWBArrowHeadWidth(CGFloat length, AWBArrowThicknessType thicknessType, AWBArrowHeadType arrowHeadType, AWBArrowLineShapeType arrowLineShapeType)
{
    CGFloat arrowHeadWidth;
    
    switch (thicknessType) {
        case kAWBArrowThicknessTypeThin:
            arrowHeadWidth = length/13.0;
            break;
        case kAWBArrowThicknessTypeMedium:
            arrowHeadWidth = 2.0 * (length/15.0);
            break;
        case kAWBArrowThicknessTypeThick:
            arrowHeadWidth = 2.0 * (length/7.0);
            break;
    } 
    
    if (arrowLineShapeType == kAWBArrowLineShapeTypeHalfCircle) {
        if (arrowHeadType == kAWBArrowHeadTypeLined) {
            arrowHeadWidth *= 0.5;
        } else {
            arrowHeadWidth *= 0.75;
        }
    } else if (arrowLineShapeType == kAWBArrowLineShapeTypeBezierCurve) {
        arrowHeadWidth *= 0.5;
    }
    
    return MAX(11.0, arrowHeadWidth);
}

CGFloat AWBArrowHeadHeight(CGFloat length, AWBArrowThicknessType thicknessType, AWBArrowHeadType arrowHeadType, AWBArrowLineShapeType arrowLineShapeType)
{
    CGFloat arrowHeadHeight;
    
    switch (thicknessType) {
        case kAWBArrowThicknessTypeThin:
            arrowHeadHeight = length/13.0;
            break;
        case kAWBArrowThicknessTypeMedium:
            arrowHeadHeight = 2.0 * (length/15.0);
            break;
        case kAWBArrowThicknessTypeThick:
            arrowHeadHeight = 2.0 * (length/7.0);
            break;
    } 
    
    if ((arrowHeadType == kAWBArrowHeadTypeLined) && (arrowLineShapeType == kAWBArrowLineShapeTypeQuarterCircle)) {
        arrowHeadHeight *= 1.5;
    } else if ((arrowHeadType == kAWBArrowHeadTypeEmptyArrow) || (arrowHeadType == kAWBArrowHeadTypeFilledArrow)) {
        if (arrowLineShapeType != kAWBArrowLineShapeTypeBezierCurve) {
            arrowHeadHeight *= 1.3;            
        }
    } 
    
    return MAX(11.0, arrowHeadHeight);
}

AWBCGMargin AWBArrowMarginOffset(CGFloat arrowHeadWidth, CGFloat arrowHeadHeight, CGFloat lineThickness, AWBArrowType arrowType, AWBArrowThicknessType thicknessType, AWBArrowHeadType arrowHeadType, AWBArrowLineShapeType arrowLineShapeType)
{
    AWBCGMargin marginOffset;
    
    switch (arrowLineShapeType) {
        case kAWBArrowLineShapeTypeStraightLine:
            if (arrowType == kAWBArrowTypeDoubleHeaded) {
                switch (arrowHeadType) {
                    case kAWBArrowHeadTypeEmptyTriangle:
                    case kAWBArrowHeadTypeFilledTriangle:
                        marginOffset.xLeft = arrowHeadWidth;
                        break;
                    case kAWBArrowHeadTypeEmptyArrow:
                    case kAWBArrowHeadTypeFilledArrow:
                        marginOffset.xLeft = (arrowHeadWidth/2.0);
                        break;
                    case kAWBArrowHeadTypeLined:
                        marginOffset.xLeft = lineThickness;
                        break;
                }  
            } else {
                marginOffset.xLeft = 0.0;
            }
            
            if (arrowType == kAWBArrowTypeNone) {
                marginOffset.xRight = 0.0;
            } else {
                switch (arrowHeadType) {
                    case kAWBArrowHeadTypeEmptyTriangle:
                    case kAWBArrowHeadTypeFilledTriangle:
                        marginOffset.xRight = arrowHeadWidth;
                        break;
                    case kAWBArrowHeadTypeEmptyArrow:
                    case kAWBArrowHeadTypeFilledArrow:
                        marginOffset.xRight = (arrowHeadWidth/2.0);
                        break;
                    case kAWBArrowHeadTypeLined:
                        marginOffset.xRight = lineThickness;
                        break;
                }  
            }
            
            marginOffset.yTop = MAX(0.0, ((25.0 - arrowHeadHeight)/2.0));
            marginOffset.yBottom = marginOffset.yTop;
            break;
        case kAWBArrowLineShapeTypeQuarterCircle:
            if (arrowType == kAWBArrowTypeNone) {
                marginOffset.xLeft = lineThickness/2.0;
                marginOffset.xRight = 0.0;
                marginOffset.yTop = 0.0;                    
                marginOffset.yBottom = lineThickness/2.0;
            } else {
                switch (arrowHeadType) {
                    case kAWBArrowHeadTypeEmptyTriangle:
                    case kAWBArrowHeadTypeFilledTriangle:
                        marginOffset.xLeft = arrowHeadHeight/2.0;
                        marginOffset.xRight = arrowHeadWidth;
                        marginOffset.yTop = arrowHeadWidth;
                        marginOffset.yBottom = arrowHeadHeight/2.0;
                        break;
                    case kAWBArrowHeadTypeEmptyArrow:
                    case kAWBArrowHeadTypeFilledArrow:
                        marginOffset.xLeft = arrowHeadHeight/2.0;
                        marginOffset.xRight = arrowHeadWidth/2.0;
                        marginOffset.yTop = arrowHeadWidth/2.0;                    
                        marginOffset.yBottom = arrowHeadHeight/2.0;                    
                        break;
                    case kAWBArrowHeadTypeLined:
                        marginOffset.xLeft = arrowHeadHeight/2.0;
                        marginOffset.xRight = lineThickness;
                        marginOffset.yTop = lineThickness;                    
                        marginOffset.yBottom = arrowHeadHeight/2.0;                    
                        break;
                }
            }
            break;
        case kAWBArrowLineShapeTypeHalfCircle:
            if (arrowType == kAWBArrowTypeNone) {
                marginOffset.xLeft = lineThickness/2.0;
                marginOffset.xRight = lineThickness/2.0;
                marginOffset.yTop = 0.0;                    
                marginOffset.yBottom = 0.0;
            } else {
                switch (arrowHeadType) {
                    case kAWBArrowHeadTypeEmptyTriangle:
                    case kAWBArrowHeadTypeFilledTriangle:
                        marginOffset.xLeft = arrowHeadHeight/2.0;
                        marginOffset.xRight = arrowHeadHeight/2.0;
                        marginOffset.yTop = arrowHeadWidth;
                        marginOffset.yBottom = 0.0;
                        break;
                    case kAWBArrowHeadTypeEmptyArrow:
                    case kAWBArrowHeadTypeFilledArrow:
                        marginOffset.xLeft = arrowHeadHeight/2.0;
                        marginOffset.xRight = arrowHeadHeight/2.0;
                        marginOffset.yTop = arrowHeadWidth/2.0;                    
                        marginOffset.yBottom = 0.0;                    
                        break;
                    case kAWBArrowHeadTypeLined:
                        marginOffset.xLeft = arrowHeadHeight/2.0;
                        marginOffset.xRight = arrowHeadHeight/2.0;
                        marginOffset.yTop = lineThickness;                    
                        marginOffset.yBottom = 0.0;                    
                        break;
                }
            }
            break;
        case kAWBArrowLineShapeTypeBezierCurve:
            if (arrowType == kAWBArrowTypeNone) {
                marginOffset.xLeft = 0.0;
                marginOffset.xRight = 0.0;
                marginOffset.yTop = 0.0;                    
                marginOffset.yBottom = lineThickness/2.0;
            } else {
                switch (arrowHeadType) {
                    case kAWBArrowHeadTypeEmptyTriangle:
                    case kAWBArrowHeadTypeFilledTriangle:
                        marginOffset.xLeft = lineThickness/2.0;
                        marginOffset.xRight = arrowHeadWidth;
                        marginOffset.yTop = arrowHeadHeight/2.0;
                        marginOffset.yBottom = arrowHeadHeight/2.0;
                        break;
                    case kAWBArrowHeadTypeEmptyArrow:
                    case kAWBArrowHeadTypeFilledArrow:
                        marginOffset.xLeft = lineThickness/2.0;
                        marginOffset.xRight = arrowHeadWidth/2.0;
                        marginOffset.yTop = arrowHeadHeight/2.0;
                        marginOffset.yBottom = arrowHeadHeight/2.0;
                        break;
                    case kAWBArrowHeadTypeLined:
                        marginOffset.xLeft = lineThickness/2.0;
                        marginOffset.xRight = lineThickness;
                        marginOffset.yTop = arrowHeadHeight/2.0;
                        marginOffset.yBottom = arrowHeadHeight/2.0;
                        break;
                }
                
                if (arrowType == kAWBArrowTypeSingleHeaded) {
                    marginOffset.yTop = 0.0;
                }
            }
            break;
        default:
            marginOffset.xLeft = 0.0;
            marginOffset.xRight = 0.0;
            marginOffset.yTop = 0.0;                    
            marginOffset.yBottom = 0.0;
            break;
    }
  
    return marginOffset;
}

void AWBCGAddArrowToPoint(CGContextRef context, CGFloat x, CGFloat y, CGFloat length, AWBArrowThicknessType thicknessType, AWBArrowType arrowType, AWBArrowHeadType arrowHeadType, AWBArrowLineShapeType arrowLineShapeType, AWBArrowLineStrokeType arrowLineStrokeType)
{
    CGPoint startPoint = CGPointZero;
    CGPoint leftArrowStartPoint = CGPointZero;
    CGPoint rightArrowStartPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    BOOL leftSided = NO;
    BOOL verticalOrientation = NO;
    CGFloat arrowLength = 0.0;
    CGFloat arrowLineThickness = AWBArrowLineThickness(length, thicknessType, arrowLineShapeType);
    CGFloat arrowHeadLineThickness = AWBArrowHeadLineThickness(length, thicknessType, arrowHeadType);
    CGFloat arrowHeadWidth = AWBArrowHeadWidth(length, thicknessType, arrowHeadType, arrowLineShapeType);
    CGFloat arrowHeadHeight = AWBArrowHeadHeight(length, thicknessType, arrowHeadType, arrowLineShapeType);
    AWBCGMargin marginOffset = AWBArrowMarginOffset(arrowHeadWidth, arrowHeadHeight, arrowLineThickness, arrowType, thicknessType, arrowHeadType, arrowLineShapeType);
    CGFloat yStart;
    
    switch (arrowLineShapeType) {
        case kAWBArrowLineShapeTypeStraightLine:    
            leftSided = YES;
            verticalOrientation = NO;
            arrowLength = length - marginOffset.xLeft - marginOffset.xRight;
            yStart = (((arrowHeadHeight + (marginOffset.yTop + marginOffset.yBottom))/2.0)+y);
            startPoint = CGPointMake((marginOffset.xLeft + x), yStart);
            endPoint = CGPointMake(x + length - marginOffset.xRight, yStart);
            leftArrowStartPoint = CGPointMake(startPoint.x + 1.0, startPoint.y);
            rightArrowStartPoint = CGPointMake(endPoint.x - 1.0, endPoint.y);                
            break;
        case kAWBArrowLineShapeTypeQuarterCircle:
            leftSided = YES;
            verticalOrientation = YES;
            arrowLength = length - (marginOffset.xLeft + marginOffset.xRight);
            startPoint = CGPointMake((marginOffset.xLeft + x),(marginOffset.yTop + y));
            endPoint = CGPointMake(x + length - marginOffset.xRight, y + length - marginOffset.yBottom);
            leftArrowStartPoint = CGPointMake(startPoint.x, startPoint.y + 1.0);
            rightArrowStartPoint = CGPointMake(endPoint.x - 1.0, endPoint.y);
            break;
        case kAWBArrowLineShapeTypeHalfCircle:
            leftSided = YES;
            verticalOrientation = YES;
            arrowLength = length - (marginOffset.xLeft + marginOffset.xRight);
            startPoint = CGPointMake((marginOffset.xLeft + x),(marginOffset.yTop + y));
            endPoint = CGPointMake(x + length - marginOffset.xRight, y + marginOffset.yTop);
            
            if (arrowHeadType == kAWBArrowHeadTypeLined) {
                leftArrowStartPoint = CGPointMake(startPoint.x, startPoint.y + 3.0);
                rightArrowStartPoint = CGPointMake(endPoint.x, endPoint.y + 3.0);                
            } else {
                leftArrowStartPoint = CGPointMake(startPoint.x, startPoint.y + 1.0);
                rightArrowStartPoint = CGPointMake(endPoint.x, endPoint.y + 1.0);
            }
            break;            
        case kAWBArrowLineShapeTypeBezierCurve:
            leftSided = NO;
            verticalOrientation = NO;
            if (arrowType == kAWBArrowTypeNone) {
                arrowLength = length;
            } else {
                arrowLength = length;
            }
            startPoint = CGPointMake(((length/4.0)+x), (marginOffset.yTop + y));  
            endPoint = CGPointMake(x + length - marginOffset.xRight, y + (arrowLength/2.0) + marginOffset.yTop);
            if ((arrowHeadType == kAWBArrowHeadTypeLined) && (thicknessType == kAWBArrowThicknessTypeThick)) {
                leftArrowStartPoint = CGPointMake(startPoint.x - 5.0, startPoint.y);
                rightArrowStartPoint = CGPointMake(endPoint.x - 5.0, endPoint.y);
            } else {
                leftArrowStartPoint = CGPointMake(startPoint.x - 1.0, startPoint.y);
                rightArrowStartPoint = CGPointMake(endPoint.x - 1.0, endPoint.y);
            }
            break;
        default:
            break;
    }
    
    //first arrow head if double ended arrow
    if (arrowType == kAWBArrowTypeDoubleHeaded) {
        AWBCGAddArrowHeadToPoint(context, leftArrowStartPoint.x, leftArrowStartPoint.y, arrowHeadWidth, arrowHeadHeight, arrowHeadType, leftSided, verticalOrientation, arrowHeadLineThickness);
    }
    
    //now arrow line (for all types)
    AWBCGAddArrowLineToPoint(context, startPoint.x, startPoint.y, arrowLength, arrowLineThickness, arrowLineShapeType, arrowLineStrokeType, endPoint.x, endPoint.y);

    //finally the right arrow head which is for single and double headed arrow types
    if (arrowType != kAWBArrowTypeNone) {
        leftSided = NO;
        verticalOrientation = NO;
        if (arrowLineShapeType == kAWBArrowLineShapeTypeHalfCircle) {
            leftSided = YES;
            verticalOrientation = YES;
        }
        AWBCGAddArrowHeadToPoint(context, rightArrowStartPoint.x, rightArrowStartPoint.y, arrowHeadWidth, arrowHeadHeight, arrowHeadType, leftSided, verticalOrientation, arrowHeadLineThickness);
    }
}

void AWBCGAddArrowHeadToPoint(CGContextRef context, CGFloat x, CGFloat y, CGFloat arrowHeadWidth, CGFloat arrowHeadHeight, AWBArrowHeadType arrowHeadType, BOOL leftSided, BOOL verticalOrientation, CGFloat lineThickness)
{       
    CGContextSetLineWidth(context, lineThickness);

    if (leftSided && !verticalOrientation) {
        arrowHeadWidth = -arrowHeadWidth;
        lineThickness = -lineThickness;
    }
    
    CGFloat xt = 0.0;
    CGFloat yt = 1.0;
    
    if (verticalOrientation) {
        xt = 1.0;
        yt = 0.0;
    }
    
    switch (arrowHeadType) {
        case kAWBArrowHeadTypeEmptyTriangle:
        case kAWBArrowHeadTypeFilledTriangle:
            CGContextMoveToPoint(context, x - (xt * (arrowHeadHeight/2.0)), y - (yt * (arrowHeadHeight/2.0)));
            CGContextAddLineToPoint(context, x + (yt * arrowHeadWidth), y - (xt * arrowHeadWidth));
            CGContextAddLineToPoint(context, x + (xt * (arrowHeadHeight/2.0)), y + (yt * (arrowHeadHeight/2.0)));            
            CGContextClosePath(context);
            break;
        case kAWBArrowHeadTypeEmptyArrow:
        case kAWBArrowHeadTypeFilledArrow:
            CGContextMoveToPoint(context, x - (yt * (arrowHeadWidth/2.0)) - (xt * (arrowHeadHeight/2.0)), y - (yt * (arrowHeadHeight/2.0)) + (xt * (arrowHeadWidth/2.0)));
            CGContextAddLineToPoint(context, x + (yt * (arrowHeadWidth/2.0)), y - (xt * (arrowHeadWidth/2.0)));           
            CGContextAddLineToPoint(context, x - (yt * (arrowHeadWidth/2.0)) + (xt * (arrowHeadHeight/2.0)), y + (yt * (arrowHeadHeight/2.0)) + (xt * (arrowHeadWidth/2.0)));             
            CGContextAddLineToPoint(context, x, y);             
            CGContextClosePath(context);
            break;
        case kAWBArrowHeadTypeLined:
            CGContextMoveToPoint(context, x - (yt * (arrowHeadWidth - lineThickness)) - (xt * (arrowHeadHeight/2.0)), y - (yt * (arrowHeadHeight/2.0)) + (xt * (arrowHeadWidth - lineThickness)));
            CGContextAddLineToPoint(context, x + (yt * lineThickness), y - (xt * lineThickness));
            CGContextAddLineToPoint(context, x - (yt * (arrowHeadWidth - lineThickness)) + (xt * (arrowHeadHeight/2.0)), y + (yt * (arrowHeadHeight/2.0)) + (xt * (arrowHeadWidth - lineThickness))); 
            break;
    }  
        
    if ((arrowHeadType == kAWBArrowHeadTypeFilledArrow) || (arrowHeadType == kAWBArrowHeadTypeFilledTriangle)) {
        CGContextFillPath(context);
    } else {
        CGContextSetLineDash(context, 0.0, NULL, 0);        
        CGContextStrokePath(context);
    }
}

void AWBCGAddArrowLineToPoint(CGContextRef context, CGFloat x, CGFloat y, CGFloat arrowLength, CGFloat lineThickness, AWBArrowLineShapeType arrowLineShapeType, AWBArrowLineStrokeType arrowLineStrokeType, CGFloat xCurveEnd, CGFloat yCurveEnd)
{
    CGContextSetLineWidth(context, lineThickness);
    if (arrowLineStrokeType == kAWBArrowLineStrokeTypeDashed) {
        CGFloat dashes[] = {8.0, 3.0};
        CGContextSetLineDash(context, 0.0, dashes, 2);        
    } else if (arrowLineStrokeType == kAWBArrowLineStrokeTypeDotted) {
        CGFloat dashes[] = {1.5, 1.5};
        CGContextSetLineDash(context, 0.0, dashes, 2);
    } else {
        CGContextSetLineDash(context, 0.0, NULL, 0);
    }
    
    switch (arrowLineShapeType) {
        case kAWBArrowLineShapeTypeStraightLine:
            CGContextMoveToPoint(context, x, y);
            CGContextAddLineToPoint(context, x + arrowLength, y);
            break;
        case kAWBArrowLineShapeTypeQuarterCircle:
            CGContextAddArc(context, x + arrowLength, y, arrowLength, M_PI, M_PI_2, 1);
            break;
        case kAWBArrowLineShapeTypeHalfCircle:
            CGContextAddArc(context, x + (arrowLength/2.0), y, (arrowLength/2.0), M_PI, 0, 1);            
            break;
        case kAWBArrowLineShapeTypeBezierCurve:
            CGContextMoveToPoint(context, x, y);    
            CGContextAddCurveToPoint(context, x - (arrowLength/3.0), (arrowLength/5.0),  x - (arrowLength/3.0), (arrowLength/2.0), xCurveEnd, yCurveEnd);             
            break;
        default:
            break;
    }  
    
    CGContextStrokePath(context);   
}

