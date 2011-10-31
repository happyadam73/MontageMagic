//
//  CollageMakerViewController+UI.m
//  Collage Maker
//
//  Created by Adam Buckley on 19/08/2011.
//  Copyright 2011 Callcredit. All rights reserved.
//

#import "CollageMakerViewController+UI.h"
#import "CollageMakerViewController+Delete.h"
#import "CollageMakerViewController+Photos.h"
#import "CollageMakerViewController+Action.h"
#import "AWBSettings.h"
#import "AWBTransformableImageView.h"
#import "AWBTransformableLabel.h"
#import "UIView+Animation.h"
#import "CollageMakerViewController+Toolbar.h"
#import "CollageMakerViewController+Edit.h"
#import "CollageMakerViewController+Text.h"
#import "CollageMakerViewController+LuckyDip.h"
#import "UIColor+Texture.h"

@implementation CollageMakerViewController (UI) 

- (void)dismissAllActionSheetsAndPopovers
{
    if (DEVICE_IS_IPAD) {
        [self dismissPopoverIfVisible:self.imagePickerPopover];
        [self dismissPopoverIfVisible:self.addressBookPopover];
        [self dismissPopoverIfVisible:self.addSymbolPopover];
        [self dismissPopoverIfVisible:self.luckyDipPopover];
        [self dismissPopoverIfVisible:self.memoryWarningPopover];        
        [self dismissActionSheetIfVisible:self.deleteConfirmationSheet];
        [self dismissActionSheetIfVisible:self.choosePhotoSourceSheet];
        [self dismissActionSheetIfVisible:self.chooseActionTypeSheet];
    }    
}

- (void)dismissActionSheetIfVisible:(UIActionSheet *)actionSheet
{
    if (actionSheet.visible) {
        [actionSheet dismissWithClickedButtonIndex:[actionSheet cancelButtonIndex] animated:YES];
    }
}

- (void)dismissPopoverIfVisible:(UIPopoverController *)popover
{
    if ([popover isPopoverVisible]) {
        [popover dismissPopoverAnimated:YES];
        [popover.delegate popoverControllerDidDismissPopover:popover];
    }        
}

- (void)dismissToolbarAndPopover:(UIPopoverController *)popover
{
    if (DEVICE_IS_IPHONE) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self dismissPopoverIfVisible:popover];        
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePickerPopover = nil;
    self.addressBookPopover = nil;
    self.addSymbolPopover = nil;
    self.luckyDipPopover = nil;
    self.memoryWarningPopover = nil;
    if (!self.isImporting && dismissAssetsLibrary) {
        self.selectedAssetsGroup = nil;
        self.assetsLibrary = nil;        
    }
}

- (void)settingsButtonAction:(id)sender
{  
    if (self.isImporting) {
        self.isImporting = NO;
    } else {
        [self resetEditMode:sender];
        [self dismissAllActionSheetsAndPopovers];
        
        AWBCollageSettingsTableViewController *settingsController = [[AWBCollageSettingsTableViewController alloc] initWithSettings:[AWBSettings mainSettingsWithInfo:[self settingsInfo]] settingsInfo:[self settingsInfo] rootController:nil]; 
        settingsController.delegate = self;
        settingsController.controllerType = AWBSettingsControllerTypeMainSettings;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
        navController.modalPresentationStyle = UIModalPresentationPageSheet;
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;  
        [self presentModalViewController:navController animated:self.isLevel1AnimationsEnabled];
        [settingsController release];   
        [navController release];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.choosePhotoSourceSheet) {
        [self choosePhotoSourceActionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
    } else if (actionSheet == self.deleteConfirmationSheet) {
        [self deleteConfirmationActionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
    } else if (actionSheet == self.chooseActionTypeSheet) {
        [self chooseActionTypeActionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)updateViewShadows   
{
    for(UIView <AWBTransformableView> *view in [[self view] subviews]) {
        if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
            //image shadows
            if ([view isKindOfClass:[AWBTransformableImageView class]]) {
                view.viewShadowColor = self.imageShadowColor;
                view.addShadow = self.addImageShadows;
            }       

            //text shadows
            if ([view isKindOfClass:[AWBTransformableLabel class]]) {
                view.viewShadowColor = self.textShadowColor;
                view.addShadow = self.addTextShadows;
            }         
        }            
    }        
}

- (void)updateViewBorders
{
    for(UIView <AWBTransformableView> *view in [[self view] subviews]) {
        if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
            //image borders
            if ([view isKindOfClass:[AWBTransformableImageView class]]) {
                view.roundedBorder = self.imageRoundedBorders;
                view.viewBorderColor = self.imageBorderColor;
                view.addBorder = self.addImageBorders;
            }   
            
            //text borders
            if ([view isKindOfClass:[AWBTransformableLabel class]]) {              
                view.roundedBorder = self.textRoundedBorders;
                view.viewBorderColor = self.textBorderColor;
                view.addBorder = self.addTextBorders;
            }   
        }            
    }        
}

- (void)updateTextViewBackgrounds
{
    for(UIView <AWBTransformableView> *view in [[self view] subviews]) {
        if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
            //text background
            if ([view isKindOfClass:[AWBTransformableLabel class]]) {
                if (self.addTextBackground) {
                    [(AWBTransformableLabel *)view setTextBackgroundColor:self.textBackgroundColor];
                } else {
                    [(AWBTransformableLabel *)view setTextBackgroundColor:[UIColor clearColor]];
                }
            }   
        }            
    }            
}

- (void)setAddShadowsFromSettingsInfo:(NSDictionary *)info
{
    self.addImageShadows = [[info objectForKey:kAWBInfoKeyImageShadows] boolValue];
    self.addTextShadows = [[info objectForKey:kAWBInfoKeyTextShadows] boolValue];
    self.imageShadowColor = [info objectForKey:kAWBInfoKeyImageShadowColor];
    self.textShadowColor = [info objectForKey:kAWBInfoKeyTextShadowColor];

    [self updateViewShadows];
}

- (void)setAddBordersFromSettingsInfo:(NSDictionary *)info
{
    self.addImageBorders = [[info objectForKey:kAWBInfoKeyImageBorders] boolValue];
    self.addTextBorders = [[info objectForKey:kAWBInfoKeyTextBorders] boolValue];
    self.imageRoundedBorders = [[info objectForKey:kAWBInfoKeyImageRoundedBorders] boolValue];
    self.textRoundedBorders = [[info objectForKey:kAWBInfoKeyTextRoundedBorders] boolValue];
    self.imageBorderColor = [info objectForKey:kAWBInfoKeyImageBorderColor];
    self.textBorderColor = [info objectForKey:kAWBInfoKeyTextBorderColor];

    [self updateViewBorders];
}

- (void)setTextBackgroundColorFromSettingsInfo:(NSDictionary *)info
{
    self.addTextBackground = [[info objectForKey:kAWBInfoKeyTextBackground] boolValue];
    self.textBackgroundColor = [info objectForKey:kAWBInfoKeyTextBackgroundColor];
    
    [self updateTextViewBackgrounds];
}

- (void)setCollageBackgroundFromSettingsInfo:(NSDictionary *)info
{
    self.addCollageBorder = [[info objectForKey:kAWBInfoKeyCollageBorder] boolValue];
    self.useBackgroundTexture = [[info objectForKey:kAWBInfoKeyCollageUseBackgroundTexture] boolValue];
    self.collageBorderColor = [info objectForKey:kAWBInfoKeyCollageBorderColor];
    self.collageBackgroundTexture = [info objectForKey:kAWBInfoKeyCollageBackgroundTexture];
    self.collageBackgroundColor = [info objectForKey:kAWBInfoKeyCollageBackgroundColor];
    
    if (self.useBackgroundTexture && self.collageBackgroundTexture) {
        [[self view] setBackgroundColor:[UIColor textureColorWithDescription:self.collageBackgroundTexture]];
    } else {
        if (self.collageBackgroundColor) {
            [[self view] setBackgroundColor:self.collageBackgroundColor];
        }            
    }
    
    if (self.addCollageBorder && self.collageBorderColor) {
        [self addCollageBorderToView];
//        [self view].layer.borderColor = [self.collageBorderColor CGColor];
//        CGFloat borderThickness = 4.0;
//        if (DEVICE_IS_IPAD) {
//            borderThickness = 6.0;
//        }
//        [self view].layer.borderWidth = borderThickness;
    } else {
        [self removeCollageBorderFromView];
//        [self view].layer.borderColor = [[UIColor blackColor] CGColor];
//        [self view].layer.borderWidth = 0.0;            
    }
}

- (void)addCollageBorderToView
{
    [self view].layer.borderColor = [self.collageBorderColor CGColor];
    CGFloat borderThickness = 4.0;
    if (DEVICE_IS_IPAD) {
        borderThickness = 6.0;
    }
    [self view].layer.borderWidth = borderThickness;
}

- (void)removeCollageBorderFromView
{
    [self view].layer.borderColor = [[UIColor blackColor] CGColor];
    [self view].layer.borderWidth = 0.0;            
}

- (void)setExportQualityFromSettingsInfo:(NSDictionary *)info
{
    [self setExportQuality:[[info objectForKey:kAWBInfoKeyExportQualityValue] floatValue]];
}

- (void)setCollageDrawingAidsFromSettingsInfo:(NSDictionary *)info
{
    self.collageObjectLocator.lockCollage = [[info objectForKey:kAWBInfoKeyObjectLocatorLockCollage] boolValue];
    self.collageObjectLocator.snapToGrid = [[info objectForKey:kAWBInfoKeyObjectLocatorSnapToGrid] boolValue];
    self.collageObjectLocator.snapToGridSize = [[info objectForKey:kAWBInfoKeyObjectLocatorSnapToGridSize] floatValue];
    self.collageObjectLocator.objectLocatorType = [[info objectForKey:kAWBInfoKeyObjectLocatorType] integerValue];
    self.collageObjectLocator.autoMemoryReduction = [[info objectForKey:kAWBInfoKeyObjectLocatorAutoMemoryReduction] boolValue];
}

- (NSMutableDictionary *)settingsInfo
{
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:self.addImageShadows], kAWBInfoKeyImageShadows,
                                 [NSNumber numberWithBool:self.addTextShadows], kAWBInfoKeyTextShadows,
                                 self.imageShadowColor, kAWBInfoKeyImageShadowColor,
                                 self.textShadowColor, kAWBInfoKeyTextShadowColor,            
                                 [NSNumber numberWithBool:self.addImageBorders], kAWBInfoKeyImageBorders,
                                 [NSNumber numberWithBool:self.addTextBorders], kAWBInfoKeyTextBorders,
                                 [NSNumber numberWithBool:self.imageRoundedBorders], kAWBInfoKeyImageRoundedBorders,
                                 [NSNumber numberWithBool:self.textRoundedBorders], kAWBInfoKeyTextRoundedBorders,
                                 [NSNumber numberWithBool:self.addTextBackground], kAWBInfoKeyTextBackground,
                                 self.imageBorderColor, kAWBInfoKeyImageBorderColor,
                                 self.textBorderColor, kAWBInfoKeyTextBorderColor,
                                 self.textBackgroundColor, kAWBInfoKeyTextBackgroundColor,
                                 [NSNumber numberWithFloat:self.exportQuality], kAWBInfoKeyExportQualityValue, 
                                 self.labelTextColor, kAWBInfoKeyTextColor,
                                 self.labelTextFont, kAWBInfoKeyTextFontName, 
                                 [NSNumber numberWithInt:self.luckyDipSourceIndex], kAWBInfoKeyLuckyDipSourceSelectedIndex,
                                 [NSNumber numberWithInt:self.luckyDipAmountIndex], kAWBInfoKeyLuckyDipAmountSelectedIndex,
                                 [NSNumber numberWithInt:self.luckyDipContactTypeIndex], kAWBInfoKeyLuckyDipContactTypeSelectedIndex,
                                 [NSNumber numberWithBool:self.luckyDipContactIncludePhoneNumber], kAWBInfoKeyLuckyDipContactIncludePhoneNumber,
                                 [NSNumber numberWithBool:self.addCollageBorder], kAWBInfoKeyCollageBorder,
                                 [NSNumber numberWithBool:self.useBackgroundTexture], kAWBInfoKeyCollageUseBackgroundTexture,
                                 [NSNumber numberWithBool:self.collageObjectLocator.lockCollage], kAWBInfoKeyObjectLocatorLockCollage, 
                                 [NSNumber numberWithBool:self.collageObjectLocator.snapToGrid], kAWBInfoKeyObjectLocatorSnapToGrid, 
                                 [NSNumber numberWithFloat:self.collageObjectLocator.snapToGridSize], kAWBInfoKeyObjectLocatorSnapToGridSize, 
                                 [NSNumber numberWithInteger:self.collageObjectLocator.objectLocatorType], kAWBInfoKeyObjectLocatorType,
                                 [NSNumber numberWithBool:self.collageObjectLocator.autoMemoryReduction], kAWBInfoKeyObjectLocatorAutoMemoryReduction,
                                 nil];

    if (self.assetGroups) {
        [info setObject:self.assetGroups forKey:kAWBInfoKeyAssetGroups];        
    }
    if (self.selectedAssetsGroup) {
        [info setObject:self.selectedAssetsGroup forKey:kAWBInfoKeySelectedAssetGroup];        
    }
    if (self.labelTextLine1) {
        [info setObject:self.labelTextLine1 forKey:kAWBInfoKeyLabelTextLine1];
    }
    if (self.labelTextLine2) {
        [info setObject:self.labelTextLine2 forKey:kAWBInfoKeyLabelTextLine2];
    }
    if (self.labelTextLine3) {
        [info setObject:self.labelTextLine3 forKey:kAWBInfoKeyLabelTextLine3];
    }
    if (self.collageBackgroundTexture) {
        [info setObject:self.collageBackgroundTexture forKey:kAWBInfoKeyCollageBackgroundTexture];
    }
    if (self.collageBorderColor) {
        [info setObject:self.collageBorderColor forKey:kAWBInfoKeyCollageBorderColor];
    }
    if (self.collageBackgroundColor) {
        [info setObject:self.collageBackgroundColor forKey:kAWBInfoKeyCollageBackgroundColor];
    }
            
    return info;
}

- (void)awbCollageSettingsTableViewController:(AWBCollageSettingsTableViewController *)settingsController didFinishSettingsWithInfo:(NSDictionary *)info
{
    switch (settingsController.controllerType) {
        case AWBSettingsControllerTypeMainSettings:
            [self setExportQualityFromSettingsInfo:info];
            [self setCollageBackgroundFromSettingsInfo:info];
            [self setTextBackgroundColorFromSettingsInfo:info];
            [self setAddBordersFromSettingsInfo:info];
            [self setAddShadowsFromSettingsInfo:info];
            [self setCollageDrawingAidsFromSettingsInfo:info];
            [self saveChanges:NO];            
            break;
        case AWBSettingsControllerTypeAddTextSettings:
            self.labelTextLine1 = [info objectForKey:kAWBInfoKeyLabelTextLine1];
            self.labelTextLine2 = [info objectForKey:kAWBInfoKeyLabelTextLine2];
            self.labelTextLine3 = [info objectForKey:kAWBInfoKeyLabelTextLine3];
            self.labelTextColor = [info objectForKey:kAWBInfoKeyTextColor];
            self.labelTextFont = [info objectForKey:kAWBInfoKeyTextFontName];
            
            if (self.labelTextLine1 || self.labelTextLine2 || self.labelTextLine3) {
                NSMutableArray *lines = [self textLabelLines];
                if ([lines count] > 0) {
                    if ([self totalCollageSubviews] == 0) {
                        [self.collageObjectLocator resetLocator];
                    }
                    [self.collageObjectLocator pushTextLabel];
                    AWBTransformableLabel *label = [[AWBTransformableLabel alloc] initWithTextLines:lines font:[UIFont fontWithName:self.labelTextFont size:28.0] offset:CGPointZero rotation:0.0 scale:self.collageObjectLocator.objectScale horizontalFlip:NO color:self.labelTextColor];
                    
                    [label setCenter:self.collageObjectLocator.objectPosition];                    
                    [self applySettingsToLabel:label];
                    [[self view] addSubview:label];
                    totalLabelSubviews += 1;
                    [label release];                        
                }
            }
            
            [self saveChanges:NO];
            break;
        case AWBSettingsControllerTypeEditTextSettings:
            self.labelTextColor = [info objectForKey:kAWBInfoKeyTextColor];
            self.labelTextFont = [info objectForKey:kAWBInfoKeyTextFontName];
            
            for(UIView <AWBTransformableView> *view in [[[self view] subviews] reverseObjectEnumerator]) {
                if ([view conformsToProtocol:@protocol(AWBTransformableView)]) {
                    if ((view.alpha == SELECTED_ALPHA) && [view isKindOfClass:[AWBTransformableLabel class]]) {
                        AWBTransformableLabel *label = (AWBTransformableLabel *)view;
                        [label.labelView setTextColor:self.labelTextColor];   
                        if (totalSelectedLabelsInEditMode == 1) {
                            //single object edit - set text
                            self.labelTextLine1 = [info objectForKey:kAWBInfoKeyLabelTextLine1];
                            self.labelTextLine2 = [info objectForKey:kAWBInfoKeyLabelTextLine2];
                            self.labelTextLine3 = [info objectForKey:kAWBInfoKeyLabelTextLine3];
                            NSMutableArray *lines = [self textLabelLines];
                            if ([lines count] > 0) {
                                [label updateLabelTextLines:lines withFont:[UIFont fontWithName:self.labelTextFont size:28.0]];
                            } else {
                                [label updateLabelTextWithFont:[UIFont fontWithName:self.labelTextFont size:28.0]];                                    
                            }
                            // break because there's just one label
                            break;
                        } else {
                            // more than one label - update the font so frame is adjusted
                            [label updateLabelTextWithFont:[UIFont fontWithName:self.labelTextFont size:28.0]];                                    
                        }
                    }
                }            
            } 
            [self resetEditMode:settingsController];
            [self saveChanges:NO];
            break;
        case AWBSettingsControllerTypeLuckyDipSettings:
            [self luckyDipTableViewController:settingsController didFinishSettingsWithInfo:info];
            break;
        default:
            break;
    }
}

- (void)awbCollageSettingsTableViewControllerDidDissmiss:(AWBCollageSettingsTableViewController *)settingsController
{
    if (settingsController.controllerType == AWBSettingsControllerTypeLuckyDipSettings) {
        [self dismissToolbarAndPopover:self.luckyDipPopover];
        self.luckyDipPopover = nil;
        self.selectedAssetsGroup = nil;
        self.assetsLibrary = nil;
    }
}

- (void)applySettingsToLabel:(AWBTransformableLabel *)label
{
    [label setRoundedBorder:self.textRoundedBorders];
    [label setViewBorderColor:self.textBorderColor];
    [label setViewShadowColor:self.textShadowColor];
    label.addBorder = self.addTextBorders;
    label.addShadow = self.addTextShadows;
    
    if (self.addTextBackground) {
        [label setTextBackgroundColor:self.textBackgroundColor];
    }
}

- (void)setNavigationBarsHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (hidden) {
        [self dismissAllActionSheetsAndPopovers];        
    }
//    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:hidden animated:animated];
    [self.navigationController setToolbarHidden:hidden animated:animated];  
    

}

@end
