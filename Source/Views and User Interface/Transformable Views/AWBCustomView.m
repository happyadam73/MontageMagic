//
//  AWBCustomView.m
//  Collage Maker
//
//  Created by Adam Buckley on 23/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "AWBCustomView.h"


@implementation AWBCustomView

@synthesize rotationAngleInRadians, currentScale, pendingRotationAngleInRadians, horizontalFlip;
@synthesize scaledSize;
@synthesize roundedBorder, viewBorderColor, viewShadowColor, addShadow, addBorder;
@synthesize roundedCornerSize, shadowOffsetRatio;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClearsContextBeforeDrawing:NO];
    }
    return self;
}

- (void)drawRect:(CGRect)rect  
{    
    //adjust bounded frame size to take into account the scale transform (don't need to do this for the frame size)
    CGFloat theta = [self rotationAngleInRadians] + [self pendingRotationAngleInRadians];
    
    CGMutablePathRef path = CGPathCreateMutable();
    AWBBuildRotatedBoundsPointsPath(path, self.scaledSize, theta, [self frame].size);
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ref, [UIColor redColor].CGColor);
    CGContextAddPath(ref, path);
    CGContextSetLineWidth(ref, 2.0);
    CGContextStrokePath(ref);
    CGPathRelease(path);
}

- (void)dealloc
{
    [viewShadowColor release];
    [viewBorderColor release];
    [super dealloc];
}

-(void)rotateAndScale
{    
//
}

- (void)rotateAndScaleWithSnapToGrid:(BOOL)snapToGrid gridSize:(CGFloat)gridSize snapRotation:(BOOL)snapRotation
{
//
}

- (CGFloat)quantisedRotation
{
    return rotationAngleInRadians+pendingRotationAngleInRadians;
}

- (CGFloat)quantisedScale
{
    return currentScale;
}

- (void)applyPendingRotationToCapturedView
{
    self.rotationAngleInRadians += self.pendingRotationAngleInRadians;
    self.pendingRotationAngleInRadians = 0.0;
}


@end
