//
//  CollageMakeViewController+Gestures.m
//  Collage Maker
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController+Gestures.h"
#import "AWBTransforms.h"
#import "AWBCustomView.h"
#import "CollageMakerViewController+Toolbar.h"
#import "CollageMakerViewController+UI.h"
#import "CollageMakerViewController+Edit.h"

@implementation CollageMakerViewController (Gestures) 

- (void)initialiseGestureRecognizers
{
    UIRotationGestureRecognizer *rotationRegonizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotations:)];
    self.rotationGestureRecognizer = rotationRegonizer;
    self.rotationGestureRecognizer.delegate = self;
    [rotationRegonizer release];
    [self.canvasView addGestureRecognizer:self.rotationGestureRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    self.panGestureRecognizer = panRecognizer;
    [panRecognizer release];
    [self.canvasView addGestureRecognizer:self.panGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinches:)];
    self.pinchGestureRecognizer = pinchRecognizer;
    self.pinchGestureRecognizer.delegate = self;
    [pinchRecognizer release];
    [self.canvasView addGestureRecognizer:self.pinchGestureRecognizer]; 
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTaps:)];
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    doubleTapRecognizer.numberOfTapsRequired = 2;
    self.doubleTapGestureRecognizer = doubleTapRecognizer;
    [doubleTapRecognizer release];
    [self.canvasView addGestureRecognizer:self.doubleTapGestureRecognizer]; 

    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTaps:)];
    singleTapRecognizer.numberOfTouchesRequired = 1;
    singleTapRecognizer.numberOfTapsRequired = 1;
    self.singleTapGestureRecognizer = singleTapRecognizer;
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    [singleTapRecognizer release];
    [self.canvasView addGestureRecognizer:self.singleTapGestureRecognizer]; 
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftAndRightSwipes:)];
    swipeRecognizer.numberOfTouchesRequired = 2;
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    self.swipeGestureRecognizer = swipeRecognizer;
    [swipeRecognizer release];
    [self.canvasView addGestureRecognizer:self.swipeGestureRecognizer];    
}

- (void)deallocGestureRecognizers
{
    [rotationGestureRecognizer release];
    [panGestureRecognizer release];
    [pinchGestureRecognizer release];
    [singleTapGestureRecognizer release];
    [doubleTapGestureRecognizer release];
    [swipeGestureRecognizer release];
}

- (void)dereferenceGestureRecognizers
{
    self.rotationGestureRecognizer = nil;
    self.panGestureRecognizer = nil;
    self.pinchGestureRecognizer = nil;
    self.singleTapGestureRecognizer = nil;
    self.doubleTapGestureRecognizer = nil;
    self.swipeGestureRecognizer = nil;    
}

- (void)handleRotations:(UIRotationGestureRecognizer *)paramSender
{
    if (self.isCollageInEditMode || self.collageObjectLocator.lockCollage) {
        return;
    } else {
        if (!self.isImporting) {
            [self setNavigationBarsHidden:YES animated:NO];
        }
    }
    
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        if (!currentlyPinching) {
            CGPoint point = [paramSender locationInView:self.canvasView]; 
            capturedView = [self.canvasView topTransformableViewAtPoint:point];            
        }
    }
    
    if (capturedView) {
        if (paramSender.state == UIGestureRecognizerStateBegan) {
            currentlyRotating = YES;
        }
        [self.canvasView bringSubviewToFront:capturedView];
        if (paramSender.state == UIGestureRecognizerStateBegan) {
            [capturedView applyPendingRotationToCapturedView];
        } else {
            capturedView.pendingRotationAngleInRadians = paramSender.rotation;
        }
        [capturedView rotateAndScaleWithSnapToGrid:self.collageObjectLocator.snapToGrid gridSize:self.collageObjectLocator.snapToGridSize snapRotation:self.collageObjectLocator.snapRotation];   
        
        if ((paramSender.state == UIGestureRecognizerStateEnded) || (paramSender.state == UIGestureRecognizerStateFailed) || (paramSender.state == UIGestureRecognizerStateCancelled)) {
            currentlyRotating = NO;
        } 
    }   
}

- (void)handlePinches:(UIPinchGestureRecognizer *)paramSender
{
    if (self.isCollageInEditMode || self.collageObjectLocator.lockCollage) {
        return;
    } else {
        if (!self.isImporting) {
            [self setNavigationBarsHidden:YES animated:NO];
        }
    }
    
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        if (!currentlyRotating) {
            CGPoint point = [paramSender locationInView:self.canvasView]; 
            capturedView = [self.canvasView topTransformableViewAtPoint:point];            
        }
    }
    
    if (capturedView) {
        if (paramSender.state == UIGestureRecognizerStateBegan) {
            currentlyPinching = YES;
        }
        [self.canvasView bringSubviewToFront:capturedView];
        
        if ((paramSender.state == UIGestureRecognizerStateBegan) && (capturedView.currentScale != 0.0)) {
            paramSender.scale = capturedView.currentScale;
        }  else {
            capturedView.currentScale = paramSender.scale;
        }
        [capturedView rotateAndScaleWithSnapToGrid:self.collageObjectLocator.snapToGrid gridSize:self.collageObjectLocator.snapToGridSize snapRotation:self.collageObjectLocator.snapRotation];  
        
        if ((paramSender.state == UIGestureRecognizerStateEnded) || (paramSender.state == UIGestureRecognizerStateFailed) || (paramSender.state == UIGestureRecognizerStateCancelled)) {
            currentlyPinching = NO;
        }
    }
}

- (void)handlePanGestures:(UIPanGestureRecognizer *)paramSender
{
    if (self.collageObjectLocator.lockCollage) {
        return;
    }
    
    if (!self.isCollageInEditMode && !self.isImporting) {
        [self setNavigationBarsHidden:YES animated:NO];
    }
    
    CGPoint point = [paramSender locationInView:self.canvasView]; 
    
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        capturedView = [self.canvasView topTransformableViewAtPoint:point];
        if (capturedView) {
            [capturedView applyPendingRotationToCapturedView];
            capturedCenterOffset = AWBTransformedViewCenterOffsetFromPoint(capturedView, [paramSender locationInView:capturedView]);
        }
    }
    
    if (capturedView) {
        [self.canvasView bringSubviewToFront:capturedView];        
        if ((paramSender.state != UIGestureRecognizerStateEnded) && (paramSender.state != UIGestureRecognizerStateFailed) && (paramSender.state != UIGestureRecognizerStateCancelled)) { 
            CGFloat x = point.x - capturedCenterOffset.x;
            CGFloat y = point.y - capturedCenterOffset.y;
            if (self.collageObjectLocator.snapToGrid && (self.collageObjectLocator.snapToGridSize > 0.0)) {
                x = AWBQuantizeFloat(x, (self.collageObjectLocator.snapToGridSize/2.0), NO);
                y = AWBQuantizeFloat(y, (self.collageObjectLocator.snapToGridSize/2.0), NO);                
            }
            
            capturedView.center = CGPointMake(x, y);
        }         
    }
}

- (void)handleSingleTaps:(UITapGestureRecognizer *)paramSender
{
    if (self.isCollageInEditMode) {
        CGPoint point = [paramSender locationInView:self.canvasView]; 
        UIView <AWBTransformableView> *view = [self.canvasView topTransformableViewAtPoint:point];
        if (view) {
            [self objectTappedInEditMode:view];            
        }
    } else {
        if (!self.isImporting) {
            [self setNavigationBarsHidden:!self.navigationController.navigationBar.hidden animated:self.isLevel1AnimationsEnabled];
        }        
    }
}

- (void)handleDoubleTaps:(UITapGestureRecognizer *)paramSender
{
    if (self.collageObjectLocator.lockCollage) {
        return;
    }
    
    if (paramSender.state == UIGestureRecognizerStateEnded) {

        if (!self.isCollageInEditMode && !self.isImporting) {
            [self setNavigationBarsHidden:YES animated:NO];
        }

        CGPoint point = [paramSender locationInView:self.canvasView]; 
        UIView <AWBTransformableView> *view = [self.canvasView topTransformableViewAtPoint:point];
        
        if (view) {
            if ([view isInFront]) {
                [self.canvasView sendSubviewToBack:view];
            } else {
                [self.canvasView bringSubviewToFront:view];                
            }
        }        
    }
}

- (void)handleLeftAndRightSwipes:(UISwipeGestureRecognizer *)paramSender
{
    if (self.collageObjectLocator.lockCollage) {
        return;
    }
    
    if (!self.isCollageInEditMode && !self.isImporting) {
        [self setNavigationBarsHidden:YES animated:NO];
    }
    
    CGPoint point = [paramSender locationInView:self.canvasView]; 
    UIView <AWBTransformableView> *view = [self.canvasView topTransformableViewAtPoint:point];
    
    if (view) {
        view.horizontalFlip = view.horizontalFlip ? NO : YES; 
        [view rotateAndScaleWithSnapToGrid:self.collageObjectLocator.snapToGrid gridSize:self.collageObjectLocator.snapToGridSize snapRotation:self.collageObjectLocator.snapRotation];       
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer 
{
    if ((gestureRecognizer == self.pinchGestureRecognizer) || (gestureRecognizer == self.rotationGestureRecognizer)) {
        if ((otherGestureRecognizer == self.pinchGestureRecognizer) || (otherGestureRecognizer == self.rotationGestureRecognizer)) {
            return YES;
        }
    }
    return NO;
}

@end
