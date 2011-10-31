//
//  CollageMakerViewController+Edit.h
//  Collage Maker
//
//  Created by Adam Buckley on 12/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController.h"

@interface CollageMakerViewController (Edit) 

- (void)objectTappedInEditMode:(UIView <AWBTransformableView> *)view;
- (void)enableEditMode:(id)sender;
- (void)resetEditMode:(id)sender;
- (void)selectAllOrNoneInEditMode:(id)sender;
- (void)updateUserInterfaceWithTotalSelectedInEditMode;

@end
