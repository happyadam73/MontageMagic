//
//  CollageMakerViewController+UI.h
//  Collage Maker
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController.h"
#import "AWBCollageSettingsTableViewController.h"
#import "AWBTransformableLabel.h"

#define NORMAL_ALPHA 1.0
#define UNSELECTED_ALPHA 0.3
#define SELECTED_ALPHA 1.0

@interface CollageMakerViewController (UI) <UIPopoverControllerDelegate, AWBCollageSettingsTableViewControllerDelegate>

- (void)dismissPopoverIfVisible:(UIPopoverController *)popover;
- (void)dismissToolbarAndPopover:(UIPopoverController *)popover;
- (void)dismissActionSheetIfVisible:(UIActionSheet *)actionSheet;
- (void)settingsButtonAction:(id)sender;
- (void)dismissAllActionSheetsAndPopovers;
- (void)setCollageBackgroundFromSettingsInfo:(NSDictionary *)info;
- (void)setExportQualityFromSettingsInfo:(NSDictionary *)info;
- (void)setAddShadowsFromSettingsInfo:(NSDictionary *)info;
- (void)setAddBordersFromSettingsInfo:(NSDictionary *)info;
- (void)setCollageDrawingAidsFromSettingsInfo:(NSDictionary *)info;
- (NSMutableDictionary *)settingsInfo;
- (void)updateViewBorders;
- (void)updateViewShadows;
- (void)updateTextViewBackgrounds;
- (void)applySettingsToLabel:(AWBTransformableLabel *)label;
- (void)setNavigationBarsHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)addCollageBorderToView;
- (void)removeCollageBorderFromView;

@end
