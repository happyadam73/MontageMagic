//
//  AWBTransformableArrow.m
//  Collage Maker
//
//  Created by Adam Buckley on 30/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBTransformableArrowView.h"
#import "AWBTransforms.h"
#import "UIView+Animation.h"
#import "AWBArrowDrawing.h"
#define QUANTISED_ROTATION (M_PI_4/2.0)

@implementation AWBTransformableArrowView

@synthesize rotationAngleInRadians, currentScale, pendingRotationAngleInRadians, horizontalFlip;
@synthesize roundedBorder, viewBorderColor, viewShadowColor, addShadow, addBorder;
@synthesize totalLength, arrowColor, arrowType, arrowThicknessType, arrowHeadType, arrowLineShapeType, arrowLineStrokeType, arrowViewDelegate;  
@synthesize roundedCornerSize;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    CGFloat length = [aDecoder decodeFloatForKey:@"arrowLength"];
    UIColor *color = [aDecoder decodeObjectForKey:@"arrowColor"];
    AWBArrowType type = [aDecoder decodeIntegerForKey:@"arrowType"];
    AWBArrowThicknessType thicknessType = [aDecoder decodeIntegerForKey:@"arrowThicknessType"];
    AWBArrowHeadType headType = [aDecoder decodeIntegerForKey:@"arrowHeadType"];
    AWBArrowLineShapeType lineShapeType = [aDecoder decodeIntegerForKey:@"arrowLineShapeType"];
    AWBArrowLineStrokeType lineStrokeType = [aDecoder decodeIntegerForKey:@"arrowLineStrokeType"];
    CGFloat arrowOffsetX = [aDecoder decodeFloatForKey:@"arrowOffsetX"];
    CGFloat arrowOffsetY = [aDecoder decodeFloatForKey:@"arrowOffsetY"];
    CGFloat arrowRotation = [aDecoder decodeFloatForKey:@"arrowRotation"];
    CGFloat arrowScale = [aDecoder decodeFloatForKey:@"arrowScale"];
    BOOL arrowHFlip = [aDecoder decodeBoolForKey:@"arrowHFlip"];
    CGPoint offset = CGPointMake(arrowOffsetX, arrowOffsetY);
    
    self = [self initWithLength:length color:color type:type thickness:thicknessType arrowHead:headType arrowLineShape:lineShapeType arrowLineStroke:lineStrokeType];
    self.currentScale = arrowScale;
    self.rotationAngleInRadians = arrowRotation;
    self.horizontalFlip = arrowHFlip;
    [self setCenter:offset];
    [self rotateAndScale];
    
    return  self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self applyPendingRotationToCapturedView];
    
    [aCoder encodeFloat:self.totalLength forKey:@"arrowLength"];
    [aCoder encodeObject:self.arrowColor forKey:@"arrowColor"];
    [aCoder encodeInteger:self.arrowType forKey:@"arrowType"];
    [aCoder encodeInteger:self.arrowThicknessType forKey:@"arrowThicknessType"];
    [aCoder encodeInteger:self.arrowHeadType forKey:@"arrowHeadType"];
    [aCoder encodeInteger:self.arrowLineShapeType forKey:@"arrowLineShapeType"];
    [aCoder encodeInteger:self.arrowLineStrokeType forKey:@"arrowLineStrokeType"];
    [aCoder encodeFloat:self.center.x forKey:@"arrowOffsetX"];
    [aCoder encodeFloat:self.center.y forKey:@"arrowOffsetY"];
    [aCoder encodeFloat:self.quantisedRotation forKey:@"arrowRotation"];
    [aCoder encodeFloat:self.quantisedScale forKey:@"arrowScale"];
    [aCoder encodeBool:self.horizontalFlip forKey:@"arrowHFlip"];
}

- (id)initWithLength:(CGFloat)length color:(UIColor *)color type:(AWBArrowType)type thickness:(AWBArrowThicknessType)thicknessType arrowHead:(AWBArrowHeadType)headType arrowLineShape:(AWBArrowLineShapeType)lineShapeType arrowLineStroke:(AWBArrowLineStrokeType)lineStroke
{
    CGSize frameSize = AWBCGArrowSuggestedSize(length, thicknessType, type, headType, lineShapeType);
    
    self = [super initWithFrame:CGRectMake(0.0, 0.0, frameSize.width, frameSize.height)];
    if (self) {
        // Initialization code
        initialHeight = frameSize.height;
        currentScale = 1.0;
        rotationAngleInRadians = 0.0;
        pendingRotationAngleInRadians = 0.0;
        horizontalFlip = NO;
        rotationAndScaleCurrentlyQuantised = NO;
        totalLength = length;
        minScale = 0.45;
        maxScale = 8.0;
        arrowType = type;
        arrowThicknessType = thicknessType;
        arrowHeadType = headType;
        arrowLineShapeType = lineShapeType;
        arrowLineStrokeType = lineStroke;
        arrowColor = [color retain];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClearsContextBeforeDrawing:NO];
        CATiledLayer *layerForView = (CATiledLayer *)self.layer;
        layerForView.levelsOfDetailBias = 4;
    }
    return self;    
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

- (void)setArrowColor:(UIColor *)color
{
    [color retain];
    [arrowColor release];
    arrowColor = color;
    [self setNeedsDisplay];
}

- (void)setArrowLineShapeType:(AWBArrowLineShapeType)lineShapeType
{
    arrowLineShapeType = lineShapeType;
    [self adjustFrame];
    [self setNeedsDisplay];
}

- (void)setTotalLength:(CGFloat)length
{
    totalLength = length;
    [self adjustFrame];
    [self setNeedsDisplay];   
}

- (void)setArrowThicknessType:(AWBArrowThicknessType)thicknessType
{
    arrowThicknessType = thicknessType;
    [self adjustFrame];
    [self setNeedsDisplay];     
}

- (void)setArrowType:(AWBArrowType)type
{
    arrowType = type;
    [self adjustFrame];
    [self setNeedsDisplay];     
}

- (void)setArrowHeadType:(AWBArrowHeadType)headType
{
    arrowHeadType = headType;
    [self adjustFrame];
    [self setNeedsDisplay];     
}

- (void)setArrowLineStrokeType:(AWBArrowLineStrokeType)lineStrokeType
{
    arrowLineStrokeType = lineStrokeType;
    [self adjustFrame];
    [self setNeedsDisplay];     
}

- (void)adjustFrame
{
    CGRect currentFrame = [self frame];
    CGSize frameSize = AWBCGArrowSuggestedSize(totalLength, arrowThicknessType, arrowType, arrowHeadType, arrowLineShapeType);
    currentFrame.size = frameSize;
    [self setFrame:currentFrame];
}

- (void)drawRect:(CGRect)rect  
{       
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [arrowColor CGColor]);
    CGContextSetFillColorWithColor(context, [arrowColor CGColor]);

    AWBCGAddArrowToPoint(context, 0.0, 0.0, totalLength, arrowThicknessType, arrowType, arrowHeadType, arrowLineShapeType, arrowLineStrokeType);    
}

- (void)dealloc
{
    [arrowColor release];
    [viewShadowColor release];
    [viewBorderColor release];
    [super dealloc];
}

-(void)rotateAndScale
{    
    [self rotateAndScaleWithSnapToGrid:NO gridSize:0.0];
}

- (void)rotateAndScaleWithSnapToGrid:(BOOL)snapToGrid gridSize:(CGFloat)gridSize
{
    CGFloat rotation = rotationAngleInRadians+pendingRotationAngleInRadians;
    CGFloat scale = currentScale;
    
    if (snapToGrid && (gridSize > 0.0) && (initialHeight > 0.0)) {
        CGFloat quantisedHeight = AWBQuantizeFloat((scale * initialHeight), gridSize, YES);
        scale = quantisedHeight / initialHeight;
        rotation = AWBQuantizeFloat(rotation, QUANTISED_ROTATION, NO);
        rotationAndScaleCurrentlyQuantised = YES;
        currentQuantisedRotation = rotation;
        currentQuantisedScale = scale;
    } else {
        rotationAndScaleCurrentlyQuantised = NO;
    }
    
    self.transform = AWBCGAffineTransformMakeRotationAndScale(rotation, scale, horizontalFlip);
}

- (CGFloat)quantisedRotation
{
    if (rotationAndScaleCurrentlyQuantised) {
        return currentQuantisedRotation;
    } else {
        return rotationAngleInRadians+pendingRotationAngleInRadians;
    }
}

- (CGFloat)quantisedScale
{
    if (rotationAndScaleCurrentlyQuantised) {
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

+ (Class)layerClass {
    return [CATiledLayer class]; 
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Arrow Length: %f Type: %d Thickness: %d Line Shape: %d Head Type: %d Line Stroke: %d Color: %@", self.totalLength, self.arrowType, self.arrowThicknessType, self.arrowLineShapeType, self.arrowHeadType, self.arrowLineStrokeType, self.arrowColor];
}

- (void)arrowViewClicked:(id)sender 
{
    CGColorRef tempColor = [self.arrowColor CGColor];
    self.arrowColor = [UIColor clearColor];
    self.arrowColor = [UIColor colorWithCGColor:tempColor];
    
    if (arrowViewDelegate && [arrowViewDelegate respondsToSelector:@selector(awbTransformableArrowViewClicked:)]) {
		[arrowViewDelegate performSelector:@selector(awbTransformableArrowViewClicked:) withObject:self withObject:nil];
	} 
}

@end
