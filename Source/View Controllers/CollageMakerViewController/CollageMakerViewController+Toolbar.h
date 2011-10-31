//
//  CollageMakerViewController+Toolbar.h
//  Collage Maker
//
//  Created by Adam Buckley on 11/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController.h"

@interface CollageMakerViewController (Toolbar) 

- (void)setToolbarForImporting;
- (void)setToolbarForEditMode;
- (void)resetToNormalToolbar;
- (NSArray *)normalToolbarButtons;
- (NSArray *)importingToolbarButtons;
- (NSArray *)editModeButtons;
- (void)insertBarButtonItem:(UIBarButtonItem *)button atIndex:(NSUInteger)index; 
- (void)removeBarButtonItem:(UIBarButtonItem *)button;
- (UISegmentedControl *)tintedSegmentedControlButtonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action;
- (void)updateTintedSegmentedControlButton:(UIBarButtonItem *)button withTitle:(NSString *)title;
- (CGPoint)deleteButtonApproxPosition;
- (UISegmentedControl *)memoryButtonControlWithColor:(UIColor *)color target:(id)target action:(SEL)action;

@end
