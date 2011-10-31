//
//  CollageMakerViewController+Edit.m
//  Collage Maker
//
//  Created by Adam Buckley on 12/09/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController+Edit.h"
#import "CollageMakerViewController+UI.h"
#import "AWBTransformableImageView.h"
#import "CollageMakerViewController+Toolbar.h"

@implementation CollageMakerViewController (Edit)

- (void)objectTappedInEditMode:(UIView <AWBTransformableView> *)view
{
    if (view.alpha == SELECTED_ALPHA) {
        view.alpha = UNSELECTED_ALPHA;
        //deselecting
        totalSelectedInEditMode -= 1;
        if ([view isKindOfClass:[AWBTransformableLabel class]]) {
            totalSelectedLabelsInEditMode -= 1;
        }
    } else {
        view.alpha = SELECTED_ALPHA;
        totalSelectedInEditMode += 1;
        if ([view isKindOfClass:[AWBTransformableLabel class]]) {
            totalSelectedLabelsInEditMode += 1;
        }
    }    
    [self updateUserInterfaceWithTotalSelectedInEditMode];
}

- (void)enableEditMode:(id)sender
{
    if (!self.isCollageInEditMode && !self.isImporting) {
        self.isCollageInEditMode = YES;
        [self dismissAllActionSheetsAndPopovers];
        self.navigationItem.title = @"Tap Objects to Select";
        self.navigationItem.rightBarButtonItem = self.cancelButton;
        [self setToolbarForEditMode];
        self.doubleTapGestureRecognizer.enabled = NO;

        self.selectNoneOrAllButton.title = @"Select All";
        
        for(UIView <AWBTransformableView> *view in [[[self view] subviews] reverseObjectEnumerator]) {
            if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
                view.alpha = UNSELECTED_ALPHA;
            }            
        }
        totalSelectedInEditMode = 0;
        totalSelectedLabelsInEditMode = 0;
        [self updateUserInterfaceWithTotalSelectedInEditMode];
    }
}

- (void)selectAllOrNoneInEditMode:(id)sender
{
    BOOL buttonSelectsAll = [[(UIBarButtonItem *)sender title] isEqualToString:@"Select All"];
    NSString *newTitle = (buttonSelectsAll ? @"Select None" : @"Select All");
    [(UIBarButtonItem *)sender setTitle:newTitle];
    
    totalSelectedInEditMode = 0;
    totalSelectedLabelsInEditMode = 0;
    for(UIView <AWBTransformableView> *view in [[[self view] subviews] reverseObjectEnumerator]) {
        if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
            if (buttonSelectsAll) {
                view.alpha = SELECTED_ALPHA;
                totalSelectedInEditMode += 1;
                if ([view isKindOfClass:[AWBTransformableLabel class]]) {
                    totalSelectedLabelsInEditMode += 1;
                }
            } else {
                view.alpha = UNSELECTED_ALPHA;
            }
        }            
    } 
    
    [self updateUserInterfaceWithTotalSelectedInEditMode];    
}

- (void)resetEditMode:(id)sender
{
    if (self.isCollageInEditMode) {
        self.isCollageInEditMode = NO;
        totalSelectedInEditMode = 0;
        totalSelectedLabelsInEditMode = 0;
        for(UIView <AWBTransformableView> *view in [[[self view] subviews] reverseObjectEnumerator]) {
            if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
                view.alpha = NORMAL_ALPHA;
            }            
        }  
        [self updateUserInterfaceWithTotalSelectedInEditMode];
        self.navigationItem.title = nil;
        self.navigationItem.rightBarButtonItem = self.editButton;
        [self resetToNormalToolbar];
        self.doubleTapGestureRecognizer.enabled = YES;
        [self saveChanges:NO];
    }
}

- (void)updateUserInterfaceWithTotalSelectedInEditMode
{
    //maybe a possible race condition - and menu/toolbar might be hidden at this point which is not good
    if (self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController setToolbarHidden:NO animated:NO];    
        
    }
    
    if (totalSelectedInEditMode == 0) {
        self.navigationItem.title = @"Tap Objects to Select";
        [self updateTintedSegmentedControlButton:self.deleteButton withTitle:@"Delete"];
        self.deleteButton.enabled = NO;
        self.deleteButton.customView.alpha = 0.5;
    } else {
        NSString *objectString;
        if (totalSelectedInEditMode == 1) {
            objectString = @"Object";
        } else {
            objectString = @"Objects";
        }
        self.navigationItem.title = [NSString stringWithFormat:@"%d %@ Selected", totalSelectedInEditMode, objectString];
        [self updateTintedSegmentedControlButton:self.deleteButton withTitle:[NSString stringWithFormat:@"Delete (%d)", totalSelectedInEditMode]];        
        self.deleteButton.enabled = YES;
        self.deleteButton.customView.alpha = 1.0;
    }
    
    if (totalSelectedLabelsInEditMode == 0) {
        [self updateTintedSegmentedControlButton:self.editTextButton withTitle:@"Edit Text"];
        self.editTextButton.enabled = NO;
        self.editTextButton.customView.alpha = 0.5;
    } else {
        [self updateTintedSegmentedControlButton:self.editTextButton withTitle:[NSString stringWithFormat:@"Edit Text (%d)", totalSelectedLabelsInEditMode]];        
        self.editTextButton.enabled = YES;
        self.editTextButton.customView.alpha = 1.0;
    }
}

@end
