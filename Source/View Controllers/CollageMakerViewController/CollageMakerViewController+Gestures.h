//
//  CollageMakerViewController+Gestures.h
//  Collage Maker
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController.h"
#import "UIView+HitTest.h"
#import "UIView+Hierarchy.h"

@interface CollageMakerViewController (Gestures) <UIGestureRecognizerDelegate>

- (void)initialiseGestureRecognizers;
- (void)deallocGestureRecognizers;
- (void)dereferenceGestureRecognizers;

@end
